// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:greenvoice/src/models/user/user_model.dart';
import 'package:greenvoice/src/services/firebase/firestore.dart';
import 'package:greenvoice/utils/constants/exports.dart';
import 'package:greenvoice/utils/helpers/enums.dart';

class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier(
      {required this.firebaseFirestoreService,
      required this.firebaseAuthService})
      : super(RegisterState());

  final FirebaseAuthService firebaseAuthService;
  final FirebaseFirestoreService firebaseFirestoreService;
  obscurePassword() {
    state = state.copyWith(isSelected: !state.isSelected);
  }

  Future<bool> createGreenVoiceUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    log('Triggering code');

    try {
      state = state.copyWith(loadingState: LoadingState.loading);
      final registerUser = await firebaseAuthService.registerUser(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber);

      state = state.copyWith(loadingState: LoadingState.success);
      if (registerUser.$1 == true) {
        log(' ${registerUser.$3?.user?.uid.toString()}');
        final String userId = registerUser.$3?.user?.uid ?? '';
        final UserModel userModel = UserModel(
            uid: userId,
            lastName: lastName,
            firstName: firstName,
            email: email,
            photo: '');

        await firebaseFirestoreService.createUser(userModel);
      }
      return true;
    } catch (e) {
      log('Something went wrong $e');
      state = state.copyWith(loadingState: LoadingState.error);
      return false;
    }
  }
}

class RegisterState {
  LoadingState loadingState;
  bool isSelected;
  RegisterState({
    this.loadingState = LoadingState.idle,
    this.isSelected = true,
  });

  RegisterState copyWith({
    LoadingState? loadingState,
    bool? isSelected,
  }) {
    return RegisterState(
      loadingState: loadingState ?? this.loadingState,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
