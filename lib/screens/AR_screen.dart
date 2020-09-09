import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'Result_screen.dart';

class ARScreen extends StatefulWidget {
  static const routeName = '/ar';

  const ARScreen({Key key}) : super(key: key);

  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  ARKitController arkitController;
  ARKitSphere sphere;
  Timer timer;

  @override
  void dispose() {
    timer?.cancel();
    arkitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(title: const Text('アクションをしろ！')),
        body: Container(
          child: ARKitSceneView(
            enableTapRecognizer: true,
            onARKitViewCreated: onARKitViewCreated,
          ),
        ),
      );

  void onARKitViewCreated(ARKitController arKitController) {
    this.arkitController = arKitController;
    this.arkitController.onNodeTap = (nodes) => onNodeTapHandler(nodes);

    final material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.lambert,
      diffuse: ARKitMaterialProperty(image: 'images/earth.jpg'),
        );
    sphere = ARKitSphere(
      materials: [material],
      radius: 0.1,
    );

    final node = ARKitNode(
      name: 'sphere',
      geometry: sphere,
      position: vector.Vector3(0, 0, -0.5),
      eulerAngles: vector.Vector3.zero(),
    );
    this.arkitController.add(node);

    timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      final old = node.eulerAngles.value;
      final rotation = vector.Vector3(old.x, old.y + 0.1, old.z);
      node.eulerAngles.value = rotation;
    });
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