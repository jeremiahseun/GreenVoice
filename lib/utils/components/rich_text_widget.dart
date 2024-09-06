import 'package:flutter/material.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class RichTextWidget extends StatelessWidget {
  const RichTextWidget(
      {super.key,
      required this.text,
      required this.subText,
      required this.ontap});
  final String text;
  final String subText;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        onPressed: ontap,
        icon: Text.rich(
          TextSpan(
            text: text,
            style: AppStyles.blackNormal14,
            children: <TextSpan>[
              TextSpan(
                text: subText,
                style: AppStyles.blackNormal14
                    .copyWith(color: AppColors.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
