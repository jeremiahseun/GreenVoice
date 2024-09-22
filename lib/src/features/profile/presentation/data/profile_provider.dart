// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/core/locator.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/src/models/user/user_model.dart';
import 'package:greenvoice/src/services/firebase/firebase.dart';
import 'package:greenvoice/src/services/image_service.dart';
import 'package:greenvoice/src/services/isar_storage.dart';
import 'package:greenvoice/src/services/storage_service.dart';
import 'package:greenvoice/utils/common_widgets/snackbar_message.dart';
import 'package:greenvoice/utils/constants/storage_keys.dart';
import 'package:greenvoice/utils/helpers/greenvoice_notifier.dart';

final profileProvider = ChangeNotifierProvider((ref) => ProfileProvider(ref));

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

  Future getUserDetailsFromDb() async {
    final details = await isarStorageService.readUserDB();
    firstName = details?.firstName ?? '';
    lastName = details?.lastName ?? '';
    email = details?.email ?? '';
    phoneNumber = details?.phoneNumber ?? '';
    imageUrls = details?.photo ?? '';
    notifyListeners();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    final userId =
        await storageService.readSecureData(key: StorageKeys.userId) ?? '';
    try {
      final getUser = await firebaseFirestore.getUser(userId);
      if (getUser.$1) {
        userData = getUser.$3 ?? UserModel(uid: userId);
        firstName = userData.firstName;
        lastName = userData.lastName;
        await isarStorageService.writeUserDB(userData);
        notifyListeners();
      }
    } catch (e) {
      log('An error occured: $e');
    }
  }

  Future<void> pickImage(bool isFromGallery) async {
    final res = await ImageService().pickmage(isGallery: isFromGallery);
    if (res != null) {
      images = File(res.path);
      notifyListeners(); // Notify that an image has been selected
    }
  }

  Future<bool> editUserProfile({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required String imageUrl, // Current image URL is passed here
    required BuildContext context,
  }) async {
    final userId =
        await storageService.readSecureData(key: StorageKeys.userId) ?? '';
    try {
      startLoading();
      String finalImageUrl = imageUrl;
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
        finalImageUrl = userImage.$3 ?? imageUrl;
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
        if (!context.mounted) return false;
        SnackbarMessage.showSuccess(
          context: context,
          message: 'Profile edited successfully.',
        );
        context.pop();
        await isarStorageService.writeUserDB(userData);
        firstName = userData.firstName ?? '';
        lastName = userData.lastName ?? '';
        email = userData.email ?? '';
        getUserDetailsFromDb();
        notifyListeners();
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
  }
}
