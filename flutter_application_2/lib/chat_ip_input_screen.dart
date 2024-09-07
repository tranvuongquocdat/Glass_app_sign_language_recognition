import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'chat_screen.dart';

class ChatIPInputScreen extends StatefulWidget {
  const ChatIPInputScreen({Key? key}) : super(key: key);

  @override
  _ChatIPInputScreenState createState() => _ChatIPInputScreenState();
}

class _ChatIPInputScreenState extends State<ChatIPInputScreen> {
  final TextEditingController _ipController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIP();
  }

  Future<void> _loadIP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ip = prefs.getString('chat_server_ip') ?? '';
    setState(() {
      _ipController.text = ip;
      _isLoading = false;
    });
  }

  Future<void> _saveIP(String ip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_server_ip', ip);
  }

  void _connect() async {
    String ip = _ipController.text;
    if (ip.isNotEmpty) {
      try {
        _saveIP(ip);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(ip: ip),
          ),
        );
      } catch (e) {
        _showConnectErrorDialog(e.toString());
      }
    }
  }

  void _handleConnectPress() async {
    HapticFeedback.lightImpact();
    _connect();
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
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Enter Chat Server IP',
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
                      'assets/connect_avt.jpeg',
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
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
