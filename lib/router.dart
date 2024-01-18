import 'package:go_router/go_router.dart';
import 'package:passkey_example/presentation/pages/home/home_page.dart';
import 'package:passkey_example/presentation/pages/sign_in/sign_in_page.dart';
import 'package:passkey_example/presentation/pages/sign_up/sign_up_page.dart';

class Routes {
  static const signUp = '/sign-up';
  static const signIn = '/sign-in';
  static const profile = '/profile';
}

final GoRouter router = GoRouter(
  initialLocation: Routes.signUp,
  routes: [
    GoRoute(
      path: Routes.signUp,
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: Routes.signIn,
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: Routes.profile,
      builder: (context, state) => const ProfilePage(),
    ),
  ],
);
