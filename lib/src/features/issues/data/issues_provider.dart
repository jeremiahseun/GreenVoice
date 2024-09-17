import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/src/models/issue/issue_model.dart';

final issuesProvider =
    StateNotifierProvider<IssuesProvider, AsyncValue<List<IssueModel>>>(
        (ref) => IssuesProvider(ref));

class IssuesProvider extends StateNotifier<AsyncValue<List<IssueModel>>> {
  IssuesProvider(this.ref) : super(const AsyncValue.loading());

  Ref ref;

  Future<void> getAllIssues() async {
    try {
      state = const AsyncValue.loading();
      await Future.delayed(const Duration(seconds: 4));
      state = AsyncValue.data(demoIssuesList);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

final demoIssuesList = [
  IssueModel(
    id: '123',
    title: 'Sample Issue',
    description: 'This is a sample issue description.',
    location: 'San Francisco, CA',
    votes: 42,
    isResolved: false,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    images: [
      'https://picsum.photos/400',
      'https://picsum.photos/400',
      'https://picsum.photos/400',
    ],
    userId: 'user123',
    category: 'Infrastructure',
    latitude: '37.7749',
    longitude: '-122.4194',
  ),
  IssueModel(
    id: '456',
    title: 'Pothole on Market Street',
    description: 'Large pothole causing traffic issues.',
    location: 'San Francisco, CA',
    votes: 128,
    isResolved: false,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    images: [
      'https://picsum.photos/id/10/400/300',
      'https://picsum.photos/id/11/400/300',
    ],
    userId: 'user456',
    category: 'Road Conditions',
    latitude: '37.7837',
    longitude: '-122.4089',
  ),
  IssueModel(
    id: '789',
    title: 'Graffiti on Public Building',
    description: 'Graffiti needs to be removed from the library.',
    location: 'San Francisco, CA',
    votes: 23,
    isResolved: true,
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    updatedAt: DateTime.now().subtract(const Duration(days: 7)),
    images: [
      'https://picsum.photos/id/12/400/300',
    ],
    userId: 'user789',
    category: 'Vandalism',
    latitude: '37.7789',
    longitude: '-122.4154',
  ),
  IssueModel(
    id: '1011',
    title: 'Broken Street Light',
    description: 'Street light out on Mission Street.',
    location: 'San Francisco, CA',
    votes: 65,
    isResolved: false,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now(),
    images: [
      'https://picsum.photos/id/13/400/300',
      'https://picsum.photos/id/14/400/300',
      'https://picsum.photos/id/15/400/300',
      'https://picsum.photos/id/16/400/300',
    ],
    userId: 'user1011',
    category: 'Street Lighting',
    latitude: '37.7704',
    longitude: '-122.4029',
  ),
  IssueModel(
    id: '1213',
    title: 'Park Maintenance Needed',
    description: 'Overgrown bushes and trash in Dolores Park.',
    location: 'San Francisco, CA',
    votes: 98,
    isResolved: false,
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
    updatedAt: DateTime.now().subtract(const Duration(days: 12)),
    images: [
      'https://picsum.photos/id/17/400/300',
      'https://picsum.photos/id/18/400/300',
      'https://picsum.photos/id/19/400/300',
      'https://picsum.photos/id/20/400/300',
      'https://picsum.photos/id/21/400/300',
    ],
    userId: 'user1213',
    category: 'Park Maintenance',
    latitude: '37.7599',
    longitude: '-122.4337',
  ),
  IssueModel(
    id: '1415',
    title: 'Sidewalk Repair',
    description: 'Uneven sidewalk on Geary Street.',
    location: 'San Francisco, CA',
    votes: 32,
    isResolved: true,
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
    updatedAt: DateTime.now().subtract(const Duration(days: 18)),
    images: [
      'https://picsum.photos/id/22/400/300',
    ],
    userId: 'user1415',
    category: 'Sidewalk Issues',
    latitude: '37.7858',
    longitude: '-122.4214',
  ),
  IssueModel(
    id: '1617',
    title: 'Noise Complaint',
    description: 'Excessive noise from construction site.',
    location: 'San Francisco, CA',
    votes: 56,
    isResolved: false,
    createdAt: DateTime.now().subtract(const Duration(days: 8)),
    updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    images: [
      'https://picsum.photos/id/23/400/300',
      'https://picsum.photos/id/24/400/300',
      'https://picsum.photos/id/25/400/300',
    ],
    userId: 'user1617',
    category: 'Noise Pollution',
    latitude: '37.7906',
    longitude: '-122.4082',
  ),
  IssueModel(
    id: '1819',
    title: 'Traffic Signal Malfunction',
    description: 'Traffic light not working properly.',
    location: 'San Francisco, CA',
    votes: 102,
    isResolved: false,
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    updatedAt: DateTime.now(),
    images: [
      'https://picsum.photos/id/26/400/300',
      'https://picsum.photos/id/27/400/300',
      'https://picsum.photos/id/28/400/300',
      'https://picsum.photos/id/29/400/300',
      'https://picsum.photos/id/30/400/300',
      'https://picsum.photos/id/31/400/300',
    ],
    userId: 'user1819',
    category: 'Traffic Signals',
    latitude: '37.7784',
    longitude: '-122.3907',
  ),
  IssueModel(
    id: '2021',
    title: 'Illegal Dumping',
    description: 'Illegal dumping on the side of the road.',
    location: 'San Francisco, CA',
    votes: 78,
    isResolved: true,
    createdAt: DateTime.now().subtract(const Duration(days: 12)),
    updatedAt: DateTime.now().subtract(const Duration(days: 9)),
    images: [
      'https://picsum.photos/id/32/400/300',
      'https://picsum.photos/id/33/400/300',
      'https://picsum.photos/id/34/400/300',
      'https://picsum.photos/id/35/400/300',
      'https://picsum.photos/id/36/400/300',
      'https://picsum.photos/id/37/400/300',
      'https://picsum.photos/id/38/400/300',
    ],
    userId: 'user2021',
    category: 'Illegal Dumping',
    latitude: '37.7649',
    longitude: '-122.4244',
  ),
  IssueModel(
    id: '2223',
    title: 'Homeless Encampment',
    description: 'Homeless encampment needs assistance.',
    location: 'San Francisco, CA',
    votes: 145,
    isResolved: false,
    createdAt: DateTime.now().subtract(const Duration(days: 6)),
    updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    images: [
      'https://picsum.photos/id/39/400/300',
      'https://picsum.photos/id/40/400/300',
      'https://picsum.photos/id/41/400/300',
      'https://picsum.photos/id/42/400/300',
      'https://picsum.photos/id/43/400/300',
      'https://picsum.photos/id/44/400/300',
      'https://picsum.photos/id/45/400/300',
      'https://picsum.photos/id/46/400/300',
    ],
    userId: 'user2223',
    category: 'Homelessness',
    latitude: '37.7870',
    longitude: '-122.4075',
  ),
];
