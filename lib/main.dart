import 'dart:convert';
import 'dart:io';

import 'package:bobby_shopping/previous_commands.dart';
import 'package:bobby_shopping/product.dart';
import 'package:bobby_shopping/shop.dart';
import 'package:bobby_shopping/sign_in.dart';
import 'package:bobby_shopping/sign_up.dart';
import 'package:bobby_shopping/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'command.dart';
import 'common.dart';
import 'custom_colors.dart';
import 'firebase_api.dart';
import 'firebase_options.dart';


bool darkTheme = false;

class Achievement {
  final String label;
  final String type;
  final int steps;

  Achievement(this.label, this.type, this.steps);

  Achievement.fromJson(Map<String, dynamic> json)
      : label = json['label'],
        type = json['type'],
        steps = json['steps'];

  Map<String, dynamic> toJson() =>
      {'label': label, 'type': type, 'steps': steps};
}

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseApi.addProduct("Banana", 10, "graphics/banana.png", "yellow");
  FirebaseApi.addProduct("Peach", 5, "graphics/peach.png", "red");
  FirebaseApi.addProduct("Apple", 1, "graphics/apple.png", "green");
  FirebaseApi.addProduct("Pear", 3, "graphics/pear.png", "green");
  FirebaseApi.getProducts();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  textTheme: GoogleFonts.comfortaaTextTheme(),
                  brightness: Brightness.light,
                  accentColor: Colors.white),
              darkTheme: ThemeData(
                  textTheme: GoogleFonts.comfortaaTextTheme(),
                  scaffoldBackgroundColor: CustomColors.greyColor.shade900,
                  brightness: Brightness.dark,
                  accentColor: Colors.white),
              themeMode: currentMode,
              home: const WelcomeScreen());
        });
  }
}

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        children: [
          Spacer(flex: 2),
          Text("Welcome !", style: TextStyle(fontSize: 50),),
          Spacer(),
          ElevatedButton.icon(
              onPressed: () => Common.goToTarget(context, const Shop()),
              icon: const Icon(
                Feather.shopping_cart,
                color: Colors.white,
                size: 30,
              ),
              label: const Text(" Shop", style: TextStyle(fontSize: 25), textAlign: TextAlign.center),
              style: ElevatedButton.styleFrom(
                  primary: CustomColors.greenColor.shade900,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  fixedSize: const Size(300, 100))),
          Spacer(),
          ElevatedButton.icon(
              onPressed: () => Common.goToTarget(context, const PreviousCommands()),
              icon: const Icon(
                MaterialIcons.history,
                color: Colors.white,
                size: 30,
              ),
              label: const Text(" Previous commands", style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
              style: ElevatedButton.styleFrom(
                  primary: CustomColors.blueColor.shade900,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  fixedSize: const Size(300, 100))),
          Spacer(),
          ElevatedButton.icon(
              onPressed: () {
                FirebaseApi.auth.signOut();
                Common.shoppingList.clear();
                Common.goToTarget(context, const SignIn());
              },
                icon: const Icon(
                Octicons.sign_out,
                color: Colors.white,
                size: 20,
                ),
                label: const Text(" Sign out", style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                style: ElevatedButton.styleFrom(
                primary: CustomColors.redColor.shade900,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                fixedSize: const Size(150, 50))),
                Spacer(flex: 2),
        ],
      )),
    );
  }
}
