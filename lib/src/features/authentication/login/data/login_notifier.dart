// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/src/services/firebase/firebase.dart';
import 'package:greenvoice/src/services/local_storage/storage_services.dart';
import 'package:greenvoice/src/services/local_storage/storagekeys.dart';
import 'package:greenvoice/utils/helpers/greenvoice_notifier.dart';

final loginNotifierProvider =
    ChangeNotifierProvider.autoDispose((ref) => LoginScreenNotifier());

class LoginScreenNotifier extends GreenVoiceNotifier {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final FirebaseFirestoreService firebaseFirestoreService =
      FirebaseFirestoreService();

  final StorageService storageService = StorageService();

  bool isObscurePassword = false;

  void obscurePassword() {
    isObscurePassword = !isObscurePassword;
    notifyListeners();
  }

  Future<bool> loginGreenVoiceUser({
    required String email,
    required String password,
  }) async {
    log('Triggering code');
    startLoading();
    try {
      final loginUser = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      stopLoading();

      if (loginUser.$1 == true) {
        log('${loginUser.$3} USERRHGUHFYGFYG');
        log(' Sign IN successful');

        storageService.writeSecureData(key: Storagekeys.userId, value: '');
      } else {
        log(loginUser.$2);
      }
      return true;
    } catch (e) {
      log('Something went wrong $e');
      stopLoading();
      return false;
    }
  }
}
