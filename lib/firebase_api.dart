import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

//TODO: Trouver un moyen clean de faire une ref static/ Exceptions/ Link à firebase storage quand on aura les jeux


class FirebaseApi {
  static Future<Directory> appDocDir = getApplicationDocumentsDirectory();
  static FirebaseAuth auth = FirebaseAuth.instance;
  static CollectionReference products = FirebaseFirestore.instance.collection('products');


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

  //Add product to the products list on the databse
  static Future<void> addProduct(String _name, int _price) async {
    return products
        .doc(_name)
        .set({
      "Price": _price,
    })
        .then((value) => print("Product added"))
        .catchError((error) => print("Failed to add product: $error"));
  }

  //Gets product information from the database
  static Future<void> getProducts() async {
    QuerySnapshot querySnapshot = await products.get();
    final allData = querySnapshot.docs.map((doc) => doc).toList();
    for (var product in allData) {
      print(product.get("Price").toString());
    }
  }

}
