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
    "bạn khỏe không": "assets/SLR_video_segment/ban_khoe_khong.mp4",
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
    "bạn bao nhiêu tuổi": "assets/SLR_video_segment/ban_bao_nhieu_tuoi.mp4",
    "bạn có đói không": "assets/SLR_video_segment/ban_co_doi_khong.mp4",
    "bạn có nuôi con gì không": "assets/SLR_video_segment/Ban_co_nuoi_con_gi_khong.mp4",
    "bạn có thích học tiếng anh không": "assets/SLR_video_segment/ban_co_thich_hoc_tieng_anh_khong.mp4",
    "bản đồ Việt Nam": "assets/SLR_video_segment/ban_do_viet_nam.mp4",
    "bạn làm nghề gì": "assets/SLR_video_segment/ban_lam_nghe_gi.mp4",
    "bàn tay": "assets/SLR_video_segment/ban_tay.mp4",
    "bạn thân": "assets/SLR_video_segment/ban_than.mp4",
    "bạn thích ăn gì": "assets/SLR_video_segment/ban_thich_an_gi.mp4",
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
    "hôm nay thời tiết thế nào": "assets/SLR_video_segment/hom_nay_thoi_tiet_the_nao.mp4",
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
    "nó có màu gì": "assets/SLR_video_segment/no_co_mau_gi.mp4",
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
    "rất vui được gặp bạn": "assets/SLR_video_segment/rat_vui_duoc_gap_ban.mp4",
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
    "tôi cũng thích chó": "assets/SLR_video_segment/toi_cung_thich_cho.mp4",
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
    "y tá": "assets/SLR_video_segment/y_ta.mp4"
};

static const Map<String, String> wordSegmentsEnglish = 
  {
    "bẩn": "assets/SLR_video_segment/baanr.mp4",
    "áo": "assets/SLR_video_segment/ao.mp4",
    "bắc cực": "assets/SLR_video_segment/bac_cuc.mp4",
    "bạn khỏe không": "assets/SLR_video_segment/ban_khoe_khong.mp4",
  }
  ;
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
    final path = VideoConstants.wordSegments[trimmedWord];
    if (path == null) {
      print('Video path not found for word: $trimmedWord');
      throw Exception('Video path not found for word: $trimmedWord');
    }
    return path;
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

// Cập nhật hàm mergeAndPlayVideos để trả về danh sách đường dẫn video
Future<List<String>> getSignLanguageVideoPaths(String splitTextOutput) async {
  try {
    print('Parsing video paths from split text...');
    if (!splitTextOutput.startsWith('OK|')) {
      throw Exception('Invalid split text output format');
    }
    return await parseVideoPathsFromSplitText(splitTextOutput);
  } catch (e) {
    print('Error getting video paths: $e');
    rethrow;
  }
}