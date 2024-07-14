import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech to Text Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SpeechToTextPage(),
    );
  }
}

class SpeechToTextPage extends StatefulWidget {
  const SpeechToTextPage({super.key});

  @override
  _SpeechToTextPageState createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Slow down the animation
      lowerBound: 0.7,
      upperBound: 1.05,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _listen() async {
    HapticFeedback.mediumImpact();
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() {
          _isListening = true;
          _animationController.repeat(reverse: true);
        });
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: TextEditingController(text: _text),
                readOnly: true,
                maxLines: null,
                style: const TextStyle(fontSize: 24.0),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Recognized text will appear here',
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Press the button and start speaking',
                    style: TextStyle(fontSize: 16.0, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
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
                            255, 182, 245, 255), // Pastel pink color
                        elevation: 10.0,
                        highlightElevation: 15.0,
                        tooltip: 'Hold to speak',
                        child: Icon(
                          _isListening ? Icons.mic_off : Icons.mic,
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
      ),
    );
  }
}
