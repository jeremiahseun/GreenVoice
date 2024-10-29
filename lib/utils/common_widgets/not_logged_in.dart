import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/core/routes/routes.dart';
import 'package:greenvoice/src/features/profile/data/profile_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'green_voice_button.dart';

class NotLoggedInWidget extends ConsumerStatefulWidget {
  const NotLoggedInWidget({super.key, this.text, required this.loggedInWidget});
  final String? text;
  final Widget loggedInWidget;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotLoggedInWidgetState();
}

class _NotLoggedInWidgetState extends ConsumerState<NotLoggedInWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileProvider.notifier).getCurrentUserProfile();
    });
    super.initState();
  }

  @override
  Widget build(context) {
    return ref.watch(userProfileProvider).when(data: (data) {
      return widget.loggedInWidget;
    }, error: (err, trace) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.text ??
                "Are you logged in? Login or register so that you can create projects.",
            textAlign: TextAlign.center,
          ),
          const Gap(15),
          GreenVoiceButton.outline(
              onTap: () => context.push(NavigateToPage.login), title: "Login")
        ],
      );
    }, loading: () {
      return Skeletonizer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "loading",
              textAlign: TextAlign.center,
            ),
            const Gap(15),
            GreenVoiceButton.fill(onTap: () {}, title: "Loading...")
          ],
        ),
      );
    });
  }
}
