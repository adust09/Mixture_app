import 'package:flutter/material.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  static const routeName = '/result';

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      new Container(
        height: double.infinity,
        width: double.infinity,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("images/background_image1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "congratulations!",
                style: TextStyle(
                    fontSize: 44.0,
                    color: Colors.yellowAccent,
                    shadows: [Shadow(color: Colors.red, blurRadius: 16.0)]),
              ),
              RaisedButton.icon(
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  label: Text('ホームに戻る', style: TextStyle(fontSize: 20)),
                  color: Colors.green,
                  shape: StadiumBorder(),
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomeScreen())))
            ],
          )))
    ]);
  }
}
