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
  bool anchorWasFound = false;

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
            child: Stack(
                fit: StackFit.expand,
                children: [
                  ARKitSceneView(
                    detectionImages: const [
                      ARKitReferenceImage(
                          name: 'https://avatars0.githubusercontent.com/u/55534054?s=460&u=402783902455ae84995129488dd3a12d0699fd84&v=4',//ここにfirebaseのCloud storageから取得した画像情報を格納する。→隠し場所
                          physicalWidth: 0.2,
                      ),
                    ],
                    onARKitViewCreated: onARKitViewCreated,
                    enableTapRecognizer: true,
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
                  )
                ]
            )
        ),
      );

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