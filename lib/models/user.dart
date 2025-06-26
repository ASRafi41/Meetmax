import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String password;

  @HiveField(3)
  String birthdate;

  @HiveField(4)
  DateTime createdTime;

  // Add an explicit key field
  @HiveField(5)
  int? key; // New field to store the key

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.birthdate,
    required this.createdTime,
    this.key,
  });
}