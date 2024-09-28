import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenvoice/core/locator.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/src/services/isar_storage.dart';
import 'package:greenvoice/utils/styles/styles.dart';

import 'firebase_options.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FlutterBranchSdk.init(enableLogging: true, disableTracking: false);
  if (!kIsWeb) {
    await IsarStorageService.initialize();
  }
  runApp(const ProviderScope(child: GreenVoice()));
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
          brightness: Brightness.light,
          useMaterial3: true,
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
