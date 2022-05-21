import 'dart:io';
import 'package:bobby_shopping/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'common.dart';


class FirebaseApi {
  static Future<Directory> appDocDir = getApplicationDocumentsDirectory();
  static FirebaseAuth auth = FirebaseAuth.instance;
  static CollectionReference products = FirebaseFirestore.instance.collection('products');
  static CollectionReference favorites = FirebaseFirestore.instance.collection('favorites');
  static CollectionReference orders = FirebaseFirestore.instance.collection('orders');


  ///Basic Email+password signUp (found on FirebaseAuth doc)
  static Future<void> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  ///Basic Email+password signIn (found on FirebaseAuth doc)
  static Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      //TODO exceptions
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  ///Check if a user is logged in
  static bool isLoggedIn() {
    return auth.currentUser != null;
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
    final allData = querySnapshot.docs.map((doc) => doc).toList();
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
