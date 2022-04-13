import 'package:bobby_shopping/product.dart';
import 'package:flutter/material.dart';

import 'custom_colors.dart';

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  List<Widget> _widgetsList = [];
  bool _favoritesDisplayed = false;

  _onPressedSeeFavorites() {
    setState(() {
      if (_favoritesDisplayed){
        _rebuildWidgets();
      }
      else{
        _rebuildFavorites();
      }
      _favoritesDisplayed = !_favoritesDisplayed;
    });
  }

  _onPressedAddFavorite(Product _product) {
    setState(() {
      print(_product.inFavorites);
      _product.inFavorites = !_product.inFavorites;
    });
  }

  _rebuildFavorites(){
    print("favorites");
    setState(() {
      _widgetsList.clear();
      for (var _product in allProducts){
        if (_product.inFavorites){
          _widgetsList.add(_listItem(context, _product));
        }
      }
    });
  }

  _rebuildWidgets(){
    setState(() {
      _widgetsList.clear();
      for (var _product in allProducts){
        _widgetsList.add(_listItem(context, _product));
      }
    });

  }

  @override
  void initState() {
    allProducts.clear();
    allProducts.add(Product("Carrot", "graphics/carrot.png", Colors.orange.shade200, Colors.orange.shade600));
    allProducts.add(Product("Apple", "graphics/carrot.png", Colors.green.shade200, Colors.green.shade600));
    allProducts.add(Product("Strawberry", "graphics/carrot.png", Colors.red.shade200, Colors.red.shade600));
    allProducts.add(Product("Banana", "graphics/carrot.png", Colors.yellow.shade200, Colors.yellow.shade600));
    allProducts.add(Product("Carrot", "graphics/carrot.png", Colors.orange.shade200, Colors.orange.shade600));
    allProducts.add(Product("Apple", "graphics/carrot.png", Colors.green.shade200, Colors.green.shade600));
    allProducts.add(Product("Strawberry", "graphics/carrot.png", Colors.red.shade200, Colors.red.shade600));
    allProducts.add(Product("Banana", "graphics/carrot.png", Colors.yellow.shade200, Colors.yellow.shade600));
    allProducts.add(Product("Carrot", "graphics/carrot.png", Colors.orange.shade200, Colors.orange.shade600));
    allProducts.add(Product("Apple", "graphics/carrot.png", Colors.green.shade200, Colors.green.shade600));
    allProducts.add(Product("Strawberry", "graphics/carrot.png", Colors.red.shade200, Colors.red.shade600));
    allProducts.add(Product("Banana", "graphics/carrot.png", Colors.yellow.shade200, Colors.yellow.shade600));
    CustomColors.currentColor = CustomColors.blueColor.shade900;
    _rebuildWidgets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressedSeeFavorites,
        child: const Icon(Icons.favorite, color: Colors.redAccent),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: SafeArea(
        child: Container(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: CustomColors.currentColor,
                centerTitle: true,
                title: const Text('Shop'),
                leading: IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(left: 100, right: 100, top: 15, bottom: 15),
                sliver: SliverGrid.count(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: _widgetsList,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Builder for each game in the trending list
  Widget _listItem(BuildContext context, Product _product) {
    return Padding(padding: const EdgeInsets.all(5), child:Container(
      width: 300,
      height: 300,
      child: TextButton(
        onPressed: () => {},
        child: Column(children: [
          Spacer(),
          Text(
            _product.name,
            style: TextStyle(color: Colors.white, fontSize: 40),
            textAlign: TextAlign.center,
          ),
          SizedBox(
              height: 100,
              width: 100,
              child: Image.asset(_product.image)
          ),
          SizedBox(height: 50, child:
          Row(children: [
            Spacer(),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  fixedSize: const Size(100, 100),
                  shape: const CircleBorder(),
                ),
                onPressed: () => _onPressedAddFavorite(_product),
                child: Icon(_product.inFavorites ? Icons.favorite : Icons.favorite_border, color: Colors.redAccent)),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                fixedSize: const Size(100, 100),
                shape: const CircleBorder(),
              ),
              onPressed: () {},
              child: const Icon(Icons.add),),
            Spacer(),
          ])),
          Spacer()
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
          //color: Colors.orange.shade200,
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              color: Colors.grey.shade300,
              offset: const Offset(0, 10), // changes position of shadow
            ),
          ]
      ),
    ));
  }
}
