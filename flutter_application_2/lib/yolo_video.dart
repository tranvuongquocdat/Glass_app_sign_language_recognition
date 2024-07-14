import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';
import 'package:image/image.dart' as img;

class YoloVideo extends StatefulWidget {
  final Socket socket;

  const YoloVideo({super.key, required this.socket});

  @override
  State<YoloVideo> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloVideo> {
  late FlutterVision vision;
  late List<Map<String, dynamic>> yoloResults;
  Uint8List? imageData;
  late StreamSubscription<List<int>> _subscription;
  bool isDetecting = false;
  int frames = 0;
  double fps = 0.0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    vision = FlutterVision();
    _subscription = widget.socket.listen(_onDataReceived);
    _loadYoloModel();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        fps = frames.toDouble();
        frames = 0;
      });
    });
  }

  @override
  void dispose() {
    vision.closeYoloModel();
    _subscription.cancel();
    timer.cancel();
    super.dispose();
  }

  Future<void> _loadYoloModel() async {
    await vision.loadYoloModel(
      labels: 'assets/label.txt',
      modelPath: 'assets/yolov8n_float32.tflite',
      modelVersion: "yolov8",
      numThreads: 4,
      useGpu: false,
    );
    setState(() {
      isDetecting = true;
      yoloResults = [];
    });
  }

  void _onDataReceived(List<int> data) async {
    if (isDetecting) {
      setState(() {
        imageData = Uint8List.fromList(data);
      });

      // Decode image data and JSON string from the received data
      int separatorIndex = data.indexWhere((element) => element == 0);
      if (separatorIndex != -1) {
        imageData = Uint8List.fromList(data.sublist(0, separatorIndex));
        String jsonStr = utf8.decode(data.sublist(separatorIndex + 1));
        yoloResults = List<Map<String, dynamic>>.from(json.decode(jsonStr));

        setState(() {});
        frames++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          imageData != null
              ? Image.memory(
                  imageData!,
                  fit: BoxFit.cover,
                )
              : const Center(child: CircularProgressIndicator()),
          ...displayBoxesAroundRecognizedObjects(size),
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              "FPS: ${fps.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];
    double factorX = screen.width /
        (imageData != null ? img.decodeImage(imageData!)?.width ?? 1 : 1);
    double factorY = screen.height /
        (imageData != null ? img.decodeImage(imageData!)?.height ?? 1 : 1);

    Color colorPick = const Color.fromARGB(255, 97, 214, 191);

    return yoloResults.map((result) {
      double objectX = result["box"][0] * factorX;
      double objectY = result["box"][1] * factorY;
      double objectWidth = (result["box"][2] - result["box"][0]) * factorX;
      double objectHeight = (result["box"][3] - result["box"][1]) * factorY;

      return Positioned(
        left: objectX,
        top: objectY,
        width: objectWidth,
        height: objectHeight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(
                color: const Color.fromARGB(255, 30, 233, 203), width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(2)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }
}
