import 'package:flutter/material.dart';
import 'AR_screen.dart';
import 'Result_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      new Container(
        height: double.infinity,
        width: double.infinity,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("images/background_image.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,

        body: Center(
          child: new Container(
            color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("宝探しゲーム",style: TextStyle(
                      fontSize: 48.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.yellowAccent,
                      shadows: [Shadow(color: Colors.greenAccent,blurRadius: 16.0)]
                  ),
                  ),
                  RaisedButton.icon(
                      icon: Icon(
                        Icons.file_upload,
                        color: Colors.white,
                      ),
                      label: Text('宝を隠す',style: TextStyle(fontSize: 20)), color:Colors.lightBlue,shape: StadiumBorder(),
                      onPressed: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => ResultScreen()))),

                  RaisedButton.icon(
                      icon: Icon(
                        Icons.directions_run,
                        color: Colors.white,
                      ),
                      label: Text('宝を探す',style: TextStyle(fontSize: 20)), color:Colors.green,shape: StadiumBorder(),
                      onPressed: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => ARScreen())))
                ],
              ),
          ),

        ),
      )
    ]);
  }
}
