import 'package:flutter/material.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.text,
      required this.isBigButton,
      this.isFilledButton = false,
      this.isLoading = false,
      required this.onTap});
  final String text;
  final bool isFilledButton;
  final VoidCallback onTap;
  final bool isBigButton;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: isBigButton ? double.infinity : 164,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: AppColors.primaryColor),
            color:
                isFilledButton ? AppColors.primaryColor : AppColors.whiteColor,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: AppColors.whiteColor,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                ),
              )
            : Text(
                text,
                style: isFilledButton
                    ? AppStyles.blackBold14.copyWith(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w300)
                    : AppStyles.blackBold14.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w300),
              ),
      ),
    );
  }
}
