import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/src/models/issue/issue_model.dart';

class IssuesExpandedView extends ConsumerWidget {
  final IssueModel issue;
  final void Function()? onPressed;
  const IssuesExpandedView(
      {super.key, required this.issue, required this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            const Gap(50),
            AppBar(
              title: Text(issue.title ?? ""),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: onPressed,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      issue.description ?? "",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    // Add more details about the issue here
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
