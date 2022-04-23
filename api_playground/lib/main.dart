import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:api_playground/state.dart';
import 'package:api_playground/screens/login.dart';
import 'package:api_playground/screens/things.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'API Playground',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _state = context.read<AppState>();

    return _state.isLoggedIn ? const ThingsScreen() : const LoginScreen();
  }
}