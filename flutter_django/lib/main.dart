import 'package:flutter/material.dart';
import 'package:flutter_django/create.dart';
import 'package:flutter_django/product.dart';
import 'package:flutter_django/update.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductList(),
      routes: {
        'update': (context) => Update(),
        'create': (context) => Create(),
        'product': (context) => ProductList(),
      },
    );
  }
}
