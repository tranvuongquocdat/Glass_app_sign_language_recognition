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

  const ChatScreen({super.key, required this.ip});

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
  String _selectedLanguage = "VI"; // Default language is Vietnamese
  String last_recognized_text=""; // Default

  // Speech to Text Variables
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  late AnimationController _animationController;
  VideoPlayerController? _videoController;
  bool _isPlayingVideo = false;
  String? _currentVideoPath;

  // Video map for English and Vietnamese phrases
final Map<String, String> _videoMap = {
  // English Sentences
  'bread': 'assets/english_sentences/bread.mp4',
  'cereals': 'assets/english_sentences/cereals.mp4',
  'french fried': 'assets/english_sentences/french_fried.mp4',
  'goodbye': 'assets/english_sentences/goodbye.mp4',
  'hello': 'assets/english_sentences/hello.mp4',
  'how are you': 'assets/english_sentences/how_are_you.mp4',
  'how old are you': 'assets/english_sentences/how_old_are_you.mp4',
  'hungry': 'assets/english_sentences/hungry.mp4',
  'i am fine': 'assets/english_sentences/i_am_fine.mp4',
  'nice to meet you': 'assets/english_sentences/nice_to_meet_you.mp4',
  'sleepy': 'assets/english_sentences/sleepy.mp4',
  'sorry': 'assets/english_sentences/sorry.mp4',
  'student': 'assets/english_sentences/student.mp4',
  'teacher': 'assets/english_sentences/teacher.mp4',
  'thank you': 'assets/english_sentences/thankyou.mp4',
  'thirsty': 'assets/english_sentences/thirsty.mp4',
  'tired': 'assets/english_sentences/tired.mp4',
  'what do you like to eat': 'assets/english_sentences/what_do_you_like_to_eat.mp4',
  'what do you work': 'assets/english_sentences/what_do_you_work.mp4',
  'what is your name': 'assets/english_sentences/what_is_your_name.mp4',

  // Vietnamese Sentences
  'bác sĩ': 'assets/vietnamese_sentences/bac_si.mp4',
  'bạn bao nhiêu tuổi': 'assets/vietnamese_sentences/ban_bao_nhieu_tuoi.mp4',
  'bạn khỏe không': 'assets/vietnamese_sentences/ban_khoe_khong.mp4',
  'bạn làm nghề gì': 'assets/vietnamese_sentences/ban_lam_nghe_gi.mp4',
  'bạn thích ăn gì': 'assets/vietnamese_sentences/ban_thich_an_gi.mp4',
  'bánh mì': 'assets/vietnamese_sentences/banh_mi.mp4',
  'bún': 'assets/vietnamese_sentences/bun.mp4',
  'cảm ơn': 'assets/vietnamese_sentences/cam_on.mp4',
  'cô giáo': 'assets/vietnamese_sentences/co_giao.mp4',
  'công nhân': 'assets/vietnamese_sentences/cong_nhan.mp4',
  'rất vui được gặp bạn': 'assets/vietnamese_sentences/rat_vui_duoc_gap_ban.mp4',
  'tạm biệt': 'assets/vietnamese_sentences/tam_biet.mp4',
  'tôi khát': 'assets/vietnamese_sentences/toi_khat.mp4',
  'tôi khỏe': 'assets/vietnamese_sentences/toi_khoe.mp4',
  'tôi mệt': 'assets/vietnamese_sentences/toi_met.mp4',
  'xin chào': 'assets/vietnamese_sentences/xin_chao.mp4',
  'xin lỗi': 'assets/vietnamese_sentences/xin_loi.mp4',
};


@override
void initState() {
  super.initState();
  _connectToServer();
  _initializeSpeech();
  _loadTtsState();
  _loadLanguageSelection(); // Load saved language
  _setTtsLanguage(); // Set TTS language based on selection
}

