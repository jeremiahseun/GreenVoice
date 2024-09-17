// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:greenvoice/src/models/socials/comment.dart';

class IssueModel {
  final String id;
  final String title;
  final String description;
  final String location;
  final String latitude;
  final String longitude;
  final List<String> votes;
  final bool isResolved;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> images;
  final String createdByUserId;
  final String createdByUserName;
  final String createdByUserPicture;
  final String category;
  final List<CommentModel> comments;
  final List<String> shares;
  IssueModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.votes,
    required this.isResolved,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
    required this.createdByUserId,
    required this.createdByUserName,
    required this.createdByUserPicture,
    required this.category,
    required this.comments,
    required this.shares,
  });

  IssueModel copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? latitude,
    String? longitude,
    List<String>? votes,
    bool? isResolved,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? images,
    String? createdByUserId,
    String? createdByUserName,
    String? createdByUserPicture,
    String? category,
    List<CommentModel>? comments,
    List<String>? shares,
  }) {
    return IssueModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      votes: votes ?? this.votes,
      isResolved: isResolved ?? this.isResolved,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      images: images ?? this.images,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      createdByUserName: createdByUserName ?? this.createdByUserName,
      createdByUserPicture: createdByUserPicture ?? this.createdByUserPicture,
      category: category ?? this.category,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'votes': votes,
      'isResolved': isResolved,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'images': images,
      'createdByUserId': createdByUserId,
      'createdByUserName': createdByUserName,
      'createdByUserPicture': createdByUserPicture,
      'category': category,
      'comments': comments.map((x) => x.toMap()).toList(),
      'shares': shares,
    };
  }

  factory IssueModel.fromMap(Map<String, dynamic> map) {
    return IssueModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      location: map['location'] as String,
      latitude: map['latitude'] as String,
      longitude: map['longitude'] as String,
      votes: List<String>.from((map['votes'] as List<String>)),
      isResolved: map['isResolved'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      images: List<String>.from((map['images'] as List<String>)),
      createdByUserId: map['createdByUserId'] as String,
      createdByUserName: map['createdByUserName'] as String,
      createdByUserPicture: map['createdByUserPicture'] as String,
      category: map['category'] as String,
      comments: List<CommentModel>.from((map['comments'] as List<int>).map<CommentModel>((x) => CommentModel.fromMap(x as Map<String,dynamic>),),),
      shares: List<String>.from((map['shares'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory IssueModel.fromJson(String source) => IssueModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'IssueModel(id: $id, title: $title, description: $description, location: $location, latitude: $latitude, longitude: $longitude, votes: $votes, isResolved: $isResolved, createdAt: $createdAt, updatedAt: $updatedAt, images: $images, createdByUserId: $createdByUserId, createdByUserName: $createdByUserName, createdByUserPicture: $createdByUserPicture, category: $category, comments: $comments, shares: $shares)';
  }

  @override
  bool operator ==(covariant IssueModel other) {
    if (identical(this, other)) return true;

    return
      other.id == id &&
      other.title == title &&
      other.description == description &&
      other.location == location &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      listEquals(other.votes, votes) &&
      other.isResolved == isResolved &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      listEquals(other.images, images) &&
      other.createdByUserId == createdByUserId &&
      other.createdByUserName == createdByUserName &&
      other.createdByUserPicture == createdByUserPicture &&
      other.category == category &&
      listEquals(other.comments, comments) &&
      listEquals(other.shares, shares);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      location.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      votes.hashCode ^
      isResolved.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      images.hashCode ^
      createdByUserId.hashCode ^
      createdByUserName.hashCode ^
      createdByUserPicture.hashCode ^
      category.hashCode ^
      comments.hashCode ^
      shares.hashCode;
  }
}
