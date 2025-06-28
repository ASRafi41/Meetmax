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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(StoryAdapter());
  Hive.registerAdapter(PostAdapter());
  Hive.registerAdapter(CommentAdapter());

  // Seed mock data
  await seedMockData();

  // Open session box & check for saved email
  final sessionBox = await Hive.openBox<String>(HiveBoxes.sessionBox);
  final rememberedEmail = sessionBox.get('email');

  // Load current user into provider
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
      theme: ThemeData(primarySwatch: Colors.blue),

      // define your named routes
      routes: {
        '/login': (_) => SignUpScreen(),
        '/feed': (_) => const FeedScreen(),
      },

      // pick the initial screen
      initialRoute: isLoggedIn ? '/feed' : '/login',
    );
  }
}
