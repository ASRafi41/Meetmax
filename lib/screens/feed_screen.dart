import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/story_provider.dart';
import '../providers/post_provider.dart';
import '../providers/comment_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/story_list.dart';
import '../widgets/post_input.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadCurrentUser();
    });
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Future<void> _logout() async {
    final userProv = Provider.of<UserProvider>(context, listen: false);
    await userProv.logout();
    // Navigate to login or splash screen after logout
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Widget _buildFeed() {
    final storyProv = Provider.of<StoryProvider>(context);
    final postProv = Provider.of<PostProvider>(context);
    final userProv = Provider.of<UserProvider>(context);
    final currentUser = userProv.currentUser;

    final avatarUrl = currentUser != null
        ? 'https://i.pravatar.cc/150?u=${currentUser.email}'
        : null;

    final allPosts = postProv.posts;
    final filteredPosts = allPosts.where((post) {
      final content = post.content?.toLowerCase() ?? '';
      final user = userProv.getById(post.userId);
      final name = user?.name.toLowerCase() ?? '';
      return content.contains(_searchText) || name.contains(_searchText);
    }).toList();

    Widget feedContent = CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: storyProv.stories.isEmpty ? const SizedBox.shrink() : const StoryList()),
        const SliverToBoxAdapter(child: PostInput()),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              if (index >= filteredPosts.length) return null;
              final post = filteredPosts[index];
              final postKey = post.key as int;
              return PostCard(post: post, postKey: postKey);
            },
            childCount: filteredPosts.length,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: avatarUrl != null
              ? CircleAvatar(backgroundImage: NetworkImage(avatarUrl))
              : const CircleAvatar(child: Icon(Icons.person)),
        ),
        title: SizedBox(
          height: 40,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              prefixIcon: const Icon(Icons.search, size: 20),
              hintText: 'Search for something here...',
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_outlined, color: Colors.black87),
            onPressed: () {
              // TODO: Navigate to messages screen
            },
            tooltip: 'Messages',
          ),
          const SizedBox(width: 8),
        ],
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<StoryProvider>(context, listen: false).reload();
          await Provider.of<PostProvider>(context, listen: false).reload();
          await Provider.of<CommentProvider>(context, listen: false).reload();
        },
        child: LayoutBuilder(builder: (context, constraints) {
          const maxWidth = 600.0;
          if (constraints.maxWidth > maxWidth) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: feedContent,
              ),
            );
          } else {
            return feedContent;
          }
        }),
      ),
    );
  }

  Widget _buildCommunity() {
    return Scaffold(
      appBar: AppBar(title: const Text('My Community')),
      body: const Center(child: Text('My Community Page')),
    );
  }

  Widget _buildExplore() {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: const Center(child: Text('Explore Page')),
    );
  }

  Widget _buildNotification() {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(child: Text('Notifications Page')),
    );
  }

  Widget _buildSettings() {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (_selectedIndex) {
      case 0:
        page = _buildFeed();
        break;
      case 1:
        page = _buildCommunity();
        break;
      case 2:
        page = _buildExplore();
        break;
      case 3:
        page = _buildNotification();
        break;
      case 4:
        page = _buildSettings();
        break;
      default:
        page = _buildFeed();
    }

    return Scaffold(
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2979FF),
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Feed',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'My community',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.language_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_outlined),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: const Text(
                      '2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            label: 'Notification',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
