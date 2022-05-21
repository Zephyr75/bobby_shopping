import 'package:bobby_shopping/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Command{
  bool isExpanded = false;
  List<String> products = [];
  Timestamp date;

  Command(this.date);
}

ExpansionPanel commandExpansionPanel(Command _command) {
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
              child: Center(child: Column(children: [
                Spacer(),
                Text(_command.products.first),
                Spacer(),
              ],)),
              color: Colors.white),
      isExpanded: _command.isExpanded,
      canTapOnHeader: true,
      hasIcon: false);
}