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
    'xin lỗi'
  ];

  /// Check if any word in the list is contained in the input string
  for (String word in wordList) {
    if (inputString.contains(word)) {
      return word;
    }
  }

  /// Return "..." if no word is found
  return '...';
}
