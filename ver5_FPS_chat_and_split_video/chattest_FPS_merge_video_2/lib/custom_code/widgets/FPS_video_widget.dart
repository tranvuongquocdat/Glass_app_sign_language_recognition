// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom widgets

import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class FPSVideoWidget extends StatefulWidget {
  const FPSVideoWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _FPSVideoWidgetState createState() => _FPSVideoWidgetState();
}

class _FPSVideoWidgetState extends State<FPSVideoWidget> {
  CameraController? controller;
  bool _isCapturing = false;
  double _currentFps = 0.0;
  int _frameCount = 0;
  DateTime _lastFpsUpdate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    controller = CameraController(cameras[0], ResolutionPreset.high);
    await controller?.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _processFrame() async {
    if (!_isCapturing || controller == null) return;

    try {
      // Capture frame and convert to base64
      final image = await controller!.takePicture();
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Send to server
      final response = await http.post(
        Uri.parse('http://${FFAppState().IPAddress}:8000/detect'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['objects'] != null && result['objects'].isNotEmpty) {
          FFAppState().appendToServerOutput(
              result['objects'].join(' ')); // Add detected objects to output
        }
        
        // Update FPS
        _frameCount++;
        final now = DateTime.now();
        final elapsed = now.difference(_lastFpsUpdate);
        if (elapsed.inSeconds >= 1) {
          setState(() {
            _currentFps = _frameCount / elapsed.inSeconds;
            _frameCount = 0;
            _lastFpsUpdate = now;
          });
        }
      }

      if (_isCapturing) {
        // Schedule next frame
        Future.delayed(Duration(milliseconds: 100), _processFrame);
      }
    } catch (e) {
      print('Error processing frame: $e');
    }
  }

  void _startCapturing() {
    setState(() {
      _isCapturing = true;
      FFAppState().serverOutput = ''; // Clear previous output
    });
    _processFrame();
  }

  void _stopCapturing() {
    setState(() {
      _isCapturing = false;
    });
  }

  @override
  void didUpdateWidget(covariant FPSVideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (FFAppState().makePhoto && !_isCapturing) {
      _startCapturing();
    } else if (!FFAppState().makePhoto && _isCapturing) {
      _stopCapturing();
    }
  }

  @override
  Widget build(BuildContext context) {
    return controller == null || !controller!.value.isInitialized
        ? Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              SizedBox(
                width: widget.width ?? double.infinity,
                height: widget.height ?? double.infinity,
                child: CameraPreview(controller!),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FPS: ${_currentFps.toStringAsFixed(1)}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8,
                        ),
                        child: Text(
                          'Output: ${FFAppState().serverOutput}',
                          style: TextStyle(color: Colors.white),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
