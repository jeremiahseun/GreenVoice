import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/src/features/authentication/user/user_provider.dart';
import 'package:greenvoice/src/features/issues/widgets/adaptive_images.dart';
import 'package:greenvoice/src/features/projects/data/projects_provider.dart';
import 'package:greenvoice/src/features/projects/presentation/comments/projectcomments_bottomsheet.dart';
import 'package:greenvoice/src/features/projects/presentation/comments/widget/comment_component.dart';
import 'package:greenvoice/src/services/branch_deeplink_service.dart';
import 'package:greenvoice/utils/common_widgets/data_box.dart';
import 'package:greenvoice/utils/common_widgets/fullscreen_carousel_image.dart';
import 'package:greenvoice/utils/common_widgets/green_voice_button.dart';
import 'package:greenvoice/utils/common_widgets/snackbar_message.dart';
import 'package:greenvoice/utils/helpers/date_formatter.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class ProjectDetailsView extends ConsumerStatefulWidget {
  final String id;
  const ProjectDetailsView({super.key, required this.id});

  @override
  ConsumerState<ProjectDetailsView> createState() => _ProjectDetailsViewState();
}

class _ProjectDetailsViewState extends ConsumerState<ProjectDetailsView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((time) {
      ref.read(oneProjectProvider.notifier).getOneProject(widget.id);
      ref.read(addProjectProvider.notifier).userImage();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLikeLoadingState = ValueNotifier<bool>(false);

    final user = ref.watch(addProjectProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ref.watch(oneProjectProvider).when(
              data: (data) => data.title,
              error: (e, s) => '',
              loading: () => '...'),
          style: AppStyles.blackBold18,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              await BranchDeeplinkService.shareProject(
                ref.watch(oneProjectProvider).value!,
              );
            },
          ),
        ],
      ),
      body: ref.watch(oneProjectProvider).when(
          data: (data) {
            final project = data;
            final daysRemaining =
                project.proposedDate.difference(DateTime.now()).inDays;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: AdaptiveImageGrid(
                      images: project.images,
                      onTap: (index) => showImageCarousel(
                          context, project.images,
                          initialIndex: index),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.title,
                          style: AppStyles.blackBold22,
                        ),
                        const Gap(15),
                        Text(
                          project.description,
                          style: AppStyles.blackSemi17,
                        ),
                        const Gap(25),
                        Row(
                          children: [
                            Expanded(
                                child: DataBox(
                                    title: 'Votes',
                                    data: project.votes.length.toString())),
                            const Gap(10),
                            Expanded(
                                child: DataBox(
                                    title: 'Days Left',
                                    data: daysRemaining.toString())),
                          ],
                        ),
                        const Gap(15.0),
                        DataBox(
                          title: 'Funding',
                          data: project.amountNeeded,
                          isLargeBox: true,
                        ),
                        const Gap(10),
                        ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.lightPrimaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.calendar_month)),
                          title: Text(
                            'Voting Ends in ${daysRemaining.toString()} days',
                            style: AppStyles.blackBold16,
                          ),
                          subtitle: Text(
                            DateFormatter.formatDate(project.proposedDate),
                            style: AppStyles.blackNormal14,
                          ),
                          trailing: SizedBox(
                            width: 120.0,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 90,
                                  child: LinearProgressIndicator(
                                    value: daysRemaining / 100,
                                    backgroundColor: daysRemaining < 10
                                        ? Colors.red.withOpacity(.1)
                                        : AppColors.lightPrimaryColor,
                                    color: daysRemaining < 10
                                        ? Colors.red
                                        : AppColors.primaryColor,
                                  ),
                                ),
                                const Gap(10),
                                Text(
                                  '$daysRemaining',
                                  style: AppStyles.blackNormal12,
                                )
                              ],
                            ),
                          ),
                        ),
                        const Gap(20.0),
                        Text(
                          'Comments',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Gap(20.0),
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: ref
                              .read(addProjectProvider.notifier)
                              .getProjectComments(issueID: project.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasData &&
                                snapshot.data!.docs.isNotEmpty) {
                              return Column(
                                children: [
                                  ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        const Gap(10),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        min(3, snapshot.data!.docs.length),
                                    itemBuilder: (context, index) {
                                      var commentData =
                                          snapshot.data!.docs[index].data();
                                      return CommentComponent(
                                        name: commentData['userName'],
                                        message: commentData['message'],
                                        image: commentData['userPicture'],
                                      );
                                    },
                                  ),
                                  const Gap(10.0),
                                  snapshot.data!.docs.length < 3
                                      ? const SizedBox()
                                      : GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              isScrollControlled: true,
                                              context: context,
                                              builder: (context) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom,
                                                  ),
                                                  child:
                                                      ProjectCommentBottomSheet(
                                                    issueID: project.id,
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              'View all Comments',
                                              style: AppStyles.blackNormal10
                                                  .copyWith(
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                          )),
                                  const Gap(20.0),
                                ],
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  "No comments yet",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            }
                          },
                        ),
                        const Gap(20.0),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  CachedNetworkImageProvider(user.profileImage),
                            ),
                            const Gap(10),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                      ),
                                      child: ProjectCommentBottomSheet(
                                        userImage: user.profileImage,
                                        issueID: project.id,
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 50,
                                  padding: const EdgeInsets.all(15),
                                  width: 330,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.greyColor,
                                    ),
                                  ),
                                  child: Text(
                                    'Enter a comment',
                                    style: AppStyles.blackNormal13
                                        .copyWith(color: AppColors.greyColor),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(40.0),
                        Row(
                          children: [
                            Expanded(
                              child: GreenVoiceButton.fill(
                                onTap: ref
                                            .watch(oneProjectProvider)
                                            .value
                                            ?.votes
                                            .contains(ref
                                                .read(userProvider)
                                                .value
                                                ?.uid) ==
                                        true
                                    ? null
                                    : () async {
                                        if (ref.read(userProvider).value ==
                                            null) {
                                          SnackbarMessage.showInfo(
                                              context: context,
                                              message:
                                                  "You need to be logged in so that you can vote");
                                          return;
                                        }
                                        isLikeLoadingState.value = true;
                                        await ref
                                            .read(oneProjectProvider.notifier)
                                            .likeAndUnlikeProject(
                                                context: context,
                                                projectId: project.id);
                                        isLikeLoadingState.value = false;
                                      },
                                isLoading: isLikeLoadingState.value == true,
                                title: ref
                                            .watch(oneProjectProvider)
                                            .value
                                            ?.votes
                                            .contains(ref
                                                .read(userProvider)
                                                .value
                                                ?.uid) ==
                                        true
                                    ? "Voted"
                                    : "Vote",
                              ),
                            ),
                            const Gap(15.0),
                            Expanded(
                              child: GreenVoiceButton.outline(
                                onTap: () async =>
                                    await BranchDeeplinkService.shareProject(
                                  ref.watch(oneProjectProvider).value!,
                                ),
                                title: "Share",
                              ),
                            )
                          ],
                        ),
                        const Gap(30.0),
                      ],
                    ),
                  )
                ].animate(interval: 200.ms).fadeIn().moveY(begin: 10, end: 0),
              ),
            );
          },
          error: (error, trace) => Center(
                child: Text(error.toString()),
              ),
          loading: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              )),
    );
  }
}
