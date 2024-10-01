import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/core/routes/routes.dart';

import 'green_voice_button.dart';

class NotLoggedInWidget extends StatelessWidget {
  const NotLoggedInWidget({
    super.key,
    this.text,
  });

  final String? text;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text ??
              "Are you logged in? Login or register so that you can create projects.",
          textAlign: TextAlign.center,
        ),
        const Gap(15),
        GreenVoiceButton.outline(
            onTap: () => context.push(NavigateToPage.login), title: "Login")
      ],
    );
  }
}
