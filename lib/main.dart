import 'package:flutter/material.dart';
import 'package:delivery_app/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  noSuchMethod(Invocation i) => super.noSuchMethod(i);
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Delivery',
      theme: ThemeData(primaryColor: Colors.blue[50]),
      home: LoginPage(),
      //debugShowCheckedModeBanner: false,
    );
  }
}
