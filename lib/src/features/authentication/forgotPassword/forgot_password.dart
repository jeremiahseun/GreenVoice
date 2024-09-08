import 'package:greenvoice/utils/constants/exports.dart';

class Forgotpassword extends ConsumerStatefulWidget {
  const Forgotpassword({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends ConsumerState<Forgotpassword> {
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
                  context.push(NavigateToPage.issues);
                },
                isFilledButton: true,
              ),
            ],
          )),
    );
  }
}
