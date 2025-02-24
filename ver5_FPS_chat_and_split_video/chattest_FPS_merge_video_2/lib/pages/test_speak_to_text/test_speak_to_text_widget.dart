import 'package:chattest/flutter_flow/FPS_custom_functions.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'test_speak_to_text_model.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'dart:io';
import 'package:flutter/services.dart' show ByteData, rootBundle;

export 'test_speak_to_text_model.dart';

class LanguageStrings {
  static Map<String, Map<String, String>> content = {
    'vi': {
      'title': 'Giám định tính năng',
      'apiKey_label': 'Khóa API Dịch vụ',
      'apiKey_hint': 'Nhập khóa API...',
      'submit': 'Xác nhận',
      'api_success': 'Cập nhật khóa API thành công!',
      'start_recording': 'Bắt đầu ghi âm',
      'stop_recording': 'Dừng ghi âm',
      'play_text': 'Phát văn bản',
      'enter_text': 'Nhập văn bản...',
      'split_text': 'Phân tích văn bản',
      'input_hint': 'Nhập văn bản cần phân tích...',
      'analyze': 'Phân tích',
    },
    'en': {
      'title': 'Test Speech to Text',
      'apiKey_label': 'Service API Key',
      'apiKey_hint': 'Enter API Key...',
      'submit': 'Submit',
      'api_success': 'API Key updated successfully!',
      'start_recording': 'Start Recording',
      'stop_recording': 'Stop Recording',
      'play_text': 'Play Text',
      'enter_text': 'Enter text...',
      'split_text': 'Split Text Analysis',
      'input_hint': 'Enter text to analyze...',
      'analyze': 'Analyze',
    }
  };
}

String getText(String key) {
  return LanguageStrings.content[FFAppState().vietnameseEnable ? 'vi' : 'en']![key] ?? '';
}

class TestSpeakToTextWidget extends StatefulWidget {
  const TestSpeakToTextWidget({super.key});

  @override
  State<TestSpeakToTextWidget> createState() => _TestSpeakToTextWidgetState();
}

