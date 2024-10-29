import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import 'green_voice_button.dart';

class GreenVoiceErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onGoHome;

  const GreenVoiceErrorWidget(
      {super.key,
      required this.onGoHome,
      required this.message,
      required this.buttonText,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/lotties/cloud_disconnection.json',
          width: 200,
          height: 200,
          fit: BoxFit.fill,
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        Text(
          message,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        GreenVoiceButton.outline(
          onTap: onGoHome,
          title: buttonText,
          size: const Size(300, 45),
        ),
      ]
          .animate(interval: const Duration(milliseconds: 50))
          .fadeIn()
          .moveY(begin: 50, end: 0),
    );
  }
}
