import 'package:bobby_shopping/product.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'custom_colors.dart';

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  List<Product> _favorites = [];
  bool _favoritesDisplayed = false;
  List<Product> _shoppingList = [];
  List<Widget> _shoppingListWidget = [
    DrawerHeader(
      decoration: BoxDecoration(
        color: CustomColors.greenColor.shade900,
      ),
      child: Center(
          child: Text('Shopping list',
              style: TextStyle(fontSize: 25, color: Colors.white))),
    )
  ];

  _onPressedSeeFavorites() {
    setState(() {
      if (!_favoritesDisplayed) {
        _rebuildFavorites();
      }
      _favoritesDisplayed = !_favoritesDisplayed;
      print("favorites displayed → " + _favoritesDisplayed.toString());
    });
  }

  _onPressedAddFavorite(Product _product) {
    setState(() {
      _product.inFavorites = !_product.inFavorites;
    });
  }

  _onPressedPlus(Product _product) {
    setState(() {
      _shoppingList.add(_product);
      _shoppingListWidget.clear();
      _shoppingListWidget.add(DrawerHeader(
        decoration: BoxDecoration(
          color: CustomColors.greenColor.shade900,
        ),
        child: Center(
            child: Text('Shopping list',
                style: TextStyle(fontSize: 25, color: Colors.white))),
      ));
      for (var _a in allProducts) {
        int _count = 0;
        for (var _b in _shoppingList) {
          if (_a.name == _b.name) {
            _count++;
          }
        }
        if (_count > 0) {
          _shoppingListWidget.add(ListTile(
              title: Center(
                  child: Text(_count.toString() + " " + _a.name,
                      style: TextStyle(fontSize: 20)))));
        }
      }
    });
  }

  _rebuildFavorites() {
    setState(() {
      _favorites.clear();
      for (var _product in allProducts) {
        if (_product.inFavorites) {
          print("+1");
          _favorites.add(_product);
        }
      }
    });
  }

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.greenColor.shade900;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Builder(
              builder: (context) => Container(),
            ),
          ],
          backgroundColor: CustomColors.currentColor,
          title: const Text('Shop'),
          leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        floatingActionButton: SizedBox(
            width: 200,
            child: Row(children: [
              FloatingActionButton(
                onPressed: _onPressedSeeFavorites,
                child: Icon(Icons.favorite,
                    color:
                        _favoritesDisplayed ? Colors.redAccent : Colors.black),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                label: const Text("Order",
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                icon:
                    const Icon(FontAwesome.shopping_cart, color: Colors.black),
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    fixedSize: const Size(130, 55),
                    primary: Colors.white),
              )
            ])),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        endDrawer: kIsWeb
            ? null
            : Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: _shoppingListWidget,
                ),
              ),
        body: Builder(
            builder: (context) => SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(children: [
                  SizedBox(
                    width: kIsWeb ? MediaQuery.of(context).size.width * 3 / 4 : MediaQuery.of(context).size.width - 50,
                    child: CustomScrollView(slivers: [
                      SliverPadding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 15, bottom: 15),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return _listItem(
                                    context,
                                    _favoritesDisplayed
                                        ? _favorites[index]
                                        : allProducts[index]);
                              },
                              childCount: _favoritesDisplayed
                                  ? _favorites.length
                                  : allProducts.length,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  MediaQuery.of(context).size.width * 3 / 4 >
                                          1000
                                      ? 4
                                      : (MediaQuery.of(context).size.width *
                                                  3 /
                                                  4 >
                                              600
                                          ? 3
                                          : (MediaQuery.of(context).size.width *
                                                      3 /
                                                      4 >
                                                  200
                                              ? 2
                                              : 1)),
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1.0,
                            ),
                          )),
                    ]),
                  ),
                  Center(
                      child: kIsWeb
                          ? Container(
                              color: Colors.grey.shade200,
                              width: MediaQuery.of(context).size.width * 1 / 4,
                              height: 1000,
                              child: Column(children: _shoppingListWidget))
                          : IconButton(
                              icon: Icon(Icons.arrow_back_ios_sharp),
                              onPressed: () {
                                Scaffold.of(context).openEndDrawer();
                              },
                            ))
                ]))));
  }

  //Builder for each game in the trending list
  Widget _listItem(BuildContext context, Product _product) {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          width: 50,
          height: 50,
          child: Column(children: [
              SizedBox(height: 10),
              Text(
                _product.name,
                style: TextStyle(color: Colors.white, fontSize: 30),
                textAlign: TextAlign.center,
              ),
              Expanded(child: Image.asset(_product.image)),
              Row(children: [
                Spacer(),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: const CircleBorder(),
                      fixedSize: const Size(40, 40),
                    ),
                    onPressed: () => _onPressedAddFavorite(_product),
                    child: Icon(
                        _product.inFavorites
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.redAccent)),
                Spacer(),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: const CircleBorder(),
                      fixedSize: const Size(40, 40),
                    ),
                    onPressed: () => _onPressedPlus(_product),
                    child: const Icon(Icons.add, color: Colors.black)),
                Spacer(),
              ]),
            SizedBox(height: 10),
            ]),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  _product.colorPrimary,
                  _product.colorSecondary,
                ],
              ),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  blurRadius: 2,
                  color: Colors.grey.shade300,
                  offset: const Offset(0, 10),
                ),
              ]),
        ));
  }
}
