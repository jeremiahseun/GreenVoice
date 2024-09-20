import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/src/models/issue/issue_model.dart';
import 'package:greenvoice/utils/common_widgets/fullscreen_carousel_image.dart';
import 'package:greenvoice/utils/styles/styles.dart';

import 'adaptive_images.dart';

class IssueCard extends StatelessWidget {
  final IssueModel issue;

  const IssueCard({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
              child: AdaptiveImageGrid(
                images: issue.images,
                onTap: (index) {
                  showImageCarousel(context, issue.images, initialIndex: index);
                },
              )),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  issue.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  issue.description,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const Gap(8),
                Text(
                  '${issue.votes.length} votes',
                  style: AppStyles.blackBold15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
