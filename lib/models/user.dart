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

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.birthdate,
    required this.createdTime,
  });
}
