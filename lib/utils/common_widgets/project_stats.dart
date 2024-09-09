import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class ProjectStats extends StatelessWidget {
  const ProjectStats({super.key, required this.icon, required this.data});
  final Widget icon;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const Gap(3),
        Text(
          data,
          style: AppStyles.blackBold12,
        )
      ],
    );
  }
}
