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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl == null ? const Icon(Icons.person) : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "What's happening?",
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ModalActionButton(
                  icon: Icons.videocam_rounded,
                  label: 'Live',
                  iconColor: Colors.black.withOpacity(0.4),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Live feature not implemented')),
                    );
                  },
                ),
                _ModalActionButton(
                  icon: Icons.photo_camera_back_rounded,
                  label: 'Photo',
                  iconColor: Colors.black.withOpacity(0.4),
                  onTap: () {
                    setState(() {
                      final sig = DateTime.now().millisecondsSinceEpoch % 1000;
                      _selectedImageUrls
                          .add('https://source.unsplash.com/random/200x200?sig=$sig');
                    });
                  },
                ),
                _ModalActionButton(
                  icon: Icons.emoji_emotions_rounded,
                  label: 'Feeling',
                  iconColor: Colors.black.withOpacity(0.4),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Feeling feature not implemented')),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: _isPosting
                      ? null
                      : () async {
                    final text = _controller.text.trim();
                    if ((text.isEmpty && _selectedImageUrls.isEmpty) || currentUser == null) {
                      return;
                    }
                    setState(() {
                      _isPosting = true;
                    });
                    try {
                      final userKey = currentUser.key;
                      if (userKey == null) return;

                      final newPost = Post(
                        userId: userKey,
                        time: DateTime.now(),
                        content: text,
                        imageUrls: _selectedImageUrls,
                        likeCount: 0,
                        commentCount: 0,
                        shareCount: 0,
                        likedUserIds: [],
                      );

                      await postProv.addPost(newPost);
                      _controller.clear();
                      _selectedImageUrls = [];
                    } catch (e) {
                      print('Error creating post: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to create post')),
                      );
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isPosting = false;
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2979FF),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isPosting
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Text(
                    'Post',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
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
                              decoration: const BoxDecoration(
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

class _ModalActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;

  const _ModalActionButton({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: iconColor.withOpacity(0.7), size: 20),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6))),
        ],
      ),
    );
  }
}
