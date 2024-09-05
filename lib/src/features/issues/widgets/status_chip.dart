

import 'package:flutter/material.dart';

class IssueStatusChip extends StatelessWidget {
  final bool isResolved;

  const IssueStatusChip({super.key, required this.isResolved});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        isResolved ? 'Resolved' : 'Unresolved',
        style: TextStyle(color: isResolved ? Colors.green : Colors.red),
      ),
      backgroundColor: isResolved
          ? Colors.green.withOpacity(0.1)
          : Colors.red.withOpacity(0.1),
    );
  }
}
