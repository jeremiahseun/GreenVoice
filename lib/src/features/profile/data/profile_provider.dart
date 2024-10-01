// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/core/locator.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/src/models/user/user_model.dart';
import 'package:greenvoice/src/services/firebase/firebase.dart';
import 'package:greenvoice/src/services/image_service.dart';
import 'package:greenvoice/src/services/isar_storage.dart';
import 'package:greenvoice/src/services/storage_service.dart';
import 'package:greenvoice/src/services/user_service.dart';
import 'package:greenvoice/src/services/web_service.dart';
import 'package:greenvoice/utils/common_widgets/snackbar_message.dart';
import 'package:greenvoice/utils/constants/storage_keys.dart';
import 'package:greenvoice/utils/helpers/greenvoice_notifier.dart';

final profileProvider = ChangeNotifierProvider((ref) => ProfileProvider(ref));

final userProfileProvider =
    StateNotifierProvider<UserProfileProvider, AsyncValue<UserModel?>>(
        (ref) => UserProfileProvider(ref));

class UserProfileProvider extends StateNotifier<AsyncValue<UserModel?>> {
  UserProfileProvider(this.ref) : super(const AsyncValue.loading());

  Ref ref;
  final firebaseFirestore = locator<FirebaseFirestoreService>();
  final isarStorageService = locator<IsarStorageService>();
  final storageService = locator<StorageService>();

  Future<List<Map<String, dynamic>>?> getVotingHistory(
      {required String userId}) async {
    return null;
  }

  Future<void> getCurrentUserProfile() async {
    state = const AsyncValue.loading();

    //* Get the current user from the backend
    try {
      final upstreamUser = await _getUserDetails();
      if (upstreamUser.$1) {
        if (kIsWeb) {
          state = AsyncValue.data(upstreamUser.$2);
          return;
        }
        final savedDBUser = await _getUserDetailsFromDb();
        if (savedDBUser == null) {
          state = AsyncValue.error("No user", StackTrace.current);
        } else {
          state = AsyncValue.data(savedDBUser);
        }
      } else {
        state = AsyncValue.error("No user", StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<UserModel?> _getUserDetailsFromDb() async {
    final details = await UserService.getSavedUser();
    return details;
  }

  Future<(bool, UserModel?)> _getUserDetails() async {
    String? userId;
    if (kIsWeb) {
      userId = WebService.readWebData(key: StorageKeys.userId);
    } else {
      userId = await storageService.readSecureData(key: StorageKeys.userId);
    }
    if (userId == null) {
      return (false, null);
    }
    try {
      final getUser = await firebaseFirestore.getUser(userId);
      if (getUser.$1 && getUser.$3 != null) {
        if (kIsWeb) {
          return (true, getUser.$3);
        }
        await isarStorageService.writeUserDB(getUser.$3!);
        return (true, getUser.$3);
      } else {
        return (false, null);
      }
    } catch (e) {
      log('An error occured: $e');
      return (false, null);
    }
  }
}

class ProfileProvider extends GreenVoiceNotifier {
  final firebaseFirestore = locator<FirebaseFirestoreService>();
  final firebaseAuthService = locator<FirebaseAuthService>();
  final firebaseStorage = locator<FirebaseStorageService>();
  final isarStorageService = locator<IsarStorageService>();
  final storageService = locator<StorageService>();
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? imageUrls;

  late UserModel userData;
  Ref ref;
  File? images;
  ProfileProvider(
    this.ref,
  );

  Future<void> pickImage(bool isFromGallery) async {
    final res = await ImageService().pickmage(isGallery: isFromGallery);
    if (res != null) {
      images = File(res.path);
      notifyListeners();
    }
  }

  Future<bool> editUserProfile({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    String? imageUrl, // Current image URL is passed here
    required BuildContext context,
  }) async {
    final userId = await storageService.readSecureData(key: StorageKeys.userId);
    if (userId == null) {
      if (!context.mounted) return false;
      SnackbarMessage.showInfo(
          context: context,
          message:
              "Looks like you are not logged in. Please try again while logged in.");
      return false;
    }
    try {
      startLoading();
      String finalImageUrl = imageUrl ?? '';
      if (images != null) {
        final userImage = await firebaseStorage.uploadUserPicture(
            image: images!, userId: userId, username: firstName);

        if (!userImage.$1) {
          stopLoading();
          if (!context.mounted) return false;
          SnackbarMessage.showError(
            context: context,
            message: "Image upload failed. Please try again.",
          );
          return false;
        }
        finalImageUrl = userImage.$3;
      }
      final userData = UserModel(
        uid: userId,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        photo: finalImageUrl,
        email: email,
      );

      stopLoading();

      final updateUser = await firebaseFirestore.updateUser(userData);
      if (updateUser.$1) {
        if (!context.mounted) return true;
        SnackbarMessage.showSuccess(
          context: context,
          message: 'Profile edited successfully.',
        );
        context.pop();
        if (!kIsWeb) {
          await isarStorageService.writeUserDB(userData);
        }

        ref.read(userProfileProvider.notifier).getCurrentUserProfile();
        return true;
      } else {
        stopLoading();
        return false;
      }
    } catch (e) {
      log('Error occurred: $e');
      stopLoading();
      return false;
    }
  }

  Future exitApp() async {
    await firebaseAuthService.signOut();
    isarStorageService.clearDB();
    storageService.clearAll();
    storageService.clearAllSecure();
  }
}
