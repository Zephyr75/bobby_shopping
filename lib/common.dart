import 'package:bobby_shopping/command.dart';
import 'package:bobby_shopping/product.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_colors.dart';

class Common{

  static List<Product> allProducts = [];

  static List<Command> allCommands = [];

  ///Display pop-up at the bottom of the screen
  static showSnackBar(BuildContext _context, String _text) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: CustomColors.currentColor,
      content: Text(_text, style: GoogleFonts.comfortaa(fontSize: 20, color: Colors.white)),
    );
    ScaffoldMessenger.of(_context).hideCurrentSnackBar();
    ScaffoldMessenger.of(_context).showSnackBar(snackBar);
  }

  //Navigate to new screen
  static goToTarget(BuildContext _context, Widget _target) {
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => _target),
    );
  }
}