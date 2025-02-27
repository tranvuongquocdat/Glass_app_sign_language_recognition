import 'dart:convert';
import 'dart:math' as math;
import 'package:ffmpeg_kit_flutter/return_code.dart';

import '/backend/gemini/gemini.dart';
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
import 'package:video_player/video_player.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'dart:io'; // Added for File operations
import 'package:path_provider/path_provider.dart';

class VideoConstants {
  static const Map<String, String> wordSegments = 
  {
    "bẩn": "assets/SLR_video_segment/baanr.mp4",
    "áo": "assets/SLR_video_segment/ao.mp4",
    "bắc cực": "assets/SLR_video_segment/bac_cuc.mp4",
    "bạn bè": "assets/SLR_video_segment/ban_be.mp4",
    "buổi chiều": "assets/SLR_video_segment/buoi_chieu.mp4",
    "bãi xe ô tô": "assets/SLR_video_segment/bai_do_xe_o_to.mp4",
    "bến xe": "assets/SLR_video_segment/ben_xe.mp4",
    "bệnh": "assets/SLR_video_segment/benh.mp4",
    "bắn": "assets/SLR_video_segment/bawns.mp4",
    "ảo thuật": "assets/SLR_video_segment/ao_thuat.mp4",
    "áo khoác": "assets/SLR_video_segment/ao_khoac.mp4",
    "ảnh hưởng": "assets/SLR_video_segment/anh_huong.mp4",
    "bãi đỗ xe oto": "assets/SLR_video_segment/bai_do_xe_o_to.mp4",
    "balo": "assets/SLR_video_segment/balo.mp4",
    "bàn tay": "assets/SLR_video_segment/ban_tay.mp4",
    "bạn thân": "assets/SLR_video_segment/ban_than.mp4",
    "bàn": "assets/SLR_video_segment/banf.mp4",
    "băng bó": "assets/SLR_video_segment/bang_bo.mp4",
    "bảo vệ": "assets/SLR_video_segment/bao_ve.mp4",
    "bầu trời": "assets/SLR_video_segment/bau_troi.mp4",
    "bẻ cành": "assets/SLR_video_segment/be_canh.mp4",
    "bình hoa": "assets/SLR_video_segment/binh_hoa.mp4",
    "bố": "assets/SLR_video_segment/bo.mp4",
    "bó đũa": "assets/SLR_video_segment/bo_dua.mp4",
    "bó hoa": "assets/SLR_video_segment/bo_hoa.mp4",
    "bớt": "assets/SLR_video_segment/bot.mp4",
    "bừa bộn": "assets/SLR_video_segment/bua_bon.mp4",
    "bức tranh": "assets/SLR_video_segment/buc_tranh.mp4",
    "buổi sáng": "assets/SLR_video_segment/buoi_sang.mp4",
    "buồn": "assets/SLR_video_segment/buoofn.mp4",
    "bút": "assets/SLR_video_segment/but.mp4",
    "bưu điện": "assets/SLR_video_segment/buu_dien.mp4",
    "cà phê": "assets/SLR_video_segment/ca_phe.mp4",
    "cá sấu": "assets/SLR_video_segment/ca_sau.mp4",
    "ca sĩ": "assets/SLR_video_segment/ca_si.mp4",
    "cá voi": "assets/SLR_video_segment/ca_voi.mp4",
    "cấm": "assets/SLR_video_segment/caasm.mp4",
    "cái bát": "assets/SLR_video_segment/cai_bat.mp4",
    "cái chăn": "assets/SLR_video_segment/cai_chawn.mp4",
    "cái chuông": "assets/SLR_video_segment/cai_chuong.mp4",
    "cái gối": "assets/SLR_video_segment/cai_goi.mp4",
    "cái hang": "assets/SLR_video_segment/cai_hang.mp4",
    "cái quạt cây": "assets/SLR_video_segment/cai_quat_cay.mp4",
    "cảm động": "assets/SLR_video_segment/cam_dong.mp4",
    "cảm ơn": "assets/SLR_video_segment/cam_on.mp4",
    "cần cù": "assets/SLR_video_segment/can_cu.mp4",
    "cẩn thận": "assets/SLR_video_segment/can_than.mp4",
    "cạnh tranh": "assets/SLR_video_segment/canh_tranh.mp4",
    "cạnh": "assets/SLR_video_segment/canhj.mp4",
    "cano": "assets/SLR_video_segment/cano.mp4",
    "cao": "assets/SLR_video_segment/cao.mp4",
    "cặp sách": "assets/SLR_video_segment/cap_sach.mp4",
    "cắt": "assets/SLR_video_segment/cat.mp4",
    "câu lạc bộ": "assets/SLR_video_segment/cau_lac_bo.mp4",
    "cấu tạo": "assets/SLR_video_segment/cau_tao.mp4",
    "cầu tre": "assets/SLR_video_segment/cau_tre.mp4",
    "cây bàng": "assets/SLR_video_segment/cay_bang.mp4",
    "cây đu đủ": "assets/SLR_video_segment/cay_du_du.mp4",
    "cây ngô": "assets/SLR_video_segment/cay_ngo.mp4",
    "chân": "assets/SLR_video_segment/chaan.mp4",
    "chải tóc": "assets/SLR_video_segment/chai_toc.mp4",
    "chậm chạp": "assets/SLR_video_segment/cham_chap.mp4",
    "chân dung": "assets/SLR_video_segment/chan_dung.mp4",
    "chào cờ": "assets/SLR_video_segment/chao_co.mp4",
    "cháo": "assets/SLR_video_segment/chaos.mp4",
    "chậu": "assets/SLR_video_segment/chau.mp4",
    "châu lục": "assets/SLR_video_segment/chau_luc.mp4",
    "chạy": "assets/SLR_video_segment/chayj.mp4",
    "chèo thuyền": "assets/SLR_video_segment/cheo_thuyen.mp4",
    "chia phần": "assets/SLR_video_segment/chia_phan.mp4",
    "chia sẻ": "assets/SLR_video_segment/chia_se.mp4",
    "chiến tranh": "assets/SLR_video_segment/chien_tranh.mp4",
    "chiều dài": "assets/SLR_video_segment/chieu_dai.mp4",
    "chim chào mào": "assets/SLR_video_segment/chim_chao_mao.mp4",
    "chim đại bàng": "assets/SLR_video_segment/chim_dai_bang.mp4",
    "chim sẻ": "assets/SLR_video_segment/chim_ser.mp4",
    "chùm nho": "assets/SLR_video_segment/chumf_nho.mp4",
    "chung cư": "assets/SLR_video_segment/chung_cw.mp4",
    "chủ đề": "assets/SLR_video_segment/chur_ddeef.mp4",
    "chú hề": "assets/SLR_video_segment/chus_heef.mp4",
    "chuyển về": "assets/SLR_video_segment/chuyeenr_veef.mp4",
    "có ích": "assets/SLR_video_segment/co_ich.mp4",
    "con bê": "assets/SLR_video_segment/con_bee.mp4",
    "con bò": "assets/SLR_video_segment/con_bof.mp4",
    "con chim": "assets/SLR_video_segment/con_chim.mp4",
    "con chó": "assets/SLR_video_segment/con_cho.mp4",
    "con cua đồng": "assets/SLR_video_segment/con_cua_dong.mp4",
    "con gà": "assets/SLR_video_segment/con_ga.mp4",
    "con gái": "assets/SLR_video_segment/con_gai.mp4",
    "con gấu": "assets/SLR_video_segment/con_gau.mp4",
    "con hươu": "assets/SLR_video_segment/con_huou.mp4",
    "con khỉ": "assets/SLR_video_segment/con_khi.mp4",
    "con mèo": "assets/SLR_video_segment/con_meo.mp4",
    "con nai": "assets/SLR_video_segment/con_nai.mp4",
    "con ốc": "assets/SLR_video_segment/con_oc.mp4",
    "con rối cạn": "assets/SLR_video_segment/con_roosi_canj.mp4",
    "con rùa": "assets/SLR_video_segment/con_rua.mp4",
    "con sâu": "assets/SLR_video_segment/con_saau.mp4",
    "con sói": "assets/SLR_video_segment/con_sois.mp4",
    "con thỏ": "assets/SLR_video_segment/con_thor.mp4",
    "con vịt": "assets/SLR_video_segment/con_vitj.mp4",
    "công chúa": "assets/SLR_video_segment/cong_chua.mp4",
    "con": "assets/SLR_video_segment/conn.mp4",
    "cô bé": "assets/SLR_video_segment/coo_bes.mp4",
    "cổng": "assets/SLR_video_segment/coongr.mp4",
    "cột": "assets/SLR_video_segment/cootj.mp4",
    "cột cờ": "assets/SLR_video_segment/cootj_cowf.mp4",
    "cơm": "assets/SLR_video_segment/cowm.mp4",
    "củ cà rốt": "assets/SLR_video_segment/cu_ca_rot.mp4",
    "cục tẩy": "assets/SLR_video_segment/cucj_taayr.mp4",
    "cụ già": "assets/SLR_video_segment/cuj_giaf.mp4",
    "cuống lá": "assets/SLR_video_segment/cuoosng_las.mp4",
    "cứu": "assets/SLR_video_segment/cuuws.mp4",
    "cưa": "assets/SLR_video_segment/cwa.mp4",
    "đá bóng": "assets/SLR_video_segment/da_bong.mp4",
    "đàn ghi ta": "assets/SLR_video_segment/dan_ghi_ta.mp4",
    "đánh trống": "assets/SLR_video_segment/danh_trong.mp4",
    "đau bụng": "assets/SLR_video_segment/dau_bung.mp4",
    "dày": "assets/SLR_video_segment/dayf.mp4",
    "đầy": "assets/SLR_video_segment/ddaayf.mp4",
    "đám cưới": "assets/SLR_video_segment/ddasm_cuowsi.mp4",
    "đánh dấu": "assets/SLR_video_segment/ddasnh_daasu.mp4",
    "để": "assets/SLR_video_segment/ddeer.mp4",
    "điểm": "assets/SLR_video_segment/ddiemr.mp4",
    "đoạn văn": "assets/SLR_video_segment/ddoanj_vawn.mp4",
    "đón": "assets/SLR_video_segment/ddons.mp4",
    "đồng bào": "assets/SLR_video_segment/ddoongf_baof.mp4",
    "đồng bằng": "assets/SLR_video_segment/ddoongf_bawfng.mp4",
    "đồng ý": "assets/SLR_video_segment/ddoongf_ys.mp4",
    "đũa": "assets/SLR_video_segment/dduax.mp4",
    "dệt": "assets/SLR_video_segment/deetj.mp4",
    "đèn pin": "assets/SLR_video_segment/den_pin.mp4",
    "đeo kính": "assets/SLR_video_segment/deo_kinh.mp4",
    "đi bộ": "assets/SLR_video_segment/di_bo.mp4",
    "đi vệ sinh": "assets/SLR_video_segment/di_ve_sinh.mp4",
    "diều": "assets/SLR_video_segment/dieeuf.mp4",
    "điện thoại": "assets/SLR_video_segment/dien_thoai.mp4",
    "dịu dàng": "assets/SLR_video_segment/diu_dang.mp4",
    "đồng hồ đeo tay": "assets/SLR_video_segment/dong_ho_deo_tay.mp4",
    "dòng kẻ": "assets/SLR_video_segment/dongf_ker.mp4",
    "dọn dẹp": "assets/SLR_video_segment/donj_depj.mp4",
    "đường thẳng": "assets/SLR_video_segment/duong_thang.mp4",
    "đường tròn": "assets/SLR_video_segment/duong_tron.mp4",
    "đường vuông góc": "assets/SLR_video_segment/duong_vuong_goc.mp4",
    "đứng": "assets/SLR_video_segment/duwsng.mp4",
    "gà mái": "assets/SLR_video_segment/ga_mai.mp4",
    "gà rừng": "assets/SLR_video_segment/ga_rung.mp4",
    "gà trống": "assets/SLR_video_segment/ga_trong.mp4",
    "gần": "assets/SLR_video_segment/gaafn.mp4",
    "găng tay": "assets/SLR_video_segment/gawng_tay.mp4",
    "gặt": "assets/SLR_video_segment/gawtj.mp4",
    "gáy": "assets/SLR_video_segment/gays.mp4",
    "giá trị": "assets/SLR_video_segment/gia_tri.mp4",
    "giá trị tuyệt đối": "assets/SLR_video_segment/gia_tri_tuyet_doi.mp4",
    "già": "assets/SLR_video_segment/giaf.mp4",
    "giao hoán": "assets/SLR_video_segment/giao_hoan.mp4",
    "giấy nháp": "assets/SLR_video_segment/giay_nhap.mp4",
    "giết": "assets/SLR_video_segment/giet.mp4",
    "giới hạn": "assets/SLR_video_segment/gioi_han.mp4",
    "giống nhau": "assets/SLR_video_segment/giong_nhau.mp4",
    "giờ": "assets/SLR_video_segment/giowf.mp4",
    "góc học tập": "assets/SLR_video_segment/goc_hoc_tap.mp4",
    "góc nhọn": "assets/SLR_video_segment/goc_nhon.mp4",
    "gọi": "assets/SLR_video_segment/goij.mp4",
    "gỗ": "assets/SLR_video_segment/goox.mp4",
    "hai chiều": "assets/SLR_video_segment/hai_chieu.mp4",
    "hàm số": "assets/SLR_video_segment/ham_so.mp4",
    "hằng đẳng thức": "assets/SLR_video_segment/hang_dang_thuc.mp4",
    "hạt lúa": "assets/SLR_video_segment/hat_lua.mp4",
    "hạt": "assets/SLR_video_segment/hatj.mp4",
    "hát": "assets/SLR_video_segment/hats.mp4",
    "hẹp": "assets/SLR_video_segment/hep.mp4",
    "hiếm": "assets/SLR_video_segment/hieems.mp4",
    "hiệu": "assets/SLR_video_segment/hieeuj.mp4",
    "hình chiếu": "assets/SLR_video_segment/hinh_chieu.mp4",
    "hình chóp cụt": "assets/SLR_video_segment/hinh_chop_cut.mp4",
    "hình chóp đều": "assets/SLR_video_segment/hinh_chop_deu.mp4",
    "hình chóp tam giác": "assets/SLR_video_segment/hinh_chop_tam_giac.mp4",
    "hình chóp tam giác cụt": "assets/SLR_video_segment/hinh_chop_tam_giac_cut.mp4",
    "hình chóp tứ giác": "assets/SLR_video_segment/hinh_chop_tu_giac.mp4",
    "hình elip": "assets/SLR_video_segment/hinh_elip.mp4",
    "hình thang vuông": "assets/SLR_video_segment/hinh_thang_vuong.mp4",
    "hình vuông": "assets/SLR_video_segment/hinh_vuong.mp4",
    "hình khối": "assets/SLR_video_segment/hinhf_khoois.mp4",
    "hô hấp": "assets/SLR_video_segment/ho_hap.mp4",
    "hồ nước": "assets/SLR_video_segment/ho_nuoc.mp4",
    "hoa": "assets/SLR_video_segment/hoa.mp4",
    "hoa sen": "assets/SLR_video_segment/hoa_sen.mp4",
    "họa sĩ": "assets/SLR_video_segment/hoa_si.mp4",
    "hoán vị": "assets/SLR_video_segment/hoan_vi.mp4",
    "học bài": "assets/SLR_video_segment/hoc_bai.mp4",
    "hú vía": "assets/SLR_video_segment/hu_via.mp4",
    "húc": "assets/SLR_video_segment/hucs.mp4",
    "hướng dẫn": "assets/SLR_video_segment/huong_dan.mp4",
    "hướng dẫn viên": "assets/SLR_video_segment/huong_dan_vien.mp4",
    "hương thơm": "assets/SLR_video_segment/huong_thom.mp4",
    "huýt sáo": "assets/SLR_video_segment/huyt_sao.mp4",
    "hứa": "assets/SLR_video_segment/hwas.mp4",
    "kéo co": "assets/SLR_video_segment/keo_co.mp4",
    "kéo ": "assets/SLR_video_segment/keos.mp4",
    "kết thúc": "assets/SLR_video_segment/ket_thuc.mp4",
    "khách sạn": "assets/SLR_video_segment/khach_san.mp4",
    "khối lượng": "assets/SLR_video_segment/khoi_lương.mp4",
    "khô": "assets/SLR_video_segment/khoo.mp4",
    "khu vườn": "assets/SLR_video_segment/khu_vuon.mp4",
    "khuôn mặt": "assets/SLR_video_segment/khuon_mat.mp4",
    "khuôn vác": "assets/SLR_video_segment/khuon_vac.mp4",
    "kí túc xá": "assets/SLR_video_segment/ki_tuc_xa.mp4",
    "kính trọng": "assets/SLR_video_segment/kinh_trong.mp4",
    "lá sen": "assets/SLR_video_segment/la_sen.mp4",
    "lái xe": "assets/SLR_video_segment/lai_xe.mp4",
    "làm tròn số": "assets/SLR_video_segment/lam_tron_so.mp4",
    "làm việc": "assets/SLR_video_segment/lam_viec.mp4",
    "lăng bác hồ": "assets/SLR_video_segment/lang_bac_ho.mp4",
    "làng": "assets/SLR_video_segment/langf.mp4",
    "lây truyền": "assets/SLR_video_segment/lay_truyen.mp4",
    "lễ phép": "assets/SLR_video_segment/le_phep.mp4",
    "lông chim": "assets/SLR_video_segment/loong_chim.mp4",
    "lũ lụt": "assets/SLR_video_segment/lu_lut.mp4",
    "lửa": "assets/SLR_video_segment/luwar.mp4",
    "lưng": "assets/SLR_video_segment/luwng.mp4",
    "mầm": "assets/SLR_video_segment/maafm.mp4",
    "mây": "assets/SLR_video_segment/maay.mp4",
    "mặc áo": "assets/SLR_video_segment/mac_ao.mp4",
    "mát mẻ": "assets/SLR_video_segment/mat_me.mp4",
    "mặt trái xoan": "assets/SLR_video_segment/mat_trai_xoan.mp4",
    "máy ảnh": "assets/SLR_video_segment/may_anh.mp4",
    "máy bay": "assets/SLR_video_segment/may_bay.mp4",
    "máy cày": "assets/SLR_video_segment/may_cay.mp4",
    "mẹ": "assets/SLR_video_segment/me.mp4",
    "miệng": "assets/SLR_video_segment/mieng.mp4",
    "môi trường": "assets/SLR_video_segment/moi_truong.mp4",
    "môn Tiếng Việt": "assets/SLR_video_segment/mon_tieng_viet.mp4",
    "mỏng": "assets/SLR_video_segment/mongr.mp4",
    "mộ": "assets/SLR_video_segment/mooj.mp4",
    "môn toán": "assets/SLR_video_segment/moon_toans.mp4",
    "một chiều": "assets/SLR_video_segment/mot_chieu.mp4",
    "múa": "assets/SLR_video_segment/muas.mp4",
    "mưa rào": "assets/SLR_video_segment/muaw_raof.mp4",
    "mũi": "assets/SLR_video_segment/muix.mp4",
    "mưa": "assets/SLR_video_segment/muwa.mp4",
    "nằm trong mặt phẳng": "assets/SLR_video_segment/nam_trong_mat_phang.mp4",
    "não": "assets/SLR_video_segment/naox.mp4",
    "nặng": "assets/SLR_video_segment/nawngj.mp4",
    "ngạc nhiên": "assets/SLR_video_segment/ngac_nhien.mp4",
    "ngà voi": "assets/SLR_video_segment/ngaf_voi.mp4",
    "ngắn": "assets/SLR_video_segment/ngawns.mp4",
    "ngày xưa": "assets/SLR_video_segment/ngay_xua.mp4",
    "nghèo": "assets/SLR_video_segment/ngheo.mp4",
    "ngộ độc": "assets/SLR_video_segment/ngo_doc.mp4",
    "ngoan ngoãn": "assets/SLR_video_segment/ngoan_ngoan.mp4",
    "ngoằn ngoèo": "assets/SLR_video_segment/ngoan_ngoeo.mp4",
    "ngon": "assets/SLR_video_segment/ngon.mp4",
    "người gửi": "assets/SLR_video_segment/nguoi_gui.mp4",
    "người nhận": "assets/SLR_video_segment/nguoiwf_nhaanj.mp4",
    "ngư dân": "assets/SLR_video_segment/nguw_daan.mp4",
    "ngửi": "assets/SLR_video_segment/nguwir.mp4",
    "nguy hiểm": "assets/SLR_video_segment/nguy_hiem.mp4",
    "nhà": "assets/SLR_video_segment/nhaf.mp4",
    "nhận xét": "assets/SLR_video_segment/nhan_xet.mp4",
    "nhận lỗi": "assets/SLR_video_segment/nhan_loi.mp4",
    "nhăn mặt": "assets/SLR_video_segment/nhanw_mawtj.mp4",
    "nhặt rau": "assets/SLR_video_segment/nhat_rau.mp4",
    "nhảy dây": "assets/SLR_video_segment/nhay_day.mp4",
    "nhảy xa": "assets/SLR_video_segment/nhayr_xa.mp4",
    "nhìn": "assets/SLR_video_segment/nhinf.mp4",
    "nho": "assets/SLR_video_segment/nho.mp4",
    "no": "assets/SLR_video_segment/no.mp4",
    "nổi giận": "assets/SLR_video_segment/noi_gian.mp4",
    "nói dối": "assets/SLR_video_segment/nois_doosi.mp4",
    "nóng": "assets/SLR_video_segment/nongs.mp4",
    "núi": "assets/SLR_video_segment/nuis.mp4",
    "nước": "assets/SLR_video_segment/nuoc.mp4",
    "oto": "assets/SLR_video_segment/oto.mp4",
    "phần thưởng": "assets/SLR_video_segment/phan_thuong.mp4",
    "phân tích": "assets/SLR_video_segment/phan_tich.mp4",
    "phát triển": "assets/SLR_video_segment/phat_trien.mp4",
    "phương tiện": "assets/SLR_video_segment/phuong_tien.mp4",
    "quả cam": "assets/SLR_video_segment/qua_cam.mp4",
    "quả đào": "assets/SLR_video_segment/qua_dao.mp4",
    "quả địa cầu": "assets/SLR_video_segment/qua_dia_cau.mp4",
    "quả đồi": "assets/SLR_video_segment/qua_doi.mp4",
    "quả lê": "assets/SLR_video_segment/qua_le.mp4",
    "quả mít": "assets/SLR_video_segment/qua_mit.mp4",
    "quả thanh long": "assets/SLR_video_segment/qua_thanh_long.mp4",
    "quần": "assets/SLR_video_segment/quaafn.mp4",
    "quan hệ tình dục": "assets/SLR_video_segment/quan_he_tinh_duc.mp4",
    "quả bầu": "assets/SLR_video_segment/quar_baafu.mp4",
    "quên": "assets/SLR_video_segment/queen.mp4",
    "quét nhà": "assets/SLR_video_segment/quet_nha.mp4",
    "quy đồng mẫu số": "assets/SLR_video_segment/quy_dong_mau_so.mp4",
    "quý hiếm": "assets/SLR_video_segment/quy_hiem.mp4",
    "quy nạp": "assets/SLR_video_segment/quy_nap.mp4",
    "quỳ": "assets/SLR_video_segment/quyf.mp4",
    "rau": "assets/SLR_video_segment/rau.mp4",
    "rau bắp cải": "assets/SLR_video_segment/rau_bap_cai.mp4",
    "rễ": "assets/SLR_video_segment/reex.mp4",
    "rơi": "assets/SLR_video_segment/roiw.mp4",
    "rụng": "assets/SLR_video_segment/rungj.mp4",
    "rụt rè": "assets/SLR_video_segment/rut_re.mp4",
    "rừng": "assets/SLR_video_segment/rwngf.mp4",
    "sần sùi": "assets/SLR_video_segment/saanf_suif.mp4",
    "sâu": "assets/SLR_video_segment/saau.mp4",
    "sách": "assets/SLR_video_segment/sachs.mp4",
    "sà xuống": "assets/SLR_video_segment/saf_xuoongs.mp4",
    "sai": "assets/SLR_video_segment/sai.mp4",
    "sin": "assets/SLR_video_segment/sin.mp4",
    "sinh quyển": "assets/SLR_video_segment/sinh_quyeern.mp4",
    "sinh sản": "assets/SLR_video_segment/sinh_sanr.mp4",
    "sinh trưởng": "assets/SLR_video_segment/sinh_truong.mp4",
    "sóng": "assets/SLR_video_segment/songs.mp4",
    "sống": "assets/SLR_video_segment/soongs.mp4",
    "sửa lỗi": "assets/SLR_video_segment/sua_loi.mp4",
    "sửa chữa": "assets/SLR_video_segment/suar_chwax.mp4",
    "súng": "assets/SLR_video_segment/sungs.mp4",
    "suy nghĩ": "assets/SLR_video_segment/suy_nghi.mp4",
    "sừng": "assets/SLR_video_segment/swngf.mp4",
    "tác giả": "assets/SLR_video_segment/tac_gia.mp4",
    "tai": "assets/SLR_video_segment/tai.mp4",
    "tập hợp rỗng": "assets/SLR_video_segment/tap_hop_rong.mp4",
    "tập thể dục": "assets/SLR_video_segment/tap_the_duc.mp4",
    "tập viết": "assets/SLR_video_segment/tap_viet.mp4",
    "tay": "assets/SLR_video_segment/tay.mp4",
    "thác nước": "assets/SLR_video_segment/thac_nuoc.mp4",
    "thân thiết": "assets/SLR_video_segment/than_thiet.mp4",
    "thành phố": "assets/SLR_video_segment/thanh_pho.mp4",
    "thật thà": "assets/SLR_video_segment/that_tha.mp4",
    "thiên nhiên": "assets/SLR_video_segment/thien_nhien.mp4",
    "thợ": "assets/SLR_video_segment/tho.mp4",
    "thổi": "assets/SLR_video_segment/thoi.mp4",
    "thời gian": "assets/SLR_video_segment/thoi_gian.mp4",
    "thổi kèn": "assets/SLR_video_segment/thoi_ken.mp4",
    "thời khóa biểu": "assets/SLR_video_segment/thoi_khoa_bieu.mp4",
    "thơm": "assets/SLR_video_segment/thom.mp4",
    "thú vị": "assets/SLR_video_segment/thu_vi.mp4",
    "thư viện": "assets/SLR_video_segment/thu_vien.mp4",
    "thức ăn": "assets/SLR_video_segment/thuc_an.mp4",
    "thúc đẩy": "assets/SLR_video_segment/thuc_day.mp4",
    "thực vật": "assets/SLR_video_segment/thuc_vat.mp4",
    "thuốc": "assets/SLR_video_segment/thuoc.mp4",
    "thuộc lòng": "assets/SLR_video_segment/thuoc_long.mp4",
    "thuyền": "assets/SLR_video_segment/thuyen.mp4",
    "thuyền buồm": "assets/SLR_video_segment/thuyen_buom.mp4",
    "thuyền rồng": "assets/SLR_video_segment/thuyen_rong.mp4",
    "tích phân": "assets/SLR_video_segment/tich_phan.mp4",
    "tiền": "assets/SLR_video_segment/tien.mp4",
    "tiến bộ": "assets/SLR_video_segment/tien_bo.mp4",
    "tiếng chiêng": "assets/SLR_video_segment/tieng_chieng.mp4",
    "tiếng kèn": "assets/SLR_video_segment/tieng_ken.mp4",
    "tiếp tuyến": "assets/SLR_video_segment/tiep_tuyen.mp4",
    "tiêu hóa": "assets/SLR_video_segment/tieu_hoa.mp4",
    "tính chất": "assets/SLR_video_segment/tinh_chat.mp4",
    "to": "assets/SLR_video_segment/to.mp4",
    "tỏa hương": "assets/SLR_video_segment/toa_huong.mp4",
    "tóc": "assets/SLR_video_segment/toc.mp4",
    "tôi": "assets/SLR_video_segment/toi.mp4",
    "tổng số": "assets/SLR_video_segment/tong_so.mp4",
    "trả lời": "assets/SLR_video_segment/tra_loi.mp4",
    "trái tim": "assets/SLR_video_segment/trai_tim.mp4",
    "tranh dân gian": "assets/SLR_video_segment/tranh_dan_gian.mp4",
    "tránh thai": "assets/SLR_video_segment/tranh_thai.mp4",
    "trẻ": "assets/SLR_video_segment/tre.mp4",
    "trên": "assets/SLR_video_segment/tren.mp4",
    "trèo": "assets/SLR_video_segment/treo.mp4",
    "trình bày": "assets/SLR_video_segment/trinh_bay.mp4",
    "trốn": "assets/SLR_video_segment/tron.mp4",
    "trong": "assets/SLR_video_segment/trong.mp4",
    "trực nhật": "assets/SLR_video_segment/truc_nhat.mp4",
    "trùng nhau": "assets/SLR_video_segment/trung_nhau.mp4",
    "tự hào": "assets/SLR_video_segment/tu_hao.mp4",
    "tường": "assets/SLR_video_segment/tuong.mp4",
    "tỷ số": "assets/SLR_video_segment/ty_so.mp4",
    "uống": "assets/SLR_video_segment/uong.mp4",
    "va chạm": "assets/SLR_video_segment/va_cham.mp4",
    "vất vả": "assets/SLR_video_segment/vat_va.mp4",
    "vòi voi": "assets/SLR_video_segment/voi_voi.mp4",
    "vòng đời": "assets/SLR_video_segment/vong_doi.mp4",
    "vồ": "assets/SLR_video_segment/voof.mp4",
    "vườn": "assets/SLR_video_segment/vuon.mp4",
    "vườn thú": "assets/SLR_video_segment/vuon_thu.mp4",
    "vuông góc": "assets/SLR_video_segment/vuong_goc.mp4",
    "xấp xỉ": "assets/SLR_video_segment/xap_xi.mp4",
    "xe đạp": "assets/SLR_video_segment/xe_dap.mp4",
    "xe máy": "assets/SLR_video_segment/xe_may.mp4",
    "xé": "assets/SLR_video_segment/xes.mp4",
    "xin lỗi": "assets/SLR_video_segment/xin_loi.mp4",
    "xôi": "assets/SLR_video_segment/xoi.mp4",
    "xù lông": "assets/SLR_video_segment/xu_long.mp4",
    "xúc động": "assets/SLR_video_segment/xuc_dong.mp4",
    "xuồng": "assets/SLR_video_segment/xuong.mp4",
    "y tá": "assets/SLR_video_segment/y_ta.mp4",
    "bạn": "assets/SLR_video_segment/banj.mp4",
    "đọc sách": "assets/SLR_video_segment/doc_sach.mp4",
    "giúp đỡ": "assets/SLR_video_segment/giup_do.mp4",
    "học": "assets/SLR_video_segment/hocj.mp4",
    "thích": "assets/SLR_video_segment/thichs.mp4",
    "thực phẩm": "assets/SLR_video_segment/thuc_pham.mp4",
};

static const Map<String, String> VietnameseSentenceVideos = {
  "bạn thích gì": "assets/SLR_video_segment/ban_thich_gi.mp4",
  "bạn có thích học toán không": "assets/SLR_video_segment/ban_co_thich_hoc_toan_khong.mp4",
  "đồng bằng duyên hải miền Trung": "assets/SLR_video_segment/dong_bang_duyen_hai_mien_trung.mp4",
  "tôi cũng thích chó": "assets/SLR_video_segment/toi_cung_thich_cho.mp4",
  "nó có màu gì": "assets/SLR_video_segment/no_co_mau_gi.mp4",
  "rất vui được gặp bạn": "assets/SLR_video_segment/rat_vui_duoc_gap_ban.mp4",
  "bạn tên là gì": "assets/SLR_video_segment/ban_ten_la_gi.mp4",
  "bạn bao nhiêu tuổi": "assets/SLR_video_segment/ban_bao_nhieu_tuoi.mp4",
  "bạn có đói không": "assets/SLR_video_segment/ban_co_doi_khong.mp4",
  "bạn có nuôi con gì không": "assets/SLR_video_segment/ban_co_nuoi_con_gi_khong.mp4",
  "bạn có thích học tiếng anh không": "assets/SLR_video_segment/ban_co_thich_hoc_tieng_anh_khong.mp4",
  "bản đồ Việt Nam": "assets/SLR_video_segment/ban_do_viet_nam.mp4",
  "bạn làm nghề gì": "assets/SLR_video_segment/ban_lam_nghe_gi.mp4",
  "bạn thích ăn gì": "assets/SLR_video_segment/ban_thich_an_gi.mp4",
  "bạn khỏe không": "assets/SLR_video_segment/ban_khoe_khong.mp4",
  "hôm nay thời tiết thế nào": "assets/SLR_video_segment/hom_nay_thoi_tiet_the_nao.mp4",

};

static const Map<String, String> wordSegmentsEnglish = 
  {
    "hello": "assets/SLR_video_segment_english/hello.mp4",
    "goodbye": "assets/SLR_video_segment_english/goodbye.mp4",
    "decorate": "assets/SLR_video_segment_english/AI_decorate.mp4",
    "decrease": "assets/SLR_video_segment_english/AI_decrease.mp4",
    "delicious": "assets/SLR_video_segment_english/AI_delicious.mp4",
    "dentist": "assets/SLR_video_segment_english/AI_dentist.mp4",
    "develope": "assets/SLR_video_segment_english/AI_develop.mp4",
    "dictionary": "assets/SLR_video_segment_english/AI_dictionary.mp4",
    "diet": "assets/SLR_video_segment_english/AI_diet.mp4",
    "different": "assets/SLR_video_segment_english/AI_different.mp4",
    "difficulty": "assets/SLR_video_segment_english/AI_difficulty.mp4",
    "dining room": "assets/SLR_video_segment_english/AI_dining_room.mp4",
    "disagree": "assets/SLR_video_segment_english/AI_disagree.mp4",
    "discuss": "assets/SLR_video_segment_english/AI_discuss.mp4",
    "doctor": "assets/SLR_video_segment_english/AI_doctor.mp4",
    "dog": "assets/SLR_video_segment_english/AI_dog.mp4",
    "doll": "assets/SLR_video_segment_english/AI_doll.mp4",
    "door": "assets/SLR_video_segment_english/AI_door.mp4",
    "draw": "assets/SLR_video_segment_english/AI_draw.mp4",
    "dream": "assets/SLR_video_segment_english/AI_dream.mp4",
    "dress": "assets/SLR_video_segment_english/AI_dress.mp4",
    "drink": "assets/SLR_video_segment_english/AI_drink.mp4",
    "drive": "assets/SLR_video_segment_english/AI_drive.mp4",
    "duck": "assets/SLR_video_segment_english/AI_duck.mp4",
    "ear": "assets/SLR_video_segment_english/AI_ear.mp4",
    "easy": "assets/SLR_video_segment_english/AI_easy.mp4",
    "eat": "assets/SLR_video_segment_english/AI_eat.mp4",
    "egg": "assets/SLR_video_segment_english/AI_egg.mp4",
    "elephant": "assets/SLR_video_segment_english/AI_elephant.mp4",
    "elevator": "assets/SLR_video_segment_english/AI_elevator.mp4",
    "emotion": "assets/SLR_video_segment_english/AI_emotion.mp4",
    "enjoy": "assets/SLR_video_segment_english/AI_enjoy.mp4",
    "enough": "assets/SLR_video_segment_english/AI_enough.mp4",
    "environment": "assets/SLR_video_segment_english/AI_environment.mp4",
    "equal": "assets/SLR_video_segment_english/AI_equal.mp4",
    "everyday": "assets/SLR_video_segment_english/AI_everyday.mp4",
    "excited": "assets/SLR_video_segment_english/AI_excited.mp4",
    "expensive": "assets/SLR_video_segment_english/AI_expensive.mp4",
    "eyes": "assets/SLR_video_segment_english/AI_eyes_.mp4",
    "face": "assets/SLR_video_segment_english/AI_face.mp4",
    "false": "assets/SLR_video_segment_english/AI_false.mp4",
    "fancy": "assets/SLR_video_segment_english/AI_fancy.mp4",
    "fast": "assets/SLR_video_segment_english/AI_fast.mp4",
    "fat": "assets/SLR_video_segment_english/AI_fat.mp4",
    "father": "assets/SLR_video_segment_english/AI_father.mp4",
    "fault": "assets/SLR_video_segment_english/AI_fault.mp4",
    "favourite": "assets/SLR_video_segment_english/AI_favorite.mp4",
    "feed": "assets/SLR_video_segment_english/AI_feed.mp4",
    "feel": "assets/SLR_video_segment_english/AI_feel.mp4",
    "fight": "assets/SLR_video_segment_english/AI_fight.mp4",
    "finish": "assets/SLR_video_segment_english/AI_finish.mp4",
    "fire": "assets/SLR_video_segment_english/AI_fire.mp4",
    "firefighter": "assets/SLR_video_segment_english/AI_firefighter.mp4",
    "fireman": "assets/SLR_video_segment_english/AI_fireman.mp4",
    "first": "assets/SLR_video_segment_english/AI_first.mp4",
    "fish": "assets/SLR_video_segment_english/AI_fish.mp4",
    "fishing": "assets/SLR_video_segment_english/AI_fishing.mp4",
    "fly": "assets/SLR_video_segment_english/AI_fly.mp4",
    "football": "assets/SLR_video_segment_english/AI_football.mp4",
    "for": "assets/SLR_video_segment_english/AI_for.mp4",
    "friday": "assets/SLR_video_segment_english/AI_friday.mp4",
    "friend": "assets/SLR_video_segment_english/AI_friend.mp4",
    "friendly": "assets/SLR_video_segment_english/AI_friendly.mp4",
    "from": "assets/SLR_video_segment_english/AI_from.mp4",
    "full": "assets/SLR_video_segment_english/Ai_full.mp4",
    "fun": "assets/SLR_video_segment_english/AI_fun.mp4",
    "funny": "assets/SLR_video_segment_english/AI_funny.mp4",
    "furniture": "assets/SLR_video_segment_english/AI_furniture.mp4",
    "future": "assets/SLR_video_segment_english/AI_future.mp4",
    "game": "assets/SLR_video_segment_english/AI_game.mp4",
    "gas": "assets/SLR_video_segment_english/AI_gas.mp4",
    "gay": "assets/SLR_video_segment_english/AI_gay.mp4",
    "gender": "assets/SLR_video_segment_english/AI_gender.mp4",
    "gentle": "assets/SLR_video_segment_english/AI_gentle.mp4",
    "get": "assets/SLR_video_segment_english/AI_get.mp4",
    "ghost": "assets/SLR_video_segment_english/AI_ghost.mp4",
    "girl": "assets/SLR_video_segment_english/AI_girl.mp4",
    "give": "assets/SLR_video_segment_english/AI_give.mp4",
    "glasses": "assets/SLR_video_segment_english/AI_glasses.mp4",
    "go": "assets/SLR_video_segment_english/AI_go.mp4",
    "good": "assets/SLR_video_segment_english/AI_good.mp4",
    "grandma": "assets/SLR_video_segment_english/AI_grandma.mp4",
    "great": "assets/SLR_video_segment_english/AI_great.mp4",
    "green": "assets/SLR_video_segment_english/AI_green.mp4",
    "grey": "assets/SLR_video_segment_english/AI_grey.mp4",
    "group": "assets/SLR_video_segment_english/AI_group.mp4",
    "grow": "assets/SLR_video_segment_english/AI_grow.mp4",
    "guest": "assets/SLR_video_segment_english/AI_guest.mp4",
    "gym": "assets/SLR_video_segment_english/AI_gym.mp4",
    "gymnastics": "assets/SLR_video_segment_english/AI_gymnastics.mp4",
    "happy": "assets/SLR_video_segment_english/AI_happy.mp4",
    "hard": "assets/SLR_video_segment_english/AI_hard.mp4",
    "hat": "assets/SLR_video_segment_english/AI_hat.mp4",
    "he": "assets/SLR_video_segment_english/AI_he.mp4",
    "healthy": "assets/SLR_video_segment_english/AI_healthy.mp4",
    "hear": "assets/SLR_video_segment_english/AI_hear.mp4",
    "heart": "assets/SLR_video_segment_english/AI_heart.mp4",
    "heavy": "assets/SLR_video_segment_english/AI_heavy.mp4",
    "height": "assets/SLR_video_segment_english/AI_height.mp4",
    "help": "assets/SLR_video_segment_english/AI_help.mp4",
    "here": "assets/SLR_video_segment_english/AI_here.mp4",
    "history": "assets/SLR_video_segment_english/AI_history.mp4",
    "hit": "assets/SLR_video_segment_english/AI_hit.mp4",
    "holiday": "assets/SLR_video_segment_english/AI_holiday.mp4",
    "home": "assets/SLR_video_segment_english/AI_home.mp4",
    "horse": "assets/SLR_video_segment_english/AI_horse.mp4",
    "hospital": "assets/SLR_video_segment_english/AI_hospital.mp4",
    "hot": "assets/SLR_video_segment_english/AI_hot.mp4",
    "hotel": "assets/SLR_video_segment_english/AI_hotel.mp4",
    "hour": "assets/SLR_video_segment_english/AI_hour.mp4",
    "house": "assets/SLR_video_segment_english/AI_house.mp4",
    "how": "assets/SLR_video_segment_english/AI_how.mp4",
    "hungry": "assets/SLR_video_segment_english/AI_hungry.mp4",
    "hurt": "assets/SLR_video_segment_english/AI_hurt.mp4",
    "ice cream": "assets/SLR_video_segment_english/AI_ice_cream.mp4",
    "idea": "assets/SLR_video_segment_english/AI_idea.mp4",
    "important": "assets/SLR_video_segment_english/AI_important.mp4",
    "impossible": "assets/SLR_video_segment_english/AI_impossible.mp4",
    "improve": "assets/SLR_video_segment_english/AI_improve.mp4",
    "in": "assets/SLR_video_segment_english/AI_in.mp4",
    "increase": "assets/SLR_video_segment_english/AI_increase.mp4",
    "interest": "assets/SLR_video_segment_english/AI_interest.mp4",
    "interesting": "assets/SLR_video_segment_english/AI_interesting.mp4",
    "interview": "assets/SLR_video_segment_english/AI_interview.mp4",
    "invent": "assets/SLR_video_segment_english/AI_invent.mp4",
    "invest": "assets/SLR_video_segment_english/AI_invest.mp4",
    "invisible": "assets/SLR_video_segment_english/AI_invisible.mp4",
    "island": "assets/SLR_video_segment_english/AI_island.mp4",
    "issue": "assets/SLR_video_segment_english/AI_issues.mp4",
    "jacket": "assets/SLR_video_segment_english/AI_jacket.mp4",
    "jail": "assets/SLR_video_segment_english/AI_jail.mp4",
    "jealous": "assets/SLR_video_segment_english/AI_jealous.mp4",
    "job": "assets/SLR_video_segment_english/AI_job.mp4",
    "join": "assets/SLR_video_segment_english/AI_join.mp4",
    "joke": "assets/SLR_video_segment_english/AI_joke.mp4",
    "jump": "assets/SLR_video_segment_english/AI_jump.mp4",
    "just": "assets/SLR_video_segment_english/AI_just.mp4",
    "kangaroo": "assets/SLR_video_segment_english/AI_kangaroo.mp4",
    "keep": "assets/SLR_video_segment_english/AI_keep.mp4",
    "keyboard": "assets/SLR_video_segment_english/AI_keyboard.mp4",
    "key": "assets/SLR_video_segment_english/AI_key.mp4",
    "kill": "assets/SLR_video_segment_english/AI_kill.mp4",
    "kiss": "assets/SLR_video_segment_english/AI_kiss.mp4",
    "kitchen": "assets/SLR_video_segment_english/AI_kitchen.mp4",
    "kite": "assets/SLR_video_segment_english/AI_kite.mp4",
    "knit": "assets/SLR_video_segment_english/AI_knit.mp4",
    "know": "assets/SLR_video_segment_english/AI_know.mp4",
    "lab": "assets/SLR_video_segment_english/AI_lab.mp4",
    "lady": "assets/SLR_video_segment_english/AI_lady.mp4",
    "language": "assets/SLR_video_segment_english/AI_language.mp4",
    "last": "assets/SLR_video_segment_english/AI_last.mp4",
    "late": "assets/SLR_video_segment_english/AI_late.mp4",
    "laugh": "assets/SLR_video_segment_english/AI_laugh.mp4",
    "law": "assets/SLR_video_segment_english/AI_law.mp4",
    "lawyer": "assets/SLR_video_segment_english/AI_lawyer.mp4",
    "lazy": "assets/SLR_video_segment_english/AI_lazy.mp4",
    "learn": "assets/SLR_video_segment_english/AI_learn.mp4",
    "lecture": "assets/SLR_video_segment_english/AI_lecture.mp4",
    "left": "assets/SLR_video_segment_english/AI_left.mp4",
    "library": "assets/SLR_video_segment_english/AI_library.mp4",
    "lie": "assets/SLR_video_segment_english/AI_lie.mp4",
    "light": "assets/SLR_video_segment_english/AI_light.mp4",
    "like": "assets/SLR_video_segment_english/AI_like.mp4",
    "list": "assets/SLR_video_segment_english/AI_list.mp4",
    "little": "assets/SLR_video_segment_english/AI_little.mp4",
    "live": "assets/SLR_video_segment_english/AI_live.mp4",
    "living room": "assets/SLR_video_segment_english/AI_living_room.mp4",
    "local": "assets/SLR_video_segment_english/AI_local.mp4",
    "long": "assets/SLR_video_segment_english/AI_long.mp4",
    "look": "assets/SLR_video_segment_english/AI_look.mp4",
    "loud": "assets/SLR_video_segment_english/AI_loud.mp4",
    "love": "assets/SLR_video_segment_english/AI_love.mp4",
    "luck": "assets/SLR_video_segment_english/Ai_luck.mp4",
    "machine": "assets/SLR_video_segment_english/AI_machine.mp4",
    "man": "assets/SLR_video_segment_english/AI_man.mp4",
    "manager": "assets/SLR_video_segment_english/AI_manager.mp4",
    "many": "assets/SLR_video_segment_english/AI_many.mp4",
    "math": "assets/SLR_video_segment_english/AI_math.mp4",
    "maybe": "assets/SLR_video_segment_english/AI_maybe.mp4",
    "me": "assets/SLR_video_segment_english/AI_me.mp4",
    "meal": "assets/SLR_video_segment_english/AI_meal.mp4",
    "meaning": "assets/SLR_video_segment_english/AI_meaning.mp4",
    "meat": "assets/SLR_video_segment_english/AI_meat.mp4",
    "medicine": "assets/SLR_video_segment_english/AI_medicine.mp4",
    "media": "assets/SLR_video_segment_english/AI_medium.mp4",
    "meet": "assets/SLR_video_segment_english/AI_meet.mp4",
    "member": "assets/SLR_video_segment_english/AI_member.mp4",
    "midnight": "assets/SLR_video_segment_english/AI_midnight.mp4",
    "milk": "assets/SLR_video_segment_english/AI_milk.mp4",
    "miss": "assets/SLR_video_segment_english/AI_miss.mp4",
    "mistake": "assets/SLR_video_segment_english/AI_mistake.mp4",
    "mom": "assets/SLR_video_segment_english/AI_mom.mp4",
    "moment": "assets/SLR_video_segment_english/AI_moment.mp4",
    "monday": "assets/SLR_video_segment_english/AI_monday.mp4",
    "monkey": "assets/SLR_video_segment_english/AI_monkey.mp4",
    "money": "assets/SLR_video_segment_english/AI_money.mp4",
    "month": "assets/SLR_video_segment_english/AI_month.mp4",
    "moon": "assets/SLR_video_segment_english/AI_moon.mp4",
    "more": "assets/SLR_video_segment_english/AI_more.mp4",
    "mountain": "assets/SLR_video_segment_english/AI_mountain.mp4",
    "mouse": "assets/SLR_video_segment_english/AI_mouse.mp4",
    "music": "assets/SLR_video_segment_english/AI_music.mp4",
    "mute": "assets/SLR_video_segment_english/AI_mute.mp4",
    "nation": "assets/SLR_video_segment_english/AI_nation.mp4",
    "natural": "assets/SLR_video_segment_english/AI_natural.mp4",
    "need": "assets/SLR_video_segment_english/AI_need.mp4",
    "negative": "assets/SLR_video_segment_english/AI_negative.mp4",
    "nervous": "assets/SLR_video_segment_english/AI_nervous.mp4",
    "new": "assets/SLR_video_segment_english/AI_new.mp4",
    "next": "assets/SLR_video_segment_english/AI_next.mp4",
    "nice": "assets/SLR_video_segment_english/AI_nice1.mp4",
    "night": "assets/SLR_video_segment_english/AI_night.mp4",
    "no": "assets/SLR_video_segment_english/AI_no.mp4",
    "noise": "assets/SLR_video_segment_english/AI_noise.mp4",
    "none": "assets/SLR_video_segment_english/AI_none.mp4",
    "nose": "assets/SLR_video_segment_english/AI_nose.mp4",
    "not": "assets/SLR_video_segment_english/AI_not.mp4",
    "now": "assets/SLR_video_segment_english/AI_now.mp4",
    "number": "assets/SLR_video_segment_english/AI_number.mp4",
    "nurse": "assets/SLR_video_segment_english/AI_nurse.mp4",
    "obey": "assets/SLR_video_segment_english/AI_obey.mp4",
    "ocean": "assets/SLR_video_segment_english/AI_ocean.mp4",
    "of": "assets/SLR_video_segment_english/AI_of.mp4",
    "office": "assets/SLR_video_segment_english/AI_office.mp4",
    "old": "assets/SLR_video_segment_english/AI_old.mp4",
    "on": "assets/SLR_video_segment_english/AI_on.mp4",
    "online": "assets/SLR_video_segment_english/AI_online.mp4",
    "open": "assets/SLR_video_segment_english/AI_open.mp4",
    "overlook": "assets/SLR_video_segment_english/AI_overlook.mp4",
    "own": "assets/SLR_video_segment_english/AI_own.mp4",
    "page": "assets/SLR_video_segment_english/AI_page.mp4",
    "pair": "assets/SLR_video_segment_english/AI_pair.mp4",
    "paper": "assets/SLR_video_segment_english/AI_paper.mp4",
    "parking": "assets/SLR_video_segment_english/AI_parking.mp4",
    "partner": "assets/SLR_video_segment_english/AI_partner.mp4",
    "pass": "assets/SLR_video_segment_english/AI_pass.mp4",
    "past": "assets/SLR_video_segment_english/AI_past.mp4",
    "patience": "assets/SLR_video_segment_english/AI_patience.mp4",
    "patient": "assets/SLR_video_segment_english/AI_patient.mp4",
    "pause": "assets/SLR_video_segment_english/AI_pause.mp4",
    "pay": "assets/SLR_video_segment_english/AI_pay.mp4",
    "peach": "assets/SLR_video_segment_english/AI_peach.mp4",
    "pear": "assets/SLR_video_segment_english/AI_pear.mp4",
    "pen": "assets/SLR_video_segment_english/AI_pen.mp4",
    "pencil": "assets/SLR_video_segment_english/AI_pencil.mp4",
    "penguine": "assets/SLR_video_segment_english/AI_penguin.mp4",
    "people": "assets/SLR_video_segment_english/AI_people.mp4",
    "perfect": "assets/SLR_video_segment_english/AI_perfect.mp4",
    "person": "assets/SLR_video_segment_english/AI_person.mp4",
    "pet": "assets/SLR_video_segment_english/AI_pet.mp4",
    "phone": "assets/SLR_video_segment_english/AI_phone.mp4",
    "pizza": "assets/SLR_video_segment_english/AI_pizza.mp4",
    "photograph": "assets/SLR_video_segment_english/AI_photograph.mp4",
    "plan": "assets/SLR_video_segment_english/AI_plan.mp4",
    "plant": "assets/SLR_video_segment_english/AI_plant.mp4",
    "play": "assets/SLR_video_segment_english/AI_play.mp4",
    "please": "assets/SLR_video_segment_english/AI_please.mp4",
    "police": "assets/SLR_video_segment_english/AI_police.mp4",
    "polite": "assets/SLR_video_segment_english/AI_polite.mp4",
    "potato": "assets/SLR_video_segment_english/AI_potato.mp4",
    "practice": "assets/SLR_video_segment_english/AI_practice.mp4",
    "prefer": "assets/SLR_video_segment_english/AI_prefer.mp4",
    "pretty": "assets/SLR_video_segment_english/AI_pretty.mp4",
    "prevent": "assets/SLR_video_segment_english/AI_prevent.mp4",
    "pride": "assets/SLR_video_segment_english/AI_pride.mp4",
    "printer": "assets/SLR_video_segment_english/AI_printer.mp4",
    "priority": "assets/SLR_video_segment_english/AI_priority.mp4",
    "sleepy": "assets/SLR_video_segment_english/sleepy.mp4",
    "sorry": "assets/SLR_video_segment_english/sorry.mp4",
    "teacher": "assets/SLR_video_segment_english/teacher.mp4",
    "thank you": "assets/SLR_video_segment_english/thank_you.mp4",
    "thirsty": "assets/SLR_video_segment_english/thirsty.mp4",
    "tired": "assets/SLR_video_segment_english/tired.mp4",
    "parents": "assets/SLR_video_segment_english/AI_parents.mp4",
    "paint": "assets/SLR_video_segment_english/AI_paint.mp4",
    "out": "assets/SLR_video_segment_english/AI_out.mp4",
    "I": "assets/SLR_video_segment_english/I.mp4"
}
  ;

static const Map<String, String> EnglishSentenceVideos = <String, String>{
    "what colour is it": "assets/SLR_video_segment_english/what_color_is_it.mp4",
    "what do you like to eat": "assets/SLR_video_segment_english/what_do_you_like_to_eat.mp4",
    "what do you want to drink": "assets/SLR_video_segment_english/what_do_you_want_to_drink.mp4",
    "what do you work": "assets/SLR_video_segment_english/what_do_you_work.mp4",
    "what is the weather like today": "assets/SLR_video_segment_english/what_is_the_weather_like_today.mp4",
    "you must try the bread that my mom cooks": "assets/SLR_video_segment_english/you_must_try_the_bread_that_my_mom_cooks.mp4",
    "are you hungry": "assets/SLR_video_segment_english/are_you_hungry.mp4",
    "do you any pets": "assets/SLR_video_segment_english/do_you_have_any_pets.mp4",
    "do you have any pets": "assets/SLR_video_segment_english/do_you_have_any_pets.mp4",
    "do you like english": "assets/SLR_video_segment_english/do_you_like_english.mp4",
    "do you like study": "assets/SLR_video_segment_english/do_you_like_study.mp4",
    "how are you": "assets/SLR_video_segment_english/how_are_you.mp4",
    "how old are you": "assets/SLR_video_segment_english/how_old_are_you.mp4",
    "i am fine": "assets/SLR_video_segment_english/i_am_fine.mp4",
    "i like dogs": "assets/SLR_video_segment_english/i_like_dogs_too.mp4",
    "i like music": "assets/SLR_video_segment_english/i_like_music.mp4",
    "let me take it for you": "assets/SLR_video_segment_english/let_me_take_it_for_you.mp4",
    "me too": "assets/SLR_video_segment_english/me_too.mp4",
    "nice to meet you": "assets/SLR_video_segment_english/nice_to_meet_you.mp4",
};
}



