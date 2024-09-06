import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      this.validator,
      this.labelText,
      required this.hintText,
      required this.controller,
      this.suffixIcon,
      this.prefixIcon,
      this.readOnly = false,
      this.isTimerBox = false,
      this.isSearchBox = false,
      this.decoration,
      this.onChanged,
      required this.keyboardType,
      this.obsureText = false,
      this.inputFormatters});
  final String hintText;
  final String? labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obsureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final bool isSearchBox;
  final bool isTimerBox;
  final List<TextInputFormatter>? inputFormatters;

  final Function(String)? onChanged;
  final Decoration? decoration;
  final FormFieldValidator<String?>? validator;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText ?? '',
          style: AppStyles.blackNormal14,
        ),
        const Gap(10),
        Container(
          //  height: isSearchBox ? 48 : 78,
          decoration: decoration,
          child: Column(
            children: [
              TextFormField(
                inputFormatters: inputFormatters,
                style: AppStyles.blackNormal14,
                onChanged: onChanged,
                readOnly: readOnly,
                validator: validator,
                obscureText: obsureText,
                keyboardType: keyboardType,
                cursorColor: AppColors.greyColor,
                controller: controller,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      top: 10, bottom: 10, right: 0, left: 15),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: suffixIcon,
                  ),
                  prefixIcon: prefixIcon,
                  hintText: hintText,
                  hintStyle: TextStyle(
                      fontSize: 13,
                      color: isTimerBox
                          ? AppColors.blackColor
                          : AppColors.greyColor),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.blackColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.greyColor,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.blackColor,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
