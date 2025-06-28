import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/user.dart';
import '../mock_server/hive_boxes.dart';

class UserProvider extends ChangeNotifier {
  Box<User>? _userBox;
  List<User> _users = [];
  User? _currentUser;

  List<User> get users => _users;
  User? get currentUser => _currentUser;

  UserProvider() {
    _init();
  }

  Future<void> _init() async {
    _userBox = await Hive.openBox<User>(HiveBoxes.userBox);
    _users = _userBox!.values.toList();
    await _loadCurrentUser();
    notifyListeners();
  }

  Future<void> _loadCurrentUser() async {
    final sessionBox = await Hive.openBox(HiveBoxes.sessionBox);
    final userKey = sessionBox.get('currentUserKey') as int?;
    if (userKey != null && _userBox != null) {
      _currentUser = _userBox!.get(userKey);
    }
  }

  User? getById(int key) {
    if (_userBox == null) return null;
    return _userBox!.get(key);
  }

  Future<int> addUser(User user) async {
    if (_userBox == null) return -1;
    final key = await _userBox!.add(user);

    // Set the Hive key on the user object
    user.key = key;

    _users = _userBox!.values.toList();
    await setCurrentUser(user);
    notifyListeners();
    return key;
  }

  Future<void> loadCurrentUser() async {
    final sessionBox = await Hive.openBox(HiveBoxes.sessionBox);
    final key = sessionBox.get('currentUserKey') as int?;
    if (key != null && _userBox != null) {
      _currentUser = _userBox!.get(key);
      notifyListeners();
    }
  }

  Future<void> setCurrentUser(User user) async {
    _currentUser = user;
    final sessionBox = await Hive.openBox(HiveBoxes.sessionBox);

    if (user.key != null) {
      await sessionBox.put('currentUserKey', user.key);
    }

    notifyListeners();
  }

  Future<void> clearCurrentUser() async {
    _currentUser = null;
    final sessionBox = await Hive.openBox(HiveBoxes.sessionBox);
    await sessionBox.delete('currentUserKey');
    notifyListeners();
  }

  Future<void> logout() async {
    await clearCurrentUser();
    // Add other cleanup logic if needed
    notifyListeners();
  }
}