Future<String> generateGeminiResponse(BuildContext context, String prompt) async {
  try {
    final response = await geminiGenerateText(context, prompt);
    if (response == null) {
      print('Gemini API returned null');
      return 'Error: No response from Gemini';
    }
    return response;
  } catch (e) {
    print('Error in generateGeminiResponse: $e');
    return 'Error: $e';
  }
}

Future<String> splitAndMatchText(BuildContext context, String inputText) async {
  final availableWords = VideoConstants.wordSegments.keys.toList();
  final wordsListStr = availableWords.map((w) => '"$w"').join(', ');

  final prompt = '''
    Hãy chuyển câu sau thành chuỗi các từ/câu đơn giản nhất, chỉ sử dụng các từ/câu có sẵn: [$wordsListStr]
    
    Câu gốc: $inputText
    
    Nguyên tắc:
    1. Giữ nguyên chủ ngữ ở đầu câu
    2. Giữ các từ quan trọng nhất, bỏ qua từ không cần thiết
    3. Đảm bảo nghĩa của câu vẫn được giữ nguyên
    4. Chỉ sử dụng các từ trong danh sách đã cho
    5. Lưu ý: Trong danh sách có cả từ đơn và từ ghép, và có một số câu hoàn chỉnh
    6. Nếu thiếu từ quan trọng, hãy chỉ ra từ đó
    7. Ưu tiên sử dụng câu hoặc từ ghép, nếu không có mới sử dụng từ đơn.
    
    Trả về kết quả dạng:
    - Nếu đủ từ: "OK|từ1 + từ2 + từ3"
    - Nếu thiếu từ: "MISSING|từ1, từ2,..."
  ''';

  try {
    inputText = inputText.toLowerCase().trim();
    if (VideoConstants.VietnameseSentenceVideos.containsKey(inputText)) {
      return 'OK|${inputText}';
    }
    // print('Sending prompt to Gemini: $prompt');
    final response = await generateGeminiResponse(context, prompt);
    
    // Thêm bước kiểm tra từ
    if (response.startsWith('OK|')) {
      final words = response.substring(3).split(' + ');
      final missingWords = <String>[];
      
      // Kiểm tra từng từ có trong danh sách không
      for (final word in words) {
        final trimmedWord = word.trim();
        if (!VideoConstants.wordSegments.containsKey(trimmedWord)) {
          missingWords.add(trimmedWord);
        }
      }
      
      // Nếu có từ không tồn tại, trả về MISSING
      if (missingWords.isNotEmpty) {
        return 'MISSING|${missingWords.join(", ")}';
      }
      
      // Nếu tất cả từ đều hợp lệ, giữ nguyên kết quả OK
      return response;
    }
    
    return response;
  } catch (e) {
    print('Error in splitAndMatchText: $e');
    return 'Error: $e';
  }
}

