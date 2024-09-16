class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String issues = 'issues';
  static const String addIssue = 'add-issue';
  static const String issueDetails = 'issue-details';
  static const String profile = 'profile';
  static const String mapView = 'map-view';
  static const String projects = 'projects';
  static const String projectDetails = 'project-details';
  static const String addProject = 'add-project';
}

class NavigateToPage {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String register = '/register';
  static const String login = '/login';
  static const String resetPassword = '/reset-password';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String issueDetails = '$home/issue-details';
  static const String addIssue = '$home/add-issue';
  static const String addProject = '/add-project';
  static const String profile = '$home/profile';
  static const String mapView = '$home/map-view';
  static const String projectDetails = '$home/project-details';
}
