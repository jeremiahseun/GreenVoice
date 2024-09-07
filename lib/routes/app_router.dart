import 'package:greenvoice/src/features/authentication/forgotPassword/forgot_password.dart';
import 'package:greenvoice/src/features/authentication/register/presentation/register.dart';
import 'package:greenvoice/src/features/issues/views/issue_description.dart';
import 'package:greenvoice/src/features/issues/views/issues_home.dart';
import 'package:greenvoice/src/features/settings/presentation/reset_password.dart';
import 'package:greenvoice/src/models/user/issue/issue_model.dart';
import 'package:greenvoice/utils/constants/exports.dart';

// final greenVoice = locator<GoRouter>();

class GreenVoiceRoutes {
  final greenVoiceRouter = GoRouter(debugLogDiagnostics: true, routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const Register(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const Forgotpassword(),
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
