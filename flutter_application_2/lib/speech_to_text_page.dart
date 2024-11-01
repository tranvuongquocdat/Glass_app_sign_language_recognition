import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

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
    _speech = stt.SpeechToText();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Slow down the animation
      lowerBound: 0.7,
      upperBound: 1.05,
    );
    _initializeSpeech();
  }

  void _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );

    if (available) {
      List<stt.LocaleName> locales = await _speech.locales();
      for (var locale in locales) {
        print('Supported language: ${locale.localeId}');
      }
    } else {
      print('Speech recognition not available');
    }
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

  @override
  void dispose() {
    _animationController.dispose();
    _videoController.dispose();
    super.dispose();
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
          'Speech to Text',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 10,
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                _isPlayingVideo && _videoController.value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context)
                              .size
                              .width, // 1:1 aspect ratio
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _videoController.value.size.width,
                              height: _videoController.value.size.height,
                              child: VideoPlayer(_videoController),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                const SizedBox(height: 16),
                Text(
                  _text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25.0,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Press the button and start speaking',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 145, 144, 144)),
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
          ),
        ),
      ),
    );
  }
}
