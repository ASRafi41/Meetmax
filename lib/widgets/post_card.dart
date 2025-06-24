import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../providers/user_provider.dart';
import '../providers/post_provider.dart';
import '../providers/comment_provider.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final int postKey;

  const PostCard({super.key, required this.post, required this.postKey});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _showComments = false;
  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final postProv = Provider.of<PostProvider>(context, listen: false);
    final commentProv = Provider.of<CommentProvider>(context);

    final user = userProv.getById(widget.post.userId);
    final userName = user?.name ?? 'User';
    final avatarUrl =
    user != null ? 'https://i.pravatar.cc/150?u=${user.email}' : null;

    final content = widget.post.content ?? '';
    final images = widget.post.imageUrls ?? [];
    final comments = commentProv.getByPostId(widget.postKey);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
              child: avatarUrl == null ? const Icon(Icons.person) : null,
            ),
            title: Text(userName),
            subtitle: Text(_formattedTime(widget.post.time)),
            trailing: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {},
            ),
          ),
          if (content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(content),
            ),
          const SizedBox(height: 8),
          if (images.isNotEmpty) _buildImageGrid(images),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('👍 ${widget.post.likeCount}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('💬 ${widget.post.commentCount}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('↪️ ${widget.post.shareCount}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Divider(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () {
                  postProv.likePost(widget.postKey);
                },
                icon: const Icon(Icons.thumb_up_off_alt),
                label: const Text('Like'),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showComments = !_showComments;
                  });
                },
                icon: const Icon(Icons.comment_outlined),
                label: const Text('Comments'),
              ),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share action not implemented')),
                  );
                },
                icon: const Icon(Icons.share_outlined),
                label: const Text('Share'),
              ),
            ],
          ),
          if (_showComments) const Divider(height: 1),
          if (_showComments)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
              child: Column(
                children: [
                  ...comments.map((c) {
                    final commenter = userProv.getById(c.userId);
                    final commenterName = commenter?.name ?? 'User';
                    final commenterAvatar = commenter != null
                        ? 'https://i.pravatar.cc/150?u=${commenter.email}'
                        : null;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundImage: commenterAvatar != null
                                ? NetworkImage(commenterAvatar)
                                : null,
                            child: commenterAvatar == null
                                ? const Icon(Icons.person, size: 15)
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  commenterName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  c.text,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  _formattedTime(c.time),
                                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage:
                        avatarUrl != null ? NetworkImage(avatarUrl) : null,
                        child:
                        avatarUrl == null ? const Icon(Icons.person, size: 15) : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          textInputAction: TextInputAction.send,
                          decoration: const InputDecoration(
                            hintText: 'Write a comment...',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          onSubmitted: (_) => _submitComment(),
                        ),
                      ),
                      _isCommenting
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : IconButton(
                        icon: const Icon(Icons.send, size: 20),
                        onPressed: _submitComment,
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(List<String> images) {
    int count = images.length;
    if (count == 1) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: _networkImage(images[0]),
      );
    }
    int crossAxisCount = 2;
    double spacing = 2;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: LayoutBuilder(builder: (context, constraints) {
        double totalWidth = constraints.maxWidth;
        double itemWidth = (totalWidth - spacing) / crossAxisCount;
        double itemHeight = itemWidth * 0.75;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(images.length, (idx) {
            return SizedBox(
              width: itemWidth,
              height: itemHeight,
              child: _networkImage(images[idx]),
            );
          }),
        );
      }),
    );
  }

  Widget _networkImage(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stack) {
        return Container(
          color: Colors.grey[200],
          child: const Center(child: Icon(Icons.broken_image)),
        );
      },
    );
  }

  String _formattedTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _isCommenting = true;
    });
    try {
      final userProv = Provider.of<UserProvider>(context, listen: false);
      final postProv = Provider.of<PostProvider>(context, listen: false);
      final commentProv = Provider.of<CommentProvider>(context, listen: false);
      if (userProv.users.isEmpty) return;
      final currentUser = userProv.users.first;
      final userKey = currentUser.key as int;
      final now = DateTime.now();
      final comment = Comment(
        postId: widget.postKey,
        userId: userKey,
        text: text,
        time: now,
      );
      await commentProv.addComment(comment);
      await postProv.incrementCommentCount(widget.postKey);
      _commentController.clear();
    } catch (_) {
      // handle error
    } finally {
      if (mounted) {
        setState(() {
          _isCommenting = false;
        });
      }
    }
  }
}
