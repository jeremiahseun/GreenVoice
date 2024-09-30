import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/src/features/authentication/user/user_provider.dart';
import 'package:greenvoice/src/features/issues/data/issues_provider.dart';
import 'package:greenvoice/src/features/issues/presentation/comments/comments_bottomsheet.dart';
import 'package:greenvoice/src/features/issues/widgets/adaptive_images.dart';
import 'package:greenvoice/src/features/issues/widgets/info_row.dart';
import 'package:greenvoice/src/features/issues/widgets/status_chip.dart';
import 'package:greenvoice/src/services/branch_deeplink_service.dart';
import 'package:greenvoice/utils/common_widgets/fullscreen_carousel_image.dart';
import 'package:greenvoice/utils/common_widgets/vote_button.dart';
import 'package:greenvoice/utils/helpers/date_formatter.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class IssueDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const IssueDetailScreen({super.key, required this.id});

  @override
  ConsumerState<IssueDetailScreen> createState() => _IssueDetailScreenState();
}

class _IssueDetailScreenState extends ConsumerState<IssueDetailScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((time) {
      ref.read(oneIssueProvider.notifier).getOneIssues(widget.id);
    });
    super.initState();
  }

  final isLikeLoadingState = ValueNotifier<bool>(false);
  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(ref.watch(oneIssueProvider).when(
              data: (data) => data.title,
              error: (e, s) => '',
              loading: () => '...')),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                await BranchDeeplinkService.shareIssue(
                  ref.watch(oneIssueProvider).value!,
                );
              },
            ),
          ],
        ),
        body: ref.watch(oneIssueProvider).when(
            data: (data) {
              final issue = data;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1.0),
                      child: AdaptiveImageGrid(
                        images: issue.images,
                        onTap: (index) {
                          showImageCarousel(context, issue.images,
                              initialIndex: index);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            issue.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const Gap(8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.location_on,
                                  size: 16, color: Colors.grey[600]),
                              const Gap(4),
                              Expanded(
                                child: Text(
                                  issue.location,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                            ],
                          ),
                          const Gap(16),
                          IssueStatusChip(isResolved: issue.isResolved),
                          const Gap(16),
                          Text(
                            issue.description,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Gap(16),
                          InfoRow(
                              icon: Icons.how_to_vote_rounded,
                              text: issue.votes.isEmpty
                                  ? "No Votes"
                                  : issue.votes.length == 1
                                      ? "1 person voted"
                                      : "${issue.votes.length} people voted"),
                          InfoRow(icon: Icons.category, text: issue.category),
                          Visibility(
                            visible: !issue.isAnonymous,
                            replacement: const InfoRow(
                                icon: Icons.person, text: 'Anonymous Post'),
                            child: InfoRow(
                                icon: Icons.person,
                                text: issue.createdByUserName
                                        .split(" ")
                                        .first
                                        .isNotEmpty
                                    ? 'Posted by ${issue.createdByUserName.split(" ").first}'
                                    : "Posted by a GreenVoice user"),
                          ),
                          InfoRow(
                            icon: Icons.access_time,
                            text:
                                'Issue created on ${DateFormatter.formatDate(issue.createdAt)}',
                          ),
                          InfoRow(
                            icon: Icons.update,
                            text:
                                'Last Update was ${DateFormatter.formatDate(issue.updatedAt)}',
                          ),
                          const Gap(16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Comments',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return CommentBottomSheet(
                                          issueID: issue.id,
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    'View all Comments',
                                    style: AppStyles.blackNormal10.copyWith(
                                      color: AppColors.primaryColor,
                                    ),
                                  )),
                            ],
                          ),



                          
                          const Gap(26),
                          AnimatedVoteButton(
                            isVoted: ref
                                    .watch(oneIssueProvider)
                                    .value
                                    ?.votes
                                    .contains(
                                      ref.read(userProvider).value?.uid,
                                    ) ==
                                true,
                            isLoading: isLikeLoadingState.value,
                            onTap: () async {
                              if (ref
                                      .watch(oneIssueProvider)
                                      .value
                                      ?.votes
                                      .contains(
                                        ref.read(userProvider).value?.uid,
                                      ) !=
                                  true) {
                                isLikeLoadingState.value = true;
                                await ref
                                    .read(oneIssueProvider.notifier)
                                    .likeAndUnlikeIssue(
                                      context: context,
                                      issueId: issue.id,
                                    );
                                isLikeLoadingState.value = false;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            error: (error, trace) => Center(
                  child: Text(error.toString()),
                ),
            loading: () => const Center(
                  child: CircularProgressIndicator.adaptive(),
                )));
  }
}
