import 'package:flutter/material.dart';
import 'package:greenvoice/utils/common_widgets/lottie_error_widgets.dart';

class NotFoundScreen extends StatelessWidget {
  final VoidCallback onGoHome;

  const NotFoundScreen({super.key, required this.onGoHome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GreenVoiceErrorWidget(
          onGoHome: onGoHome,
          buttonText: "Go Home",
          title: 'Oops! Page Not Found',
          message:
              'The page you are looking for doesn\'t exist or has been moved.',
        ),
      ),
    );
  }
}
