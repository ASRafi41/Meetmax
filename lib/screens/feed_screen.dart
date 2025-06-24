import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../mock_server/hive_boxes.dart';
import 'signin_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final sessionBox = await Hive.openBox(HiveBoxes.sessionBox);
    await sessionBox.delete('email'); // clear session
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meetmax Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.feed, size: 100, color: Colors.blueAccent),
              SizedBox(height: 20),
              Text(
                'Welcome to your Feed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                'This is where you will see posts, stories, and updates.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
