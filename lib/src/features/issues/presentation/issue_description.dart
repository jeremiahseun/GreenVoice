import 'package:flutter/material.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/src/features/issues/widgets/adaptive_images.dart';
import 'package:greenvoice/src/features/issues/widgets/info_row.dart';
import 'package:greenvoice/src/features/issues/widgets/status_chip.dart';
import 'package:greenvoice/src/features/issues/widgets/vote_button.dart';
import 'package:greenvoice/utils/helpers/date_formatter.dart';

class IssueDetailScreen extends StatelessWidget {
  final IssueDetailArguments arguments;

  const IssueDetailScreen({
    super.key,
    required this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    final issue = arguments.issue;
    return Scaffold(
      appBar: AppBar(
        title: Text(issue.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
              child: AdaptiveImageGrid(images: issue.images),
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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        issue.location,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  IssueStatusChip(isResolved: issue.isResolved),
                  const SizedBox(height: 16),
                  Text(
                    issue.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  InfoRow(
                      icon: Icons.category,
                      text: issue.category),
                  InfoRow(
                      icon: Icons.person,
                      text: 'User ID: ${issue.createdByUserName}'),
                  InfoRow(
                    icon: Icons.access_time,
                    text:
                        'Created: ${DateFormatter.formatDate(issue.createdAt)}',
                  ),
                  InfoRow(
                    icon: Icons.update,
                    text:
                        'Updated: ${DateFormatter.formatDate(issue.updatedAt)}',
                  ),
                  const SizedBox(height: 16),
                  VoteButton(votes: issue.votes.length),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
