import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String? email;

  @HiveField(2)
  final String? firstName;

  @HiveField(3)
  final String? lastName;

  @HiveField(4)
  final String? photo;

  @HiveField(5)
  final String? phoneNumber;

  UserModel({
    required this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.photo,
    this.phoneNumber,
  });

  factory UserModel.fromMap(Map<String, dynamic>? map) {
    return UserModel(
      uid: map?['uid'] ?? "",
      email: map?['email'] ?? "",
      firstName: map?['firstName'] ?? "",
      lastName: map?['lastName'] ?? "",
      photo: map?['photo'] ?? "",
      phoneNumber: map?['phoneNumber'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'photo': photo,
      'phoneNumber': phoneNumber,
    };
  }
}
