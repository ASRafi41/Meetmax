import 'package:hive/hive.dart';
import '../models/user.dart';
import '../models/story.dart';
import '../models/post.dart';
import '../models/comment.dart';
import 'hive_boxes.dart';

Future<void> seedMockData() async {
  final userBox = await Hive.openBox<User>(HiveBoxes.userBox);
  final storyBox = await Hive.openBox<Story>(HiveBoxes.storyBox);
  final postBox = await Hive.openBox<Post>(HiveBoxes.postBox);
  final commentBox = await Hive.openBox<Comment>(HiveBoxes.commentBox);

  // Seed users
  if (userBox.isEmpty) {
    final mockUsers = [
      'Marcus Ng',
      'David Brooks',
      'Jane Doe',
      'Matthew Hinkle',
      'Amy Smith',
      'Ed Morris',
      'Carolyn Duncan',
      'Paul Pinnock',
      'Elizabeth Wong',
      'James Lathrop',
      'Jessie Samson',
    ];

    for (var i = 0; i < mockUsers.length; i++) {
      final user = User(
        name: mockUsers[i],
        email: '${mockUsers[i].toLowerCase().replaceAll(" ", "")}@mock.com',
        password: '123456',
        birthdate: '1990-01-01',
        createdTime: DateTime.now(),
      );
      await userBox.add(user);
    }
  }

  final userKeys = userBox.keys.cast<int>().toList();
  final users = userBox.values.toList();

  // Seed stories
  if (storyBox.isEmpty) {
    final storyImageUrls = [
      'https://images.unsplash.com/photo-1498307833015-e7b400441eb8',
      'https://images.unsplash.com/photo-1499363536502-87642509e31b',
      'https://images.unsplash.com/photo-1497262693247-aa258f96c4f5',
      'https://images.unsplash.com/photo-1496950866446-3253e1470e8e',
      'https://images.unsplash.com/photo-1475688621402-4257c812d6db',
    ];

    for (var i = 0; i < storyImageUrls.length && i < userKeys.length; i++) {
      await storyBox.add(Story(
        userId: userKeys[i],
        imageUrl: storyImageUrls[i],
        text: 'Story from ${users[i].name}',
      ));
    }
  }

  // Seed posts
  if (postBox.isEmpty) {
    final postSamples = [
      {
        "caption": "Adventure 🏔",
        "imageUrl": "https://images.unsplash.com/photo-1573331519317-30b24326bb9a",
        "likes": 722,
        "comments": 183,
        "shares": 42,
        "userIndex": 3,
      },
      {
        "caption": "Check out these cool puppers",
        "imageUrl": "https://images.unsplash.com/photo-1525253086316-d0c936c814f8",
        "likes": 1202,
        "comments": 184,
        "shares": 96,
        "userIndex": 0,
      },
      {
        "caption": "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
        "imageUrl": null,
        "likes": 683,
        "comments": 79,
        "shares": 18,
        "userIndex": 5,
      },
      {
        "caption": "This is a very good boi.",
        "imageUrl": "https://images.unsplash.com/photo-1575535468632-345892291673",
        "likes": 894,
        "comments": 201,
        "shares": 27,
        "userIndex": 4,
      },
      {
        "caption": "More placeholder text for the soul...",
        "imageUrl": null,
        "likes": 482,
        "comments": 37,
        "shares": 9,
        "userIndex": 0,
      },
      {
        "caption": "A classic.",
        "imageUrl": "https://images.unsplash.com/reserve/OlxPGKgRUaX0E1hg3b3X_Dumbo.JPG",
        "likes": 1523,
        "comments": 301,
        "shares": 129,
        "userIndex": 9,
      },
    ];

    for (var postData in postSamples) {
      final int userIndex = postData["userIndex"] as int;
      final int userId = userKeys[userIndex];
      final String? image = postData["imageUrl"] as String?;
      final String caption = postData["caption"] as String;
      final int likes = postData["likes"] as int;
      final int comments = postData["comments"] as int;
      final int shares = postData["shares"] as int;

      await postBox.add(Post(
        userId: userId,
        content: caption,
        imageUrls: image != null ? [image] : [],
        time: DateTime.now().subtract(Duration(hours: userIndex * 3)),
        likeCount: likes,
        commentCount: comments,
        shareCount: shares,
        likedUserIds: [],
      ));
    }
  }

  // Seed comments
  if (commentBox.isEmpty) {
    final postKeys = postBox.keys.cast<int>().toList();
    for (var i = 0; i < postKeys.length; i++) {
      final postKey = postKeys[i];
      final commenterKey = userKeys[(i + 1) % userKeys.length];

      await commentBox.add(Comment(
        postId: postKey,
        userId: commenterKey,
        text: 'Great post!',
        time: DateTime.now().subtract(Duration(minutes: i * 5)),
      ));
    }
  }
}
