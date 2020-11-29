import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_market/CustomProductWidget.dart';
import 'package:open_market/compras.dart';
import 'package:open_market/conta.dart';
import 'package:open_market/globals.dart';
import 'package:open_market/produto.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int paginaCorrente = 0;
  @override
  final List<Widget> paginas = [
    Front(),
    //Favoritos(),
    Compras(),
    Conta(),
  ];

  void quandoPressionado(int index) {
    setState(() {
      paginaCorrente = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: paginas[paginaCorrente],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black,
        onTap: quandoPressionado,
        currentIndex: paginaCorrente,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          /*BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favoritos",
          ),*/
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
}

class Front extends StatefulWidget {
  @override
  _FrontState createState() => _FrontState();
}

class _FrontState extends State<Front> {
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String queryString = "";

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
      queryString = newQuery;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
        _isSearching ? const BackButton() : Icon(Icons.local_grocery_store),
        title: _isSearching ? _buildSearchField() : Text("Open Market"),
        actions: _buildActions(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CarouselSlider(
              options: CarouselOptions(
                  height: 200.0,
                  aspectRatio: 16 / 9,
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
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                SizedBox(width: 10),
                Container(
                  width: 64,
                  child: Column(
                    children: [
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.white,
                        textColor: Colors.black,
                        child: Icon(Icons.local_mall, size: 20),
                        padding: EdgeInsets.all(15),
                        shape: CircleBorder(
                            side: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                              style: BorderStyle.solid,
                            )),
                      ),
                      Text('Moda')
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 65,
                  child: Column(
                    children: [
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.white,
                        textColor: Colors.black,
                        child: Icon(
                          Icons.stay_current_portrait,
                          size: 20,
                        ),
                        padding: EdgeInsets.all(15),
                        shape: CircleBorder(
                            side: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                              style: BorderStyle.solid,
                            )),
                      ),
                      Text('Celulares')
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 65,
                  child: Column(
                    children: [
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.white,
                        textColor: Colors.black,
                        child: Icon(
                          Icons.sports_motorsports,
                          size: 20,
                        ),
                        padding: EdgeInsets.all(15),
                        shape: CircleBorder(
                            side: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                              style: BorderStyle.solid,
                            )),
                      ),
                      Text('Motos')
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 65,
                  child: Column(
                    children: [
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.white,
                        textColor: Colors.black,
                        child: Icon(
                          Icons.directions_car,
                          size: 20,
                        ),
                        padding: EdgeInsets.all(15),
                        shape: CircleBorder(
                            side: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                              style: BorderStyle.solid,
                            )),
                      ),
                      Text('Carros')
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 65,
                  child: Column(
                    children: [
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.white,
                        textColor: Colors.black,
                        child: Icon(
                          Icons.add,
                          size: 20,
                        ),
                        padding: EdgeInsets.all(15),
                        shape: CircleBorder(
                            side: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                              style: BorderStyle.solid,
                            )),
                      ),
                      Text('Mais')
                    ],
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("produtos")
                            .orderBy("produtoNome", descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.done:
                            case ConnectionState.waiting:
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            default:
                              if (snapshot.data.documents.length == 0) {
                                //
                                return Center(
                                  child: Text(
                                    "Não há dados!",
                                    style: TextStyle(
                                        color: Colors.redAccent, fontSize: 20),
                                  ),
                                );
                              }
                              return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (context, index) {
                                    return queryString != null &&
                                        snapshot.data.documents[index]
                                            .data()["produtoNome"]
                                            .toString()
                                            .toLowerCase()
                                            .contains(queryString
                                            .toLowerCase())
                                        ? Card(
                                      // Lista os produtos
                                      child: CustomProductWidget(
                                        id: snapshot.data.documents[index]
                                            .documentID
                                            .toString(),
                                        descricao: snapshot
                                            .data.documents[index]
                                            .data()["produtoNome"]
                                            .toString(),
                                        valor: double.parse(snapshot
                                            .data.documents[index]
                                            .data()["produtoPreco"]
                                            .toString()),
                                        imageURL: snapshot
                                            .data.documents[index]
                                            .data()["produtoImagem"]
                                            .toString(),
                                        //favorito:  snapshot.data.documents[index].data()["produtoFavorito"].toString() == "true" ? true : false,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Produto(snapshot.data
                                                          .documents[
                                                      index])));
                                        },
                                      ),
                                    )
                                        : Container();
                                  });
                          }
                        }),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
