import 'package:bobby_shopping/sign_in.dart';
import 'package:flutter/material.dart';

import 'common.dart';
import 'custom_colors.dart';
import 'firebase_api.dart';
import 'main.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> addUserAndClear() async {
    await FirebaseApi.signUp(_emailController.text, _passwordController.text, context);
    if (FirebaseApi.isLoggedIn()) {
      FocusScope.of(context).unfocus();
      _emailController.clear();
      _passwordController.clear();
      Common.goToTarget(context, const MainMenu());
    }
  }

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.greyColor.shade900;
    super.initState();
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
                  Spacer(flex: 2),
                  const Padding(padding: const EdgeInsets.all(10), child: Text(
                      "Create a new account",
                      style: TextStyle(fontSize: 40),
                      textAlign: TextAlign.center)),
                  Spacer(flex: 2),
                  Container(
                      padding: const EdgeInsets.all(30),
                      width: 500,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          hintText: 'Enter an email',
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
                  Spacer(),
                  Container(
                      padding: const EdgeInsets.all(30),
                      width: 500,
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText: 'Enter a password',
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
                      child: Text("Create account"),
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          addUserAndClear();
                        }
                      }, style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero))
                      ),
                  const Spacer(),
                  Row(children: [
                    const Spacer(),
                    const Text("Already have an account?  ",
                        style: TextStyle(fontSize: 18)),
                    ElevatedButton(
                        child: const Text("Log in"),
                        onPressed: () => Common.goToTarget(context, const SignIn()),
                        style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero)),
                    ),
                    const Spacer()
                  ]),
                  const Spacer(flex: 2),
                ]))));
  }
}
