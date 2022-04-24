import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:api_playground/state.dart';
import 'package:api_playground/screens/login.dart';
import 'package:api_playground/screens/things.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await sharedPrefs.init();

  runApp(const MyApp());
}

class AppRouter {
  late final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
        const InitScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) =>
        const LoginScreen(),
      ),
      GoRoute(
        path: '/things',
        builder: (BuildContext context, GoRouterState state) =>
        const ThingsScreen(),
      ),
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // widget
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
          lazy: false,
        ),
        ChangeNotifierProvider<Helpers>(
          create: (_) => Helpers(),
          lazy: false,
        ),
        Provider<AppRouter>(
          lazy: false,
          create: (_) => AppRouter(),
        ),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final router = Provider.of<AppRouter>(context, listen: false).router;
          return MaterialApp.router(
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
            title: 'API Playground',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            debugShowCheckedModeBanner: false,
          );
        }
      ),
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