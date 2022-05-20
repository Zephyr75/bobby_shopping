import 'package:bobby_shopping/command.dart';
import 'package:flutter/material.dart';

class Common{
  static List<Command> allCommands = [];

  //Navigate to new screen
  static goToTarget(BuildContext _context, Widget _target) {
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => _target),
    );
  }
}