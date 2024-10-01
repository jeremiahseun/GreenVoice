import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/utils/helpers/date_formatter.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class CommentComponent extends StatelessWidget {
  const CommentComponent({
    super.key,
    this.image,
    required this.name,
    required this.message,
    required this.date,
    this.isDetailsPage = false,
  });

  final String? image;
  final String? name;
  final String message;
  final int date;
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
            backgroundImage: CachedNetworkImageProvider(
              image ?? 'https://example.com/default-avatar.jpg',
            ),
          ),
          const Gap(10.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    name?.isEmpty == true || name == null
                        ? "A GreenVoice user"
                        : name!,
                    style: AppStyles.blackBold14),
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
                  child: Text(message.trim(), style: AppStyles.blackNormal16),
                ),
                const Gap(5),
                Text(
                    DateFormatter.formatDateWithTime(
                        DateTime.fromMillisecondsSinceEpoch(date)),
                    style: AppStyles.blackNormal12)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
