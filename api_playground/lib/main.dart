import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:api_playground/state.dart';
import 'package:api_playground/screens/login.dart';
import 'package:api_playground/screens/things.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // state
  await sharedPrefs.init();
  await secureStorage.init();

  // router
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
      const InitScreen(),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(-1.0, 0.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeIn)),
              ),
              child: child,
            ),
      ),
    ),
    GoRoute(
      path: '/things',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const ThingsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeIn)),
              ),
              child: child,
            ),
      ),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      title: 'API Playground',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InitScreen extends StatelessWidget {
  const InitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sharedPrefs.isLoggedIn) {
      return const ThingsScreen();
    } else {
      return const LoginScreen();
    }
  }
}