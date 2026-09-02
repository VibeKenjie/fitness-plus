import 'package:fitness_pulse/app/dependencies.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/signup_page.dart';
import '../features/home/presentation/pages/home_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  refreshListenable: AppDependencies.authController,

  redirect: (context, state){
    final isLoggedIn = AppDependencies.authController.isLoggedIn;
    final isLoginPage = state.matchedLocation == '/login';
    final isSignupPage = state.matchedLocation == '/signup';
    final isAuthPage = isLoginPage || isSignupPage;

    if(!isLoggedIn && !isAuthPage){
      return '/login';
    }

    if(isLoggedIn && isAuthPage){
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) {
        return const LoginPage();
      }
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state){
        return const SignupPage();
      }
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state){
        return const HomeShell();
      }
    ),
  ]
);