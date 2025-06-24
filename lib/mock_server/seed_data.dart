import 'package:hive/hive.dart';
import '../models/user.dart';
import '../models/post.dart';
import '../models/story.dart';
import 'hive_boxes.dart';

Future<void> seedMockData() async {
  final userBox = await Hive.openBox<User>(HiveBoxes.userBox);
  final postBox = await Hive.openBox<Post>(HiveBoxes.postBox);
  final storyBox = await Hive.openBox<Story>(HiveBoxes.storyBox);

  if (userBox.isEmpty) {
    final user = User(
      name: 'John Doe',
      email: 'john@example.com',
      password: '123456',
      birthdate: '01/01/2000',
      createdTime: DateTime.now(),
    );
    final userKey = await userBox.add(user);

    final post = Post(
      userId: userKey,
      time: DateTime.now(),
      likeCount: 20,
      commentCount: 5,
      shareCount: 2,
    );
    await postBox.add(post);

    final story = Story(
      userId: userKey,
      imageUrl: 'https://example.com/image.jpg',
      text: 'Hello from story',
    );
    await storyBox.add(story);
  }
}
