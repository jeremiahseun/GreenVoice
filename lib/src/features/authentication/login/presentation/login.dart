import 'package:greenvoice/utils/constants/exports.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
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
                  title: 'Welcome to GreenVoice',
                  subTitle: 'Kindly login in',
                  isLargerTitle: true,
                  doesHaveSubtitle: true),
              const Gap(60),
              CustomTextField(
                  labelText: 'Email Address',
                  hintText: 'destan@gmail.com',
                  controller: TextEditingController(),
                  keyboardType: TextInputType.emailAddress),
              const Gap(20),
              CustomTextField(
                  labelText: 'Password',
                  hintText: '******************',
                  obsureText: true,
                  controller: TextEditingController(),
                  keyboardType: TextInputType.emailAddress),
              const Gap(50),
              CustomButton(
                text: 'Login',
                isBigButton: true,
                onTap: () {},
                isFilledButton: true,
              ),
              const Gap(20),
              RichTextWidget(
                ontap: () {
                  context.push(NavigateToPage.register);
                },
                text: 'Don\'t have an account? ',
                subText: 'Register',
              ),
            ],
          )),
    );
  }
}
