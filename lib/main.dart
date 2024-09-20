import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/core/locator.dart';
import 'package:greenvoice/utils/styles/styles.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: GreenVoice()));

  Animate.restartOnHotReload = true;
  if (!kIsWeb) {
    MapboxOptions.setAccessToken(
        "pk.eyJ1IjoiamVyZW1pYWhzZXVuIiwiYSI6ImNtMHU2NHllNjB1MG8ybHI1ZzRpMDR1bGYifQ.srO22bCjZuGdApdDXdooSg");
  }
}

class GreenVoice extends StatelessWidget {
  const GreenVoice({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: greenVoice.routeInformationParser,
      routeInformationProvider: greenVoice.routeInformationProvider,
      routerDelegate: greenVoice.routerDelegate,
      debugShowCheckedModeBanner: false,
      title: 'GreenVoice',
      theme: ThemeData(
          colorScheme: const ColorScheme.light(primary: AppColors.primaryColor),
          progressIndicatorTheme:
              const ProgressIndicatorThemeData(color: AppColors.primaryColor),
          textTheme: GoogleFonts.publicSansTextTheme(),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              textStyle: GoogleFonts.publicSans(),
            ),
          )),
    );
  }
}

/**
 *
 * ISSUES HOME SEARCH
 * ISSUE DETAILS (WITH ID TO NAVIGATE TO THE PARTICULAR ISSUE)
 * - VOTING
 * - COMMENTS
 * - SHARE ISSUE
 * DEEP LINKING
 * FIREBASE IMPLEMENTATION
 * - ADD ISSUE
 * - LIST ALL PROJECTS
 * - ADD PROJECT
 *
 */
