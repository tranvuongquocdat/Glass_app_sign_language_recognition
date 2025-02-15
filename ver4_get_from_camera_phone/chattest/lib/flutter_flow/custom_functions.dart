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
  'bác sĩ',
  'bạn bao nhiêu tuổi',
  'bạn có đói không',
  'bạn có nuôi con gì không',
  'bạn có thích toán không',
  'bạn làm nghề gì',
  'bạn khỏe không',
  'bạn thích ăn gì',
  'bạn thích học không',
  'bạn thích học tiếng anh không',
  'bạn thích uống gì',
  'bánh mì',
  'bún',
  'cảm ơn',
  'cô giáo',
  'công nhân',
  'hôm nay thời tiết thế nào',
  'nó có màu gì',
  'đồng ý',
  'rất vui được gặp bạn',
  'tạm biệt',
  'tôi cũng thế',
  'tôi cũng thích chó',
  'tôi khát',
  'tôi khỏe',
  'tôi mệt',
  'xin chào',
  'xin lỗi',
  'are you hungry',
  'do you have any pets',
  'do you like english',
  'do you like study',
  'goodbye',
  'hello',
  'how are you',
  'how old are you',
  'i am fine',
  'i like dog',
  'i like music',
  'it is a way to express feeling',
  'let me take it for you',
  'mee too',
  'nice to meet you',
  'sleepy',
  'sorry',
  'student',
  'teacher',
  'me too',
  'thank you',
  'thirsty',
  'tired',
  'what do you like to eat',
  'what color is it',
  'what do you want to drink',
  'what do you work',
  'what is the weather like today',
  'do you have any pets',
  'you must try the bread that my mom cooks'
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
  'bạn có đói không': 'ban_co_doi_khong',
  'bạn có nuôi con gì không': 'ban_co_nuoi_con_gi_khong',
  'bạn có thích toán không': 'ban_co_thich_toan_khong',
  'bạn khỏe không': 'ban_khoe_khong',
  'bạn làm nghề gì': 'ban_lam_nghe_gi',
  'bạn tên gì': 'ban_ten_gi',
  'bạn thích ăn gì': 'ban_thich_an_gi',
  'bạn thích học không': 'ban_thich_hoc_khong',
  'bạn thích học tiếng anh không': 'ban_thich_hoc_tieng_anh_khong',
  'bạn thích uống gì': 'ban_thich_uong_gi',
  'bánh mì': 'banh_mi',
  'bún': 'bun',
  'cảm ơn': 'cam_on',
  'cô giáo': 'co_giao',
  'công nhân': 'cong_nhan',
  'hôm nay thời tiết thế nào': 'hom_nay_thoi_tiet_the_nao',
  'nó có màu gì': 'no_co_mau_gi',
  'đồng ý': 'dong_y',
  'rất vui được gặp bạn': 'rat_vui_duoc_gap_ban',
  'tạm biệt': 'tam_biet',
  'tôi cũng thế': 'toi_cung_the',
  'tôi cũng thích chó': 'toi_cung_thich_cho',
  'tôi khát': 'toi_khat',
  'tôi khỏe': 'toi_khoe',
  'tôi mệt': 'toi_met',
  'xin chào': 'xin_chao',
  'xin lỗi': 'xin_loi',
};


 const Map<String, String> englishVideos = {
  'are you hungry': 'are_you_hungry',
  'cereals': 'cereals',
  'do you have any pets': 'do_you_have_any_pets',
  'do you like english': 'do_you_like_english',
  'do you like study': 'do_you_like_study',
  'french fried': 'french_fried',
  'goodbye': 'goodbye',
  'hello': 'hello',
  'how are you': 'how_are_you',
  'how old are you': 'how_old_are_you',
  'i am fine': 'i_am_fine',
  'i like dog': 'i_like_dogs_too',
  'i like music': 'i_like_music',
  'it is a way to express feeling': 'it_is_a_way_to_express_feeling',
  'let me take it for you': 'let_me_take_it_for_you',
  "let's eat out": 'lets_eat_out',
  'me too': 'me_too',
  'nice to meet you': 'nice_to_meet_you',
  'sleepy': 'sleepy',
  'sorry': 'sorry',
  'student': 'student',
  'teacher': 'teacher',
  'thank you': 'thank_you',
  'thirsty': 'thirsty',
  'tired': 'tired',
  'what do you like to eat': 'what_do_you_like_to_eat',
  'what color is it': 'what_color_is_it',
  'what do you want to drink': 'what_do_you_want_to_drink',
  'what do you work': 'what_do_you_work',
  'what is the weather like today': 'what_is_the_weather_like_today',
  'what is your name': 'what_is_your_name',
  'you must try the bread that my mom cooks': 'you_must_try_the_bread_that_my_mom_cooks',
};


  if (vietnameseVideos.containsKey(videoName)) {
    return 'assets/SLR_video/vietnamese/${vietnameseVideos[videoName]}.gif';
  } else if (englishVideos.containsKey(videoName)) {
    return 'assets/SLR_video/english/${englishVideos[videoName]}.gif';
  } else {
    throw ArgumentError('Video name not found');
  }
}
