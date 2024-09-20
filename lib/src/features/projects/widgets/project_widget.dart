import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/src/models/project/project_model.dart';
import 'package:greenvoice/utils/common_widgets/project_stats.dart';
import 'package:greenvoice/utils/common_widgets/rich_text_widget.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onClickProject;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  const ProjectCard({
    super.key,
    required this.project,
    required this.onClickProject,
    required this.onComment,
    required this.onLike,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onClickProject,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.whiteColor,
              boxShadow: const [
                BoxShadow(
                  color: Color(0xfff2efed),
                  blurRadius: 15,
                  spreadRadius: 1,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            height: 390,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(project.images.first),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Gap(10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(5),
                      Text(
                        project.title,
                        style: AppStyles.blackBold18,
                      ),
                      const Gap(5),
                      Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        project.description,
                      ),
                      const Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichTextWidget(
                            text: 'Status:',
                            subText: switch (project.status) {
                              ProjectStatus.inProgress => ' In Progress',
                              ProjectStatus.open => ' Open for Voting',
                              ProjectStatus.closed => ' Closed',
                            },
                            subtextColor: switch (project.status) {
                              ProjectStatus.inProgress => AppColors.orangeColor,
                              ProjectStatus.open => AppColors.primaryColor,
                              ProjectStatus.closed => AppColors.redColor,
                            },
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              alignment: Alignment.center,
                              width: 70,
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.primaryColor),
                              child: Text(
                                'Vote',
                                style: AppStyles.blackBold12.copyWith(
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: onLike,
              child: ProjectStats(
                data: project.likes.length.toString(),
                icon: const Icon(
                  Icons.arrow_upward,
                ),
              ),
            ),
            InkWell(
              onTap: onComment,
              child: ProjectStats(
                data: project.comments.length.toString(),
                icon: const Icon(
                  Icons.message_outlined,
                ),
              ),
            ),
            InkWell(
              onTap: onShare,
              child: ProjectStats(
                data: project.shares.length.toString(),
                icon: const Icon(
                  Icons.stacked_line_chart_sharp,
                ),
              ),
            ),
          ],
        ),
        const Gap(25),
      ],
    );
  }
}
