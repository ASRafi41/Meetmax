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

  // Register Hive adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(StoryAdapter());
  Hive.registerAdapter(PostAdapter());
  Hive.registerAdapter(CommentAdapter());

  // Optional: Clear existing data for a clean demo experience
  // await Hive.deleteBoxFromDisk(HiveBoxes.userBox);
  // await Hive.deleteBoxFromDisk(HiveBoxes.storyBox);
  // await Hive.deleteBoxFromDisk(HiveBoxes.postBox);
  // await Hive.deleteBoxFromDisk(HiveBoxes.commentBox);
  // await Hive.deleteBoxFromDisk(HiveBoxes.sessionBox);

  // Seed mock data
  await seedMockData();

  // Load session and determine login state
  final sessionBox = await Hive.openBox(HiveBoxes.sessionBox);
  final rememberedEmail = sessionBox.get('email') as String?;

  final userProvider = UserProvider();
  await userProvider.loadCurrentUser();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => userProvider),
        ChangeNotifierProvider(create: (_) => StoryProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
      ],
      child: MeetmaxApp(isLoggedIn: rememberedEmail != null),
    ),
  );
}

class MeetmaxApp extends StatelessWidget {
  final bool isLoggedIn;

  const MeetmaxApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meetmax',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? const FeedScreen() : SignUpScreen(),
    );
  }
}
