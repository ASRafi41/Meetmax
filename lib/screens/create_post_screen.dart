import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/post_provider.dart';
import '../models/post.dart';
import './feed_screen.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _visibility = 'Friends';
  final List<String> _visibilityOptions = ['Friends', 'Public', 'Only me'];
  bool _isPosting = false;

  int _selectedNavIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Navigation handler
  void _onNavTapped(int index) {
    if (index == _selectedNavIndex) return;

    setState(() => _selectedNavIndex = index);

    if (index == 0) {
      // Navigate back to FeedScreen when Feed tab is selected
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const FeedScreen())
      );
    } else {
      // Placeholder for other tabs - implement your navigation logic here
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigating to tab $index'))
      );
    }
  }

  Future<void> _submit() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;
    setState(() => _isPosting = true);

    final userProv = Provider.of<UserProvider>(context, listen: false);
    final postProv = Provider.of<PostProvider>(context, listen: false);
    final currentUser = userProv.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No user logged in.')));
      setState(() => _isPosting = false);
      return;
    }

    final newPost = Post(
      userId: currentUser.key as int,
      time: DateTime.now(),
      content: content,
      likeCount: 0,
      commentCount: 0,
      shareCount: 0,
      imageUrls: null,
      likedUserIds: [],
    );
    await postProv.addPost(newPost);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context);
    final currentUser = userProv.currentUser;
    final avatarUrl = currentUser != null
        ? 'https://i.pravatar.cc/150?u=${currentUser.email}'
        : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: avatarUrl != null
              ? CircleAvatar(backgroundImage: NetworkImage(avatarUrl))
              : const CircleAvatar(child: Icon(Icons.person)),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Icon(Icons.search, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search for something here...',
                    hintStyle: TextStyle(fontSize: 14),
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_chat_unread_outlined, size: 24),
            onPressed: () {
              // TODO: navigate to messages
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Create a post',
                              style:
                              TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const Text('Visible for',
                                    style: TextStyle(color: Colors.grey)),
                                const SizedBox(width: 4),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _visibility,
                                    items: _visibilityOptions
                                        .map((v) => DropdownMenuItem(
                                      value: v,
                                      child: Text(v,
                                          style: const TextStyle(fontSize: 14)),
                                    ))
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null) setState(() => _visibility = val);
                                    },
                                    icon: const Icon(Icons.arrow_drop_down,
                                        color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage:
                              avatarUrl != null ? NetworkImage(avatarUrl) : null,
                              child: avatarUrl == null
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                maxLines: null,
                                minLines: 5,
                                decoration: const InputDecoration(
                                  hintText: "What's happening?",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _OptionButton(
                              icon: Icons.videocam_outlined,
                              label: 'Live Video',
                            ),
                            _OptionButton(
                              icon: Icons.photo_library_outlined,
                              label: 'Photo/Video',
                            ),
                            _OptionButton(
                              icon: Icons.emoji_emotions_outlined,
                              label: 'Feeling',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isPosting ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2979FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isPosting
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                              'Post',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
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

class _OptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _OptionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: TextButton.icon(
        onPressed: () {
          // TODO: Implement actions
        },
        icon: Icon(icon, size: 20, color: Colors.grey[700]),
        label: Text(
          label,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
