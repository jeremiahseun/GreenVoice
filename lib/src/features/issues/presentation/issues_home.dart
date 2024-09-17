import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/core/routes/routes.dart';
import 'package:greenvoice/src/features/issues/data/issues_provider.dart';
import 'package:greenvoice/src/features/issues/widgets/category_tabs.dart';
import 'package:greenvoice/src/features/issues/widgets/issue_card.dart';
import 'package:greenvoice/src/models/issue/issue_model.dart';
import 'package:greenvoice/utils/styles/styles.dart';
import 'package:skeletonizer/skeletonizer.dart';

class IssuesView extends ConsumerStatefulWidget {
  const IssuesView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IssuesViewState();
}

class _IssuesViewState extends ConsumerState<IssuesView> {
  bool isExtended = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(issuesProvider.notifier).getAllIssues();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            shadowColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: const Icon(EvaIcons.search),
                onPressed: () {},
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: TextButton.icon(
                  label: const Text("View Map"),
                  icon: const Icon(EvaIcons.mapOutline),
                  onPressed: () => context.push(NavigateToPage.mapView),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Issues',
                style: AppStyles.blackBold18,
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(child: CategoryTabs()),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: ref.watch(issuesProvider).when(
                data: (issues) => SliverList.separated(
                      itemCount: issues.length,
                      separatorBuilder: (context, index) => const Gap(16),
                      itemBuilder: (context, i) => IssueCard(
                        issue: issues[i],
                      ),
                    ),
                error: (err, trace) => SliverToBoxAdapter(
                      child: Text(err.toString()),
                    ),
                loading: () => SliverSkeletonizer(
                        child: SliverList.separated(
                      itemCount: 4,
                      separatorBuilder: (context, index) => const Gap(16),
                      itemBuilder: (context, i) => IssueCard(
                        issue:   IssueModel(
                            id: '123',
                            title: 'Sample Issue',
                            description: 'This is a sample issue description.',
                            location: 'San Francisco, CA',
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
                            latitude: '37.7749',
                            longitude: '-122.4194',
                            comments: [],
                            createdByUserName: '',
                            createdByUserPicture: '',
                            shares: []),
                      ),
                    ))),
          ),
          const SliverGap(60)
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(NavigateToPage.addIssue),
        isExtended: isExtended,
        label: Text(
          'Report Issue',
          style: AppStyles.blackBold14.copyWith(color: AppColors.whiteColor),
        ),
        icon: const Icon(Icons.add, color: AppColors.whiteColor),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }
}
