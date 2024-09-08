class UserModel {
  final String uid;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? photo;
  final String? phoneNumber;

  UserModel({
    required this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.photo,
    this.phoneNumber
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
      'phoneNumber':phoneNumber
    };
  }
}