Future<String> splitAndMatchTextEnglish(BuildContext context, String inputText) async {
  final availableSentences = VideoConstants.EnglishSentenceVideos.keys.toList();
  final availableWords = VideoConstants.wordSegmentsEnglish.keys.toList();
  final wordsListStr = availableWords.map((w) => '"$w"').join(', ');

  final prompt = '''
    Convert the following sentence into the simplest sequence of sentences/words, using only the available words: [$wordsListStr]
    
    Original sentence: $inputText
    
    Rules:
    1. Keep the subject at the beginning of the sentence
    2. Retain the most important words, omit unnecessary ones
    3. Ensure the meaning of the sentence remains intact
    4. Use only the words from the provided list
    5. Note: The list includes both single words and compound words, as well as some complete sentences (e.g., "North Pole", "affect", "what do you do for a living")
    6. If a key word is missing, indicate it
    7. Prioritize using complete sentences or compound words; use single words only if necessary

    Return the result in this format:
    - If all words are available: "OK|word1 + word2 + word3" (words separated by " + ")
    - If words are missing: "MISSING|word1, word2,..."
  ''';

  try {
    inputText = inputText.toLowerCase().trim();
    // Kiểm tra xem câu có trong danh sách câu không
    if (availableSentences.contains(inputText)) {
      return 'OK|${inputText}';
    }
    // print('Sending prompt to Gemini: $prompt');
    final response = await generateGeminiResponse(context, prompt);
    
    // Thêm bước kiểm tra từ
    if (response.startsWith('OK|')) {
      final words = response.substring(3).split(' + ');
      final missingWords = <String>[];
      
      // Kiểm tra từng từ có trong danh sách không
      for (final word in words) {
        final trimmedWord = word.trim();
        if (!VideoConstants.wordSegments.containsKey(trimmedWord)) {
          missingWords.add(trimmedWord);
        }
      }
      
      // Nếu có từ không tồn tại, trả về MISSING
      if (missingWords.isNotEmpty) {
        return 'MISSING|${missingWords.join(", ")}';
      }
      
      // Nếu tất cả từ đều hợp lệ, giữ nguyên kết quả OK
      return response;
    }
    
    return response;
  } catch (e) {
    print('Error in splitAndMatchTextEnglish: $e');
    return 'Error: $e';
  }
}

