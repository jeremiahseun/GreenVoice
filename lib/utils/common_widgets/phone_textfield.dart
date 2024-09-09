import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/utils/styles/styles.dart';

import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneField extends StatelessWidget {
  const PhoneField(
      {super.key, required this.controller, this.validator, this.onChanged});

  final TextEditingController controller;
  final String? Function(PhoneNumber?)? validator;
  final void Function(PhoneNumber)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: AppStyles.blackNormal14,
        ),
        const Gap(5),
        IntlPhoneField(
            style: AppStyles.blackNormal14,
            pickerDialogStyle: PickerDialogStyle(
              backgroundColor: AppColors.whiteColor,
              searchFieldCursorColor: AppColors.blackColor,
              searchFieldInputDecoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.greyColor),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.blackColor),
                ),
              ),
            ),
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            disableLengthCheck: true,
            showCountryFlag: false,
            showDropdownIcon: true,
            decoration: InputDecoration(
              hintText: '01234454664*',
              contentPadding: const EdgeInsets.all(10),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.blackColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.greyColor),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.blackColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.blackColor),
              ),
            ),
            initialCountryCode: 'NG',
            inputFormatters: [
              LengthLimitingTextInputFormatter(11),
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: onChanged,
            validator: validator),
      ],
    );
  }
}
