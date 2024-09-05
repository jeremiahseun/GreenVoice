import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'issue_card.dart';

class IssuesLoading extends StatelessWidget {
  const IssuesLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView(
        children: const [
          IssueCard(
            title: 'Traffic on 5th and Mission',
            location: 'San Francisco, CA',
            votes: '1.2k',
            rating: 3.5,
            reviewCount: 12,
            imageUrls: [
              'https://picsum.photos/400',
              'https://picsum.photos/400'
            ],
          ),
          SizedBox(height: 16),
          IssueCard(
            title: 'Need more dog parks',
            location: 'Los Angeles, CA',
            votes: '1.1k',
            rating: 4.5,
            reviewCount: 55,
            imageUrls: ['https://picsum.photos/400'],
          ),
        ],
      ),
    );
  }
}
