import 'package:flutter/material.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class GreenVoiceButton extends StatelessWidget {
  final Size size;
  final String title;
  final VoidCallback? onTap;
  final Color? color;
  final Color textColor;
  final Color? outlineColor;
  final bool isOutlined;
  final bool isLoading;
  const GreenVoiceButton(
      {super.key,
      required this.onTap,
      required this.title,
      this.isOutlined = false,
      this.size = const Size(150, 40),
      this.isLoading = false,
      this.textColor = AppColors.blackColor,
      this.outlineColor,
      this.color = AppColors.primaryColor});
  const GreenVoiceButton.outline(
      {super.key,
      required this.onTap,
      this.size = const Size(150, 40),
      required this.title,
      this.isOutlined = true,
      this.isLoading = false,
      this.textColor = AppColors.primaryColor,
      this.outlineColor = AppColors.primaryColor,
      this.color});
  const GreenVoiceButton.red(
      {super.key,
      required this.onTap,
      this.size = const Size(150, 40),
      required this.title,
      this.isOutlined = false,
      this.isLoading = false,
      this.textColor = AppColors.whiteColor,
      this.outlineColor,
      this.color = Colors.red});
  const GreenVoiceButton.fill(
      {super.key,
      required this.onTap,
      this.size = const Size(150, 40),
      required this.title,
      this.isOutlined = false,
      this.isLoading = false,
      this.textColor = AppColors.whiteColor,
      this.outlineColor,
      this.color = AppColors.primaryColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          side: isOutlined
              ? const BorderSide(
                  color: AppColors.primaryColor,
                  width: 1,
                )
              : null,
          fixedSize: size,
          maximumSize: size,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: AppColors.blackColor,
                ),
              )
            : Text(
                title,
                style: AppStyles.blackBold12.copyWith(color: textColor),
              ));
  }
}
