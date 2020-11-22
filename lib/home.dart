import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  int paginaCorrente=0;

  final List<Widget> paginas = [
    //Home(),
    //Favoritos(),
    //Compras(),
    //Conta(),
  ];

  void quandoPressionado(int index){
    setState(() {
      paginaCorrente = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            _isSearching ? const BackButton() : Icon(Icons.local_grocery_store),
        title: _isSearching ? _buildSearchField() : Text("Open Market"),
        actions: _buildActions(),
      ),
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CarouselSlider(
              options: CarouselOptions(
                  height: 200.0,
                  aspectRatio: 16/9,
                  viewportFraction: 1,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 15),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn),
              items: [
                'assets/iphone.png',
                'assets/xps.jpg',
              ].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Image(
                      image: AssetImage(i),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Column(
                  children: [
                    MaterialButton(
                      onPressed: () {},
                      color: Colors.white,
                      textColor: Colors.black,
                      child: Icon(
                        Icons.local_mall,
                        size: 25,
                      ),
                      padding: EdgeInsets.all(15),
                      shape: CircleBorder(side: BorderSide(
                        color: Colors.grey, width: 1.0, style: BorderStyle.solid,
                      )),
                    ),
                    Text('Moda')
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    MaterialButton(
                      onPressed: () {},
                      color: Colors.white,
                      textColor: Colors.black,
                      child: Icon(
                        Icons.stay_current_portrait,
                        size: 25,
                      ),
                      padding: EdgeInsets.all(15),
                      shape: CircleBorder(side: BorderSide(
                        color: Colors.grey, width: 1.0, style: BorderStyle.solid,
                      )),
                    ),
                    Text('Celulares')
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    MaterialButton(
                      onPressed: () {},
                      color: Colors.white,
                      textColor: Colors.black,
                      child: Icon(
                        Icons.sports_motorsports,
                        size: 25,
                      ),
                      padding: EdgeInsets.all(15),
                      shape: CircleBorder(side: BorderSide(
                        color: Colors.grey, width: 1.0, style: BorderStyle.solid,
                      )),
                    ),
                    Text('Motos')
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    MaterialButton(
                      onPressed: () {},
                      color: Colors.white,
                      textColor: Colors.black,
                      child: Icon(
                        Icons.add,
                        size: 25,
                      ),
                      padding: EdgeInsets.all(15),
                      shape: CircleBorder(side: BorderSide(
                        color: Colors.grey, width: 1.0, style: BorderStyle.solid,
                      )),
                    ),
                    Text('Mais')
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            //Don' know how to put the products here without taking out the SingleChildScrollView!
            
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        onTap: quandoPressionado,
        currentIndex: paginaCorrente,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favoritos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Compras",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Conta",
          ),

        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Pesquisar...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }
}
