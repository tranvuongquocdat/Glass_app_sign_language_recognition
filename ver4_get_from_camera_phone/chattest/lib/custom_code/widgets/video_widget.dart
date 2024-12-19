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

class VideoWidget extends StatefulWidget {
  const VideoWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  CameraController? controller;
  late Future<List<CameraDescription>> _cameras;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _cameras = availableCameras();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await _cameras;
    if (cameras.isNotEmpty) {
      controller = CameraController(cameras[0], ResolutionPreset.medium);
      await controller!.initialize();
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _startCapturing() {
    // Làm rỗng danh sách base64 trước khi bắt đầu
    FFAppState().update(() {
      FFAppState().fileBase64List.clear();
    });
    setState(() {
      _isCapturing = true;
    });
    _captureFrames();
  }

  void _stopCapturing() {
    setState(() {
      _isCapturing = false;
    });
  }

  void _captureFrames() async {
    while (_isCapturing && FFAppState().makePhoto) {
      try {
        final file = await controller!.takePicture();
        final bytes = await file.readAsBytes();
        final base64 = base64Encode(bytes);

        FFAppState().update(() {
          FFAppState().fileBase64List.add(base64);
        });

        await Future.delayed(Duration(milliseconds: 500)); // Adjust frame rate
      } catch (e) {
        print('Error capturing frame: $e');
      }
    }
    FFAppState().update(() {
      FFAppState().makePhoto = false;
    });
  }

  @override
  void didUpdateWidget(covariant VideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (FFAppState().makePhoto && !_isCapturing) {
      _startCapturing();
    } else if (!FFAppState().makePhoto && _isCapturing) {
      _stopCapturing();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return controller == null || !controller!.value.isInitialized
        ? Center(child: CircularProgressIndicator())
        : SizedBox(
            width: widget.width ?? double.infinity,
            height: widget.height ?? double.infinity,
            child: CameraPreview(controller!),
          );
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
