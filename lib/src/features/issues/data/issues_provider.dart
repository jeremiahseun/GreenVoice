import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/core/locator.dart';
import 'package:greenvoice/src/models/issue/issue_model.dart';
import 'package:greenvoice/src/models/socials/comment.dart';
import 'package:greenvoice/src/services/firebase/firebase.dart';
import 'package:greenvoice/src/services/image_service.dart';
import 'package:greenvoice/src/services/isar_storage.dart';
import 'package:greenvoice/src/services/storage_service.dart';
import 'package:greenvoice/src/services/user_service.dart';
import 'package:greenvoice/src/services/uuid.dart';
import 'package:greenvoice/utils/common_widgets/snackbar_message.dart';
import 'package:greenvoice/utils/constants/storage_keys.dart';
import 'package:greenvoice/utils/helpers/greenvoice_notifier.dart';

final issuesProvider =
    StateNotifierProvider<IssuesProvider, AsyncValue<List<IssueModel>>>(
        (ref) => IssuesProvider(ref));

final oneIssueProvider =
    StateNotifierProvider<OneIssueProvider, AsyncValue<IssueModel>>(
        (ref) => OneIssueProvider(ref));

final addIssueProvider =
    ChangeNotifierProvider.autoDispose((ref) => AddIssueProvider(ref));

class AddIssueProvider extends GreenVoiceNotifier {
  final firebaseFirestore = locator<FirebaseFirestoreService>();
  final firebaseStorage = locator<FirebaseStorageService>();
  final storageService = locator<StorageService>();
  final isarStorageService = locator<IsarStorageService>();

  AddIssueProvider(this.ref);
  Ref ref;
  double latitude = 0.0;
  double longitude = 0.0;
  int uploadState = 0;
  String address = '';
  List<File> images = [];
  bool postAnonymously = false;
  String profileImage = '';

  void disposeItems() {
    latitude = 0.0;
    longitude = 0.0;
    address = '';
    images = [];
    postAnonymously = false;
    uploadState = 0;
  }

  void removeImage(int index) {
    images.removeAt(index);
    notifyListeners();
  }

  void setPostAnonymous(bool value) {
    postAnonymously = value;
    notifyListeners();
  }

  void setUploadState(int number) {
    uploadState = number;
    notifyListeners();
  }

