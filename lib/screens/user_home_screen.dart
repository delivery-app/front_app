import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:delivery_app/services/products_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery_app/helpers/bottom_navbar_bloc.dart';
import 'restaurants_screen.dart';
import 'package:delivery_app/screens/cart_screen.dart';

class UserHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserHome();
}

class _UserHome extends State<UserHome> {
  BottomNavBarBloc _bottomNavBarBloc;
  final prodApi = ProductsApi();

  var _topProducts = [];

  static Future<String> getJWT() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String jsonString = prefs.getString('jwt') ?? "";
    if (jsonString.isNotEmpty) {
      return jsonString;
    } else {
      return '';
    }
  }

  Future _getTopProducts() async {
    return await prodApi.getAllProducts();
  }

  @override
  void initState() {
    super.initState();
    _bottomNavBarBloc = BottomNavBarBloc();
  }

  @override
  void dispose() {
    _bottomNavBarBloc.close();
    super.dispose();
  }

  // main builder
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showBody(),
      bottomNavigationBar: _showBottomNavBar(),
    );
  }

  Widget _showBody() {
    return StreamBuilder<NavBarItem>(
      stream: _bottomNavBarBloc.itemStream,
      initialData: _bottomNavBarBloc.defaultItem,
      builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
        switch (snapshot.data) {
          case NavBarItem.PROFILE:
            return Container(
              child: Center(
                child: Text(
                  'Profile Screen',
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            );
          case NavBarItem.HOME:
            return _homeScreen();
          case NavBarItem.CART:
            return CartScreen();
        }
      },
    );
  }

  Widget _showBottomNavBar() {
    return StreamBuilder(
      stream: _bottomNavBarBloc.itemStream,
      initialData: _bottomNavBarBloc.defaultItem,
      builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
        return BottomNavigationBar(
          fixedColor: Colors.blueAccent,
          currentIndex: snapshot.data.index,
          onTap: _bottomNavBarBloc.pickItem,
          items: [
            BottomNavigationBarItem(
              title: Text('Profile'),
              icon: Icon(Icons.person),
              activeIcon: Icon(
                Icons.person,
                color: Colors.redAccent,
              ),
            ),
            BottomNavigationBarItem(
              title: Text('UserHome'),
              icon: Icon(Icons.home),
              activeIcon: Icon(
                Icons.home,
                color: Colors.redAccent,
              ),
            ),
            BottomNavigationBarItem(
              title: Text('Shopping cart'),
              icon: Icon(Icons.shopping_cart),
              activeIcon: Icon(
                Icons.shopping_cart,
                color: Colors.redAccent,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _homeScreen() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _showUserHomeMessage(), // there's a future bug right here
            _restaurantButton(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Divider(
                color: Colors.black45,
              ),
            ),
            _getAndShowTopProducts(),
          ],
        ),
      ),
    );
  }

  Widget _showUserHomeMessage() {
    return FutureBuilder<String>(
        // get the languageCode, saved in the preferences
        future: getJWT(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Column(
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text('Loading...'),
                ],
              );
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');

              var data = jsonDecode(snapshot.data);
              final parts = data.split('.');
              final payload = _decodeBase64(parts[1]);
              final payloadMap = json.decode(payload);

              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Text('Welcome back ${payloadMap['name']}!',
                      style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold)),
                ),
              );
          }
        });
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  _goToRestaurants() {
    var route = new MaterialPageRoute(
        builder: (BuildContext context) => RestaurantsScreen());

    Navigator.of(context).push(route);
  }

  Widget _restaurantButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: FlatButton(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(14.0),
              child: Image.asset(
                'assets/restaurants.png',
                scale: 6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Text(
                'Restaurants',
                style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.redAccent.shade200,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        onPressed: () {
          _goToRestaurants();
        },
      ),
    );
  }

  // still missing the functionality on pressed
  Widget _singleProduct(product) {
    var prodTitle = product['title'];
    var prodImage = product['imagePath'];

    return FlatButton(
      padding: EdgeInsets.all(1.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              prodImage,
              scale: 7.5,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            prodTitle,
            style: TextStyle(fontSize: 12.0, color: Colors.black87),
          ),
        ],
      ),
      onPressed: () {
        print('top product');
      },
    );
  }

  Widget _showTopProducts() {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            'Top products of the week',
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade300),
          ),
          SizedBox(
            height: 25.0,
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _singleProduct(_topProducts[0]),
                      _singleProduct(_topProducts[1]),
                      _singleProduct(_topProducts[2]),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _singleProduct(_topProducts[3]),
                    _singleProduct(_topProducts[4]),
                    _singleProduct(_topProducts[5]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAndShowTopProducts() {
    return FutureBuilder(
      future: _getTopProducts(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Text('Awaiting result...');
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            _topProducts = snapshot.data;

            return _showTopProducts();
        }
      },
    );
  }
}
