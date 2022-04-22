import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const InitScreen(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  bool isLoggedIn = true;
  late String firstName;

  void login() {
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }
}


class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _state = context.watch<AppState>();

    return Center(
      child: Column(
        children: <Widget>[
          Text('Welcome!',
            style: Theme.of(context).textTheme.headline5,
          ),
          ElevatedButton(
            child: const Text("Login"),
            onPressed: _state.login,
          ),
        ],
      ),
    );
  }
}

class YourJobsWidget extends StatelessWidget {
  const YourJobsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _state = context.watch<AppState>();
    final List _dummyJobs = [{'name': "Job 1", 'id': 0},
                             {'name': "Job 2", 'id': 1}];

    return Expanded(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text("Your Jobs",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Expanded(
          child: Center(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _dummyJobs.length,
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("'${_dummyJobs[i]['name']}' tapped"),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                  title: Text(_dummyJobs[i]['name'],
                    textAlign: TextAlign.center,
                  )
                );
              },
            ),
          ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              child: const Text("Logout"),
              onPressed: _state.logout,
            ),
          ),
        ],
      ),
    );
  }
}

class InitScreen extends StatelessWidget {
  const InitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _state = Provider.of<AppState>(context);
    final _state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _state.isLoggedIn
              ? const YourJobsWidget()
              : const LoginFormWidget()
          ],
        ),
      ),
    );
  }
}
