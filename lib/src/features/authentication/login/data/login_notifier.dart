// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/core/locator.dart';
import 'package:greenvoice/src/features/profile/data/profile_provider.dart';
import 'package:greenvoice/src/models/user/user_model.dart';
import 'package:greenvoice/src/services/firebase/firebase.dart';
import 'package:greenvoice/src/services/isar_storage.dart';
import 'package:greenvoice/src/services/storage_service.dart';
import 'package:greenvoice/src/services/web_service.dart';
import 'package:greenvoice/utils/constants/storage_keys.dart';
import 'package:greenvoice/utils/helpers/greenvoice_notifier.dart';

final loginNotifierProvider =
    ChangeNotifierProvider.autoDispose((ref) => LoginScreenNotifier(ref));

class LoginScreenNotifier extends GreenVoiceNotifier {
  Ref ref;
  LoginScreenNotifier(this.ref);
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final FirebaseFirestoreService firebaseFirestoreService =
      FirebaseFirestoreService();

  final StorageService storageService = StorageService();
  final isarStorageService = locator<IsarStorageService>();

  bool isObscurePassword = false;

  void obscurePassword() {
    isObscurePassword = !isObscurePassword;
    notifyListeners();
  }

  Future<(bool status, String message)> loginGreenVoiceUser({
    required String email,
    required String password,
  }) async {
    startLoading();
    try {
      final loginUser = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      stopLoading();
      if (loginUser.$1 == true) {
        log('${loginUser.$3}    USWRE DATA');
        final String userId = loginUser.$3?.user?.uid ?? '';
        String fullName = loginUser.$3?.user?.displayName ?? '';

        List<String> nameParts = fullName.split(" ");
        final UserModel userModel = UserModel(
            uid: loginUser.$3?.user?.uid ?? '',
            email: loginUser.$3?.user?.email ?? '',
            firstName: nameParts[0],
            lastName: nameParts[1],
            photo: loginUser.$3?.user?.photoURL);

        if (kIsWeb) {
          WebService.writeUserModelData(
              userId: userId,
              username: fullName,
              picture: userModel.photo ?? "");
        } else {
          await isarStorageService.writeUserDB(userModel);
          await storageService.writeSecureData(
              key: StorageKeys.userId, value: userId);
        }
        ref.read(userProfileProvider.notifier).getCurrentUserProfile(true);
        return (true, 'Login Successful');
      } else {
        return (false, loginUser.$2);
      }
    } catch (e) {
      stopLoading();
      return (false, 'An error occured: $e');
    }
  }
}
