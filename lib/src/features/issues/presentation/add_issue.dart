import 'package:flutter/material.dart';
import 'package:flutter_location_search/flutter_location_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/src/features/issues/data/issues_provider.dart';
import 'package:greenvoice/src/features/issues/widgets/add_issues_widgets.dart';
import 'package:greenvoice/utils/common_widgets/green_voice_button.dart';
import 'package:greenvoice/utils/common_widgets/snackbar_message.dart';

class AddIssueScreen extends ConsumerStatefulWidget {
  const AddIssueScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddIssueScreenState();
}

class _AddIssueScreenState extends ConsumerState<AddIssueScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Issue',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            CustomTextField(controller: _titleController, hint: 'Title'),
            const SizedBox(height: 16),
            const Text('Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            CustomTextField(
                controller: _descriptionController,
                hint: 'Description',
                maxLines: 5),
            const SizedBox(height: 16),
            LocationButton(
                address: addIssueWatch.address.isEmpty
                    ? 'Add location'
                    : addIssueWatch.address,
                onLocationSelected: () async {
                  LocationData? locationData = await LocationSearch.show(
                      countryCodes: ["NG"],
                      loadingWidget: const CircularProgressIndicator.adaptive(),
                      context: context,
                      mode: Mode.overlay);
                  if (locationData != null) {
                    addIssueRead.setLocation(
                        address: locationData.address,
                        longitude: locationData.longitude,
                        latitude: locationData.latitude);
                  }
                }),
            const SizedBox(height: 16),
            ImageGrid(
                images: addIssueWatch.images,
                onImageAdded: () async {
                  if (addIssueWatch.images.length > 5) {
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
            const SizedBox(height: 16),
            AnonymousSwitch(
              value: addIssueWatch.postAnonymously,
              onChanged: (value) => addIssueRead.setPostAnonymous(value),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GreenVoiceButton.outline(
                    onTap: !addIssueWatch.postAnonymously ? null : () {},
                    title: 'Post Anonymously',
                    size: const Size(300, 50),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: GreenVoiceButton.fill(
                    onTap: () {},
                    title: 'Post',
                    size: const Size(300, 50),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
