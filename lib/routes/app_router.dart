
import 'package:beauty_nest/widgets/app_shell.dart';
import 'package:go_router/go_router.dart';
import '../views/login_screen.dart';
import '../views/registration_screen.dart';
import '../views/main_screen.dart';
import '../viewmodels/auth_view_model.dart';
import '../views/splash_screen.dart';

GoRouter createRouter(AuthViewModel auth) {
  return GoRouter(
    refreshListenable: auth,
    redirect: (context, state) {
      if (!auth.isInitialized) return '/splash';
      final loggedIn = auth.user != null;
      final loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register' || state.matchedLocation == '/splash';
      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const AppShell(),
      ),
    ],
  );
}