void _setTtsLanguage() {
  if (_selectedLanguage == "VI") {
    _flutterTts.setLanguage("vi-VN"); // Vietnamese language
  } else if (_selectedLanguage == "EN") {
    _flutterTts.setLanguage("en-US"); // English language
  }
}

  Future<void> _loadLanguageSelection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? "VI";
    });
  }

  Future<void> _saveLanguageSelection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedLanguage', _selectedLanguage);
  }

  void _sendLanguageSelection() {
    if (_socket != null) {
      _socket.write(_selectedLanguage); // Send selected language to server
    }
  }

  Future<void> _connectToServer() async {
    try {
      _socket = await Socket.connect(widget.ip, 8001);
      _sendLanguageSelection(); // Send language selection on connect
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
    if (_messages.isEmpty || (_messages.last['isUser'] != isUser || _messages.last['text'] != text)) {
      _messages.add({
        'text': text,
        'isUser': isUser,
      });
      if (_isTtsEnabled){
      _speak(text);
      }
    }

    if (_isTtsEnabled && !isUser) {
      if (text.isEmpty && last_recognized_text.length > 5) {
        _speak(last_recognized_text);
      };
      last_recognized_text = text;
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
      duration: const Duration(seconds: 1),
      lowerBound: 0.7,
      upperBound: 1.05,
    );
  }

  Future<void> _initializeVideoPlayer(String videoPath) async {
    _videoController?.dispose();
    _videoController = VideoPlayerController.asset(videoPath);
    try {
      await _videoController!.initialize();
      _videoController!.addListener(() {
        if (_videoController!.value.position == _videoController!.value.duration) {
          setState(() {
            _isPlayingVideo = false;
            _videoController!.pause();
            _videoController!.seekTo(Duration.zero);
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

      // Set localeId based on the selected language
      String localeId = _selectedLanguage == 'EN' ? 'en-US' : 'vi-VN';

      _speech.listen(
        localeId: localeId,
        onResult: (val) {
          setState(() {
            // Update _text with interim results, but do not process them
            _text = val.recognizedWords.toLowerCase();
          });
        },
        listenMode: stt.ListenMode.confirmation,
      );
    } else {
      setState(() {
        _isListening = false;
        _animationController.stop();
      });
    }
  } else {
    // Stop listening and process the final result
    setState(() {
      _isListening = false;
      _animationController.stop();
    });

    _speech.stop();

    if (_text.isNotEmpty) {
      bool videoPlayed = false;

      // Match phrase in _videoMap
      _videoMap.forEach((phrase, videoPath) {
        if (_text.contains(phrase)) {
          _playVideo(videoPath);
          videoPlayed = true;
          _addMessage(_text, true);
        }
      });

      // If no video is played, add the speech input as a user message
      if (!videoPlayed) {
        _addMessage(_text, true); // Add recognized phrase as a user message
      }

      // Clear recognized text
      setState(() {
        _text = '';
      });
    }
  }
}

  void _playVideo(String videoPath) {
    setState(() {
      _isPlayingVideo = true;
      _currentVideoPath = videoPath;
    });
    _initializeVideoPlayer(videoPath).then((_) {
      if (_videoController != null && !_videoController!.value.isPlaying) {
        _videoController!.play();
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
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SPECS Chatbox',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Settings'),
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                const Expanded(child: Text('Enable Text-to-Speech')),
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
                            ),
                            Row(
                              children: [
                                const Expanded(child: Text('Select Language')),
                                DropdownButton<String>(
                                  value: _selectedLanguage,
                                  items: const [
                                    DropdownMenuItem(value: "EN", child: Text("English")),
                                    DropdownMenuItem(value: "VI", child: Text("Vietnamese")),
                                  ],
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedLanguage = value!;
                                    });
                                    _saveLanguageSelection();
                                    _sendLanguageSelection();
                                  },
                                ),
                              ],
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
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
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
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['isUser'];
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message['text'],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isPlayingVideo && _videoController != null)
            Container(
              padding: const EdgeInsets.all(8.0),
              height: 200,
              child: AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
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
                  child: FloatingActionButton(
                    onPressed: _listen,
                    backgroundColor: const Color.fromARGB(255, 34, 219, 213),
                    child: Icon(
                      _isListening ? Icons.stop : Icons.mic,
                      size: 30,
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
