import 'package:flutter/material.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/src/features/issues/presentation/issue_description.dart';
import 'package:greenvoice/src/models/issue/issue_model.dart';

import 'adaptive_images.dart';

class IssueCard extends StatelessWidget {
  final IssueModel issue;

  const IssueCard({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IssueDetailScreen(
              arguments: IssueDetailArguments(issue: issue),
            ),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(4)),
                child: AdaptiveImageGrid(
                  images: issue.images,
                )),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    issue.title ?? '',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    issue.location ?? '',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text('${issue.votes} votes'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