Future<List<String>> parseVideoPathsFromSplitText(String splitTextOutput) async {
  if (!splitTextOutput.startsWith('OK|')) {
    print('Invalid split text output: $splitTextOutput');
    throw Exception('Invalid split text output format');
  }

  final wordsString = splitTextOutput.substring(3);
  final words = wordsString.split(' + ');

  final videoPaths = words.map((word) {
    final trimmedWord = word.trim();
    print('Mapping word: "$trimmedWord"');
    
    // First check if it's a complete sentence
    final sentencePath = VideoConstants.VietnameseSentenceVideos[trimmedWord];
    if (sentencePath != null) {
      return sentencePath;
    }
    
    // If not a sentence, check individual words
    final wordPath = VideoConstants.wordSegments[trimmedWord];
    if (wordPath == null) {
      print('Video path not found for word: $trimmedWord');
      throw Exception('Video path not found for word: $trimmedWord');
    }
    return wordPath;
  }).toList();

  return videoPaths;
}

Future<List<String>> parseVideoPathsFromSplitTextEnglish(String splitTextOutput) async {
  if (!splitTextOutput.startsWith('OK|')) {
    print('Invalid split text output: $splitTextOutput');
    throw Exception('Invalid split text output format');
  }

  final wordsString = splitTextOutput.substring(3);
  final words = wordsString.split(' + ');

  final videoPaths = words.map((word) {
    final trimmedWord = word.trim();
    print('Mapping word: "$trimmedWord"');
    
    // First check if it's a complete sentence
    final sentencePath = VideoConstants.EnglishSentenceVideos[trimmedWord];
    if (sentencePath != null) {
      return sentencePath;
    }
    
    // If not a sentence, check individual words
    final wordPath = VideoConstants.wordSegmentsEnglish[trimmedWord];
    if (wordPath == null) {
      print('Video path not found for word: $trimmedWord');
      throw Exception('Video path not found for word: $trimmedWord');
    }
    return wordPath;
  }).toList();

  return videoPaths;
}

