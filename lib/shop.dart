import 'package:flutter/material.dart';

import 'custom_colors.dart';

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  _onPressedSearch() {}

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.blueColor.shade900;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*return Scaffold(
        appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.currentColor,
        title: const Text('Shop'),
    leading: IconButton(
    icon: Icon(Icons.home),
    onPressed: () => Navigator.of(context).pop(),
    ),
    ),
    floatingActionButton: FloatingActionButton(
    onPressed: _onPressedSearch,
    child: const Icon(Icons.search),
    ),
      body: CustomScrollView(SingleChildScrollView(child: SliverGrid.count(
        crossAxisCount: 4,
        children: [Text("Carrot"), Text("Carrot"),Text("Carrot"),Text("Carrot")]
      )),
    );*/

    var size = MediaQuery.of(context).size;
    return Scaffold(
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
                  children: <Widget>[
                    _listItem(context, 0),
                    _listItem(context, 0),
                    _listItem(context, 0),
                    _listItem(context, 0),
                    _listItem(context, 0),
                    _listItem(context, 0),
                    _listItem(context, 0),
                    _listItem(context, 0),
                    _listItem(context, 0),
                    _listItem(context, 0),
                    _listItem(context, 0),
                    _listItem(context, 0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Builder for each game in the trending list
  Widget _listItem(BuildContext context, int index) {
    return Padding(padding: const EdgeInsets.all(5), child:Container(
      width: 300,
      height: 300,
      child: TextButton(
        onPressed: () => {},
        child: Column(children: [
          Spacer(),
          Text(
          "Carrot",
          style: TextStyle(color: Colors.white, fontSize: 40),
          textAlign: TextAlign.center,
          ),
          SizedBox(
              height: 100,
              width: 100,
              child: Image.asset('graphics/carrot.png')
          ),
          SizedBox(height: 50, child:
          Row(children: [
            Spacer(),
            FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.favorite, color: Colors.redAccent)  ),
            Spacer(),
            FloatingActionButton(
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
              Colors.orange.shade200,
              Colors.orange.shade600,
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
