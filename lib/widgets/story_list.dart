import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/story_provider.dart';
import '../providers/user_provider.dart';

class StoryList extends StatelessWidget {
  const StoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final storyProv = Provider.of<StoryProvider>(context);
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final stories = storyProv.stories;
    final currentUser = userProv.currentUser;

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: stories.length + 1, // +1 for "Your Story"
        itemBuilder: (context, index) {
          if (index == 0) {
            // First item: "Your Story"
            final avatarUrl = currentUser != null
                ? 'https://i.pravatar.cc/150?u=${currentUser.email}'
                : null;

            return GestureDetector(
              onTap: () {
                // TODO: Navigate to story creation
              },
              child: Container(
                width: 80,
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: avatarUrl != null
                              ? NetworkImage(avatarUrl)
                              : null,
                          backgroundColor: Colors.grey[300],
                          child: avatarUrl == null
                              ? const Icon(Icons.person, size: 30)
                              : null,
                        ),
                        Positioned(
                          bottom: -2, // Adjusted position
                          right: -2,   // Adjusted position
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.add, size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Your Story',
                      style: TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Other users' stories
            final story = stories[index - 1];
            final user = userProv.getById(story.userId);
            final userName = user?.name ?? 'User';
            final imageUrl = story.imageUrl;

            return Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 28, // Slightly smaller to account for border
                      backgroundImage: NetworkImage(imageUrl),
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userName,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}