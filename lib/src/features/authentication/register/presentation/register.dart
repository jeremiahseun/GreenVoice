// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/src/features/authentication/login/presentation/login.dart';
import 'package:greenvoice/src/features/authentication/register/data/register_notifier.dart';
import 'package:greenvoice/utils/common_widgets/custom_button.dart';
import 'package:greenvoice/utils/common_widgets/custom_textfield.dart';
import 'package:greenvoice/utils/common_widgets/default_scaffold.dart';
import 'package:greenvoice/utils/common_widgets/page_title.dart';
import 'package:greenvoice/utils/common_widgets/phone_textfield.dart';
import 'package:greenvoice/utils/common_widgets/rich_text_widget.dart';
import 'package:greenvoice/utils/common_widgets/snackbar_message.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<RegisterView> {
  String phoneNumber = '';

  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerNotifierProvider);
    return DefaultScaffold(
      safeAreaTop: true,
      isBusy: registerState.isLoading ? true : false,
      body: SingleChildScrollView(
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(40),
                  const TitleWidget(
                      title: 'Welcome to GreenVoice',
                      subTitle: 'Kindly Register your account',
                      isLargerTitle: true,
                      doesHaveSubtitle: true),
                  const Gap(50),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: SizedBox(
                            width: 190,
                            child: CustomTextField(
                              labelText: 'First Name',
                              hintText: 'last name',
                              controller: nameController,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const Gap(10),
                        Flexible(
                          child: SizedBox(
                            width: 190,
                            child: CustomTextField(
                              labelText: 'Last Name',
                              hintText: 'last name',
                              controller: lastNameController,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }

                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),
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
                  PhoneField(
                    controller: phoneController,
                    onChanged: (phone) {
                      phoneNumber = phone.completeNumber;
                    },
                    validator: (value) {
                      if (value!.number.isEmpty) {
                        return 'Please enter phone number';
                      }
                      if (value.number.length < 3) {
                        return 'Number is too short';
                      }
                      return null;
                    },
                  ),
                  const Gap(20),
                  CustomTextField(
                      suffixIcon: InkWell(
                          onTap: ref
                              .read(registerNotifierProvider)
                              .obscurePassword,
                          child: Visibility(
                            visible: registerState.isObscurePassword,
                            replacement: const Icon(
                              Icons.visibility,
                              color: AppColors.greyColor,
                            ),
                            child: const Icon(
                              Icons.visibility_off,
                              color: AppColors.greyColor,
                            ),
                          )),
                      labelText: 'Enter Password',
                      hintText: '******************',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Password';
                        }
                        return null;
                      },
                      obsureText: registerState.isObscurePassword,
                      controller: passwordController,
                      keyboardType: TextInputType.emailAddress),
                  const Gap(20),
                  CustomTextField(
                      suffixIcon: InkWell(
                          onTap: ref
                              .read(registerNotifierProvider)
                              .obscurePassword,
                          child: Visibility(
                            visible: registerState.isObscurePassword,
                            replacement: const Icon(
                              Icons.visibility,
                              color: AppColors.greyColor,
                            ),
                            child: const Icon(
                              Icons.visibility_off,
                              color: AppColors.greyColor,
                            ),
                          )),
                      labelText: 'Re-Enter Password',
                      hintText: '******************',
                      obsureText: registerState.isObscurePassword,
                      controller: confirmController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Re-Enter Password';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress),
                  const Gap(50),
                  CustomButton(
                    text: 'Register',
                    isBigButton: true,
                    onTap: () async {
                      if (passwordController.text != confirmController.text) {
                        SnackbarMessage.showError(
                            message: 'Passwords do not match',
                            context: context);
                        return;
                      }
                      if (formKey.currentState!.validate()) {
                        final registerUser = await ref
                            .read(registerNotifierProvider.notifier)
                            .createGreenVoiceUser(
                                email: emailController.text,
                                password: passwordController.text,
                                firstName: nameController.text,
                                lastName: lastNameController.text,
                                phoneNumber: phoneNumber);

                        if (registerUser == true) {
                          SnackbarMessage.showSuccess(
                              message: 'Account created successfully',
                              context: context);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginView()));
                          //   context.push(NavigateToPage.login);
                        }
                      }
                    },
                    isFilledButton: true,
                  ),
                  Center(
                    child: RichTextWidget(
                      ontap: () {
                        // context.push(NavigateToPage.login);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginView()));
                      },
                      text: 'Already have an account? ',
                      subText: 'Login',
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
