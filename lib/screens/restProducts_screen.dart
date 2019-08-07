import 'package:flutter/material.dart';
import 'package:delivery_app/services/restaurants_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestProductScreen extends StatefulWidget {
  final restaurant;
  const RestProductScreen({Key key, this.restaurant}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RestProductScreen();
}

class _RestProductScreen extends State<RestProductScreen> {
  final restApi = RestaurantsApi();
  var _allRestProducts = [];

  Future _getRestProducts() async {
    var restaurantId = widget.restaurant['_id'];
    return await restApi.getRestaurantProducts(restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showBody(),
    );
  }

  Widget _showRestInfo() {
    var image = widget.restaurant['imagePath'];
    var name = widget.restaurant['name'];
    var description = widget.restaurant['description'];
    var deliveryPrice = widget.restaurant['delivery_price'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 120.0,
              width: double.infinity,
              child: FittedBox(
                child: Image.network(image),
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              name,
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                description,
                style: TextStyle(fontSize: 18.0, color: Colors.black54),
              ),
            ),
            Text(
              'Delivery price: \$$deliveryPrice',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _singleRestProduct(product) {
    var title = product['title'];
    var image = product['imagePath'];
    var description = product['description'];
    var price = product['price'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                      child: Text(
                        description,
                        style: TextStyle(fontSize: 14.0, color: Colors.black54),
                      ),
                    ),
                    Text('Price: \$$price'),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.network(
                  image,
                  scale: 6,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: 100.0,
            child: OutlineButton(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.green.shade700,
                  ),
                  Text(
                    'Add',
                    style: TextStyle(color: Colors.green, fontSize: 14.0),
                  ),
                ],
              ),
              onPressed: () {
                print('Add to cart');
              },
              disabledBorderColor: Colors.black26,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _showRestProducts(products) {
    List<Widget> restaurantsWidgets = new List();
    for (var product in products) {
      restaurantsWidgets.add(_singleRestProduct(product));
    }
    return restaurantsWidgets;
  }

  Widget _getAndShowRestProducts() {
    return FutureBuilder(
      future: _getRestProducts(),
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
            _allRestProducts = snapshot.data;

            return Column(
              children: _showRestProducts(_allRestProducts),
            );
        }
      },
    );
  }

  Widget _showBody() {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _showRestInfo(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Divider(
                  color: Colors.black45,
                ),
              ),
              _getAndShowRestProducts(),
            ],
          ),
        ));
  }
}
