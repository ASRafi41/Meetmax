import 'package:hive/hive.dart';
import '../models/user.dart';
import 'hive_boxes.dart';

class UserService {
  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required String birthdate,
  }) async {
    final userBox = await Hive.openBox<User>(HiveBoxes.userBox);

    final user = User(
      name: name,
      email: email,
      password: password,
      birthdate: birthdate,
      createdTime: DateTime.now(),
    );

    await userBox.add(user);
  }

  Future<bool> authenticateUser(String email, String password) async {
    final userBox = await Hive.openBox<User>(HiveBoxes.userBox);
    return userBox.values.any((u) => u.email == email && u.password == password);
  }

  Future<bool> isEmailAlreadyRegistered(String email) async {
    final userBox = await Hive.openBox<User>(HiveBoxes.userBox);
    return userBox.values.any((u) => u.email == email);
  }
}