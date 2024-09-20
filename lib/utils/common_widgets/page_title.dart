import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.isLargerTitle,
      required this.doesHaveSubtitle});

  final String title;
  final String subTitle;
  final bool isLargerTitle;
  final bool doesHaveSubtitle;

  @override
  Widget build(BuildContext context) {
    return doesHaveSubtitle
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: isLargerTitle
                    ? AppStyles.blackBold24
                    : AppStyles.blackBold18,
              ),
              const Gap(5),
              Text(
                subTitle,
                style: AppStyles.blackNormal16,
              ),
            ],
          )
        : Text(
            title,
            style:
                isLargerTitle ? AppStyles.blackBold16 : AppStyles.blackBold14,
          );
  }
}
