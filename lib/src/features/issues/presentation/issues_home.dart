import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/core/routes/routes.dart';
import 'package:greenvoice/src/features/issues/data/issues_provider.dart';
import 'package:greenvoice/src/features/issues/widgets/issue_card.dart';
import 'package:greenvoice/src/features/issues/widgets/issue_loading.dart';
import 'package:greenvoice/utils/styles/styles.dart';

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
            actions: [
              Visibility(
                visible: !kIsWeb,
                replacement: const SizedBox(),
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: TextButton.icon(
                    label: const Text("View Map"),
                    icon: const Icon(EvaIcons.mapOutline),
                    onPressed: () => context.push(NavigateToPage.mapView),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Issues',
                style: AppStyles.blackBold18,
              ),
            ),
          ),
          // const SliverPadding(
          //   padding: EdgeInsets.all(16.0),
          //   sliver: SliverToBoxAdapter(child: CategoryTabs()),
          // ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: ref.watch(issuesProvider).when(
                data: (issues) => SliverList.separated(
                      itemCount: issues.length,
                      separatorBuilder: (context, index) => const Gap(16),
                      itemBuilder: (context, i) => InkWell(
                        onTap: () {
                          context.push(
                              "${NavigateToPage.issueDetails}/${issues[i].id}");
                        },
                        child: IssueCard(
                          issue: issues[i],
                        ),
                      ),
                    ),
                error: (err, trace) => SliverToBoxAdapter(
                      child: Text(err.toString()),
                    ),
                loading: () => const IssueLoadingWidget()),
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
