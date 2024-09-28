import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/src/models/issue/issue_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'issue_card.dart';

class IssueLoadingWidget extends StatelessWidget {
  const IssueLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverSkeletonizer(
        child: SliverList.separated(
      itemCount: 4,
      separatorBuilder: (context, index) => const Gap(16),
      itemBuilder: (context, i) => IssueCard(
        issue: IssueModel(
            id: '123',
            title: 'Sample Issue',
            description: 'This is a sample issue description.',
            location: 'San Francisco, CA',
            isAnonymous: true,
            votes: [],
            isResolved: false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            images: [
              'https://picsum.photos/400',
              'https://picsum.photos/400',
              'https://picsum.photos/400',
            ],
            createdByUserId: 'user123',
            category: 'Infrastructure',
            latitude: 37.7749,
            longitude: -122.4194,
            comments: [],
            createdByUserName: '',
            createdByUserPicture: '',
            shares: []),
      ),
    ));
  }
}
