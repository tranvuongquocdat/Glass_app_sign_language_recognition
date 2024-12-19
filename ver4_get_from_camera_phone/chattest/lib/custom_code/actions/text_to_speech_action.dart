// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_tts/flutter_tts.dart'; // Import FlutterTTS package

Future<void> textToSpeechAction(
  String inputString,
  bool vietnameseEnable,
) async {
  final FlutterTts flutterTts = FlutterTts();

  try {
    if (vietnameseEnable) {
      // Speak in Vietnamese
      await flutterTts.setLanguage("vi-VN");
    } else {
      // Speak in English
      await flutterTts.setLanguage("en-US");
    }

    // Configure additional TTS settings (optional)
    await flutterTts.setPitch(1.0); // Adjust pitch if needed
    await flutterTts.setSpeechRate(0.5); // Adjust speech rate if needed

    // Speak the text
    await flutterTts.speak(inputString);
  } catch (e) {
    // Handle errors gracefully
    debugPrint('Error in TTS: $e');
  } finally {
    // Cleanup or finalize if necessary
    await flutterTts.stop();
  }
}
