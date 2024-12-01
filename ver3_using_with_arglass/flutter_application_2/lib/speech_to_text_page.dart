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

  // Video map
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


  // Language selection
  final List<String> _languages = ['English', 'Vietnamese'];
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
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
        if (_videoController.value.position == _videoController.value.duration) {
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

        String localeId = _selectedLanguage == 'English' ? 'en-US' : 'vi-VN';

        _speech.listen(
          localeId: localeId,
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
            HapticFeedback.lightImpact();
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<String>(
                value: _selectedLanguage,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue!;
                  });
                },
                items: _languages.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _isPlayingVideo && _videoController.value.isInitialized
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
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
                  ],
                ),
              ),
            ),
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
                            255, 182, 245, 255),
                        elevation: 10.0,
                        highlightElevation: 15.0,
                        tooltip: 'Hold to speak',
                        child: Icon(
                          _isListening ? Icons.stop : Icons.mic,
                          size: 40,
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
