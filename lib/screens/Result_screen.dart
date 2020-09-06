import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget{
  static const routeName = '/result';

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text("Result Screen"),
        ),
        body:Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("This is Result Screen"),
              ],
            )
        )
    );
  }
}