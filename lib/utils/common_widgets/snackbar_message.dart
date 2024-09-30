import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

class SnackbarMessage {
  static void showError(
      {required BuildContext context,
      required String message,
      int seconds = 5}) {
    AnimatedSnackBar.rectangle('Oh Snap!', message,
            type: AnimatedSnackBarType.error,
            mobileSnackBarPosition: MobileSnackBarPosition.bottom,
            brightness: Brightness.light,
            duration: Duration(seconds: seconds))
        .show(
      context,
    );
  }

  static void showSuccess(
      {required BuildContext context, required String message}) {
    AnimatedSnackBar.rectangle('Oh Hey!', message,
            type: AnimatedSnackBarType.success,
            mobileSnackBarPosition: MobileSnackBarPosition.bottom,
            brightness: Brightness.light,
            duration: const Duration(seconds: 3))
        .show(
      context,
    );
  }

  static void showInfo(
      {required BuildContext context,
      required String message,
      int seconds = 5}) {
    AnimatedSnackBar.rectangle('Hey there!', message,
            type: AnimatedSnackBarType.info,
            mobileSnackBarPosition: MobileSnackBarPosition.bottom,
            brightness: Brightness.light,
            duration: Duration(seconds: seconds))
        .show(
      context,
    );
  }
}
