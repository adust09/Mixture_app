import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'Result_screen.dart';

class ARScreen extends StatefulWidget {
  static const routeName = '/ar';

  const ARScreen({Key key}) : super(key: key);

  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> with SingleTickerProviderStateMixin{
  ARKitController arkitController;
  ARKitSphere sphere;
  Timer timer;
  bool anchorWasFound = false;

  AnimationController _animationController;
  var _isScaledUp = false;
  static double _accelmaxX = 0;
  static double _accelmaxY = 0;
  static double _accelmaxZ = 0;
  static double _countup_accel = 0;
  List<double> _accelerometerValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
  <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      if (event.x > _accelmaxX) {
        _accelmaxX = event.x;
      } else if (event.y > _accelmaxY) {
        _accelmaxY = event.y;
      } else if (event.z > _accelmaxZ) {
        _accelmaxZ = event.z;
      }

      if (event.x > 50) {
        _countup_accel++;
      }
      setState(() {
        _accelerometerValues = <double>[
          _accelmaxX,
          _accelmaxY,
          _accelmaxZ,
          _countup_accel
        ];
      });
    }));
  }

  @override
  void dispose() {
    timer?.cancel();
    arkitController?.dispose();
    _animationController.dispose();
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }

  }

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer =
    _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isScaledUp) {
            _animationController.reverse();
          } else {
            _animationController.forward();
          }
          _isScaledUp = !_isScaledUp;
        },
        child: const Icon(Icons.refresh),
      ),
      appBar: AppBar(title: const Text('アクションをしろ！')),
      body: SafeArea(
          child: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Align(
                child: ARKitSceneView(
                  detectionImages: const [
                    ARKitReferenceImage(
                      name: 'https://avatars0.githubusercontent.com/u/55534054?s=460&u=402783902455ae84995129488dd3a12d0699fd84&v=4',
                      //ここにfirebaseのCloud storageから取得した画像情報を格納する。→隠し場所
                      physicalWidth: 0.2,
                    ),
                  ],
                  onARKitViewCreated: onARKitViewCreated,
                  enableTapRecognizer: true,
                ),
              ),
              anchorWasFound
                  ? Container()
                  : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '隠したオブジェクトを見つけてね！',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Colors.white),
                ),
              ),
              Align(
                child: Column(
                  children: [
                    Padding(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Accelerometer: $accelerometer'),
                        ],
                      ),
                      padding: const EdgeInsets.all(16.0),
                    ),
                    Center(
                      child: SizeTransition(
                        axis: Axis.vertical, // default
                        axisAlignment: 0,
                        sizeFactor: _animationController
                            .drive(
                          CurveTween(curve: Curves.fastOutSlowIn),
                        )
                            .drive(
                          Tween<double>(
                            begin: 0.01,
                            end: _countup_accel * 0.01,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: <Widget>[
                                Image.network(
                                    "https://avatars0.githubusercontent.com/u/55534054?s=460&u=402783902455ae84995129488dd3a12d0699fd84&v=4"),
                                Positioned.fill(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      color: Colors.black.withOpacity(1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],


          )
      ),
    );
  }
  void onARKitViewCreated(ARKitController arKitController) {
    this.arkitController = arKitController;
    this.arkitController.onNodeTap = (nodes) => onNodeTapHandler(nodes);
    this.arkitController.onAddNodeForAnchor = onAnchorWasFound;
  }

  void onAnchorWasFound(ARKitAnchor anchor) {
    if (anchor is ARKitImageAnchor) {
      setState(() => anchorWasFound = true);

      final material = ARKitMaterial(
        lightingModelName: ARKitLightingModel.lambert,
        diffuse: ARKitMaterialProperty(
            image: 'images/earth.jpg'),
      );
      sphere = ARKitSphere(
        materials: [material],
        radius: 0.1,
      );

      final earthPosition = anchor.transform.getColumn(3);
      final node = ARKitNode(
        geometry: sphere,
        position:
        vector.Vector3(earthPosition.x, earthPosition.y, earthPosition.z),
        eulerAngles: vector.Vector3.zero(),
      );
      arkitController.add(node);

      timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        final old = node.eulerAngles;
        final eulerAngles = vector.Vector3(old.value.x, old.value.y + 0.1, old.value.z);
        node.eulerAngles.value = eulerAngles;
      });
    }
  }


  onNodeTapHandler(List<String> nodesList) {
    final name = nodesList.first;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(content: Text('宝を見つけました！おめでとう！')),
    );
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ResultScreen()));
  }
}