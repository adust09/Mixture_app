import 'package:flutter/material.dart';
import 'AR_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Screen"),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                child: Text('Press This Button', style: TextStyle(fontSize: 20)),
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => ARScreen())))
          ],
        )));
  }
}
