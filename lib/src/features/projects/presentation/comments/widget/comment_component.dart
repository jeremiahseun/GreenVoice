import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CommentComponent extends StatelessWidget {
  const CommentComponent({
    super.key,
    this.image,
    required this.name,
    required this.message,
    this.isDetailsPage = false,
  });

  final String? image;
  final String name;
  final String message;
  final bool isDetailsPage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(
              image ?? 'https://example.com/default-avatar.jpg',
            ),
          ),
          const Gap(10.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDetailsPage
                        ? Colors.transparent
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    maxWidth: 300,
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
