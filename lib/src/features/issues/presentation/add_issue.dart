import 'package:flutter/material.dart';
import 'package:flutter_location_search/flutter_location_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/src/features/authentication/user/user_provider.dart';
import 'package:greenvoice/src/features/issues/data/issues_provider.dart';
import 'package:greenvoice/src/features/issues/widgets/add_issues_widgets.dart';
import 'package:greenvoice/utils/common_widgets/green_voice_button.dart';
import 'package:greenvoice/utils/common_widgets/not_logged_in.dart';
import 'package:greenvoice/utils/common_widgets/snackbar_message.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class AddIssueScreen extends ConsumerStatefulWidget {
  const AddIssueScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddIssueScreenState();
}

class _AddIssueScreenState extends ConsumerState<AddIssueScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    ref.read(addIssueProvider).disposeItems();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final addIssueRead = ref.read(addIssueProvider);
    final addIssueWatch = ref.watch(addIssueProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: const Text('Report an issue'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Issue Title', style: AppStyles.blackBold18),
              const Gap(8),
              CustomTextField(
                controller: _titleController,
                hint: 'Title',
                validator: (value) {
                  if (value == null) {
                    return "You must provide a title.";
                  }
                  return null;
                },
              ),
              const Gap(16),
              Text('Issue Description', style: AppStyles.blackBold18),
              const Gap(8),
              CustomTextField(
                  controller: _descriptionController,
                  hint: 'Description',
                  validator: (value) {
                    if (value == null) {
                      return "You must provide a description.";
                    }
                    return null;
                  },
                  maxLines: 5),
              const Gap(16),
              Text('What is the location?', style: AppStyles.blackBold18),
              const Gap(8),
              LocationButton(
                  address: addIssueWatch.address.isEmpty
                      ? 'Add location'
                      : addIssueWatch.address,
                  onLocationSelected: () async {
                    LocationData? locationData = await LocationSearch.show(
                        countryCodes: ["NG"],
                        loadingWidget:
                            const CircularProgressIndicator.adaptive(),
                        context: context,
                        mode: Mode.overlay);
                    if (locationData != null) {
                      addIssueRead.setLocation(
                          address: locationData.address,
                          longitude: locationData.longitude,
                          latitude: locationData.latitude);
                    }
                  }),
              const Gap(16),
              Text('Issue Images', style: AppStyles.blackBold18),
              const Gap(8),
              ImageGrid(
                  onImageRemove: (index) => addIssueRead.removeImage(index),
                  images: addIssueWatch.images,
                  onImageAdded: () async {
                    if (addIssueWatch.images.length >= 5) {
                      SnackbarMessage.showInfo(
                          context: context,
                          message: "You cannot upload more than 5 images");
                      return;
                    }
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
                                  await addIssueRead.pickImage(false);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text('Choose from gallery'),
                                onTap: () async {
                                  context.pop();
                                  await addIssueRead.pickImage(true);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
              const Gap(16),
              AnonymousSwitch(
                value: addIssueWatch.postAnonymously,
                onChanged: (value) => addIssueRead.setPostAnonymous(value),
              ),
              const Gap(24),
              Visibility(
                visible: ref.watch(userProvider).hasValue &&
                    !ref.watch(userProvider).hasError,
                replacement: const NotLoggedInWidget(),
                child: Row(
                  children: [
                    Expanded(
                      child: GreenVoiceButton.outline(
                        onTap: !addIssueWatch.postAnonymously
                            ? null
                            : () async {
                                if (formKey.currentState?.validate() == false) {
                                  SnackbarMessage.showInfo(
                                      context: context,
                                      message: "Fill the form and try again.");
                                  return;
                                }
                                if (addIssueWatch.images.isEmpty) {
                                  SnackbarMessage.showInfo(
                                      context: context,
                                      message:
                                          "You cannot add a project without adding images.");
                                  return;
                                }
                                if (ref
                                    .read(addIssueProvider)
                                    .address
                                    .isEmpty) {
                                  SnackbarMessage.showInfo(
                                      context: context,
                                      message:
                                          "You need the add the location of the project.");
                                  return;
                                }

                                //* We are good to go from here
                                final res = await addIssueRead.addIssue(
                                    title: _titleController.text,
                                    description: _descriptionController.text,
                                    isAnonymous: true,
                                    context: context);
                                if (res) {
                                  if (!context.mounted) return;
                                  context.pop();
                                  ref
                                      .read(issuesProvider.notifier)
                                      .getAllIssues();
                                }
                              },
                        isLoading: addIssueWatch.isLoading,
                        title: 'Post Anonymously',
                        size: const Size(300, 50),
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: GreenVoiceButton.fill(
                        onTap: () async {
                          if (formKey.currentState?.validate() == false) {
                            SnackbarMessage.showInfo(
                                context: context,
                                message: "Fill the form and try again.");
                            return;
                          }
                          if (addIssueWatch.images.isEmpty) {
                            SnackbarMessage.showInfo(
                                context: context,
                                message:
                                    "You cannot add a project without adding images.");
                            return;
                          }
                          if (ref.read(addIssueProvider).address.isEmpty) {
                            SnackbarMessage.showInfo(
                                context: context,
                                message:
                                    "You need the add the location of the project.");
                            return;
                          }

                          //* We are good to go from here

                          final res = await addIssueRead.addIssue(
                              title: _titleController.text,
                              description: _descriptionController.text,
                              isAnonymous: false,
                              context: context);
                          if (res) {
                            if (!context.mounted) return;
                            context.pop();
                            ref.read(issuesProvider.notifier).getAllIssues();
                          }
                        },
                        isLoading: addIssueWatch.isLoading,
                        title: 'Post',
                        size: const Size(300, 50),
                      ),
                    )
                  ],
                ),
              ),
              const Gap(5),
              Visibility(
                  visible: addIssueWatch.isLoading,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                        "Uploading images... ${addIssueWatch.uploadState} of ${addIssueWatch.images.length}"),
                  )),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
