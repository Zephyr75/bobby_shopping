import 'package:flutter/material.dart';

class Product{
  String name = "";
  int price;
  String image = "";
  Color colorPrimary = Colors.black;
  Color colorSecondary = Colors.black;
  bool inFavorites = false;

  Product(
      this.name,
      this.price,
      this.image,
      this.colorPrimary,
      this.colorSecondary,
      );
}