import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:video_player/video_player.dart';

class ChatScreen extends StatefulWidget {
  final String ip;

  const ChatScreen({Key? key, required this.ip}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _messages = [];
  final FlutterTts _flutterTts = FlutterTts();
  bool _isTtsEnabled = false;
  late Socket _socket;
  String _fps = "0.00";

  // Speech to Text Variables
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  late AnimationController _animationController;
  late VideoPlayerController _videoController;
  bool _isPlayingVideo = false;
  final Map<String, String> _videoMap = {
    'nice to meet you': 'assets/vid1.mp4',
    'i have lunch': 'assets/vid2.mp4',
    'goodbye': 'assets/vid3.mp4',
    'are you happy': 'assets/video/are_you_happy.mp4',
    'i drink': 'assets/video/i_drink.mp4',
    'i am eating cake': 'assets/video/i_eat_food.mp4',
    'i like biscuit': 'assets/video/i_like_biscuit.mp4',
    'i like sleep': 'assets/video/i_like_sleep.mp4',
    'i am fine': 'assets/video/ok.mp4',
    'sorry': 'assets/video/sorry.mp4',
    'thank you': 'assets/video/thanks.mp4',
    'what are you doing': 'assets/video/what_are_you_do.mp4',
    'what do you like': 'assets/video/what_do_you_like.mp4',
  };

  @override
  void initState() {
    super.initState();
    _connectToServer();
    _initializeSpeech();
    _loadTtsState();
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
        _addMessage(parts[1], false);
      });
    }
  }

  void _addMessage(String text, bool isUser) {
    setState(() {
      _messages.add({
        'text': text,
        'isUser': isUser,
      });
      if (_isTtsEnabled && !isUser) {
        _speak(text);
      }
    });
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  void _initializeSpeech() {
    _speech = stt.SpeechToText();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Slow down the animation
      lowerBound: 0.7,
      upperBound: 1.05,
    );
  }

  Future<void> _initializeVideoPlayer(String videoPath) async {
    _videoController = VideoPlayerController.asset(videoPath);
    try {
      await _videoController.initialize();
      _videoController.addListener(() {
        if (_videoController.value.position ==
            _videoController.value.duration) {
          setState(() {
            _isPlayingVideo = false;
            _text = '';
          });
        }
      });
      setState(() {});
    } catch (e) {
      print('Error initializing video player: $e');
    }
  }

  void _listen() async {
    HapticFeedback.mediumImpact();
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
          _animationController.repeat(reverse: true);
        });
        _speech.listen(
          localeId: 'en-US', // Specify a supported language here
          onResult: (val) => setState(() {
            _text = val.recognizedWords.toLowerCase();
            _videoMap.forEach((phrase, videoPath) {
              if (_text.contains(phrase)) {
                _playVideo(videoPath);
                _addMessage(_text, true); // Add recognized text as a message
              }
            });
            if (!_isPlayingVideo) {
              Future.delayed(const Duration(seconds: 3), () {
                setState(() {
                  _text = '';
                });
              });
            }
          }),
        );
      } else {
        setState(() {
          _isListening = false;
          _animationController.stop();
        });
        _speech.stop();
      }
    } else {
      setState(() {
        _isListening = false;
        _animationController.stop();
      });
      _speech.stop();
      HapticFeedback.mediumImpact();
    }
  }

  void _playVideo(String videoPath) {
    setState(() {
      _isPlayingVideo = true;
    });
    _initializeVideoPlayer(videoPath).then((_) {
      if (!_videoController.value.isPlaying) {
        _videoController.play();
        _videoController.setLooping(false);
      }
    });
  }

  Future<void> _loadTtsState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isTtsEnabled = prefs.getBool('isTtsEnabled') ?? false;
    });
  }

  Future<void> _saveTtsState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isTtsEnabled', _isTtsEnabled);
  }

  @override
  void dispose() {
    _socket.close();
    _flutterTts.stop();
    _animationController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SPECS Chatbox'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Settings'),
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Row(
                          children: [
                            Expanded(child: Text('Enable Text-to-Speech')),
                            Switch(
                              value: _isTtsEnabled,
                              onChanged: (bool value) {
                                setState(() {
                                  _isTtsEnabled = value;
                                });
                                _saveTtsState();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('FPS: $_fps'),
          ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Align(
                    alignment: message['isUser']
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      decoration: BoxDecoration(
                        color: message['isUser'] ? Colors.blue : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        message['text'],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _isListening
                      ? _animationController
                      : const AlwaysStoppedAnimation(1.0),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: FloatingActionButton(
                      onPressed: _listen,
                      backgroundColor: const Color.fromARGB(
                          255, 182, 245, 255), // Pastel color
                      elevation: 10.0,
                      highlightElevation: 15.0,
                      tooltip: 'Hold to speak',
                      child: Icon(
                        _isListening ? Icons.stop : Icons.mic,
                        size: 40, // Increase the size of the icon
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
