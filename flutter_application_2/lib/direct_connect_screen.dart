import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/services.dart'; // Import the services package for HapticFeedback
import 'yolo_video.dart';

class DirectConnectScreen extends StatefulWidget {
  const DirectConnectScreen({super.key});

  @override
  _DirectConnectScreenState createState() => _DirectConnectScreenState();
}

class _DirectConnectScreenState extends State<DirectConnectScreen> {
  final TextEditingController _ipController = TextEditingController();
  bool _isConnected = false;
  late Socket _socket;

  @override
  void initState() {
    super.initState();
    _loadIp();
  }

  Future<void> _loadIp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ip = prefs.getString('server_ip');
    if (ip != null) {
      setState(() {
        _ipController.text = ip;
      });
    }
  }

  Future<void> _saveIp(String ip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_ip', ip);
  }

  void _connect() async {
    String ip = _ipController.text;
    if (ip.isNotEmpty) {
      try {
        _socket = await Socket.connect(ip, 8000);
        await _saveIp(ip);
        setState(() {
          _isConnected = true;
        });
        _showConnectSuccessDialog();
      } catch (e) {
        _showConnectErrorDialog(e.toString());
      }
    }
  }

  void _handleConnectPress() async {
    HapticFeedback.lightImpact(); // Provide haptic feedback
    _connect();
  }

  void _showConnectSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connection Successful'),
        content: const Text('You have successfully connected to the server.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showConnectErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connection Error'),
        content: Text('Error connecting to the server: $errorMessage'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
          'Directly Connect to Ras',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 30,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                'assets/connect_avt.jpeg', // Make sure to add your image in the assets folder and update pubspec.yaml accordingly
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
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
              onPressed: _handleConnectPress,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Connect'),
            ),
            const SizedBox(height: 20),
            _isConnected
                ? Expanded(
                    child: YoloVideo(socket: _socket),
                  )
                : const Text(''),
          ],
        ),
      ),
    );
  }
}
