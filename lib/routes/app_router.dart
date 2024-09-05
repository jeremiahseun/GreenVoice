<<<<<<< HEAD
import 'package:greenvoice/src/features/authentication/register/presentation/register.dart';
import 'package:greenvoice/utils/constants/exports.dart';
=======
import 'package:greenvoice/routes/app_router.dart';
import 'package:greenvoice/src/features/issues/views/issue_description.dart';
import 'package:greenvoice/src/features/issues/views/issues_home.dart';
import 'package:greenvoice/src/models/user/issue/issue_model.dart';
import 'package:greenvoice/utils/helpers/locator.dart';

export 'package:go_router/go_router.dart';
>>>>>>> c59b887 (Issue Home)

final greenVoice = locator<GoRouter>();

class GreenVoiceRoutes {
  final greenVoiceRouter = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const Register(),
      builder: (context, state) => const IssuesScreen(),
      // builder: (context, state) => const SignIn(),
      routes: [
        GoRoute(
          path: 'issues',
          builder: (context, state) => const IssuesScreen(),
        ),
        GoRoute(
          path: 'issues-details',
          builder: (context, state) => IssueDetailScreen(
            arguments: state.extra as IssueDetailArguments,
          ),
        ),

      ]
    )
  ]);
}

class IssueDetailArguments {
  final IssueModel issue;

  IssueDetailArguments({required this.issue});
}
