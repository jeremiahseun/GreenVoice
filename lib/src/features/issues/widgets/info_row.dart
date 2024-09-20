import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const Gap(8),
          Expanded(
              child: Text(text,
                  style: AppStyles.blackNormal16
                      .copyWith(color: Colors.grey[800]))),
        ],
      ),
    );
  }
}
