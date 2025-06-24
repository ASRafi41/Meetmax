import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
import 'models/story.dart';
import 'models/post.dart';
import 'models/comment.dart';

import 'mock_server/hive_boxes.dart';
import 'mock_server/seed_data.dart';

import 'providers/user_provider.dart';
import 'providers/story_provider.dart';
import 'providers/post_provider.dart';
import 'providers/comment_provider.dart';

import 'screens/signup_screen.dart';
import 'screens/feed_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(StoryAdapter());
  Hive.registerAdapter(PostAdapter());
  Hive.registerAdapter(CommentAdapter());

  // During development: optionally clear boxes if model changed:
  // await Hive.deleteBoxFromDisk(HiveBoxes.userBox);
  // await Hive.deleteBoxFromDisk(HiveBoxes.storyBox);
  // await Hive.deleteBoxFromDisk(HiveBoxes.postBox);
  // await Hive.deleteBoxFromDisk(HiveBoxes.commentBox);
  // await Hive.deleteBoxFromDisk(HiveBoxes.sessionBox);

  await seedMockData();

  final sessionBox = await Hive.openBox(HiveBoxes.sessionBox);
  final rememberedEmail = sessionBox.get('email') as String?;

  runApp(MeetmaxApp(isLoggedIn: rememberedEmail != null));
}

class MeetmaxApp extends StatelessWidget {
  final bool isLoggedIn;

  const MeetmaxApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => StoryProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meetmax',
        home: isLoggedIn ? const FeedScreen() : SignUpScreen(),
      ),
    );
  }
}
