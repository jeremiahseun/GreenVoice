import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/core/locator.dart';
import 'package:greenvoice/src/models/project/project_model.dart';
import 'package:greenvoice/src/services/firebase/firebase.dart';
import 'package:greenvoice/src/services/image_service.dart';
import 'package:greenvoice/src/services/storage_service.dart';
import 'package:greenvoice/utils/common_widgets/snackbar_message.dart';
import 'package:greenvoice/utils/constants/storage_keys.dart';
import 'package:greenvoice/utils/helpers/greenvoice_notifier.dart';

final projectsProvider =
    StateNotifierProvider<ProjectsProvider, AsyncValue<List<ProjectModel>>>(
        (ref) => ProjectsProvider(ref));

final oneProjectProvider =
    StateNotifierProvider<OneProjectProvider, AsyncValue<ProjectModel>>(
        (ref) => OneProjectProvider(ref));

final addProjectProvider =
    ChangeNotifierProvider.autoDispose((ref) => AddProjectProvider(ref));

class AddProjectProvider extends GreenVoiceNotifier {
  final firebaseFirestore = locator<FirebaseFirestoreService>();
  final firebaseStorage = locator<FirebaseStorageService>();
  final storageService = locator<StorageService>();
  AddProjectProvider(this.ref);
  Ref ref;
  double latitude = 0.0;
  double longitude = 0.0;
  int uploadState = 0;
  ProjectStatus projectStatus = ProjectStatus.open;
  String address = '';
  List<File> images = [];
  DateTime proposedDate = DateTime.now();

  void disposeItems() {
    latitude = 0.0;
    longitude = 0.0;
    address = '';
    images = [];
    uploadState = 0;
    proposedDate = DateTime.now();
    projectStatus = ProjectStatus.open;
  }

  void setProjectStatus(ProjectStatus status) {
    projectStatus = status;
    notifyListeners();
  }

  void removeImage(int index) {
    images.removeAt(index);
    notifyListeners();
  }

  void setProposedDate(DateTime date) {
    proposedDate = date;
    notifyListeners();
  }

  void setUploadState(int number) {
    uploadState = number;
    notifyListeners();
  }

  Future<void> pickImage(bool isFromGallery) async {
    final res = await ImageService().pickmage(isGallery: isFromGallery);
    if (res != null) {
      images.add(File(res.path));
      notifyListeners();
    }
  }

  void setLocation(
      {required String address,
      required double longitude,
      required double latitude}) {
    this.address = address;
    this.longitude = longitude;
    this.latitude = latitude;
    notifyListeners();
  }

  Future<bool> addProject(
      {required String title,
      required String description,
      required String amountNeeded,
      required BuildContext context}) async {
    if (isLoading) return false;
    startLoading();

    //* Get the current user ID
    final userId =
        await storageService.readSecureData(key: StorageKeys.userId) ?? '';
    final username =
        await storageService.readSecureData(key: StorageKeys.username);
    final userPicture =
        await storageService.readSecureData(key: StorageKeys.userPicture);
    if (userId.isEmpty) {
      stopLoading();
      if (!context.mounted) return false;
      SnackbarMessage.showError(
          context: context,
          message:
              "You are not logged in. Only logged in users can add issues");
      return false;
    }
    //* Upload Images first
    final imagesList = await firebaseStorage.uploadProjectPicture(
        image: images,
        uploadProgress: (progress) {
          setUploadState(progress);
        },
        userId: userId,
        folderPath: '$userId/${title.replaceAll(" ", '-')}');
    if (!imagesList.$1) {
      stopLoading();
      if (!context.mounted) return false;
      SnackbarMessage.showError(
          context: context,
          message: 'Unable to upload images. ${imagesList.$2}');
      return false;
    }
    final res = await firebaseFirestore.createProject(ProjectModel(
        id: DateTime.now().toIso8601String(),
        proposedDate: proposedDate,
        amountNeeded: amountNeeded,
        status: projectStatus,
        likes: [],
        title: title,
        description: description,
        location: address,
        latitude: latitude,
        longitude: longitude,
        votes: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        images: imagesList.$3,
        createdByUserId: userId,
        createdByUserName: username ?? '',
        createdByUserPicture: userPicture ?? '',
        comments: [],
        shares: []));
    stopLoading();
    if (res.$1) {
      if (!context.mounted) return false;
      SnackbarMessage.showSuccess(
          context: context, message: 'Project uploaded successfully.');
      return true;
    }
    if (!context.mounted) return false;
    SnackbarMessage.showError(context: context, message: res.$2);
    return false;
  }
}

class ProjectsProvider extends StateNotifier<AsyncValue<List<ProjectModel>>> {
  ProjectsProvider(this.ref) : super(const AsyncValue.loading());
  final firestore = locator<FirebaseFirestoreService>();

  Ref ref;

  Future<void> getAllProjects() async {
    try {
      state = const AsyncValue.loading();
      final res = await firestore.getAllProjects();
      if (res.$1) {
        if (res.$3 != null) {
          state = AsyncValue.data(res.$3!);
        }
      } else {
        state = AsyncValue.error(res.$2, StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

class OneProjectProvider extends StateNotifier<AsyncValue<ProjectModel>> {
  OneProjectProvider(this.ref) : super(const AsyncValue.loading());
  final firestore = locator<FirebaseFirestoreService>();
  final storage = locator<StorageService>();

  Ref ref;

  Future<void> getOneProject(String projectId, {bool force = false}) async {
    try {
      state = const AsyncValue.loading();
      if (force) {
        //* Fetch from Firebase server
        final res = await firestore.getProject(projectId);
        if (res.$1) {
          if (res.$3 != null) {
            state = AsyncValue.data(res.$3!);
            //* If successful, save to cache
            //! If it fails, don't kill the app.
            saveToCache(res.$3!, projectId);
          }
        } else {
          state = AsyncValue.error(res.$2, StackTrace.current);
        }
      } else {
        //* User cached state or fetch depending on the state.
        final getProject = ref.read(projectsProvider).value?.firstWhere(
              (project) => project.id == projectId,
              orElse: () => ProjectModel.fromMap({'id': ''}),
            );
        if (getProject?.id != null && getProject!.id.isNotEmpty) {
          state = AsyncValue.data(getProject);
        } else {
          final res = await firestore.getProject(projectId);
          if (res.$1) {
            if (res.$3 != null) {
              state = AsyncValue.data(res.$3!);
            }
          } else {
            state = AsyncValue.error(res.$2, StackTrace.current);
          }
        }
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<bool> likeAndUnlikeProject({required String projectId}) async {
    final userId = await storage.readSecureData(key: StorageKeys.userId);
    final res = await firestore.likeAndUnlikeProject(projectId, userId ?? '');
    log("Liking project response ${res.$2}");
    if (res.$1) {
      await getOneProject(projectId, force: true);
    }
    return res.$1;
  }

  void saveToCache(ProjectModel model, String projectId) {
    try {
      final getProject = ref.read(projectsProvider).value?.firstWhere(
            (proj) => proj.id == projectId,
            orElse: () => ProjectModel.fromMap({'id': ''}),
          );
      if (getProject?.id != null && getProject!.id.isNotEmpty) {
        final copiedProject = model;
        final projectIndex =
            ref.read(projectsProvider).value?.indexOf(getProject);
        ref
            .read(projectsProvider)
            .value
            ?.replaceRange(projectIndex!, projectIndex + 1, [copiedProject]);
      }
    } catch (e) {
      log("It failed while saving the project to cache: ${e.toString()}");
    }
  }
}
