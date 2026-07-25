import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/admin_panel/admin_panel_screen.dart';
import '../../presentation/screens/ai_chat/ai_chat_screen.dart';
import '../../presentation/screens/bookmarks/bookmarks_screen.dart';
import '../../presentation/screens/eligibility_checker/eligibility_checker_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/login/login_screen.dart';
import '../../presentation/screens/notifications/notifications_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/pdf_explainer/pdf_explainer_screen.dart';
import '../../presentation/screens/profile/edit_profile_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/registration/registration_wizard_screen.dart';
import '../../presentation/screens/schemes/schemes_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.splash,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardingScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.registrationWizard,
      builder: (BuildContext context, GoRouterState state) {
        return const RegistrationWizardScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      builder: (BuildContext context, GoRouterState state) {
        return const EditProfileScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (BuildContext context, GoRouterState state) {
        return const ProfileScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.schemes,
      builder: (BuildContext context, GoRouterState state) {
        return const SchemesScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.aiChat,
      builder: (BuildContext context, GoRouterState state) {
        return const AiChatScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.eligibilityChecker,
      builder: (BuildContext context, GoRouterState state) {
        return const EligibilityCheckerScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (BuildContext context, GoRouterState state) {
        return const SettingsScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (BuildContext context, GoRouterState state) {
        return const NotificationsScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.pdfExplainer,
      builder: (BuildContext context, GoRouterState state) {
        return const PdfExplainerScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.bookmarks,
      builder: (BuildContext context, GoRouterState state) {
        return const BookmarksScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.adminPanel,
      builder: (BuildContext context, GoRouterState state) {
        return const AdminPanelScreen();
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('No route defined for ${state.uri.path}'),
    ),
  ),
);
