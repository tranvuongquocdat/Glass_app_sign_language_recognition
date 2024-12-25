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

String getRelativeVideo(String videoName) {
  // Danh sách các từ điển quy định tên file tương ứng
  const Map<String, String> vietnameseVideos = {
    'bác sĩ': 'bac_si',
    'bạn bao nhiêu tuổi': 'ban_bao_nhieu_tuoi',
    'bạn khỏe không': 'ban_khoe_khong',
    'bạn làm nghề gì': 'ban_lam_nghe_gi',
    'bạn thích ăn gì': 'ban_thich_an_gi',
    'bánh mì': 'banh_mi',
    'bún': 'bun',
    'cảm ơn': 'cam_on',
    'cô giáo': 'co_giao',
    'công nhân': 'cong_nhan',
    'rất vui được gặp bạn': 'rat_vui_duoc_gap_ban',
    'tạm biệt': 'tam_biet',
    'tôi khát': 'toi_khat',
    'tôi khỏe': 'toi_khoe',
    'tôi mệt': 'toi_met',
    'xin chào': 'xin_chao',
    'xin lỗi': 'xin_loi',
    'bạn có thích toán không': 'ban_co_thich_toan_khong',
    'bạn tên gì': 'ban_ten_gi',
    'bạn thích uống gì': 'ban_thich_uong_gi',
    'hôm nay thời tiết thế nào': 'hom_nay_thoi_tiet_the_nao',
    'tôi ăn cơm': 'toi_an_com'
  };

  const Map<String, String> englishVideos = {
    'bread': 'bread',
    'cereals': 'cereals',
    'french fried': 'french_fried',
    'goodbye': 'goodbye',
    'hello': 'hello',
    'how are you': 'how_are_you',
    'how old are you': 'how_old_are_you',
    'hungry': 'hungry',
    'i am fine': 'i_am_fine',
    'nice to meet you': 'nice_to_meet_you',
    'sleepy': 'sleepy',
    'sorry': 'sorry',
    'student': 'student',
    'teacher': 'teacher',
    'thank you': 'thank_you',
    'thirsty': 'thirsty',
    'tired': 'tired',
    'what do you like to eat': 'what_do_you_like_to_eat',
    'what do you work': 'what_do_you_work',
    'what is your name': 'what_is_your_name',
    "let's eat out": 'lets_eat_out',
    'do you like study': 'do_you_like_study',
    'mee too': 'mee_too',
    'you must try the bread that my mom cooks': 'you_must_try_the_bread_that_my_mom_cooks',
    'do you like math': 'do_you_like_math',
    'i like music': 'i_like_music',
    'it is a way to express feeling': 'it_is_a_way_to_express_feeling',
    'let me take it for you': 'let_me_take_it_for_you',
    'what do you want to drink': 'what_do_you_want_to_drink',
    'what is weather like today': 'what_is_weather_like_today'
  };

  if (vietnameseVideos.containsKey(videoName)) {
    return 'assets/SLR_video/vietnamese/${vietnameseVideos[videoName]}.gif';
  } else if (englishVideos.containsKey(videoName)) {
    return 'assets/SLR_video/english/${englishVideos[videoName]}.gif';
  } else {
    throw ArgumentError('Video name not found');
  }
}
