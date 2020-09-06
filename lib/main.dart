import 'package:app/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context){
    return MaterialApp(
        title: 'mixture',
        home: HomeScreen()
    );
  }
}
