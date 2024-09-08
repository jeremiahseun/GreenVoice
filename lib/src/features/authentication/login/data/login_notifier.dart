// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:greenvoice/src/services/firebase/firestore.dart';
import 'package:greenvoice/utils/constants/exports.dart';
import 'package:greenvoice/utils/helpers/enums.dart';

class LoginScreenNotifier extends StateNotifier<LoginScreenState> {
  LoginScreenNotifier(
      {required this.firebaseFirestoreService,
      required this.firebaseAuthService})
      : super(LoginScreenState());

  final FirebaseAuthService firebaseAuthService;
  final FirebaseFirestoreService firebaseFirestoreService;
  obscurePassword() {
    state = state.copyWith(isSelected: !state.isSelected);
  }

  Future<bool> loginGreenVoiceUser({
    required String email,
    required String password,
  }) async {
    log('Triggering code');
    try {
      state = state.copyWith(loadingState: LoadingState.loading);
      final registerUser = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (registerUser.$1 == true) {
        log(' Sign IN successful');
      } else {
        log(registerUser.$2);
      }
      return true;
    } catch (e) {
      log('Something went wrong $e');
      state = state.copyWith(loadingState: LoadingState.error);
      return false;
    }
  }
}

class LoginScreenState {
  LoadingState loadingState;
  bool isSelected;
  bool isSuccessful;
  LoginScreenState(
      {this.loadingState = LoadingState.idle,
      this.isSelected = true,
      this.isSuccessful = false});

  LoginScreenState copyWith({
    LoadingState? loadingState,
    bool? isSelected,
    bool? isSuccessful,
  }) {
    return LoginScreenState(
      loadingState: loadingState ?? this.loadingState,
      isSelected: isSelected ?? this.isSelected,
      isSuccessful: isSuccessful ?? this.isSuccessful,
    );
  }
}
