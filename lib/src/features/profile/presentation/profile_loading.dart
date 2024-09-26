import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/src/features/profile/presentation/profile_view.dart';
import 'package:greenvoice/src/models/issue/issue_model.dart';
import 'package:greenvoice/utils/common_widgets/green_voice_button.dart';
import 'package:greenvoice/utils/styles/styles.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileLoadingWidget extends StatelessWidget {
  const ProfileLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverSkeletonizer(
            child: SliverAppBar(
              expandedHeight: 50,
              title: Text(
                'Profile',
                style: AppStyles.blackBold18,
              ),
              pinned: true,
              centerTitle: true,
            ),
          ),
          SliverSkeletonizer(
            child: SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    const ProfileHeader(
                      firstName: 'Loading',
                      lastName: 'Loading',
                      image:
                          'https://cdn.pixabay.com/photo/2023/08/02/18/21/yoga-8165759_1280.jpg',
                    ),
                    const Gap(20),
                    IssuesReported(issues: [
                      IssueModel(
                          id: 'id',
                          title: 'title',
                          description: 'description',
                          location: 'location',
                          latitude: 0.0,
                          longitude: 0.0,
                          votes: [],
                          isResolved: false,
                          isAnonymous: false,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                          images: [],
                          createdByUserId: 'createdByUserId',
                          createdByUserName: 'createdByUserName',
                          createdByUserPicture: 'createdByUserPicture',
                          category: 'category',
                          comments: [],
                          shares: []),
                      IssueModel(
                          id: 'id',
                          title: 'title',
                          description: 'description',
                          location: 'location',
                          latitude: 0.0,
                          longitude: 0.0,
                          votes: [],
                          isResolved: false,
                          isAnonymous: false,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                          images: [],
                          createdByUserId: 'createdByUserId',
                          createdByUserName: 'createdByUserName',
                          createdByUserPicture: 'createdByUserPicture',
                          category: 'category',
                          comments: [],
                          shares: [])
                    ]),
                    const Gap(20),
                    const VotingHistory(votes: [
                      {
                        'id': 'id',
                        'title': 'title',
                        'date': 'date',
                        'isIssues': null
                      },
                      {
                        'id': 'id',
                        'title': 'title',
                        'date': 'date',
                        'isIssues': null
                      },
                    ]),
                    const Gap(50),
                    GreenVoiceButton.red(onTap: () {}, title: 'Log out'),
                    const Gap(50),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
