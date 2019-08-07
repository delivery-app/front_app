import 'package:flutter/material.dart';
import 'package:delivery_app/services/restaurants_api.dart';
import 'restProducts_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RestaurantsScreen();
}

class _RestaurantsScreen extends State<RestaurantsScreen> {
  final restApi = RestaurantsApi();
  var _allRestaurants = [];

  Future _getRestaurants() async {
    return await restApi.getAllRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showBody(),
    );
  }

  Widget _showLogo() {
    return Container(
      height: 150.0,
      width: double.infinity,
      child: FittedBox(
        child: Image.asset(
          'assets/restaurants.png',
          scale: 6,
        ),
        fit: BoxFit.fitWidth,
      ),
    );
  }

  _goToRestProducts(restaurant) {
    var route = new MaterialPageRoute(
        builder: (BuildContext context) =>
            RestProductScreen(restaurant: restaurant));

    Navigator.of(context).push(route);
  }

  Widget _singleRestaurant(restaurant) {
    var image = restaurant['imagePath'];
    var name = restaurant['name'];
    var description = restaurant['description'];
    var deliveryPrice = restaurant['delivery_price'];

    return FlatButton(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          height: 110,
          child: Card(
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Image.network(image),
                ),
                SizedBox(width: 20.0),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8),
                      ),
                      Text(
                        description,
                        style: TextStyle(fontSize: 14.0, color: Colors.black54),
                      ),
                      Text('Delivery price: \$$deliveryPrice'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onPressed: () {
        _goToRestProducts(restaurant);
      },
    );
  }

  List<Widget> _showRestaurants(restaurants) {
    List<Widget> restaurantsWidgets = new List();
    for (var restaurant in restaurants) {
      restaurantsWidgets.add(_singleRestaurant(restaurant));
    }
    return restaurantsWidgets;
  }

  Widget _getAndShowRestaurants() {
    return FutureBuilder(
      future: _getRestaurants(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
            _allRestaurants = snapshot.data;

            return Column(
              children: <Widget>[
                Text(
                  '${_allRestaurants.length} Restaurants open',
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15.0),
                Column(
                  children: _showRestaurants(_allRestaurants),
                ),
              ],
            );
        }
      },
    );
  }

  Widget _showBody() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _showLogo(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Divider(
                  color: Colors.black45,
                ),
              ),
              _getAndShowRestaurants(),
            ],
          ),
        ));
  }
}
