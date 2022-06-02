import 'dart:convert';
import 'dart:io';

import 'package:bobby_shopping/firebase_api.dart';
import 'package:bobby_shopping/product.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:qr_code_tools/qr_code_tools.dart';

import 'common.dart';
import 'custom_colors.dart';

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  List<Product> _favorites = [];
  bool _favoritesDisplayed = false;
  List<Widget> _shoppingListWidget = [];

  _onPressedSeeFavorites() {
    setState(() {
      if (!_favoritesDisplayed) {
        _rebuildFavorites();
      }
      _favoritesDisplayed = !_favoritesDisplayed;
    });
  }

  _sendUDPList() {
    String _message = "{";
    for (var _a in Common.allProducts) {
      int _count = 0;
      for (var _b in Common.shoppingList) {
        if (_a.name == _b.name) {
          _count++;
        }
      }
      if (_count > 0) {
        _message += "\"" + _a.name + "\": \"" + _count.toString() + "\",";
      }
    }
    _message = _message.substring(0, _message.length - 1);
    _message += "}";

    RawDatagramSocket.bind(InternetAddress.anyIPv4, 1234)
        .then((RawDatagramSocket socket) {
      socket.broadcastEnabled = true;
      socket.send(
        _message.codeUnits,
        InternetAddress('192.168.43.3'),
        1234,
      );
      socket.close();
    });
  }

  _receiveUDP() {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 1234)
        .then((RawDatagramSocket socket) {
      socket.broadcastEnabled = true;
      socket.listen((e) {
        Datagram? dg = socket.receive();
        if (dg != null) {
          String received = utf8.decode(dg.data);
          if (received.toLowerCase() == "end") {
            print(received);
            socket.close();
          }
          for (var _product in Common.allProducts) {
            if (received == _product.name) {
              print(_product.name);
              _onProductConfirmed(_product);
            }
          }
        }
      });
    });
  }

  _onPressedAddFavorite(Product _product) {
    if (_product.inFavorites) {
      FirebaseApi.removeFavorite(_product);
    } else {
      FirebaseApi.addFavorite(_product);
    }
    setState(() {
      _product.inFavorites = !_product.inFavorites;
    });
  }

  _decode() async{
    try {
      var imageId = await ImageDownloader.downloadImage(
        //"https://authena.io/wp-content/uploads/2020/11/qrcodes-lowR.jpg"
          "http://192.168.43.3/capture?_cb=" + DateTime.now().millisecondsSinceEpoch.toString()
      );
      if (imageId == null) {
        return;
      }

      var path = await ImageDownloader.findPath(imageId);

      String data = await QrCodeToolsPlugin.decodeFrom(path);
      print("Data: $data");
      print(path);

    } on PlatformException catch (error) {
      print(error);
    }
  }

  _onPressedPlus(Product? _product) {
    _decode();
    setState(() {
      if (_product != null) {
        Common.shoppingList.add(_product);
      }
      _shoppingListWidget.clear();
      _shoppingListWidget.add(_header());
      for (var _a in Common.allProducts) {
        int _count = 0;
        for (var _b in Common.shoppingList) {
          if (_a.name == _b.name) {
            _count++;
          }
        }
        if (_count > 0) {
          _shoppingListWidget.add(ListTile(
              title: Center(
                  child: Text("$_count ${_a.name}",
                      style: TextStyle(fontSize: 20)))));
        }
      }
    });
  }

  _onProductConfirmed(Product? _product) {
    Common.receivedList.remove(_product);

    setState(() {
      _shoppingListWidget.clear();
      _shoppingListWidget.add(_header());
    });
    if (Common.receivedList.isEmpty) {
      Common.shoppingList.clear();
      setState(() {
        _shoppingListWidget.clear();
        _shoppingListWidget.add(_header());
      });
      Common.isOrdering = false;
      return;
    }
    for (var _a in Common.allProducts) {
      int _totalCount = 0;
      bool _isDone = true;
      for (var _b in Common.shoppingList) {
        if (_a.name == _b.name) {
          _totalCount++;
        }
      }
      for (var _b in Common.receivedList) {
        if (_a.name == _b.name) {
          setState(() {
            _isDone = false;
          });
        }
      }
      if (_totalCount > 0) {
        _shoppingListWidget.add(ListTile(
            title: Center(
                child: Text(
                    "$_totalCount ${_a.name} " +
                        (_isDone ? "(done)" : "(loading)"),
                    style: TextStyle(fontSize: 20)))));
      }
    }
    setState(() {
      _shoppingListWidget.add(Image.asset(
        "graphics/loading.gif",
        height: 125.0,
        width: 125.0,
      ));
    });
  }

  _onPressedOrder() {
    for (var _a in Common.allProducts) {
      int _count = 0;
      for (var _b in Common.shoppingList) {
        if (_a.name == _b.name) {
          _count++;
        }
      }
      if (_count > 0) {
        Common.receivedList.add(_a);
        FirebaseApi.addOrder(_a, _count);
      }
    }
    setState(() {
      Common.isOrdering = true;
      _onProductConfirmed(null);
    });
    FirebaseApi.getCommands();
    _sendUDPList();
    _receiveUDP();
    Common.showSnackBar(context, "Order sent");
  }

  _rebuildFavorites() {
    setState(() {
      _favorites.clear();
      for (var _product in Common.allProducts) {
        if (_product.inFavorites) {
          _favorites.add(_product);
        }
      }
    });
  }

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.greenColor.shade900;
    _onPressedPlus(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = kIsWeb
        ? MediaQuery.of(context).size.width * 3 / 4
        : MediaQuery.of(context).size.width - 50;
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
            width: 220,
            child: Row(children: [
              FloatingActionButton(
                onPressed: _onPressedSeeFavorites,
                child: Icon(Icons.favorite,
                    color:
                        _favoritesDisplayed ? Colors.redAccent : Colors.black),
              ),
              const Spacer(),
              Builder(
                  builder: (context) => ElevatedButton.icon(
                        onPressed: Common.isOrdering
                            ? () {
                                Common.shoppingList.clear();
                                setState(() {
                                  _shoppingListWidget.clear();
                                  _shoppingListWidget.add(_header());
                                });
                                Common.isOrdering = false;
                                return;
                              }
                            : _onPressedOrder,
                        label: Text(Common.isOrdering ? "Cancel" : "Order",
                            style:
                                TextStyle(color: Colors.black, fontSize: 18)),
                        icon: const Icon(FontAwesome.shopping_cart,
                            color: Colors.black),
                        style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            fixedSize: const Size(160, 55),
                            primary: Colors.white),
                      ))
            ])),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        endDrawer: kIsWeb && MediaQuery.of(context).size.width > 700
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
                  Spacer(),
                  SizedBox(
                    width: _width,
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
                                        : Common.allProducts[index]);
                              },
                              childCount: _favoritesDisplayed
                                  ? _favorites.length
                                  : Common.allProducts.length,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  _width > 700 ? 4 : (_width > 500 ? 3 : 2),
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1.0,
                            ),
                          )),
                    ]),
                  ),
                  Center(
                      child: kIsWeb && MediaQuery.of(context).size.width > 700
                          ? Material(
                              elevation: 20,
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 1 / 4,
                                  height: 1000,
                                  child: Column(children: _shoppingListWidget)))
                          : IconButton(
                              icon: Icon(Icons.arrow_back_ios_sharp),
                              onPressed: () =>
                                  Scaffold.of(context).openEndDrawer(),
                            )),
                  Spacer(),
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
              style: TextStyle(color: Colors.white, fontSize: 25),
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
                  onPressed:
                      Common.isOrdering ? null : () => _onPressedPlus(_product),
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

  Widget _header() {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: CustomColors.greenColor.shade900,
      ),
      child: Center(
          child: Text(
        'Shopping list',
        style: TextStyle(fontSize: 25, color: Colors.white),
        textAlign: TextAlign.center,
      )),
    );
  }
}
