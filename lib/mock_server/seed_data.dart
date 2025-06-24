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

  if (userBox.isEmpty) {
    // 1. Users
    final users = [
      User(
        name: 'John Doe',
        email: 'john@example.com',
        password: '123456',
        birthdate: '01/01/2000',
        createdTime: DateTime.now(),
      ),
      User(
        name: 'Jane Smith',
        email: 'jane@example.com',
        password: 'abcdef',
        birthdate: '02/02/2001',
        createdTime: DateTime.now(),
      ),
      User(
        name: 'Ali Hasan',
        email: 'ali@example.com',
        password: 'pass123',
        birthdate: '03/03/1999',
        createdTime: DateTime.now(),
      ),
      User(
        name: 'Sara Khan',
        email: 'sara@example.com',
        password: 'password',
        birthdate: '04/04/2002',
        createdTime: DateTime.now(),
      ),
    ];
    final userKeys = <int>[];
    for (var u in users) {
      final key = await userBox.add(u);
      userKeys.add(key);
    }

    // 2. Stories
    final stories = [
      Story(
        userId: userKeys[0],
        imageUrl: 'https://source.unsplash.com/random/200x200?sig=10',
        text: 'Adventure time!',
      ),
      Story(
        userId: userKeys[1],
        imageUrl: 'https://source.unsplash.com/random/200x200?sig=20',
        text: 'Photography day',
      ),
      Story(
        userId: userKeys[2],
        imageUrl: 'https://source.unsplash.com/random/200x200?sig=30',
        text: 'Beach vibes',
      ),
      Story(
        userId: userKeys[3],
        imageUrl: 'https://source.unsplash.com/random/200x200?sig=40',
        text: 'Coffee break',
      ),
    ];
    for (var s in stories) {
      await storyBox.add(s);
    }

    // 3. Posts
    final now = DateTime.now();
    final posts = [
      Post(
        userId: userKeys[0],
        time: now.subtract(const Duration(minutes: 15)),
        likeCount: 12,
        commentCount: 2,
        shareCount: 1,
        content: 'Loving this view!',
        imageUrls: ['https://source.unsplash.com/random/800x600?sig=101'],
      ),
      Post(
        userId: userKeys[1],
        time: now.subtract(const Duration(hours: 2, minutes: 10)),
        likeCount: 30,
        commentCount: 3,
        shareCount: 4,
        content: 'Weekend getaway snapshots.',
        imageUrls: [
          'https://source.unsplash.com/random/400x300?sig=201',
          'https://source.unsplash.com/random/400x300?sig=202',
          'https://source.unsplash.com/random/400x300?sig=203',
          'https://source.unsplash.com/random/400x300?sig=204',
        ],
      ),
      Post(
        userId: userKeys[2],
        time: now.subtract(const Duration(days: 1, hours: 1)),
        likeCount: 50,
        commentCount: 4,
        shareCount: 5,
        content: 'Exploring the mountains.',
        imageUrls: [
          'https://source.unsplash.com/random/800x600?sig=301',
          'https://source.unsplash.com/random/800x600?sig=302',
        ],
      ),
      Post(
        userId: userKeys[3],
        time: now.subtract(const Duration(hours: 5)),
        likeCount: 8,
        commentCount: 1,
        shareCount: 0,
        content: 'Coffee art is life ☕',
        imageUrls: ['https://source.unsplash.com/random/800x600?sig=401'],
      ),
    ];
    final postKeys = <int>[];
    for (var p in posts) {
      final key = await postBox.add(p);
      postKeys.add(key);
    }

    // 4. Comments
    final comments = <Comment>[];
    // Post 0
    comments.add(Comment(
      postId: postKeys[0],
      userId: userKeys[1],
      text: 'Looks amazing!',
      time: now.subtract(const Duration(minutes: 10)),
    ));
    comments.add(Comment(
      postId: postKeys[0],
      userId: userKeys[2],
      text: 'Where is this place?',
      time: now.subtract(const Duration(minutes: 5)),
    ));
    // Post 1
    comments.add(Comment(
      postId: postKeys[1],
      userId: userKeys[0],
      text: 'Great shots!',
      time: now.subtract(const Duration(hours: 2)),
    ));
    comments.add(Comment(
      postId: postKeys[1],
      userId: userKeys[2],
      text: 'I want to go there.',
      time: now.subtract(const Duration(hours: 1, minutes: 45)),
    ));
    comments.add(Comment(
      postId: postKeys[1],
      userId: userKeys[3],
      text: 'Nice!',
      time: now.subtract(const Duration(hours: 1, minutes: 30)),
    ));
    // Post 2
    comments.add(Comment(
      postId: postKeys[2],
      userId: userKeys[0],
      text: 'Beautiful!',
      time: now.subtract(const Duration(hours: 23)),
    ));
    comments.add(Comment(
      postId: postKeys[2],
      userId: userKeys[1],
      text: 'How was the trek?',
      time: now.subtract(const Duration(hours: 22)),
    ));
    comments.add(Comment(
      postId: postKeys[2],
      userId: userKeys[3],
      text: 'So cool.',
      time: now.subtract(const Duration(hours: 21, minutes: 30)),
    ));
    comments.add(Comment(
      postId: postKeys[2],
      userId: userKeys[0],
      text: 'Adding to my list!',
      time: now.subtract(const Duration(hours: 21)),
    ));
    // Post 3
    comments.add(Comment(
      postId: postKeys[3],
      userId: userKeys[0],
      text: 'Yum!',
      time: now.subtract(const Duration(hours: 4, minutes: 30)),
    ));

    for (var c in comments) {
      await commentBox.add(c);
    }
  }
}
