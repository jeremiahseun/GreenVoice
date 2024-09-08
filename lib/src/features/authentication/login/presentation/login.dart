// ignore_for_file: use_build_context_synchronously

import 'package:greenvoice/src/features/authentication/forgotPassword/forgot_password.dart';
import 'package:greenvoice/src/features/issues/views/issues_home.dart';
import 'package:greenvoice/src/services/providers.dart';
import 'package:greenvoice/utils/components/custom_toast.dart';
import 'package:greenvoice/utils/constants/exports.dart';
import 'package:greenvoice/utils/helpers/enums.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginNotifier);
    return DefaultScaffold(
      isBusy: loginState.loadingState == LoadingState.loading ? true : false,
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
                    onTap: () {
                      ref.read(loginNotifier.notifier).obscurePassword();
                    },
                    child: loginState.isSelected
                        ? const Icon(
                            Icons.visibility,
                            color: AppColors.greyColor,
                          )
                        : const Icon(
                            Icons.visibility_off,
                            color: AppColors.greyColor,
                          ),
                  ),
                  labelText: 'Password',
                  hintText: '******************',
                  obsureText: loginState.isSelected,
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
                      // context.push(NavigateToPage.forgotPassword);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Forgotpassword()));
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
                          .read(loginNotifier.notifier)
                          .loginGreenVoiceUser(
                              email: emailController.text,
                              password: passwordController.text);
                      if (loginUser == true) {
                        CustomToast().showCustomToast(
                            message: 'login successful',
                            isError: false,
                            context: context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const IssuesScreen()));
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
