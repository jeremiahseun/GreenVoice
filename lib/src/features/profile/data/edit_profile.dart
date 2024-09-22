import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/src/features/issues/widgets/add_issues_widgets.dart';
import 'package:greenvoice/src/features/profile/data/profile_provider.dart';
import 'package:greenvoice/utils/common_widgets/custom_button.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key, required this.editProfileArgument});

  final EditProfileArgument editProfileArgument;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNumber = TextEditingController();
  final emailAddress = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? imageUrl;

  @override
  void initState() {
    firstName.text = widget.editProfileArgument.firstName;
    lastName.text = widget.editProfileArgument.lastName;
    emailAddress.text = widget.editProfileArgument.email;
    imageUrl = widget.editProfileArgument.image;
    super.initState();
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    emailAddress.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Edit Profile',
          style: AppStyles.blackBold18,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const Gap(40),
                    GestureDetector(
                      onTap: () async {
                        await showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: const Icon(Icons.camera),
                                    title: const Text('Take a photo'),
                                    onTap: () async {
                                      context.pop();
                                      await profile.pickImage(false);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Choose from gallery'),
                                    onTap: () async {
                                      context.pop();
                                      await profile.pickImage(true);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 150,
                        width: 160,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.greyColor),
                          image: DecorationImage(
                            image: profile.images == null
                                ? CachedNetworkImageProvider(imageUrl ?? '')
                                : FileImage(
                                    profile.images!,
                                  ),
                            fit: BoxFit.cover,
                          ),
                          color: AppColors.lightPrimaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: profile.images != null
                            ? const Icon(
                                Icons.camera_alt,
                                color: AppColors.redColor,
                              )
                            : imageUrl == null
                                ? const SizedBox()
                                : profile.images == null && imageUrl!.isEmpty
                                    ? const Icon(
                                        Icons.camera_alt,
                                        color: AppColors.redColor,
                                      )
                                    : const SizedBox(),
                      ),
                    ),
                    const Gap(30),
                    Row(
                      children: [
                        Flexible(
                          child: CustomTextField(
                              hint: 'First name',
                              controller: firstName,
                              keyboardType: TextInputType.name),
                        ),
                        const Gap(10),
                        Flexible(
                          child: CustomTextField(
                              hint: 'Last Name',
                              controller: lastName,
                              keyboardType: TextInputType.name),
                        ),
                      ],
                    ),
                    const Gap(20),
                    CustomTextField(
                        hint: 'Email Address',
                        controller: emailAddress,
                        readOnly: true,
                        keyboardType: TextInputType.name),
                    const Gap(20),
                    CustomTextField(
                        hint: 'Phone number',
                        controller: phoneNumber,
                        keyboardType: TextInputType.name),
                    const Gap(150),
                    CustomButton(
                      isBigButton: true,
                      isFilledButton: true,
                      text: 'Save',
                      isLoading: profile.isLoading,
                      onTap: () async {
                        await ref
                            .read(profileProvider.notifier)
                            .editUserProfile(
                                imageUrl: '',
                                firstName: firstName.text,
                                lastName: lastName.text,
                                phoneNumber: phoneNumber.text,
                                email: emailAddress.text,
                                context: context);
                      },
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
