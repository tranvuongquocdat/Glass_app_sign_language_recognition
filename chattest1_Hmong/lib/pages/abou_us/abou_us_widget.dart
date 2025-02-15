import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'abou_us_model.dart';
export 'abou_us_model.dart';

class LanguageStrings {
  static Map<String, Map<String, String>> content = {
    'vi': {
      'title': 'Về chúng tôi',
      'version': 'Phiên bản: v2.3.0',
      'welcome': 'Chào mừng đến với DPSA',
      'subtitle': 'Ứng dụng AI hỗ trợ giao tiếp thủ ngữ',
      'step1_title': 'Bước 1: Đăng nhập tài khoản',
      'step1_content': 'Đăng nhập vào tài khoản của bạn để bắt đầu sử dụng các tính năng.',
      'step2_title': 'Bước 2: Khám phá tính năng ứng dụng',
      'feature1_title': 'AI Sign Language Recognition Chat (Giao tiếp Thủ ngữ AI)',
      'language_switch': 'Chọn ngôn ngữ: Nhấn biểu tượng ba dấu chấm ở góc trên bên phải để chuyển đổi giữa tiếng Việt và tiếng Anh.',
      'sign_recognition': 'Nhận diện thủ ngữ:',
      'sign_recognition_steps': '- Nhấn vào biểu tượng camera và chọn bắt đầu để kích hoạt nhận diện thủ ngữ.\n- Khi nhận diện xong, tắt camera và chờ hiển thị kết quả.',
      'voice_recognition': 'Nhận diện giọng nói:',
      'voice_recognition_steps': '- Nhấn vào biểu tượng ghi âm để thu âm giọng nói.\n- Sau khi tắt ghi âm, ứng dụng sẽ hiển thị video chuyển đổi sang thủ ngữ.',
      'text_conversion': 'Chuyển đổi văn bản: Nhập văn bản vào ô Chat để chuyển nội dung thành video sử dụng thủ ngữ.',
      'settings_title': 'Cài đặt (Setting)',
      'video_library': 'Xem thư viện video: Duyệt qua các video thủ ngữ có sẵn trong ứng dụng.',
      'contribute_video': 'Đóng góp video cá nhân:',
      'contribute_steps': '- Thêm video thủ ngữ của bạn vào ứng dụng.\n- Video sẽ được đội ngũ kiểm duyệt trước khi được chuyển đổi thành video AI chính thức.',
      'test_stt_title': 'Kiểm tra chuyển đổi giọng nói thành văn bản (Test Speech-to-Text)',
      'test_stt_content': 'Dùng công cụ để kiểm tra khả năng nhận diện giọng nói của thiết bị, bao gồm từ và câu đơn giản.',
    },
    'en': {
      'title': 'About Us',
      'version': 'Version: v2.3.0',
      'welcome': 'Welcome to DPSA',
      'subtitle': 'AI-powered sign language application',
      'step1_title': 'Step 1: Login',
      'step1_content': 'Log in to your account to start using the features.',
      'step2_title': 'Step 2: Explore App Features',
      'feature1_title': 'AI Sign Language Recognition Chat',
      'language_switch': 'Select language: Tap the three dots icon in the top right corner to switch between Vietnamese and English.',
      'sign_recognition': 'Sign Language Recognition:',
      'sign_recognition_steps': '- Tap the camera icon and select start to activate sign language recognition.\n- When recognition is complete, turn off the camera and wait for results.',
      'voice_recognition': 'Voice Recognition:',
      'voice_recognition_steps': '- Tap the recording icon to record your voice.\n- After stopping the recording, the app will display the sign language video conversion.',
      'text_conversion': 'Text Conversion: Enter text in the Chat box to convert content into sign language video.',
      'settings_title': 'Settings',
      'video_library': 'View video library: Browse through available sign language videos in the app.',
      'contribute_video': 'Contribute Personal Videos:',
      'contribute_steps': '- Add your sign language videos to the app.\n- Videos will be reviewed by the moderation team before being converted to official AI videos.',
      'test_stt_title': 'Test Speech-to-Text',
      'test_stt_content': 'Use the tool to test your device\'s voice recognition capabilities, including simple words and sentences.',
    }
  };
}