Future<String> mergeVideos(List<String> videoPaths) async {
  try {
    final directory = await getTemporaryDirectory();
    final outputPath = '${directory.path}/merged_video.mp4';
    final listFilePath = '${directory.path}/video_list.txt';
    final listFile = File(listFilePath);

    // Tạo danh sách file cho FFmpeg
    final fileContent = videoPaths.map((path) => "file '$path'").join('\n');
    await listFile.writeAsString(fileContent);

    // Thực thi lệnh FFmpeg để ghép video
    final command = '-f concat -safe 0 -i $listFilePath -c copy $outputPath';
    print('Executing FFmpeg command: $command');
    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode!)) {
      final logs = await session.getAllLogsAsString();
      print('FFmpeg failed: $logs');
      throw Exception('Video merge failed: $logs');
    }

    // Xóa file tạm
    if (await listFile.exists()) {
      await listFile.delete();
    }

    print('Video merged successfully: $outputPath');
    return outputPath;
  } catch (e) {
    print('Error merging videos: $e');
    rethrow;
  }
}

// Thay thế class VideoPlayerScreen cũ bằng CustomVideoPlayer mới
class CustomVideoPlayer extends StatefulWidget {
  final List<String> assetPaths;
  final double? width;
  final double? height;
  final Function(String)? onError;
  final BoxFit fit;
  final bool autoPlay;
  final bool showControls;
  final BorderRadius? borderRadius;

