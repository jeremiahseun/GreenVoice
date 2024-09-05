import 'package:flutter/material.dart';

class VoteButton extends StatelessWidget {
  final int votes;

  const VoteButton({super.key, required this.votes});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Implement voting functionality
      },
      icon: const Icon(Icons.thumb_up),
      label: Text('Vote ($votes)'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }
}
