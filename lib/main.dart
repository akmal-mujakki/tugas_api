import 'package:flutter/material.dart';
import 'package:projek/list.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Pengguna',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListUser(),
    );
  }
}





