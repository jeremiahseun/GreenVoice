// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CommentModel {
  final String id;
  final String userId;
  final String userName;
  final String userPicture;
  final String message;
  final DateTime createdAt;
  CommentModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPicture,
    required this.message,
    required this.createdAt,
  });

  CommentModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userPicture,
    String? message,
    DateTime? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPicture: userPicture ?? this.userPicture,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'userName': userName,
      'userPicture': userPicture,
      'message': message,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic>? map) {
    return CommentModel(
      id: map?['id'] ?? "",
      userId: map?['userId'] ?? "",
      userName: map?['userName'] ?? "",
      userPicture: map?['userPicture'] ?? "",
      message: map?['message'] ?? "",
      createdAt: DateTime.fromMillisecondsSinceEpoch(map?['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentModel(id: $id, userId: $userId, userName: $userName, userPicture: $userPicture, message: $message, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.userName == userName &&
        other.userPicture == userPicture &&
        other.message == message &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        userName.hashCode ^
        userPicture.hashCode ^
        message.hashCode ^
        createdAt.hashCode;
  }
}
