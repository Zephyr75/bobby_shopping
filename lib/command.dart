import 'package:bobby_shopping/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Command{
  bool isExpanded = false;
  List<Product> products = [];
  DateTime date;

  Command(this.products, this.date);
}

ExpansionPanel commandExpansionPanel(Command _command) {
  return ExpansionPanel(
      headerBuilder: (context, isOpen) =>
          Container(
              height: 100,
              width: 1000,
              child: Center(child: Text(DateFormat().format(_command.date), style: TextStyle(color: Colors.white, fontSize: 20),)),
              color: Colors.blueGrey.shade200),
      body:
          Container(
              height: 200,
              width: 1000,
              child: Center(child: Column(children: [
                Spacer(),
                Text("1 carrot", style: TextStyle(fontSize: 20, color: Colors.grey.shade700)),
                Text("2 apples", style: TextStyle(fontSize: 20, color: Colors.grey.shade700)),
                Spacer(),
              ],)),
              color: Colors.white),
      isExpanded: _command.isExpanded,
      canTapOnHeader: true,
      hasIcon: false);
}