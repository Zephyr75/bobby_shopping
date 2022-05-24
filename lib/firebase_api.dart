import 'dart:io';
import 'package:bobby_shopping/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'command.dart';
import 'common.dart';


class FirebaseApi {
  static Future<Directory> appDocDir = getApplicationDocumentsDirectory();
  static FirebaseAuth auth = FirebaseAuth.instance;
  static CollectionReference products = FirebaseFirestore.instance.collection('products');
  static CollectionReference favorites = FirebaseFirestore.instance.collection('favorites');
  static CollectionReference orders = FirebaseFirestore.instance.collection('orders');


  ///Basic Email+password signUp (found on FirebaseAuth doc)
  static Future<void> signUp(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      await signIn(email, password, context);
    } on FirebaseAuthException catch (e) {
      Common.showSnackBar(context, 'Invalid email address');
    } catch (e) {
      print(e);
    }
  }

  ///Basic Email+password signIn (found on FirebaseAuth doc)
  static Future<void> signIn(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      getCommands();
    } on FirebaseAuthException catch (e) {
      Common.showSnackBar(context, 'No user found');
    }
  }

  ///Check if a user is logged in
  static bool isLoggedIn() {
    return auth.currentUser != null;
  }

  //Add favorite to the favorites list on the database
  static Future<void> addOrder(Product _product, int _count) async {
    return orders
        .doc()
        .set({
      "User": auth.currentUser?.uid,
      "Product": _product.name,
      "Count": _count,
      "Date": DateTime.now()
    })
        .then((value) => print("Order added"))
        .catchError((error) => print("Failed to add order: $error"));
  }

  //Add previous commands to the commands list from the database
  static Future<void> getCommands() async {
    Common.allCommands.clear();
    QuerySnapshot querySnapshot = await orders.where('User', isEqualTo: auth.currentUser?.uid).get();
    final allData = querySnapshot.docs.toList();
    for (var order in allData) {
      Timestamp tempTime = order.get("Date");
      Command temp = Command(tempTime);
      bool _neverSeen = true;
      for (var command in Common.allCommands){
        if (command.date.toDate().difference(tempTime.toDate()).inSeconds.abs() < 2){
          for (int i = 0; i < order.get("Count"); i++){
            command.products.add(order.get("Product"));
          }
          _neverSeen = false;
        }
      }
      if (_neverSeen){
        for (int i = 0; i < order.get("Count"); i++){
          temp.products.add(order.get("Product"));
        }
        Common.allCommands.add(temp);
      }
    }
    Common.allCommands.sort((a, b) => b.date.compareTo(a.date));
  }

  //Add favorite to the favorites list on the database
  static Future<void> addFavorite(Product _product) async {
    return favorites
        .doc()
        .set({
      "User": auth.currentUser?.uid,
      "Product": _product.name,
    })
        .then((value) => print("Favorite added"))
        .catchError((error) => print("Failed to add favorite: $error"));
  }

  //Remove favorite from the favorites list on the database
  static Future<void> removeFavorite(Product _product) async {
    QuerySnapshot snapshot = await favorites
        .where('Product', isEqualTo: _product.name)
        .where('User', isEqualTo: auth.currentUser?.uid)
        .get();
    snapshot.docs.first.reference.delete();
  }

  //Add product to the products list on the database
  static Future<void> addProduct(String _name, int _price, String _image, String _color) async {
    return products
        .doc(_name)
        .set({
      "Price": _price,
      "Image": _image,
      "Color": _color,
    })
        .then((value) => print("Product added"))
        .catchError((error) => print("Failed to add product: $error"));
  }

  //Gets product information from the database
  static Future<void> getProducts() async {
    QuerySnapshot querySnapshot = await products.get();
    final allData = querySnapshot.docs.toList();
    for (var product in allData) {
      Product temp = Product(
          product.id,
          product.get("Price"),
          product.get("Image"),
          getPrimary(product.get("Color")),
          getSecondary(product.get("Color")));
      QuerySnapshot snapshot = await favorites
          .where('Product', isEqualTo: temp.name)
          .where('User', isEqualTo: auth.currentUser?.uid)
          .get();
      if (snapshot.size > 0){
        temp.inFavorites = true;
      }
      Common.allProducts.add(temp);
    }
  }


  static Color getPrimary(String _name){
    switch(_name){
      case 'red' : return Colors.red.shade200;
      case 'green' : return Colors.green.shade200;
      default : return Colors.yellow.shade200;
    }
  }

  static Color getSecondary(String _name){
    switch(_name){
      case 'red' : return Colors.red.shade600;
      case 'green' : return Colors.green.shade600;
      default : return Colors.yellow.shade600;
    }
  }

}
