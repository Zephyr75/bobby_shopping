import 'package:bobby_shopping/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'common.dart';

class Command{
  bool isExpanded = false;
  List<String> products = [];
  Timestamp date;

  Command(this.date);
}

ExpansionPanel commandExpansionPanel(Command _command) {
  List<Widget> _lines = [];
  _lines.add(Spacer());
  for (var _a in Common.allProducts) {
    int _count = 0;
    for (var _b in _command.products) {
      if (_a.name == _b) {
        _count++;
      }
    }
    if (_count > 0) {
      _lines.add(Text(_count.toString() + " " + _a.name, style: TextStyle(fontSize: 20)));
    }
  }
  _lines.add(Spacer());
  return ExpansionPanel(
      headerBuilder: (context, isOpen) =>
          Container(
              height: 100,
              width: 1000,
              child: Center(child: Text(DateFormat().format(_command.date.toDate()), style: TextStyle(color: Colors.white, fontSize: 20),)),
              color: Colors.blueGrey.shade200),
      body:
          Container(
              height: 200,
              width: 1000,
              child: Center(child: Column(children: _lines)),
              color: Colors.white),
      isExpanded: _command.isExpanded,
      canTapOnHeader: true,
      hasIcon: false);
}