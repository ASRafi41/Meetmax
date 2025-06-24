import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/story_provider.dart';
import '../providers/post_provider.dart';
import '../providers/comment_provider.dart';
import '../widgets/story_list.dart';
import '../widgets/post_input.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final storyProv = Provider.of<StoryProvider>(context);
    final postProv = Provider.of<PostProvider>(context);

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
              if (index >= postProv.posts.length) return null;
              final post = postProv.posts[index];
              final postKey = post.key as int;
              return PostCard(post: post, postKey: postKey);
            },
            childCount: postProv.posts.length,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
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
