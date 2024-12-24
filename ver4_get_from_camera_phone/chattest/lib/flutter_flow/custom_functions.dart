import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

String textContained(String inputString) {
  /// Normalize input string and word list for comparison
  String normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll("’", "'")
        .replaceAll("‘", "'")
        .replaceAll("`", "'");
  }

  /// List of words/phrases to check
  List<String> wordList = [
    'bread',
    'cereals',
    'french fried',
    'goodbye',
    'hello',
    'how are you',
    'how old are you',
    'hungry',
    'i am fine',
    'nice to meet you',
    'sleepy',
    'sorry',
    'student',
    'teacher',
    'thank you',
    'thirsty',
    'tired',
    'what do you like to eat',
    'what do you work',
    'what is your name',
    'bác sĩ',
    'bạn bao nhiêu tuổi',
    'bạn khỏe không',
    'bạn làm nghề gì',
    'bạn thích ăn gì',
    'bánh mì',
    'bún',
    'cảm ơn',
    'cô giáo',
    'công nhân',
    'rất vui được gặp bạn',
    'tạm biệt',
    'tôi khát',
    'tôi khỏe',
    'tôi mệt',
    'xin chào',
    'xin lỗi',
    'do you like study',
    "let's eat out", // Chuyển thành dạng chuẩn
    'mee too',
    'you must try the bread that my mom cooks',
    'bạn thích học không',
    'đồng ý',
    'tôi cũng thế',
    'do you like math',
    'i like music',
    'it is a way to express feeling',
    'let me take it for you',
    'what do you want to drink',
    'what is weather like today',
    'bạn có thích toán không',
    'bạn tên gì',
    'bạn thích uống gì',
    'hôm nay thời tiết thế nào'
  ].map(normalize).toList();

  /// Normalize the input string
  String normalizedInput = normalize(inputString);

  /// Check if any word in the list is contained in the input string
  for (String word in wordList) {
    if (normalizedInput.contains(word)) {
      return word;
    }
  }

  /// Return "..." if no word is found
  return '...';
}
