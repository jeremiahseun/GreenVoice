// ignore_for_file: prefer_const_constructors

import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/core/routes/routes.dart';
import 'package:greenvoice/src/features/authentication/forgot_password/forgot_password.dart';
import 'package:greenvoice/src/features/authentication/login/presentation/login.dart';
import 'package:greenvoice/src/features/authentication/onboarding/onboarding_view.dart';
import 'package:greenvoice/src/features/authentication/register/presentation/register.dart';
import 'package:greenvoice/src/features/authentication/reset_password/reset_password.dart';
import 'package:greenvoice/src/features/authentication/splash/splash_screen.dart';
import 'package:greenvoice/src/features/issues/views/issue_description.dart';
import 'package:greenvoice/src/features/issues/views/issues_home.dart';
import 'package:greenvoice/src/models/user/issue/issue_model.dart';
import 'package:greenvoice/core/locator.dart';

export 'package:go_router/go_router.dart';

final greenVoice = locator<GoRouter>();

class GreenVoiceRoutes {
  final greenVoiceRouter = GoRouter(debugLogDiagnostics: true, routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => OnboardingView(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => LoginView(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterView(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordView(),
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      builder: (context, state) => const ResetPassword(),
    ),
    GoRoute(
      path: AppRoutes.issues,
      builder: (context, state) => const IssuesScreen(),
    ),
    GoRoute(
      path: AppRoutes.issueDetails,
      builder: (context, state) => IssueDetailScreen(
        arguments: state.extra as IssueDetailArguments,
      ),
    ),
  ]);
}

class IssueDetailArguments {
  final IssueModel issue;

  IssueDetailArguments({required this.issue});
}
