import 'package:isar/isar.dart';
part 'user_model.g.dart';

@collection
class UserModel {
    Id id = 1;
  final String uid;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? photo;

  UserModel({
    required this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.photo,
  });

  factory UserModel.fromMap(Map<String, dynamic>? map) {
    return UserModel(
      uid: map?['uid'] ?? "",
      email: map?['email'] ?? "",
      firstName: map?['firstName'] ?? "",
      lastName: map?['lastName'] ?? "",
      photo: map?['photo'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'photo': photo,
    };
  }
}
