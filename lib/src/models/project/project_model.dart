// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:greenvoice/src/models/socials/comment.dart';

class ProjectModel {
  final String title;
  final String description;
  final List<String> images;
  final List<String> votes;
  final DateTime proposedDate;
  final String amountNeeded;
  final String location;
  final double latitude;
  final double longitude;
  final String createdByUserId;
  final String createdByUserName;
  final String createdByUserPicture;
  final DateTime createdBy;
  final DateTime updatedBy;
  final ProjectStatus status;
  final List<CommentModel> comments;
  final List<String> likes;
  final List<String> shares;
  ProjectModel({
    required this.title,
    required this.description,
    required this.images,
    required this.votes,
    required this.proposedDate,
    required this.amountNeeded,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.createdByUserId,
    required this.createdByUserName,
    required this.createdByUserPicture,
    required this.createdBy,
    required this.updatedBy,
    required this.status,
    required this.comments,
    required this.likes,
    required this.shares,
  });

  ProjectModel copyWith({
    String? title,
    String? description,
    List<String>? images,
    List<String>? votes,
    DateTime? proposedDate,
    String? amountNeeded,
    String? location,
    double? latitude,
    double? longitude,
    String? createdByUserId,
    String? createdByUserName,
    String? createdByUserPicture,
    DateTime? createdBy,
    DateTime? updatedBy,
    ProjectStatus? status,
    List<CommentModel>? comments,
    List<String>? likes,
    List<String>? shares,
  }) {
    return ProjectModel(
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      votes: votes ?? this.votes,
      proposedDate: proposedDate ?? this.proposedDate,
      amountNeeded: amountNeeded ?? this.amountNeeded,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      createdByUserName: createdByUserName ?? this.createdByUserName,
      createdByUserPicture: createdByUserPicture ?? this.createdByUserPicture,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      status: status ?? this.status,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
      shares: shares ?? this.shares,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'images': images,
      'votes': votes,
      'proposedDate': proposedDate.millisecondsSinceEpoch,
      'amountNeeded': amountNeeded,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'createdByUserId': createdByUserId,
      'createdByUserName': createdByUserName,
      'createdByUserPicture': createdByUserPicture,
      'createdBy': createdBy.millisecondsSinceEpoch,
      'updatedBy': updatedBy.millisecondsSinceEpoch,
      'status': status.name,
      'comments': comments.map((x) => x.toMap()).toList(),
      'likes': likes,
      'shares': shares,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      title: map['title'] as String,
      description: map['description'] as String,
      images: List<String>.from((map['images'] as List<String>)),
      votes: List<String>.from((map['votes'] as List<String>)),
      proposedDate: DateTime.fromMillisecondsSinceEpoch(map['proposedDate'] as int),
      amountNeeded: map['amountNeeded'] as String,
      location: map['location'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      createdByUserId: map['createdByUserId'] as String,
      createdByUserName: map['createdByUserName'] as String,
      createdByUserPicture: map['createdByUserPicture'] as String,
      createdBy: DateTime.fromMillisecondsSinceEpoch(map['createdBy'] as int),
      updatedBy: DateTime.fromMillisecondsSinceEpoch(map['updatedBy'] as int),
      status: ProjectStatus.values.byName(map['status'] as String),
      comments: List<CommentModel>.from((map['comments'] as List<int>).map<CommentModel>((x) => CommentModel.fromMap(x as Map<String,dynamic>),),),
      likes: List<String>.from((map['likes'] as List<String>)),
      shares: List<String>.from((map['shares'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectModel.fromJson(String source) => ProjectModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProjectModel(title: $title, description: $description, images: $images, votes: $votes, proposedDate: $proposedDate, amountNeeded: $amountNeeded, location: $location, latitude: $latitude, longitude: $longitude, createdByUserId: $createdByUserId, createdByUserName: $createdByUserName, createdByUserPicture: $createdByUserPicture, createdBy: $createdBy, updatedBy: $updatedBy, status: $status, comments: $comments, likes: $likes, shares: $shares)';
  }

  @override
  bool operator ==(covariant ProjectModel other) {
    if (identical(this, other)) return true;

    return
      other.title == title &&
      other.description == description &&
      listEquals(other.images, images) &&
      listEquals(other.votes, votes) &&
      other.proposedDate == proposedDate &&
      other.amountNeeded == amountNeeded &&
      other.location == location &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.createdByUserId == createdByUserId &&
      other.createdByUserName == createdByUserName &&
      other.createdByUserPicture == createdByUserPicture &&
      other.createdBy == createdBy &&
      other.updatedBy == updatedBy &&
      other.status == status &&
      listEquals(other.comments, comments) &&
      listEquals(other.likes, likes) &&
      listEquals(other.shares, shares);
  }

  @override
  int get hashCode {
    return title.hashCode ^
      description.hashCode ^
      images.hashCode ^
      votes.hashCode ^
      proposedDate.hashCode ^
      amountNeeded.hashCode ^
      location.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      createdByUserId.hashCode ^
      createdByUserName.hashCode ^
      createdByUserPicture.hashCode ^
      createdBy.hashCode ^
      updatedBy.hashCode ^
      status.hashCode ^
      comments.hashCode ^
      likes.hashCode ^
      shares.hashCode;
  }
}

enum ProjectStatus { open, closed, inProgress }
