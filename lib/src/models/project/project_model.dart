// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:greenvoice/src/models/socials/comment.dart';

class ProjectModel {
  final String id;
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
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProjectStatus status;
  final List<CommentModel> comments;
  final List<String> likes;
  final List<String> shares;
  ProjectModel({
    required this.id,
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
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.comments,
    required this.likes,
    required this.shares,
  });

  ProjectModel copyWith({
    String? id,
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
    DateTime? createdAt,
    DateTime? updatedAt,
    ProjectStatus? status,
    List<CommentModel>? comments,
    List<String>? likes,
    List<String>? shares,
  }) {
    return ProjectModel(
      id: id ?? this.id,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
      shares: shares ?? this.shares,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
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
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'status': status.name,
      'comments': comments.map((x) => x.toMap()).toList(),
      'likes': likes,
      'shares': shares,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic>? map) {
    return ProjectModel(
      id: map?['id'] ?? '',
      title: map?['title'] ?? '',
      description: map?['description'] ?? '',
      images: List<String>.from((map?['images'] ?? [])),
      votes: List<String>.from((map?['votes'] ?? [])),
      proposedDate: DateTime.fromMillisecondsSinceEpoch(map?['proposedDate']),
      amountNeeded: map?['amountNeeded'] ?? '',
      location: map?['location'] ?? '',
      latitude: map?['latitude'],
      longitude: map?['longitude'],
      createdByUserId: map?['createdByUserId'] ?? '',
      createdByUserName: map?['createdByUserName'] ?? '',
      createdByUserPicture: map?['createdByUserPicture'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map?['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map?['updatedAt']),
      status: ProjectStatus.values.byName(map?['status'] ?? ''),
      comments: List<CommentModel>.from(
        (map?['comments']).map<CommentModel>(
          (x) => CommentModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      likes: List<String>.from((map?['likes'] ?? [])),
      shares: List<String>.from((map?['shares'] ?? [])),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectModel.fromJson(String source) =>
      ProjectModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProjectModel(id: $id, title: $title, description: $description, images: $images, votes: $votes, proposedDate: $proposedDate, amountNeeded: $amountNeeded, location: $location, latitude: $latitude, longitude: $longitude, createdByUserId: $createdByUserId, createdByUserName: $createdByUserName, createdByUserPicture: $createdByUserPicture, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, comments: $comments, likes: $likes, shares: $shares)';
  }

  @override
  bool operator ==(covariant ProjectModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
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
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.status == status &&
        listEquals(other.comments, comments) &&
        listEquals(other.likes, likes) &&
        listEquals(other.shares, shares);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
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
        createdAt.hashCode ^
        updatedAt.hashCode ^
        status.hashCode ^
        comments.hashCode ^
        likes.hashCode ^
        shares.hashCode;
  }
}

enum ProjectStatus { open, closed, inProgress }
