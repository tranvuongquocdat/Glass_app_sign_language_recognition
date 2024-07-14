import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YOLOv8 Detection Info',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const IPInputScreen(),
    );
  }
}

class IPInputScreen extends StatefulWidget {
  const IPInputScreen({super.key});

  @override
  _IPInputScreenState createState() => _IPInputScreenState();
}

class _IPInputScreenState extends State<IPInputScreen> {
  final TextEditingController _ipController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIP();
  }

  Future<void> _loadIP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ip = prefs.getString('server_ip') ?? '';
    setState(() {
      _ipController.text = ip;
      _isLoading = false;
    });
  }

  Future<void> _saveIP(String ip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_ip', ip);
  }

  void _connect() {
    String ip = _ipController.text;
    if (ip.isNotEmpty) {
      _saveIP(ip);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetectionInfoScreen(ip: ip),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Server IP')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _ipController,
                    decoration: const InputDecoration(
                      labelText: 'Server IP',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _connect,
                    style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Connect'),
                  ),
                ],
              ),
            ),
    );
  }
}

class DetectionInfoScreen extends StatefulWidget {
  final String ip;

  const DetectionInfoScreen({super.key, required this.ip});

  @override
  _DetectionInfoScreenState createState() => _DetectionInfoScreenState();
}

class _DetectionInfoScreenState extends State<DetectionInfoScreen> {
  late Socket _socket;
  String _fps = "0.00";
  String _detectedText = "Waiting for detection...";

  @override
  void initState() {
    super.initState();
    _connectToServer();
  }

  Future<void> _connectToServer() async {
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
      });
    }
  }

  @override
  void dispose() {
    _socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign language recognition demo')),
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
}
