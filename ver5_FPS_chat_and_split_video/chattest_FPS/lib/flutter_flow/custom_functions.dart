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

class VideoConstants {
  static const Map<String, String> _hmongVideos = {
    'cur jông saz tau ntshwz caox': 'rat_vui_duoc_gap_ban',
    'hnuz nor six ntux jông lê chăngl xưz': 'hom_nay_thoi_tiet_the_nao',
    'caox tshaiz plăngz tsư tshaiz': 'ban_co_doi_khong',
    'caox xăngr naox đăngz tsư': 'ban_thich_an_gi',
    'ua tsâuk': 'cam_on',
    'caox ua tul dex nuv đăngz tsư': 'ban_lam_nghe_gi',
    'caox xăngr cươv lus txươr têz chươl tsi xăngr': 'ban_thich_hoc_tieng_anh_khong',
    'cur nqeg dex': 'toi_khat',
    'cur las iz zăngv thab': 'toi_cung_the',

  };

  static const Map<String, String> _vietnameseVideos = {
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

  static const Map<String, String> _englishVideos = {
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

  static final List<String> _normalizedWordList = [
    ..._vietnameseVideos.keys,
    ..._englishVideos.keys,
    ..._hmongVideos.keys,
  ].map((text) => text
      .toLowerCase()
      .replaceAll("'", "'")
      .replaceAll("'", "'")
      .replaceAll("`", "'")).toList();
}

String textContained(String inputString) {
  /// Normalize input string for comparison
  String normalizedInput = inputString
      .toLowerCase()
      .replaceAll("'", "'")
      .replaceAll("'", "'")
      .replaceAll("`", "'");
  
  print('Normalized input: $normalizedInput');

  /// Check if any word in the list is contained in the input string
  for (String word in VideoConstants._normalizedWordList) {
    print('Checking word: $word');
    if (normalizedInput.contains(word)) {
      print('Found match: $word');
      // Tìm key tương ứng trong các map videos
      if (VideoConstants._hmongVideos.containsKey(word)) {
        return word;
      } else if (VideoConstants._vietnameseVideos.containsKey(word)) {
        return word;
      } else if (VideoConstants._englishVideos.containsKey(word)) {
        return word;
      }
    }
  }

  return '...';
}

String getRelativeVideo(String videoName) {
  print('Video name: $videoName');
  if (VideoConstants._hmongVideos.containsKey(videoName)) {
    print('Found in hmongVideos: assets/SLR_video/vietnamese/${VideoConstants._hmongVideos[videoName]}.gif');
    return 'assets/SLR_video/vietnamese/${VideoConstants._hmongVideos[videoName]}.gif';
  } else if (VideoConstants._vietnameseVideos.containsKey(videoName)) {
    print('Found in vietnameseVideos: assets/SLR_video/vietnamese/${VideoConstants._vietnameseVideos[videoName]}.gif');
    return 'assets/SLR_video/vietnamese/${VideoConstants._vietnameseVideos[videoName]}.gif';
  } else if (VideoConstants._englishVideos.containsKey(videoName)) {
    print('Found in englishVideos: assets/SLR_video/english/${VideoConstants._englishVideos[videoName]}.gif');
    return 'assets/SLR_video/english/${VideoConstants._englishVideos[videoName]}.gif';
  } else {
    throw ArgumentError('Video name not found');
  }
}
