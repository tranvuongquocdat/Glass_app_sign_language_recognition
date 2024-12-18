// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:speech_to_text/speech_to_text.dart'; // Import thư viện Speech to Text

class SpeechToTextWidget extends StatefulWidget {
  const SpeechToTextWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _SpeechToTextWidgetState createState() => _SpeechToTextWidgetState();
}

class _SpeechToTextWidgetState extends State<SpeechToTextWidget>
    with SingleTickerProviderStateMixin {
  final SpeechToText _speechToText = SpeechToText();
  late AnimationController _animationController;
  bool _isSpeechAvailable = false;

  @override
  void initState() {
    super.initState();
    _initializeSpeechRecognition();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      lowerBound: 0.9,
      upperBound: 1.1,
    )..repeat(reverse: true); // Loop animation
  }

  Future<void> _initializeSpeechRecognition() async {
    bool available = await _speechToText.initialize(
      onStatus: (status) {
        if (status == "notListening" && FFAppState().isRecording) {
          FFAppState().update(() {
            FFAppState().isRecording = false;
          });
        }
      },
      onError: (error) {
        print("Speech recognition error: $error");
      },
    );

    setState(() {
      _isSpeechAvailable = available;
    });
  }

  void _toggleListening() {
    if (FFAppState().isRecording) {
      if (_isSpeechAvailable && !_speechToText.isListening) {
        _speechToText.listen(
          localeId: FFAppState().vietnameseEnable ? 'vi_VN' : 'en_US',
          onResult: (result) {
            FFAppState().update(() {
              FFAppState().speechToTextOutput = result.recognizedWords;
            });
          },
        );
      }
    } else {
      if (_speechToText.isListening) {
        _speechToText.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // React to changes in isRecording
    _toggleListening();

    return Center(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: FFAppState().isRecording ? _animationController.value : 1.0,
            child: Icon(
              FFAppState().isRecording ? Icons.stop : Icons.mic,
              size: 0.1,
              color: FlutterFlowTheme.of(context).primaryColor,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _speechToText.stop();
    _animationController.dispose();
    super.dispose();
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
