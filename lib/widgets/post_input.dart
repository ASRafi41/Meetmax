import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/post_provider.dart';
import '../models/post.dart';

class PostInput extends StatefulWidget {
  const PostInput({super.key});

  @override
  State<PostInput> createState() => _PostInputState();
}

class _PostInputState extends State<PostInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isPosting = false;
  List<String> _selectedImageUrls = [];

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context);
    final postProv = Provider.of<PostProvider>(context, listen: false);

    final currentUser = userProv.users.isNotEmpty ? userProv.currentUser : null;
    final avatarUrl =
    currentUser != null ? 'https://i.pravatar.cc/150?u=${currentUser.email}' : null;

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl == null ? const Icon(Icons.person) : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "What's happening?",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                _isPosting
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : TextButton(
                  onPressed: () async {
                    final text = _controller.text.trim();
                    if ((text.isEmpty && _selectedImageUrls.isEmpty) || currentUser == null) {
                      return;
                    }
                    setState(() {
                      _isPosting = true;
                    });
                    try {
                      // Use currentUser.keyId instead of currentUser.key
                      final userKey = currentUser.key;
                      if (userKey == null) return; // Add null check

                      final newPost = Post(
                        userId: userKey, // Use keyId here
                        time: DateTime.now(),
                        content: text,
                        imageUrls: _selectedImageUrls,
                        likeCount: 0,
                        commentCount: 0,
                        shareCount: 0,
                        likedUserIds: [], // Initialize with empty list
                      );

                      await postProv.addPost(newPost);
                      _controller.clear();
                      _selectedImageUrls = [];
                    } catch (e) {
                      print('Error creating post: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to create post')),
                      );
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isPosting = false;
                        });
                      }
                    }
                  },
                  child: const Text('Post'),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Live feature not implemented')),
                    );
                  },
                  icon: const Icon(Icons.videocam, color: Colors.red),
                  label: const Text('Live'),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      final sig = DateTime.now().millisecondsSinceEpoch % 1000;
                      _selectedImageUrls
                          .add('https://source.unsplash.com/random/200x200?sig=$sig');
                    });
                  },
                  icon: const Icon(Icons.photo_library, color: Colors.green),
                  label: const Text('Photo'),
                ),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Feeling feature not implemented')),
                    );
                  },
                  icon: const Icon(Icons.emoji_emotions, color: Colors.orange),
                  label: const Text('Feeling'),
                ),
              ],
            ),
            if (_selectedImageUrls.isNotEmpty)
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImageUrls.length,
                  itemBuilder: (context, idx) {
                    final url = _selectedImageUrls[idx];
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(url),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImageUrls.removeAt(idx);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}