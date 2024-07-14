import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Socket Client',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Socket Client'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> messages = [];
  final TextEditingController _ipController = TextEditingController();
  String? storedIpAddress;

  @override
  void initState() {
    super.initState();
    _loadIpAddress();
  }

  void _loadIpAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      storedIpAddress = prefs.getString('ipAddress');
      _ipController.text = storedIpAddress ?? '';
    });
  }

  void _saveIpAddress(String ipAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ipAddress', ipAddress);
  }

  void connectToServer(String ipAddress) async {
    try {
      final serverAddress = InternetAddress(ipAddress);
      const serverPort = 65432;

      Socket socket = await Socket.connect(serverAddress, serverPort);
      print(
          'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

      socket.listen((data) {
        setState(() {
          messages.add(utf8.decode(data));
        });
      }, onDone: () {
        print('Server left.');
        socket.destroy();
      }, onError: (error) {
        print('Error: $error');
        socket.destroy();
      });
    } catch (e) {
      print('Unable to connect: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _ipController,
              decoration: const InputDecoration(
                labelText: 'Server IP Address',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String ipAddress = _ipController.text;
              _saveIpAddress(ipAddress);
              connectToServer(ipAddress);
            },
            child: const Text('Connect'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
