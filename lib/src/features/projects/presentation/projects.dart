import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/core/routes/routes.dart';
import 'package:greenvoice/src/features/issues/widgets/issue_loading.dart';
import 'package:greenvoice/src/features/projects/data/projects_provider.dart';
import 'package:greenvoice/src/features/projects/widgets/project_widget.dart';
import 'package:greenvoice/utils/styles/styles.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProjectHome extends ConsumerStatefulWidget {
  const ProjectHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends ConsumerState<ProjectHome> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(projectsProvider.notifier).getAllProjects();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 100,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [
                  StretchMode.blurBackground,
                  StretchMode.zoomBackground,
                  StretchMode.fadeTitle,
                ],
                centerTitle: true,
                title: Text(
                  'Proposed Projects',
                  style: AppStyles.blackBold18,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: ref.watch(projectsProvider).when(
                  data: (data) => SliverList.separated(
                        itemCount: data.length,
                        separatorBuilder: (context, index) => const Gap(10),
                        itemBuilder: (context, index) {
                          final project = data[index];
                          return ProjectCard(
                            project: project,
                            onComment: () {},
                            onLike: () {},
                            onShare: () {},
                            onClickProject: () => context.push(
                                "${NavigateToPage.projectDetails}/${project.id}"),
                          );
                        },
                      ),
                  error: (e, s) => SliverToBoxAdapter(
                        child: Center(child: Text(e.toString())),
                      ),
                  loading: () => const SliverSkeletonizer(
                        child: IssueLoadingWidget(),
                      )),
            ),
            const SliverGap(60)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(NavigateToPage.addProject),
        isExtended: true,
        label: Text(
          'Create a new project',
          style: AppStyles.blackBold14.copyWith(color: AppColors.whiteColor),
        ),
        icon: const Icon(Icons.add, color: AppColors.whiteColor),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }
}
