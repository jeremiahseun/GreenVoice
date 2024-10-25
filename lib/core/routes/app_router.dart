// ignore_for_file: prefer_const_constructors

import 'package:greenvoice/core/locator.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/core/routes/routes.dart';
import 'package:greenvoice/src/features/authentication/forgot_password/forgot_password.dart';
import 'package:greenvoice/src/features/authentication/login/presentation/login.dart';
import 'package:greenvoice/src/features/authentication/onboarding/onboarding_view.dart';
import 'package:greenvoice/src/features/authentication/register/presentation/register.dart';
import 'package:greenvoice/src/features/authentication/reset_password/reset_password.dart';
import 'package:greenvoice/src/features/authentication/splash/splash_screen.dart';
import 'package:greenvoice/src/features/bottom_navigation/presentation/bottom_navigation.dart';
import 'package:greenvoice/src/features/issues/presentation/add_issue.dart';
import 'package:greenvoice/src/features/issues/presentation/issue_description.dart';
import 'package:greenvoice/src/features/issues/presentation/issues_home.dart';
import 'package:greenvoice/src/features/issues/presentation/maps/map_screen.dart';
import 'package:greenvoice/src/features/profile/data/edit_profile.dart';
import 'package:greenvoice/src/features/profile/presentation/profile_view.dart';
import 'package:greenvoice/src/features/projects/presentation/add_project.dart';
import 'package:greenvoice/src/features/projects/presentation/projects.dart';
import 'package:greenvoice/src/features/projects/presentation/projects_details.dart';

import 'page_not_found.dart';

export 'package:go_router/go_router.dart';

final greenVoice = locator<GoRouter>();

class GreenVoiceRoutes {
  final greenVoiceRouter = GoRouter(
      errorBuilder: (context, state) => NotFoundScreen(
            onGoHome: () => context.go('/home'),
          ),
      routes: [
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
            path: AppRoutes.home,
            builder: (context, state) => HomeScreen(),
            routes: [
              GoRoute(
                  path: AppRoutes.issues,
                  builder: (context, state) => const IssuesView(),
                  routes: [
                    GoRoute(
                      path: AppRoutes.addIssue,
                      builder: (context, state) => const AddIssueScreen(),
                    ),
                    GoRoute(
                      path: AppRoutes.issueDetails,
                      builder: (context, state) => IssueDetailScreen(
                        id: state.pathParameters['issueId'] ?? '',
                      ),
                    ),
                  ]),
              GoRoute(
                path: AppRoutes.mapView,
                builder: (context, state) => MapScreen(),
              ),
              GoRoute(
                  path: AppRoutes.projects,
                  builder: (context, state) => const ProjectHome(),
                  routes: [
                    GoRoute(
                      path: AppRoutes.projectDetails,
                      builder: (context, state) => ProjectDetailsView(
                        id: state.pathParameters['projectId'] ?? '',
                      ),
                    ),
                    GoRoute(
                      path: AppRoutes.addProject,
                      builder: (context, state) => const AddProjectScreen(),
                    ),
                  ]),
              GoRoute(
                  path: AppRoutes.profile,
                  builder: (context, state) => const ProfileView(),
                  routes: [
                    GoRoute(
                      path: AppRoutes.editProfile,
                      builder: (context, state) => EditProfile(
                        editProfileArgument: state.extra as EditProfileArgument,
                      ),
                    ),
                  ]),
            ]),
      ]);
}

class EditProfileArgument {
  String firstName;
  String lastName;
  String email;
  String image;
  String phoneNumber;

  EditProfileArgument(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.image,
      required this.phoneNumber});
}
