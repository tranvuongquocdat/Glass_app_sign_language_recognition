import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // Import the services package for HapticFeedback
import 'detection_info_screen.dart';

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

  void _connect() async {
    String ip = _ipController.text;
    if (ip.isNotEmpty) {
      try {
        // Simulate connecting to the server (replace with actual connection code)
        // throw Exception('Simulated connection error'); // Uncomment to simulate an error
        _saveIP(ip);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetectionInfoScreen(ip: ip),
          ),
        );
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
          'Enter Server IP',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 10,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      'assets/connect_avt.jpeg', // Make sure to add your image in the assets folder and update pubspec.yaml accordingly
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 30),
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
