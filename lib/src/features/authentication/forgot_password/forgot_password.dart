import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:greenvoice/core/routes/routes.dart';
import 'package:greenvoice/utils/common_widgets/custom_button.dart';
import 'package:greenvoice/utils/common_widgets/custom_textfield.dart';
import 'package:greenvoice/utils/common_widgets/default_scaffold.dart';
import 'package:greenvoice/utils/common_widgets/page_title.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPasswordView> {
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
                  title: 'Forgot Password',
                  subTitle: 'Kindly enter your email address',
                  isLargerTitle: true,
                  doesHaveSubtitle: true),
              const Gap(50),
              CustomTextField(
                  labelText: 'Email Address',
                  hintText: 'destan@gmail.com',
                  controller: TextEditingController(),
                  keyboardType: TextInputType.emailAddress),
              const Gap(40),
              CustomButton(
                text: 'Verify',
                isBigButton: true,
                onTap: () {
                  context.go(NavigateToPage.home);
                },
                isFilledButton: true,
              ),
            ],
          )),
    );
  }
}
