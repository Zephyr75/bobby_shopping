import 'package:flutter/material.dart';

class Product{
  String name = "";
  String image = "";
  Color colorPrimary = Colors.black;
  Color colorSecondary = Colors.black;
  bool inFavorites = false;
  bool isExpanded = false;

  Product(
      this.name,
      this.image,
      this.colorPrimary,
      this.colorSecondary,
      );
}

List<Product> allProducts = [];