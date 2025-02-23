// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechWidget extends StatefulWidget {
  const TextToSpeechWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _TextToSpeechWidgetState createState() => _TextToSpeechWidgetState();
}

class _TextToSpeechWidgetState extends State<TextToSpeechWidget> {
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  void _initializeTts() {
    _flutterTts.setStartHandler(() {
      debugPrint("TTS playback started");
    });

    _flutterTts.setCompletionHandler(() {
      debugPrint("TTS playback completed");
    });

    _flutterTts.setErrorHandler((msg) {
      debugPrint("TTS error: $msg");
    });
  }

  Future<void> _speak(String text) async {
    String language = FFAppState().vietnameseEnable ? "vi-VN" : "en-US";
    await _flutterTts.setLanguage(language);
    await _flutterTts.setPitch(1.0); // Adjust pitch as needed
    await _flutterTts.setSpeechRate(0.5); // Adjust speed as needed

    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  @override
  void didUpdateWidget(covariant TextToSpeechWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (FFAppState().makeSpeech) {
      _speak(FFAppState().textToSpeechInput).then((_) {
        FFAppState().update(() {
          FFAppState().makeSpeech = false;
        });
      }).catchError((error) {
        debugPrint("TTS error: $error");
      });
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      alignment: Alignment.center,
      child: Text(
        "Text-to-Speech Ready",
        style: FlutterFlowTheme.of(context).bodyText1,
      ),
    );
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
