import 'package:bobby_shopping/main.dart';
import 'package:bobby_shopping/sign_up.dart';
import 'package:flutter/material.dart';

import 'common.dart';
import 'firebase_api.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> logUserAndClear() async {
    await FirebaseApi.signIn(_emailController.text, _passwordController.text);
    FocusScope.of(context).unfocus();
    _emailController.clear();
    _passwordController.clear();
    Common.goToTarget(context, const MainMenu());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Form(
                key: _formKey,
                child: Column(children: [
                  const Spacer(flex: 2),
                  const Padding(padding: const EdgeInsets.all(10), child: Text(
                    "Log in to existing account",
                    style: TextStyle(fontSize: 40),
                    textAlign: TextAlign.center,
                  )),
                  const Spacer(flex: 2),
                  Container(
                      padding: const EdgeInsets.all(30),
                      width: 500,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          hintText: 'Enter your email',
                          labelText: 'Email',
                        ),
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      )),
                  const Spacer(),
                  Container(
                      padding: const EdgeInsets.all(30),
                      width: 500,
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText: 'Enter your password',
                          labelText: 'Password',
                        ),
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          if (value.length < 6) {
                            return 'Please enter a password that has at least 6 characters';
                          }
                          return null;
                        },
                      )),
                  const Spacer(flex: 2),
                  ElevatedButton(
                    child: const Text("Log in"),
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        logUserAndClear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero)),
                  ),
                  const Spacer(),
                  Row(children: [
                    const Spacer(),
                    const Text("Don't have an account?  ",
                        style: TextStyle(fontSize: 18)),
                    ElevatedButton(
                      child: const Text("Sign up"),
                      onPressed: () =>
                          Common.goToTarget(context, const SignUp()),
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero)),
                    ),
                    const Spacer()
                  ]),
                  const Spacer(flex: 2),
                ]))));
  }
}
