import 'package:flutter/material.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/src/features/issues/presentation/issue_description.dart';
import 'package:greenvoice/src/models/user/issue/issue_model.dart';

import 'adaptive_images.dart';
import 'star_rating.dart';

class IssueCard extends StatelessWidget {
  final String title;
  final String location;
  final String votes;
  final double rating;
  final int reviewCount;
  final List<String> imageUrls;

  const IssueCard({
    super.key,
    required this.title,
    required this.location,
    required this.votes,
    required this.rating,
    required this.reviewCount,
    required this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IssueDetailScreen(
              arguments: IssueDetailArguments(
                  issue: IssueModel(
                id: '123',
                title: 'Sample Issue',
                description: 'This is a sample issue description.',
                location: 'San Francisco, CA',
                votes: 42,
                isResolved: false,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                images: imageUrls,
                userId: 'user123',
                category: 'Infrastructure',
              )),
            ),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(4)),
                child: AdaptiveImageGrid(
                  images: imageUrls,
                )),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    location,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text('$votes votes'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      StarRating(rating: rating),
                      const SizedBox(width: 8),
                      Text('$reviewCount reviews'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