class _TestSpeakToTextWidgetState extends State<TestSpeakToTextWidget>
    with RouteAware {
  late TestSpeakToTextModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController? splitTextController;
  String splitOutput = '';
  bool isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TestSpeakToTextModel());

    _model.textController ??= TextEditingController()
      ..addListener(() {
        debugLogWidgetClass(_model);
      });
    _model.textFieldFocusNode ??= FocusNode();

    _model.apiKeyController ??= TextEditingController(
      text: FFAppState().GeminiAPIKey,
    )..addListener(() {
        debugLogWidgetClass(_model);
      });
    _model.apiKeyFocusNode ??= FocusNode();

    splitTextController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();
    splitTextController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, DebugModalRoute.of(context)!);
    debugLogGlobalProperty(context);
  }

  @override
  void didPopNext() {
    safeSetState(() => _model.isRouteVisible = true);
    debugLogWidgetClass(_model);
  }

  @override
  void didPush() {
    safeSetState(() => _model.isRouteVisible = true);
    debugLogWidgetClass(_model);
  }

  @override
  void didPop() {
    _model.isRouteVisible = false;
  }

  @override
  void didPushNext() {
    _model.isRouteVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    DebugFlutterFlowModelContext.maybeOf(context)
        ?.parentModelCallback
        ?.call(_model);
    context.watch<FFAppState>();

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
                        height: 107.0,
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
                          padding: EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
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
                                  color: FlutterFlowTheme.of(context).primaryText,
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
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondaryBackground.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).primary.withOpacity(0.2),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getText('apiKey_label'),
                                    style: FlutterFlowTheme.of(context).titleMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 12.0),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _model.apiKeyController,
                                          focusNode: _model.apiKeyFocusNode,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            hintText: getText('apiKey_hint'),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: FlutterFlowTheme.of(context).alternate,
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: FlutterFlowTheme.of(context).primary,
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.0),
                                      FFButtonWidget(
                                        onPressed: () async {
                                          FFAppState().GeminiAPIKey = 
                                              _model.apiKeyController.text;
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(getText('api_success')),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                        text: getText('submit'),
                                        options: FFButtonOptions(
                                          height: 40.0,
                                          padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context).primary,
                                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                            fontFamily: 'Inter',
                                            color: Colors.white,
                                          ),
                                          elevation: 3.0,
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ].divide(SizedBox(height: 12.0)),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.0),

                          // Speech Recognition Section
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondaryBackground.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).primary.withOpacity(0.2),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  if (FFAppState().isRecording)
                                    custom_widgets.SpeechToTextWidget(
                                      width: double.infinity,
                                      height: 200,
                                    ),
                                  Text(
                                    FFAppState().speechToTextOutput,
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      fontSize: 16.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FlutterFlowIconButton(
                                        borderRadius: 12.0,
                                        buttonSize: 50.0,
                                        fillColor: FlutterFlowTheme.of(context).primary,
                                        icon: Icon(
                                          Icons.mic,
                                          color: FlutterFlowTheme.of(context).info,
                                          size: 24.0,
                                        ),
                                        onPressed: () async {
                                          FFAppState().isRecording = true;
                                          safeSetState(() {});
                                        },
                                      ),
                                      SizedBox(width: 16.0),
                                      FlutterFlowIconButton(
                                        borderRadius: 12.0,
                                        buttonSize: 50.0,
                                        fillColor: FlutterFlowTheme.of(context).error,
                                        icon: Icon(
                                          Icons.stop_sharp,
                                          color: FlutterFlowTheme.of(context).info,
                                          size: 24.0,
                                        ),
                                        onPressed: () async {
                                          FFAppState().isRecording = false;
                                          safeSetState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 24.0),

                          // Text to Speech Section
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondaryBackground.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).primary.withOpacity(0.2),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _model.textController,
                                    focusNode: _model.textFieldFocusNode,
                                    decoration: InputDecoration(
                                      hintText: getText('enter_text'),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context).alternate,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context).primary,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                    maxLines: 3,
                                    minLines: 2,
                                  ),
                                  SizedBox(height: 16.0),
                                  FlutterFlowIconButton(
                                    borderRadius: 12.0,
                                    buttonSize: 50.0,
                                    fillColor: FlutterFlowTheme.of(context).primary,
                                    icon: Icon(
                                      Icons.play_arrow,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 24.0,
                                    ),
                                    onPressed: () async {
                                      await actions.textToSpeechAction(
                                        _model.textController.text,
                                        FFAppState().vietnameseEnable,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 24.0),

                          // Split Text Analysis Section
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondaryBackground.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).primary.withOpacity(0.2),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getText('split_text'),
                                    style: FlutterFlowTheme.of(context).titleMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  TextFormField(
                                    controller: splitTextController,
                                    decoration: InputDecoration(
                                      hintText: getText('input_hint'),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context).alternate,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context).primary,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    maxLines: 3,
                                    minLines: 2,
                                  ),
                                  SizedBox(height: 16.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FFButtonWidget(
                                        onPressed: isAnalyzing
                                            ? null
                                            : () async {
                                                setState(() {
                                                  isAnalyzing = true;
                                                  splitOutput = '';
                                                });

                                                try {
                                                  final result = await splitAndMatchText(
                                                    context,
                                                    splitTextController!.text,
                                                  );
                                                  setState(() {
                                                    splitOutput = result;
                                                  });
                                                } catch (e) {
                                                  setState(() {
                                                    splitOutput = 'Error: $e';
                                                  });
                                                } finally {
                                                  setState(() {
                                                    isAnalyzing = false;
                                                  });
                                                }
                                              },
                                        text: isAnalyzing ? '...' : getText('analyze'),
                                        options: FFButtonOptions(
                                          width: 120.0,
                                          height: 40.0,
                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context).primary,
                                          textStyle: FlutterFlowTheme.of(context).titleSmall.copyWith(
                                            color: Colors.white,
                                          ),
                                          elevation: 2.0,
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (splitOutput.isNotEmpty) ...[
                                    SizedBox(height: 16.0),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        borderRadius: BorderRadius.circular(8.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context).alternate,
                                        ),
                                      ),
                                      child: splitOutput.startsWith('OK|')
                                          ? Wrap(
                                              spacing: 8.0,
                                              runSpacing: 8.0,
                                              children: splitOutput
                                                  .substring(3)
                                                  .split(' + ')
                                                  .map((word) => Container(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: 12.0,
                                                          vertical: 6.0,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: FlutterFlowTheme.of(context)
                                                              .primary
                                                              .withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(16.0),
                                                        ),
                                                        child: Text(word),
                                                      ))
                                                  .toList(),
                                            )
                                          : Text(
                                              splitOutput,
                                              style: FlutterFlowTheme.of(context).bodyMedium,
                                            ),
                                    ),
                                  ],
                                  if (splitOutput.startsWith('OK|')) ...[
                                    SizedBox(height: 16.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        FFButtonWidget(
                                          onPressed: () async {
                                            await mergeAndPlayVideos(context, splitOutput);
                                          },
                                          text: 'Play Sign Language Videos',
                                          options: FFButtonOptions(
                                            width: 200.0,
                                            height: 40.0,
                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context).secondary,
                                            textStyle: FlutterFlowTheme.of(context).titleSmall.copyWith(
                                              color: Colors.white,
                                            ),
                                            elevation: 2.0,
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16.0),
                                    Container(
                                      width: double.infinity,
                                      height: 200.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        borderRadius: BorderRadius.circular(8.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context).alternate,
                                        ),
                                      ),
                                      child: Center(
                                        child: AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: Container(
                                            color: Colors.black,
                                            child: const Center(
                                              child: Text(
                                                'Video Player Area',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
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
}
