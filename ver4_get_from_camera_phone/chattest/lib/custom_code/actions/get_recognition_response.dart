// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getRecognitionResponse(
  List<String> fileBase64List,
  bool isVietnamese,
  String serverIP,
) async {
  // fix current code
  try {
    // Check if fileBase64List is empty
    if (fileBase64List.isEmpty) {
      return "Error: No files provided.";
    }

    // Prepare request data
    Map<String, dynamic> requestData = {
      "videos": fileBase64List,
      "isVietnamese": isVietnamese
    };

    // Construct the API URL
    String apiUrl = "http://$serverIP:8000/process_video/";

    // Send the POST request
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestData),
    );

    // Check response status
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "Error: ${response.statusCode} - ${response.reasonPhrase}";
    }
  } catch (e) {
    return "Error: $e";
  }
}
