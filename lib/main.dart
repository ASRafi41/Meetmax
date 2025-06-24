import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'mock_server/hive_boxes.dart';
import 'mock_server/seed_data.dart';
import 'models/user.dart';
import 'models/post.dart';
import 'models/story.dart';

import 'screens/signup_screen.dart';
import 'screens/feed_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(PostAdapter());
  Hive.registerAdapter(StoryAdapter());

  await seedMockData();

  final sessionBox = await Hive.openBox(HiveBoxes.sessionBox);
  final rememberedEmail = sessionBox.get('email');

  runApp(MeetmaxApp(isLoggedIn: rememberedEmail != null));
}

class MeetmaxApp extends StatelessWidget {
  final bool isLoggedIn;

  const MeetmaxApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meetmax',
      home: isLoggedIn ? const FeedScreen() : SignUpScreen(),
    );
  }
}
