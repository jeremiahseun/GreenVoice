import 'package:flutter/material.dart';
import 'package:flutter_location_search/flutter_location_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/src/features/authentication/user/user_provider.dart';
import 'package:greenvoice/src/features/issues/widgets/add_issues_widgets.dart';
import 'package:greenvoice/src/features/projects/data/projects_provider.dart';
import 'package:greenvoice/src/features/projects/widgets/adaptive_date_picker.dart';
import 'package:greenvoice/src/features/projects/widgets/project_status.dart';
import 'package:greenvoice/src/models/project/project_model.dart';
import 'package:greenvoice/utils/common_widgets/green_voice_button.dart';
import 'package:greenvoice/utils/common_widgets/not_logged_in.dart';
import 'package:greenvoice/utils/common_widgets/snackbar_message.dart';
import 'package:greenvoice/utils/helpers/naira_format.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class AddProjectScreen extends ConsumerStatefulWidget {
  const AddProjectScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddIssueScreenState();
}

class _AddIssueScreenState extends ConsumerState<AddProjectScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    ref.read(addProjectProvider).disposeItems();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final addProjectsRead = ref.read(addProjectProvider);
    final addProjectsWatch = ref.watch(addProjectProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: const Text('Create a new Project'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Project Title', style: AppStyles.blackBold18),
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
              Text('Project Description', style: AppStyles.blackBold18),
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
                  address: addProjectsWatch.address.isEmpty
                      ? 'Add location'
                      : addProjectsWatch.address,
                  onLocationSelected: () async {
                    LocationData? locationData = await LocationSearch.show(
                        countryCodes: ["NG"],
                        loadingWidget:
                            const CircularProgressIndicator.adaptive(),
                        context: context,
                        mode: Mode.overlay);
                    if (locationData != null) {
                      addProjectsRead.setLocation(
                          address: locationData.address,
                          longitude: locationData.longitude,
                          latitude: locationData.latitude);
                    }
                  }),
              const Gap(16),
              Text('Project Status', style: AppStyles.blackBold18),
              const Gap(8),
              ProjectStatusPicker(
                initialStatus: ProjectStatus.open,
                onStatusChanged: (value) =>
                    ref.read(addProjectProvider).setProjectStatus(value),
              ),
              const Gap(16),
              Text('Proposed Date', style: AppStyles.blackBold18),
              const Gap(8),
              AdaptiveDatePicker(
                initialDate: DateTime.now(),
                onDateChanged: (value) =>
                    ref.read(addProjectProvider).setProposedDate(value),
              ),
              const Gap(16),
              Text('Proposed Amount', style: AppStyles.blackBold18),
              const Gap(8),
              CustomTextField(
                controller: _amountController,
                hint: 'Amount needed',
                inputFormatters: [
                  NairaInputFormatter(),
                ],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null) {
                    return "You must provide the amount needed.";
                  }
                  return null;
                },
              ),
              const Gap(16),
              Text('Project Images', style: AppStyles.blackBold18),
              const Gap(8),
              ImageGrid(
                  images: addProjectsWatch.images,
                  onImageRemove: (index) => addProjectsRead.removeImage(index),
                  onImageAdded: () async {
                    if (addProjectsWatch.images.length >= 5) {
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
                                  await addProjectsRead.pickImage(false);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text('Choose from gallery'),
                                onTap: () async {
                                  context.pop();
                                  await addProjectsRead.pickImage(true);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
              const Gap(24),
              Visibility(
                  visible: ref.watch(userProvider).hasValue &&
                      !ref.watch(userProvider).hasError,
                  replacement: const NotLoggedInWidget(),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GreenVoiceButton.fill(
                      isLoading: addProjectsWatch.isLoading,
                      onTap: () async {
                        if (formKey.currentState?.validate() == false) {
                          SnackbarMessage.showInfo(
                              context: context,
                              message: "Fill the form and try again.");
                          return;
                        }
                        if (addProjectsWatch.images.isEmpty) {
                          SnackbarMessage.showInfo(
                              context: context,
                              message:
                                  "You cannot add a project without adding images.");
                          return;
                        }
                        if (ref.read(addProjectProvider).address.isEmpty) {
                          SnackbarMessage.showInfo(
                              context: context,
                              message:
                                  "You need the add the location of the project.");
                          return;
                        }
                        if (ref
                                .read(addProjectProvider)
                                .proposedDate
                                .difference(DateTime.now())
                                .inDays <
                            2) {
                          SnackbarMessage.showInfo(
                              context: context,
                              message:
                                  "The project proposed date is too short.");
                          return;
                        }
                        //* We are good to go from here.

                        final res = await addProjectsRead.addProject(
                            title: _titleController.text.trim(),
                            description: _descriptionController.text.trim(),
                            amountNeeded: _amountController.text.trim(),
                            context: context);
                        if (res) {
                          if (!context.mounted) return;
                          context.pop();
                          ref.read(projectsProvider.notifier).getAllProjects();
                        }
                      },
                      title: 'Post',
                      size: const Size(300, 50),
                    ),
                  )),
              const Gap(5),
              Visibility(
                  visible: addProjectsWatch.isLoading,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                        "Uploading images... ${addProjectsWatch.uploadState} of ${addProjectsWatch.images.length}"),
                  )),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