  void userImage() async {
    final isarData = await UserService.getSavedUser();
    profileImage = isarData?.photo ?? '';
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

  Future<bool> addIssue(
      {required String title,
      required String description,
      required bool isAnonymous,
      required BuildContext context}) async {
    if (isLoading) return false;

    startLoading();

    //* Get the current user information
    final currentUser = await UserService.getSavedUser();

    if (currentUser?.uid == null) {
      stopLoading();
      if (!context.mounted) return false;
      SnackbarMessage.showError(
          context: context,
          message:
              "You are not logged in. Only logged in users can add issues");
      return false;
    }
    final firstName = currentUser?.firstName;
    final lastName = currentUser?.lastName;
    final userId = currentUser!.uid;
    final userPicture = currentUser.photo;
    //* Upload Images first
    final imagesList = await firebaseStorage.uploadIssuePicture(
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
    final res = await firebaseFirestore.createIssue(IssueModel(
        id: DateTime.now().toIso8601String(),
        isAnonymous: isAnonymous,
        title: title,
        description: description,
        location: address,
        latitude: latitude,
        longitude: longitude,
        votes: [],
        isResolved: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        images: imagesList.$3,
        createdByUserId: userId,
        createdByUserName: '$firstName ${lastName?.split("").first}',
        createdByUserPicture: userPicture ?? '',
        category: 'category',
        comments: [],
        shares: []));
    stopLoading();
    if (res.$1) {
      if (!context.mounted) return true;
      SnackbarMessage.showSuccess(
          context: context, message: 'Issue uploaded successfully.');
      return true;
    }
    if (!context.mounted) return false;
    SnackbarMessage.showError(context: context, message: res.$2);
    return false;
  }

  ///******************CREATE AND ISSUE COMMENT ******************* */

  Future<bool> sendUserComment({
    required String issueID,
    required String message,
    required BuildContext context,
  }) async {
    final String uniqueMessageID = generateUniqueID();
    final isarData = await UserService.getSavedUser();
    try {
      final userId =
          await storageService.readSecureData(key: StorageKeys.userId);

      final res = await firebaseFirestore.createIssueComments(
          CommentModel(
              id: uniqueMessageID,
              userId: userId ?? '',
              userName:
                  '${isarData?.firstName} ${isarData?.lastName?.split("").first}',
              userPicture: isarData?.photo ?? '',
              message: message,
              createdAt: DateTime.now()),
          issueID,
          uniqueMessageID);
      if (res.$1) {
        if (!context.mounted) return true;
        SnackbarMessage.showSuccess(
            context: context, message: 'Comment added.');
        return true;
      } else {
        if (!context.mounted) return false;
        SnackbarMessage.showError(context: context, message: res.$2);
        return false;
      }
    } catch (e) {
      if (!context.mounted) return false;
      SnackbarMessage.showError(context: context, message: e.toString());

      return false;
    }
  }

  //Get iserComments

  Stream<QuerySnapshot<Map<String, dynamic>>> getComments(
      {required String issueID}) async* {
    final messages = firebaseFirestore.getIssueComments(issueID);
    yield* messages;
  }
}

class IssuesProvider extends StateNotifier<AsyncValue<List<IssueModel>>> {
  IssuesProvider(this.ref) : super(const AsyncValue.loading());
  final firestore = locator<FirebaseFirestoreService>();

  Ref ref;

  Future<void> getAllIssues() async {
    try {
      state = const AsyncValue.loading();
      final res = await firestore.getAllIssues();
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

class OneIssueProvider extends StateNotifier<AsyncValue<IssueModel>> {
  OneIssueProvider(this.ref) : super(const AsyncValue.loading());
  final firestore = locator<FirebaseFirestoreService>();
  final storage = locator<StorageService>();

  Ref ref;

  Future<void> getOneIssues(String issueId, {bool force = false}) async {
    try {
      state = const AsyncValue.loading();
      if (force) {
        //* Fetch from Firebase server
        final res = await firestore.getIssue(issueId);
        if (res.$1) {
          if (res.$3 != null) {
            state = AsyncValue.data(res.$3!);
            //* If successful, save to cache
            //! If it fails, don't kill the app.
            saveToCache(res.$3!, issueId);
          }
        } else {
          state = AsyncValue.error(res.$2, StackTrace.current);
        }
      } else {
        //* User cached state or fetch depending on the state.
        final getIssue = ref.read(issuesProvider).value?.firstWhere(
              (issue) => issue.id == issueId,
              orElse: () => IssueModel.fromMap({'id': ''}),
            );
        if (getIssue?.id != null && getIssue!.id.isNotEmpty) {
          state = AsyncValue.data(getIssue);
        } else {
          final res = await firestore.getIssue(issueId);
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

  Future<bool> likeAndUnlikeIssue(
      {required String issueId, required BuildContext context}) async {
    final userId = await storage.readSecureData(key: StorageKeys.userId);
    if (userId == null) {
      if (!context.mounted) return false;
      SnackbarMessage.showInfo(
          context: context,
          message:
              "Looks like you are not logged in. Please try again while logged in.");
      return false;
    }
    final res = await firestore.likeAndUnlikeIssue(issueId, userId);
    log("Liking issue response ${res.$1} ${res.$2}");
    if (res.$1) {
      await getOneIssues(issueId, force: true);
    } else {
      if (!context.mounted) return false;
      SnackbarMessage.showInfo(context: context, message: res.$2);
    }
    return res.$1;
  }

  void saveToCache(IssueModel model, String issueId) {
    try {
      final getIssue = ref.read(issuesProvider).value?.firstWhere(
            (issue) => issue.id == issueId,
            orElse: () => IssueModel.fromMap({'id': ''}),
          );
      if (getIssue?.id != null && getIssue!.id.isNotEmpty) {
        final copiedIssue = model;
        final issueIndex = ref.read(issuesProvider).value?.indexOf(getIssue);
        ref
            .read(issuesProvider)
            .value
            ?.replaceRange(issueIndex!, issueIndex + 1, [copiedIssue]);
      }
    } catch (e) {
      log("It failed while saving the issue to cache: ${e.toString()}");
    }
  }
}
