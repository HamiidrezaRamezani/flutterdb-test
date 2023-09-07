import 'package:flutter/material.dart';
import 'package:fluttertest/pages/todos_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your favorite todo app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodosPage(),
    );
  }
}