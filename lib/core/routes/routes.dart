class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/resetPassword';
  static const String forgotPassword = '/forgotPassword';
  static const String home = '/home';
  static const String issues = 'issues';
  static const String issueDetails = 'issueDetails';
  static const String profile = 'profile';
  static const String mapView = 'mapView';
  static const String projectDetails = 'projectDetails';
  static const String projects = 'projects';
}

class NavigateToPage {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String register = '/register';
  static const String login = '/login';
  static const String resetPassword = '/resetPassword';
  static const String forgotPassword = '/forgotPassword';
  static const String home = '/home';
  static const String issues = '$home/issues';
  static const String issueDetails = '$issues/issueDetails';
  static const String profile = '$home/profile';
  static const String mapView = '$home/mapView';
  static const String projectDetails = '$projects/projectDetails';
  static const String projects = '$home/projects';
}
