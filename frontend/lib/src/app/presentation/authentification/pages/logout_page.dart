import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogoutRouteArguments {
  final String message;

  const LogoutRouteArguments(this.message);
}

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as LogoutRouteArguments;

    return Container(
      child: AlertDialog(
        title: const Text('You have been logged out'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(args.message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              // pop all the routes stored in the navigator
              while (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }

              // return to the login page
              Navigator.of(context).pushNamed("/");
            },
          ),
        ],
      ),
    );
  }

}