  const CustomVideoPlayer({
    required this.assetPaths,
    this.width,
    this.height,
    this.onError,
    this.fit = BoxFit.contain,
    this.autoPlay = false,
    this.showControls = true,
    this.borderRadius,
    super.key,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  int _currentVideoIndex = 0;
  bool _hasCompletedOnce = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.autoPlay;
    _initializeNextVideo();
  }

  Future<void> _initializeNextVideo() async {
    try {
      if (_currentVideoIndex >= widget.assetPaths.length) {
        _currentVideoIndex = 0;
        _hasCompletedOnce = true;
        if (_isInitialized) {
          _controller.pause();
          setState(() {
            _isPlaying = false;
          });
        }
        return;
      }

      if (_isInitialized) {
        await _controller.dispose();
      }

      _controller = VideoPlayerController.asset(widget.assetPaths[_currentVideoIndex])
        ..addListener(() {
          if (_controller.value.position >= _controller.value.duration) {
            if (_currentVideoIndex < widget.assetPaths.length - 1) {
              _currentVideoIndex++;
              _initializeNextVideo().then((_) {
                if (_isPlaying && mounted) {
                  _controller.play();
                }
              });
            } else {
              setState(() {
                _hasCompletedOnce = true;
                _isPlaying = false;
                _currentVideoIndex = 0;
              });
            }
          }
        });

      await _controller.initialize();
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = false;
        });
        
        if (_isPlaying) {
          _controller.play();
        }
      }
    } catch (e) {
      print('Error initializing video: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
      widget.onError?.call(e.toString());
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.play();
      } else {
        _controller.pause();
      }
    });
  }

  void _restartPlayback() {
    setState(() {
      _currentVideoIndex = 0;
      _hasCompletedOnce = false;
      _isPlaying = true;
    });
    _initializeNextVideo().then((_) {
      if (_isPlaying && mounted) {
        _controller.play();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: GestureDetector(
        onTap: widget.showControls ? _togglePlayPause : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_hasError)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    SizedBox(height: 8),
                    Text('Error loading video', 
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              )
            else if (!_isInitialized)
              const Center(child: CircularProgressIndicator())
            else
              ClipRRect(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
                child: FittedBox(
                  fit: widget.fit,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
            if (widget.showControls && (_hasCompletedOnce || !_isPlaying))
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    _hasCompletedOnce ? Icons.replay : 
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: _hasCompletedOnce ? _restartPlayback : _togglePlayPause,
                ),
              ),
          ],
        ),
      ),
    );
  }
}