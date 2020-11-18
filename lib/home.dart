import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";

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

          ],
        ),
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
