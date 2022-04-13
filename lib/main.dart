import 'package:bobby_shopping/shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_colors.dart';


bool darkTheme = false;


void main() {
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
        const Duration(seconds: 0),
            () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainMenu()),
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

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  _onPressedShop() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Shop()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        children: [
          Spacer(flex: 2),
          Text("Welcome Christoph!", style: TextStyle(fontSize: 50),),
          Spacer(),
          ElevatedButton.icon(
              onPressed: _onPressedShop,
              icon: const Icon(
                Feather.shopping_cart,
                color: Colors.white,
                size: 30,
              ),
              label: const Text(" Shop", style: TextStyle(fontSize: 25), textAlign: TextAlign.center),
              style: ElevatedButton.styleFrom(
                  primary: CustomColors.blueColor.shade900,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  fixedSize: const Size(300, 100))),
          Spacer(),
          ElevatedButton.icon(
              onPressed: _onPressedShop,
              icon: const Icon(
                MaterialIcons.history,
                color: Colors.white,
                size: 30,
              ),
              label: const Text(" Previous commands", style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
              style: ElevatedButton.styleFrom(
                  primary: CustomColors.greenColor.shade900,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  fixedSize: const Size(300, 100))),
          Spacer(),
          ElevatedButton.icon(
              onPressed: _onPressedShop,
              icon: const Icon(
                Octicons.sign_out,
                color: Colors.white,
                size: 20,
              ),
              label: const Text(" Sign out", style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
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
