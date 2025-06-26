import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import '../models/user.dart';
import '../mock_server/hive_boxes.dart';

class AuthProvider extends ChangeNotifier {
  int? currentUserKey;
  User? currentUser;

  AuthProvider(BuildContext context) {
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final box = await Hive.openBox(HiveBoxes.sessionBox);
    final key = box.get('userKey') as int?;
    if (key != null) {
      currentUserKey = key;
      final userBox = await Hive.openBox<User>(HiveBoxes.userBox);
      currentUser = userBox.get(key);
    }
    notifyListeners();
  }

  Future<void> login(int userKey) async {
    final box = await Hive.openBox(HiveBoxes.sessionBox);
    await box.put('userKey', userKey);
    currentUserKey = userKey;
    final userBox = await Hive.openBox<User>(HiveBoxes.userBox);
    currentUser = userBox.get(userKey);
    notifyListeners();
  }

  Future<void> logout() async {
    final box = await Hive.openBox(HiveBoxes.sessionBox);
    await box.delete('userKey');
    currentUserKey = null;
    currentUser = null;
    notifyListeners();
  }
}
