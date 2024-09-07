import 'package:greenvoice/src/services/providers.dart';
import 'package:greenvoice/utils/components/phone_textfield.dart';

import '../../../../../utils/constants/exports.dart';

class Register extends ConsumerStatefulWidget {
  const Register({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  String phoneNumber = '';

  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final regsisterState = ref.watch(registerNotifier);
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
                  keyboardType: TextInputType.emailAddress),
              const Gap(20),
              PhoneField(
                controller: TextEditingController(),
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
                  labelText: 'Enter Password',
                  hintText: '******************',
                  obsureText: true,
                  controller: passwordController,
                  keyboardType: TextInputType.emailAddress),
              const Gap(20),
              CustomTextField(
                  labelText: 'Re-Enter Password',
                  hintText: '******************',
                  obsureText: true,
                  controller: confirmController,
                  keyboardType: TextInputType.emailAddress),
              const Gap(50),
              CustomButton(
                text: 'Register',
                isBigButton: true,
                onTap: () {
                  ref.read(registerNotifier.notifier).createGreenVoiceUser(
                      email: emailController.text,
                      password: passwordController.text,
                      firstName: nameController.text,
                      lastName: lastNameController.text,
                      phoneNumber: phoneNumber);
                },
                isFilledButton: true,
              ),
              Center(
                child: RichTextWidget(
                  ontap: () {
                    context.push(NavigateToPage.login);
                  },
                  text: 'Already have an account? ',
                  subText: 'Login',
                ),
              ),
            ],
          )),
    );
  }
}
