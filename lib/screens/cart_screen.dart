import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final userId;
  const CartScreen({Key key, this.userId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CartScreen();
}

class _CartScreen extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showBody(),
    );
  }

  Widget _showCartInfo() {
    return Column(
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Total',
                  style: TextStyle(color: Colors.black26, fontSize: 20.0),
                ),
                Text('\$0',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _cartBackground() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 80.0, horizontal: 30.0),
      child: Image.asset(
        'assets/cart.png',
        color: Color.fromRGBO(150, 150, 150, 0.1),
      ),
    );
  }

  Widget _cartBuyBtn() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 40.0,
        width: double.infinity,
        child: RaisedButton(
          disabledColor: Colors.green.shade500,
          child: Text(
            'Continue',
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _showBody() {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _showCartInfo(),
                _cartBackground(),
                _cartBuyBtn(),
              ],
            ),
          ),
        ));
  }
}
