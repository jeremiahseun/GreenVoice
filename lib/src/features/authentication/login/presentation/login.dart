// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/core/routes/routes.dart';
import 'package:greenvoice/src/features/authentication/login/data/login_notifier.dart';
import 'package:greenvoice/src/features/issues/views/issues_home.dart';
import 'package:greenvoice/utils/common_widgets/custom_button.dart';
import 'package:greenvoice/utils/common_widgets/custom_textfield.dart';
import 'package:greenvoice/utils/common_widgets/default_scaffold.dart';
import 'package:greenvoice/utils/common_widgets/page_title.dart';
import 'package:greenvoice/utils/common_widgets/rich_text_widget.dart';
import 'package:greenvoice/utils/common_widgets/snackbar_message.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginNotifierProvider);
    return DefaultScaffold(
      isBusy: loginState.isLoading ? true : false,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(40),
                const TitleWidget(
                  title: 'Welcome to GreenVoice',
                  subTitle: 'Kindly login in',
                  isLargerTitle: true,
                  doesHaveSubtitle: true,
                ),
                const Gap(50),
                CustomTextField(
                    labelText: 'Email Address',
                    hintText: 'destan@gmail.com',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                      if (!emailRegex.hasMatch(value ?? '')) {
                        return 'Enter a valid email Address';
                      }
                      return null;
                    }),
                const Gap(20),
                CustomTextField(
                  suffixIcon: InkWell(
                      onTap: ref.read(loginNotifierProvider).obscurePassword,
                      child: Visibility(
                        visible: loginState.isObscurePassword,
                        replacement: const Icon(
                          Icons.visibility,
                          color: AppColors.greyColor,
                        ),
                        child: const Icon(
                          Icons.visibility_off,
                          color: AppColors.greyColor,
                        ),
                      )),
                  labelText: 'Password',
                  hintText: '******************',
                  obsureText: loginState.isObscurePassword,
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Password';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: RichTextWidget(
                    ontap: () {
                      context.push(NavigateToPage.forgotPassword);
                    },
                    text: '',
                    subText: 'Forgot Password?',
                  ),
                ),
                const Gap(40),
                CustomButton(
                  text: 'Login',
                  isBigButton: true,
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      final loginUser = await ref
                          .read(loginNotifierProvider)
                          .loginGreenVoiceUser(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim());
                      if (loginUser == true) {
                        SnackbarMessage.showSuccess(
                            context: context, message: 'Login successful');
                        context.go(NavigateToPage.issues);
                      } else {}
                    }
                  },
                  isFilledButton: true,
                ),
                const Gap(20),
                Center(
                  child: RichTextWidget(
                    ontap: () {
                      context.push(NavigateToPage.register);
                    },
                    text: 'Don\'t have an account? ',
                    subText: 'Register',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
