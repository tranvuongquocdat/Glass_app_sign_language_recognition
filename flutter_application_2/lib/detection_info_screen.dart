import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart'; // Import the services package for HapticFeedback
import 'package:flutter_tts/flutter_tts.dart';

class DetectionInfoScreen extends StatefulWidget {
  final String ip;

  const DetectionInfoScreen({super.key, required this.ip});

  @override
  DetectionInfoScreenState createState() => DetectionInfoScreenState();
}

class DetectionInfoScreenState extends State<DetectionInfoScreen> {
  late Socket _socket;
  String _fps = "0.00";
  String _detectedText = "Waiting for detection...";
  String _lastDetectedText = "";
  bool _isTtsEnabled = false;
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _connectToServer();
  }

  Future<void> _connectToServer() async {
    try {
      _socket = await Socket.connect(widget.ip, 8001);
      _socket.listen(
        (Uint8List data) {
          _processData(data);
        },
        onError: (error) {
          print("Socket error: $error");
          _socket.destroy();
        },
        onDone: () {
          print("Socket closed");
          _socket.destroy();
        },
      );
    } catch (e) {
      print("Failed to connect: $e");
    }
  }

  void _processData(Uint8List data) {
    ByteData byteData = ByteData.sublistView(data);
    int msgLength = byteData.getUint32(0, Endian.little);
    if (data.length >= msgLength + 4) {
      Uint8List messageBytes = data.sublist(4, msgLength + 4);
      String message = utf8.decode(messageBytes);
      List<String> parts = message.split(',');
      setState(() {
        _fps = parts[0];
        _detectedText = parts[1];
        if (_isTtsEnabled &&
            _detectedText.isEmpty &&
            _lastDetectedText.isNotEmpty &&
            !_isSpeaking) {
          _speak(_lastDetectedText);
        }
        _lastDetectedText = _detectedText;
      });
    }
  }

  Future<void> _speak(String text) async {
    setState(() {
      _isSpeaking = true;
    });
    await _flutterTts.speak(text);
    setState(() {
      _isSpeaking = false;
    });
  }

  @override
  void dispose() {
    _socket.close();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            HapticFeedback
                .lightImpact(); // Provide haptic feedback for back button
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Sign Language Recognition',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Spacer(),
            // Adding the image section at the top
            Image.asset(
              'assets/avt.avif', // Make sure to add your image in the assets folder and update pubspec.yaml accordingly
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const Spacer(),
            _buildInfoBox("FPS", _fps),
            const SizedBox(height: 20),
            _buildInfoBox("Detected", _detectedText),
            const SizedBox(height: 20),
            _buildTtsSwitch(),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildTtsSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Enable Text-to-Speech',
          style: TextStyle(fontSize: 18),
        ),
        Switch(
          value: _isTtsEnabled,
          onChanged: (bool value) {
            setState(() {
              _isTtsEnabled = value;
            });
          },
        ),
      ],
    );
  }
}
