import 'package:bobby_shopping/product.dart';
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

  _onPressedSeeFavorites() {
    setState(() {
      if (!_favoritesDisplayed){
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

  _rebuildFavorites(){
    setState(() {
      _favorites.clear();
      for (var _product in allProducts){
        if (_product.inFavorites){
          print("+1");
          _favorites.add(_product);
        }
      }
    });
  }

  @override
  void initState() {
    allProducts.clear();
    allProducts.add(Product("Pear", "graphics/pear.png", Colors.green.shade200, Colors.green.shade600));
    allProducts.add(Product("Peach", "graphics/peach.png", Colors.red.shade200, Colors.red.shade600));
    allProducts.add(Product("Banana", "graphics/banana.png", Colors.yellow.shade200, Colors.yellow.shade600));
    allProducts.add(Product("Apple", "graphics/apple.png", Colors.green.shade200, Colors.green.shade600));
    allProducts.add(Product("Peach", "graphics/peach.png", Colors.red.shade200, Colors.red.shade600));
    allProducts.add(Product("Banana", "graphics/banana.png", Colors.yellow.shade200, Colors.yellow.shade600));
    allProducts.add(Product("Peach", "graphics/peach.png", Colors.red.shade200, Colors.red.shade600));
    allProducts.add(Product("Pear", "graphics/pear.png", Colors.green.shade200, Colors.green.shade600));
    allProducts.add(Product("Banana", "graphics/banana.png", Colors.yellow.shade200, Colors.yellow.shade600));
    allProducts.add(Product("Apple", "graphics/apple.png", Colors.green.shade200, Colors.green.shade600));
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
      floatingActionButton: SizedBox(width: 200, child: Row(children:[
        FloatingActionButton(
        onPressed: _onPressedSeeFavorites,
        child: Icon(Icons.favorite, color: _favoritesDisplayed ? Colors.redAccent : Colors.black),
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () {},
          label: const Text("Order", style: TextStyle(color: Colors.black, fontSize: 18)),
          icon: const Icon(FontAwesome.shopping_cart, color: Colors.black),
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            fixedSize: const Size(130, 55),
            primary: Colors.white
          ),
        )
      ])),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: CustomColors.greenColor.shade900,
                ),
                child: Center(child: Text('Shopping list')),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      body: Builder(
    builder: (context) => SizedBox(width: MediaQuery.of(context).size.width, child: Row(children:[
          SizedBox(width: MediaQuery.of(context).size.width * 6 / 7, child:
          CustomScrollView(
            slivers: [
      SliverPadding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
      sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return _listItem(context, _favoritesDisplayed ? _favorites[index] : allProducts[index]);
                  },
                  childCount: _favoritesDisplayed ? _favorites.length : allProducts.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width * 3 / 4 > 1000 ? 4
                      : (MediaQuery.of(context).size.width * 3 / 4 > 600 ? 3
                      : (MediaQuery.of(context).size.width * 3 / 4 > 200 ? 2 : 1)),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.0,
                ),
              )),
            ]),
          ),
        Center(child: IconButton(icon: Icon(Icons.arrow_back_ios_sharp), onPressed: () {
          Scaffold.of(context).openEndDrawer();
        },))
    ]))));
  }

  //Builder for each game in the trending list
  Widget _listItem(BuildContext context, Product _product) {
    return Padding(padding: const EdgeInsets.all(0), child:Container(
      width: 50,
      height: 50,
      child: TextButton(
        onPressed: () => {},
        child: Column(children: [
          Spacer(),
          Text(
            _product.name,
            style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width / 30),
            textAlign: TextAlign.center,
          ),
          SizedBox(
              height: MediaQuery.of(context).size.width / 7,
              width: MediaQuery.of(context).size.width / 7,
              child: Image.asset(_product.image)
          ),
          Row(children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  fixedSize: const Size(15, 15),
                  shape: const CircleBorder(),
                ),
                onPressed: () => _onPressedAddFavorite(_product),
                child: Icon(_product.inFavorites ? Icons.favorite : Icons.favorite_border, color: Colors.redAccent)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                fixedSize: const Size(15, 15),
                shape: const CircleBorder(),
              ),
              onPressed: () {},
              child: const Icon(Icons.add, color: Colors.black)),
          ]),
        ]),
      ),
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
          ]
      ),
    ));
  }
}
