import '/backend/backend.dart';
import '/backend/gemini/gemini.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/more_options/more_options_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'FPS_chat_page_model.dart';
export 'FPS_chat_page_model.dart';

class FPSChatPageWidget extends StatefulWidget {
  const FPSChatPageWidget({
    super.key,
    String? serverResponse,
    this.chatHistory,
    int? messageIndex,
  })  : this.serverResponse = serverResponse ?? 'null',
        this.messageIndex = messageIndex ?? 0;

  final String serverResponse;
  final List<String>? chatHistory;
  final int messageIndex;

  @override
  State<FPSChatPageWidget> createState() => _FPSChatPageWidgetState();
}

class _FPSChatPageWidgetState extends State<FPSChatPageWidget>
    with TickerProviderStateMixin, RouteAware {
  late FPSChatPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FPSChatPageModel());

    FFAppState().addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      setDarkModeSetting(context, ThemeMode.dark);
      if (widget!.chatHistory != null && (widget!.chatHistory)!.isNotEmpty) {
        _model.chatHistory = widget!.chatHistory!.toList().cast<String>();
        _model.messageIndex = widget!.messageIndex;
        safeSetState(() {});
      }
      if (widget!.serverResponse != 'null') {
        _model.addToChatHistory('...');
        _model.messageIndex = _model.messageIndex + 1;
        safeSetState(() {});
        _model.addToChatHistory('...');
        _model.messageIndex = _model.messageIndex + 1;
        safeSetState(() {});
        _model.addToChatHistory('...');
        safeSetState(() {});
        await _model.listViewController?.animateTo(
          _model.listViewController!.position.maxScrollExtent,
          duration: Duration(milliseconds: 100),
          curve: Curves.ease,
        );
        if (FFAppState().vietnameseEnable) {
          await geminiGenerateText(
            context,
            'Bạn là một bot kiểm tra chính tả và ngữ pháp tiếng Việt. Nhiệm vụ của bạn là chỉnh sửa văn bản có lỗi sai do lặp chữ, sai chính tả hoặc cấu trúc câu chưa chính xác. Sau đây là một số ví dụ để tham khảo:\"iiimmmlllllaaaannnnnongggmmmocoooootttttlllaaaaatvtt\" → \"im lặng một lát\"\"ddddxdooooccccccnnnlnnnaaayyyyyy\" → \"đọc này\"\"nnnnnngggggaaaaaayyyrmmmmmmhaaaaiiisibbbbbaaaennnnnnccccccooogdddeeteeennnnskkkhhhoooooonnnnonnggg\" → \"ngày mai bạn có đến không\"\"aaannnnnhhhqaaaayyyyyycccoooooohhhhhaaaiiiinnnnggtggguuuoooiiiddjdiiiiozoooobbsbbbeeeeefnnnmmmmeeeeee\" → \"anh ấy có hai người dì ở bên mẹ\"Chỉ xuất ra câu đã được chỉnh sửa, đảm bảo chính tả, ngữ pháp và dấu câu chuẩn xác.Ví dụ:\"Ttttrrrooooiioiioooaaaabbbbuuuuaaaa,\" sẽ trở thành \"Trời ơi, mưa!\"Bây giờ, hãy áp dụng quy tắc này để chỉnh sửa văn bản sau:${widget!.serverResponse}',
          ).then((generatedText) {
            safeSetState(() => _model.vieCorretedOutput = generatedText);
          });

          _model.updateChatHistoryAtIndex(
            _model.messageIndex,
            (_) => _model.vieCorretedOutput!,
          );
          _model.messageIndex = _model.messageIndex + 1;
          safeSetState(() {});
          
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });

          if (FFAppState().enableText2Speech) {
            await actions.textToSpeechAction(
              _model.vieCorretedOutput!,
              true,
            );
          }
        } else {
          await geminiGenerateText(
            context,
            'You are an English spelling and grammar correction bot. Here are examples of common errors for reference:\"hheelllooooowwwwwwwwoooorrrrllllldddd\" → \"hello world\"\"wwwhhhaaaattttttaaarrrreeeeyyyooouuudooiinngggg\" → \"what are you doing\"\"yyyyeeeesssssiicannnnnnheeeaaarrrrryouuuuuu\" → \"yes, I can hear you\"\"cccoooouuulllddddyyyoouuuuhelpmmmeeeee\" → \"could you help me\"Output only the corrected version of the sentence. Ensure proper spelling, grammar, punctuation, and case for all text.Now, correct this text:${widget!.serverResponse}',
          ).then((generatedText) {
            safeSetState(() => _model.engCorrectedOutput = generatedText);
          });

          _model.updateChatHistoryAtIndex(
            _model.messageIndex,
            (_) => _model.engCorrectedOutput!,
          );
          _model.messageIndex = _model.messageIndex + 1;
          safeSetState(() {});
          
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });

          if (FFAppState().enableText2Speech) {
            await actions.textToSpeechAction(
              _model.engCorrectedOutput!,
              false,
            );
          }
        }
      }
    });

    _model.userInputTextController ??= TextEditingController()
      ..addListener(() {
        debugLogWidgetClass(_model);
      });
    _model.userInputFocusNode ??= FocusNode();

    animationsMap.addAll({
      'iconButtonOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.8, 0.8),
            end: Offset(1.1, 1.1),
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    FFAppState().removeListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    _model.dispose();
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

  void _scrollToBottom() {
    if (_model.listViewController != null) {
      Future.delayed(Duration(milliseconds: 100), () {
        _model.listViewController!.animateTo(
          _model.listViewController!.position.maxScrollExtent + 100,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    }
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
        body: Container(
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
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.12,
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
                              'assets/images/header.png',
                            ).image,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10.0, 0.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FlutterFlowIconButton(
                                        borderColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        borderRadius: 8.0,
                                        borderWidth: 1.0,
                                        buttonSize: 30.0,
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 15.0,
                                        ),
                                        onPressed: () async {
                                          context.pushNamed('HomePage');
                                        },
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              FFAppState().vietnameseEnable 
                                                ? 'FPS DPSA Chat' 
                                                : 'FPS DPSA Chat',
                                              style: FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Inter',
                                                    fontSize: 18.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 12.0)),
                                      ),
                                      Builder(
                                        builder: (context) =>
                                            FlutterFlowIconButton(
                                          borderColor: Colors.transparent,
                                          borderRadius: 20.0,
                                          borderWidth: 1.0,
                                          buttonSize: 60.0,
                                          icon: Icon(
                                            Icons.more_vert,
                                            size: 30.0,
                                          ),
                                          onPressed: () async {
                                            await showAlignedDialog(
                                              context: context,
                                              isGlobal: false,
                                              avoidOverflow: true,
                                              targetAnchor:
                                                  AlignmentDirectional(
                                                          1.0, -1.0)
                                                      .resolve(
                                                          Directionality.of(
                                                              context)),
                                              followerAnchor:
                                                  AlignmentDirectional(
                                                          1.0, -1.0)
                                                      .resolve(
                                                          Directionality.of(
                                                              context)),
                                              builder: (dialogContext) {
                                                return Material(
                                                  color: Colors.transparent,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      FocusScope.of(
                                                              dialogContext)
                                                          .unfocus();
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();
                                                    },
                                                    child: MoreOptionsWidget(
                                                      clear: () async {
                                                        _model.chatHistory = [];
                                                        _model.threadId = null;
                                                        _model.messageIndex = 0;
                                                        safeSetState(() {});
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (responsiveVisibility(
                          context: context,
                          phone: false,
                          tablet: false,
                        ))
                          Container(
                            width: 100.0,
                            height: 24.0,
                            decoration: BoxDecoration(),
                          ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 12.0, 12.0, 0.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 5.0,
                                  sigmaY: 4.0,
                                ),
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  height:
                                      MediaQuery.sizeOf(context).height * 1.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, -1.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 0.0, 12.0, 0.0),
                                      child: Builder(
                                        builder: (context) {
                                          final chat =
                                              _model.chatHistory.toList();
                                          _model.debugGeneratorVariables[
                                                  'chat${chat.length > 100 ? ' (first 100)' : ''}'] =
                                              debugSerializeParam(
                                            chat.take(100),
                                            ParamType.String,
                                            isList: true,
                                            link:
                                                'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=FPSchatPage',
                                            name: 'String',
                                            nullable: false,
                                          );
                                          debugLogWidgetClass(_model);

                                          return ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: chat.length,
                                            itemBuilder: (context, chatIndex) {
                                              final chatItem = chat[chatIndex];
                                              return Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 12.0, 0.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if ((chatIndex % 3 == 2) &&
                                                        (chatItem != 'none'))
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Flexible(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Stack(
                                                                  children: [
                                                                    if (valueOrDefault<
                                                                        bool>(
                                                                      chatItem !=
                                                                          '...',
                                                                      true,
                                                                    ))
                                                                      AnimatedContainer(
                                                                        duration:
                                                                            Duration(milliseconds: 500),
                                                                        curve: Curves
                                                                            .easeInOut,
                                                                        constraints:
                                                                            BoxConstraints(
                                                                          maxWidth:
                                                                              () {
                                                                            if (MediaQuery.sizeOf(context).width >=
                                                                                1170.0) {
                                                                              return 700.0;
                                                                            } else if (MediaQuery.sizeOf(context).width <=
                                                                                470.0) {
                                                                              return 330.0;
                                                                            } else {
                                                                              return 530.0;
                                                                            }
                                                                          }(),
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              blurRadius: 3.0,
                                                                              color: Color(0x33000000),
                                                                              offset: Offset(
                                                                                0.0,
                                                                                1.0,
                                                                              ),
                                                                            )
                                                                          ],
                                                                          borderRadius:
                                                                              BorderRadius.circular(12.0),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            width:
                                                                                1.0,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            if (valueOrDefault<bool>(
                                                                              chatItem == '...',
                                                                              true,
                                                                            ))
                                                                              Lottie.asset(
                                                                                'assets/jsons/Typing_indicator.json',
                                                                                width: 48.0,
                                                                                height: 31.0,
                                                                                fit: BoxFit.cover,
                                                                                frameRate: FrameRate(60.0),
                                                                                animate: true,
                                                                              ),
                                                                            if (valueOrDefault<bool>(
                                                                              (chatItem != null && chatItem != '') || (chatItem != '...'),
                                                                              true,
                                                                            ))
                                                                              AnimatedContainer(
                                                                                duration: Duration(milliseconds: 500),
                                                                                curve: Curves.easeInOut,
                                                                                decoration: BoxDecoration(),
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.all(4.0),
                                                                                  child: Text(
                                                                                    chatItem,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Inter',
                                                                                          letterSpacing: 0.0,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    if (valueOrDefault<
                                                                        bool>(
                                                                      chatItem ==
                                                                          '...',
                                                                      true,
                                                                    ))
                                                                      AnimatedContainer(
                                                                        duration:
                                                                            Duration(milliseconds: 500),
                                                                        curve: Curves
                                                                            .easeInOut,
                                                                        constraints:
                                                                            BoxConstraints(
                                                                          maxWidth:
                                                                              () {
                                                                            if (MediaQuery.sizeOf(context).width >=
                                                                                1170.0) {
                                                                              return 700.0;
                                                                            } else if (MediaQuery.sizeOf(context).width <=
                                                                                470.0) {
                                                                              return 330.0;
                                                                            } else {
                                                                              return 530.0;
                                                                            }
                                                                          }(),
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.black,
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              blurRadius: 3.0,
                                                                              color: Color(0x33000000),
                                                                              offset: Offset(
                                                                                0.0,
                                                                                1.0,
                                                                              ),
                                                                            )
                                                                          ],
                                                                          borderRadius:
                                                                              BorderRadius.circular(12.0),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            width:
                                                                                1.0,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Lottie.asset(
                                                                              'assets/jsons/Typing_indicator.json',
                                                                              width: 48.0,
                                                                              height: 31.0,
                                                                              fit: BoxFit.cover,
                                                                              frameRate: FrameRate(60.0),
                                                                              animate: true,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                  ],
                                                                ),
                                                                if (valueOrDefault<
                                                                    bool>(
                                                                  chatItem !=
                                                                      '...',
                                                                  false,
                                                                ))
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            6.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child:
                                                                        InkWell(
                                                                      splashColor:
                                                                          Colors
                                                                              .transparent,
                                                                      focusColor:
                                                                          Colors
                                                                              .transparent,
                                                                      hoverColor:
                                                                          Colors
                                                                              .transparent,
                                                                      highlightColor:
                                                                          Colors
                                                                              .transparent,
                                                                      onTap:
                                                                          () async {
                                                                        await Clipboard.setData(ClipboardData(
                                                                            text:
                                                                                chatItem));
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                            content:
                                                                                Text(
                                                                              'Response copied to clipboard.',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Inter',
                                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                                    fontSize: 14.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                            ),
                                                                            duration:
                                                                                Duration(milliseconds: 3000),
                                                                            backgroundColor:
                                                                                FlutterFlowTheme.of(context).alternate,
                                                                          ),
                                                                        );
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                4.0,
                                                                                0.0),
                                                                            child:
                                                                                Icon(
                                                                              Icons.content_copy,
                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                              size: 12.0,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            'Copy response',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'Inter',
                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                  fontSize: 12.0,
                                                                                  letterSpacing: 0.0,
                                                                                ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    if ((chatIndex % 3 == 0) &&
                                                        (chatItem != '...'))
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          AnimatedContainer(
                                                            duration: Duration(
                                                                milliseconds:
                                                                    500),
                                                            curve: Curves
                                                                .easeInOut,
                                                            constraints:
                                                                BoxConstraints(
                                                              maxWidth: () {
                                                                if (MediaQuery.sizeOf(
                                                                            context)
                                                                        .width >=
                                                                    1170.0) {
                                                                  return 700.0;
                                                                } else if (MediaQuery.sizeOf(
                                                                            context)
                                                                        .width <=
                                                                    470.0) {
                                                                  return 330.0;
                                                                } else {
                                                                  return 530.0;
                                                                }
                                                              }(),
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          12.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  AnimatedDefaultTextStyle(
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Outfit',
                                                                          letterSpacing:
                                                                              0.0,
                                                                        ),
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            300),
                                                                    curve: Curves
                                                                        .easeIn,
                                                                    child: Text(
                                                                      chatItem,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    if ((chatIndex % 3 == 1) &&
                                                        (chatItem != '...'))
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          StreamBuilder<
                                                              List<
                                                                  SignLanguageVideoRecord>>(
                                                            stream:
                                                                querySignLanguageVideoRecord(
                                                              queryBuilder:
                                                                  (signLanguageVideoRecord) =>
                                                                      signLanguageVideoRecord
                                                                          .where(
                                                                'name',
                                                                isEqualTo:
                                                                    chatItem,
                                                              ),
                                                              singleRecord:
                                                                  true,
                                                            ),
                                                            builder: (context,
                                                                snapshot) {
                                                              // Customize what your widget looks like when it's loading.
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return Center(
                                                                  child:
                                                                      SizedBox(
                                                                    width: 50.0,
                                                                    height:
                                                                        50.0,
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      valueColor:
                                                                          AlwaysStoppedAnimation<
                                                                              Color>(
                                                                        FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              List<SignLanguageVideoRecord>
                                                                  containerSignLanguageVideoRecordList =
                                                                  snapshot
                                                                      .data!;
                                                              // Return an empty Container when the item does not exist.
                                                              if (snapshot.data!
                                                                  .isEmpty) {
                                                                return Container();
                                                              }
                                                              final containerSignLanguageVideoRecord =
                                                                  containerSignLanguageVideoRecordList
                                                                          .isNotEmpty
                                                                      ? containerSignLanguageVideoRecordList
                                                                          .first
                                                                      : null;
                                                              _model.debugBackendQueries[
                                                                      'containerSignLanguageVideoRecord_Container_jucism4r'] =
                                                                  debugSerializeParam(
                                                                containerSignLanguageVideoRecord,
                                                                ParamType
                                                                    .Document,
                                                                link:
                                                                    'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=FPSchatPage',
                                                                name:
                                                                    'sign_language_video',
                                                                nullable: false,
                                                              );
                                                              debugLogWidgetClass(
                                                                  _model);

                                                              return AnimatedContainer(
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        500),
                                                                curve: Curves
                                                                    .easeInOut,
                                                                constraints:
                                                                    BoxConstraints(
                                                                  maxWidth: () {
                                                                    if (MediaQuery.sizeOf(context)
                                                                            .width >=
                                                                        1170.0) {
                                                                      return 700.0;
                                                                    } else if (MediaQuery.sizeOf(context)
                                                                            .width <=
                                                                        470.0) {
                                                                      return 330.0;
                                                                    } else {
                                                                      return 530.0;
                                                                    }
                                                                  }(),
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12.0),
                                                                  border: Border
                                                                      .all(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .alternate,
                                                                  ),
                                                                ),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child: Image
                                                                      .asset(functions.getRelativeVideo(containerSignLanguageVideoRecord!.name),
                                                                    width:
                                                                        220.0,
                                                                    height:
                                                                        220.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                              //   child: 
                                                              //     Text(containerSignLanguageVideoRecord!.name                                                                  //       .name)
                                                              //   ),
                                                              ));
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                              );
                                            },
                                            controller:
                                                _model.listViewController,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 12.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3.0,
                        color: Colors.transparent,
                        offset: Offset(
                          0.0,
                          1.0,
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 4.0, 10.0, 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 30.0,
                          borderWidth: 1.0,
                          buttonSize: 40.0,
                          icon: FaIcon(
                            FontAwesomeIcons.camera,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 25.0,
                          ),
                          showLoadingIndicator: true,
                          onPressed: () async {
                            context.pushNamed(
                              'FPSchatrecordVideoPage',
                              queryParameters: {
                                'chatHistory': serializeParam(
                                  _model.chatHistory,
                                  ParamType.String,
                                  isList: true,
                                ),
                                'messageIndex': serializeParam(
                                  _model.messageIndex,
                                  ParamType.int,
                                ),
                              }.withoutNulls,
                            );
                          },
                        ),
                        Stack(
                          alignment: AlignmentDirectional(-1.0, -1.0),
                          children: [
                            Container(
                              width: 1.0,
                              height: 1.0,
                              child: custom_widgets.SpeechToTextWidget(
                                width: 1.0,
                                height: 1.0,
                              ),
                            ),
                            if (!FFAppState().isRecording)
                              FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 8.0,
                                buttonSize: 50.0,
                                icon: Icon(
                                  Icons.mic,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 30.0,
                                ),
                                onPressed: () async {
                                  FFAppState().speechToTextOutput = '';
                                  safeSetState(() {});
                                  FFAppState().isRecording = true;
                                  safeSetState(() {});
                                },
                              ),
                            if (FFAppState().isRecording)
                              FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 8.0,
                                buttonSize: 50.0,
                                icon: Icon(
                                  Icons.stop_rounded,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 30.0,
                                ),
                                onPressed: () async {
                                  FFAppState().isRecording = false;
                                  safeSetState(() {});
                                  if (FFAppState().speechToTextOutput != null &&
                                      FFAppState().speechToTextOutput != '') {
                                    HapticFeedback.heavyImpact();
                                    if (functions.textContained(
                                            FFAppState().speechToTextOutput) ==
                                        '...') {
                                      _model.addToChatHistory(
                                          FFAppState().speechToTextOutput);
                                      _model.messageIndex =
                                          _model.messageIndex + 1;
                                      safeSetState(() {});
                                      
                                      SchedulerBinding.instance.addPostFrameCallback((_) {
                                        _scrollToBottom();
                                      });

                                      _model.addToChatHistory('...');
                                      _model.messageIndex =
                                          _model.messageIndex + 1;
                                      safeSetState(() {});
                                      
                                      SchedulerBinding.instance.addPostFrameCallback((_) {
                                        _scrollToBottom();
                                      });

                                      HapticFeedback.lightImpact();
                                      _model.addToChatHistory('none');
                                      _model.messageIndex =
                                          _model.messageIndex + 1;
                                      safeSetState(() {});
                                      await _model.listViewController
                                          ?.animateTo(
                                        _model.listViewController!.position
                                            .maxScrollExtent,
                                        duration: Duration(milliseconds: 100),
                                        curve: Curves.ease,
                                      );
                                      safeSetState(() {
                                        _model.userInputTextController?.clear();
                                      });
                                    } else {
                                      _model.addToChatHistory(
                                          functions.textContained(
                                              FFAppState().speechToTextOutput));
                                      _model.messageIndex =
                                          _model.messageIndex + 1;
                                      safeSetState(() {});
                                      _model.addToChatHistory(
                                          functions.textContained(
                                              FFAppState().speechToTextOutput));
                                      _model.messageIndex =
                                          _model.messageIndex + 1;
                                      safeSetState(() {});
                                      HapticFeedback.lightImpact();
                                      _model.addToChatHistory('none');
                                      _model.messageIndex =
                                          _model.messageIndex + 1;
                                      safeSetState(() {});
                                      await _model.listViewController
                                          ?.animateTo(
                                        _model.listViewController!.position
                                            .maxScrollExtent,
                                        duration: Duration(milliseconds: 100),
                                        curve: Curves.ease,
                                      );
                                      safeSetState(() {
                                        _model.userInputTextController?.clear();
                                      });
                                    }
                                  }
                                },
                              ).animateOnPageLoad(animationsMap[
                                  'iconButtonOnPageLoadAnimation']!),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 1.0, 8.0, 1.0),
                              child: Container(
                                width: 300.0,
                                child: TextFormField(
                                  controller: _model.userInputTextController,
                                  focusNode: _model.userInputFocusNode,
                                  autofocus: true,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: FFAppState().vietnameseEnable 
                                      ? 'Nhập văn bản của bạn để chuyển thành video...'
                                      : 'Type your text here to convert to video...',
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Color(0x56FFFFFF),
                                          letterSpacing: 0.0,
                                        ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                      ),
                                  maxLines: 8,
                                  minLines: 1,
                                  keyboardType: TextInputType.multiline,
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primary,
                                  validator: _model
                                      .userInputTextControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                        FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 30.0,
                          borderWidth: 1.0,
                          buttonSize: 60.0,
                          icon: Icon(
                            Icons.send_rounded,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 30.0,
                          ),
                          showLoadingIndicator: true,
                          onPressed: () async {
                            if (_model.userInputTextController.text != null &&
                                _model.userInputTextController.text != '') {
                              HapticFeedback.heavyImpact();
                              _model.addToChatHistory(_model.userInputTextController.text);
                              _model.messageIndex = _model.messageIndex + 1;
                              safeSetState(() {});
                              
                              SchedulerBinding.instance.addPostFrameCallback((_) {
                                _scrollToBottom();
                              });

                              if (functions.textContained(_model.userInputTextController.text) ==
                                  '...') {
                                _model.addToChatHistory('...');
                                _model.messageIndex = _model.messageIndex + 1;
                                safeSetState(() {});
                                
                                SchedulerBinding.instance.addPostFrameCallback((_) {
                                  _scrollToBottom();
                                });

                                HapticFeedback.lightImpact();
                                _model.addToChatHistory('none');
                                _model.messageIndex = _model.messageIndex + 1;
                                safeSetState(() {});
                                
                                SchedulerBinding.instance.addPostFrameCallback((_) {
                                  _scrollToBottom();
                                });
                                
                                safeSetState(() {
                                  _model.userInputTextController?.clear();
                                });
                              } else {
                                _model.addToChatHistory(
                                    functions.textContained(_model.userInputTextController.text));
                                _model.messageIndex = _model.messageIndex + 1;
                                safeSetState(() {});
                                
                                SchedulerBinding.instance.addPostFrameCallback((_) {
                                  _scrollToBottom();
                                });
                                
                                HapticFeedback.lightImpact();
                                _model.addToChatHistory('none');
                                _model.messageIndex = _model.messageIndex + 1;
                                safeSetState(() {});
                                
                                SchedulerBinding.instance.addPostFrameCallback((_) {
                                  _scrollToBottom();
                                });
                                
                                safeSetState(() {
                                  _model.userInputTextController?.clear();
                                });
                              }
                            }
                          },
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
    );
  }
}
