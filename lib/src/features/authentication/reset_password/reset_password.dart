import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/utils/common_widgets/custom_button.dart';
import 'package:greenvoice/utils/common_widgets/custom_textfield.dart';
import 'package:greenvoice/utils/common_widgets/default_scaffold.dart';
import 'package:greenvoice/utils/common_widgets/page_title.dart';

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {
  final oldPassword = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      safeAreaTop: true,
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(40),
              const TitleWidget(
                  title: 'Password Reset',
                  subTitle: '',
                  isLargerTitle: true,
                  doesHaveSubtitle: true),
              const Gap(30),
              CustomTextField(
                  labelText: 'Old password',
                  hintText: 'Enter old password ',
                  controller: oldPassword,
                  keyboardType: TextInputType.emailAddress),
              const Gap(20),
              CustomTextField(
                  labelText: 'New Password',
                  hintText: 'Enter new password',
                  obsureText: true,
                  controller: passwordController,
                  keyboardType: TextInputType.emailAddress),
              const Gap(20),
              CustomTextField(
                  labelText: 'Confrim new Password',
                  hintText: 'Confirm new password',
                  obsureText: true,
                  controller: confirmController,
                  keyboardType: TextInputType.emailAddress),
              const Gap(50),
              CustomButton(
                text: 'Save',
                isBigButton: true,
                onTap: () {},
                isFilledButton: true,
              ),
            ],
          )),
    );
  }
}
