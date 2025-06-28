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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyProv = Provider.of<StoryProvider>(context);
    final postProv = Provider.of<PostProvider>(context);
    final userProv = Provider.of<UserProvider>(context);
    final currentUser = userProv.currentUser;
    if (currentUser != null) {
      print('Logged in as: ${currentUser.name}');
    }
    final avatarUrl = currentUser != null
        ? 'https://i.pravatar.cc/150?u=${currentUser.email}'
        : null;

    // Filter posts by search: match content or poster's name
    final allPosts = postProv.posts;
    final filteredPosts = allPosts.where((post) {
      final content = post.content?.toLowerCase() ?? '';
      final user = userProv.getById(post.userId);
      final name = user?.name.toLowerCase() ?? '';
      return content.contains(_searchText) || name.contains(_searchText);
    }).toList();

    Widget feedContent = CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child:
          storyProv.stories.isEmpty ? const SizedBox.shrink() : const StoryList(),
        ),
        SliverToBoxAdapter(
          child: const PostInput(),
        ),
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
                borderRadius: BorderRadius.circular(6), // ← Rectangular-ish
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_outlined, color: Colors.black87),
            onPressed: () {
              // Navigate to messages screen
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
}
