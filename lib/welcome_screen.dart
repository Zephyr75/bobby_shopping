import 'package:bobby_shopping/sign_in.dart';
import 'package:flutter/material.dart';

import 'firebase_api.dart';
import 'main.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(seconds: 2),
            () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FirebaseApi.isLoggedIn() ? MainMenu() : SignIn()),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child:
    FractionallySizedBox(
        heightFactor: .3,
        widthFactor: .3,
        child: Image.asset('graphics/logo.png')
    )));
  }
}