class AbouUsWidget extends StatefulWidget {
  const AbouUsWidget({super.key});

  @override
  State<AbouUsWidget> createState() => _AbouUsWidgetState();
}

class _AbouUsWidgetState extends State<AbouUsWidget> with RouteAware {
  late AbouUsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AbouUsModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = DebugModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route);
    }
    debugLogGlobalProperty(context);
  }

  @override
  void didPopNext() {
    if (mounted && DebugFlutterFlowModelContext.maybeOf(context) == null) {
      setState(() => _model.isRouteVisible = true);
      debugLogWidgetClass(_model);
    }
  }

  @override
  void didPush() {
    if (mounted && DebugFlutterFlowModelContext.maybeOf(context) == null) {
      setState(() => _model.isRouteVisible = true);
      debugLogWidgetClass(_model);
    }
  }

  @override
  void didPop() {
    _model.isRouteVisible = false;
  }

  @override
  void didPushNext() {
    _model.isRouteVisible = false;
  }

  String getText(String key) {
    return LanguageStrings.content[FFAppState().vietnameseEnable ? 'vi' : 'en']![key] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    DebugFlutterFlowModelContext.maybeOf(context)
        ?.parentModelCallback
        ?.call(_model);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.asset(
                  'assets/images/Background.png',
                ).image,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Stack(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: Image.asset(
                              'assets/images/header_fix3.png',
                            ).image,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, -1.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              15.0, 15.0, 15.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FlutterFlowIconButton(
                                borderColor: FlutterFlowTheme.of(context).info,
                                borderRadius: 8.0,
                                borderWidth: 1.0,
                                buttonSize: 30.0,
                                icon: Icon(
                                  Icons.arrow_back,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 15.0,
                                ),
                                onPressed: () async {
                                  context.safePop();
                                },
                              ),
                              Text(
                                getText('title'),
                                style: FlutterFlowTheme.of(context).headlineMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.0,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              FlutterFlowIconButton(
                                borderColor: FlutterFlowTheme.of(context).info,
                                borderRadius: 8.0,
                                buttonSize: 30.0,
                                icon: Icon(
                                  Icons.language,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  size: 15.0,
                                ),
                                onPressed: () {
                                  setState(() {
                                    FFAppState().vietnameseEnable = !FFAppState().vietnameseEnable;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                SizedBox(height: 20),
                                Container(
                                  width: 100.0,
                                  height: 100.0,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context).primary,
                                      width: 2,
                                    ),
                                  ),
                                  child: Image.asset(
                                    'assets/images/5332306.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  getText('welcome'),
                                  style: FlutterFlowTheme.of(context).headlineMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  getText('subtitle'),
                                  style: FlutterFlowTheme.of(context).bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  getText('version'),
                                  style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 32),
                          _buildSection(
                            title: getText('step1_title'),
                            content: getText('step1_content'),
                            context: context,
                          ),
                          SizedBox(height: 24),
                          _buildSection(
                            title: getText('step2_title'),
                            content: '',
                            context: context,
                          ),
                          SizedBox(height: 16),
                          _buildFeatureSection(
                            title: getText('feature1_title'),
                            items: [
                              getText('language_switch'),
                              getText('sign_recognition'),
                              getText('sign_recognition_steps'),
                              getText('voice_recognition'),
                              getText('voice_recognition_steps'),
                              getText('text_conversion'),
                            ],
                            context: context,
                          ),
                          Divider(height: 32),
                          _buildFeatureSection(
                            title: getText('settings_title'),
                            items: [
                              getText('video_library'),
                              getText('contribute_video'),
                              getText('contribute_steps'),
                            ],
                            context: context,
                          ),
                          Divider(height: 32),
                          _buildSection(
                            title: getText('test_stt_title'),
                            content: getText('test_stt_content'),
                            context: context,
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required BuildContext context,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: FlutterFlowTheme.of(context).titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (content.isNotEmpty) ...[
            SizedBox(height: 8),
            Text(content),
          ],
        ],
      ),
    );
  }

  Widget _buildFeatureSection({
    required String title,
    required List<String> items,
    required BuildContext context,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: FlutterFlowTheme.of(context).titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(item),
              )),
        ],
      ),
    );
  }
}
