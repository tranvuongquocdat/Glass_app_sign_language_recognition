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

final FlutterTts flutterTts = FlutterTts(); // Global reusable instance

Future<void> textToSpeechAction(
  String inputString,
  bool vietnameseEnable,
) async {
  // Check if input string is valid
  if (inputString == null || inputString.trim().isEmpty) {
    debugPrint('Input string is empty or null. Skipping TTS.');
    return;
  }

  try {
    // Determine the language to set
    String targetLanguage = vietnameseEnable ? "vi-VN" : "en-US";

    // Set language directly
    await flutterTts.setLanguage(targetLanguage);

    // Configure additional TTS settings
    await flutterTts.setPitch(1.0); // Default pitch
    await flutterTts.setSpeechRate(0.5); // Default speech rate

    // Speak the input string
    await flutterTts.speak(inputString);
    debugPrint('TTS is speaking: $inputString');
  } catch (e) {
    // Handle any errors gracefully
    debugPrint('Error in TTS: $e');
  }
}
