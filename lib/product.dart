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

List<Product> allProducts = [
  Product("Pear", "graphics/pear.png", Colors.green.shade200, Colors.green.shade600),
  Product("Peach", "graphics/peach.png", Colors.red.shade200, Colors.red.shade600),
  Product("Banana", "graphics/banana.png", Colors.yellow.shade200, Colors.yellow.shade600),
  Product("Apple", "graphics/apple.png", Colors.green.shade200, Colors.green.shade600)
];