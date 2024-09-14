class IssueModel {
  final String id;
  final String? title;
  final String? description;
  final String? location;
  final String latitude;
  final String longitude;
  final int votes;
  final bool isResolved;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> images;
  final String? userId;
  final String? category;

  IssueModel(
      {required this.id,
      this.title,
      this.description,
      this.location,
      this.votes = 0,
      this.createdAt,
      this.updatedAt,
      this.category,
      this.isResolved = false,
      this.userId,
      required this.latitude,
      required this.longitude,
      this.images = const []});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'votes': votes,
      'isResolved': isResolved,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'images': images,
      'userId': userId,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory IssueModel.fromMap(Map<String, dynamic>? map) {
    return IssueModel(
      id: map?['id'] ?? '',
      title: map?['title'] ?? '',
      description: map?['description'] ?? '',
      location: map?['location'] ?? '',
      votes: map?['votes'] ?? 0,
      isResolved: map?['isResolved'] ?? false,
      createdAt: map?['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map?['createdAt'])
          : null,
      updatedAt: map?['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map?['updatedAt'])
          : null,
      images: map?['images'] == null ? [] : List<String>.from(map?['images']),
      userId: map?['userId'] ?? '',
      category: map?['category'] ?? '',
      latitude: map?['latitude'] ?? '',
      longitude: map?['longitude'] ?? ''
    );
  }


  IssueModel copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? latitude,
    String? longitude,
    int? votes,
    bool? isResolved,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? images,
    String? userId,
    String? category,
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
      userId: userId ?? this.userId,
      category: category ?? this.category,
    );
  }
}
