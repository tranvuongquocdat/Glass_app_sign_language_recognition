import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'chatrecord_video_page_model.dart';
export 'chatrecord_video_page_model.dart';

class ChatrecordVideoPageWidget extends StatefulWidget {
  const ChatrecordVideoPageWidget({
    super.key,
    this.chatHistory,
    int? messageIndex,
  }) : this.messageIndex = messageIndex ?? 0;

  final List<String>? chatHistory;
  final int messageIndex;

  @override
  State<ChatrecordVideoPageWidget> createState() =>
      _ChatrecordVideoPageWidgetState();
}

class _ChatrecordVideoPageWidgetState extends State<ChatrecordVideoPageWidget>
    with TickerProviderStateMixin, RouteAware {
  late ChatrecordVideoPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatrecordVideoPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.chatHistory = widget!.chatHistory!.toList().cast<String>();
      _model.messageIndex = widget!.messageIndex;
      safeSetState(() {});
    });

    animationsMap.addAll({
      'iconButtonOnPageLoadAnimation': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.54,
            end: 1.0,
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
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
          child: Stack(
            alignment: AlignmentDirectional(0.0, 0.0),
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 0.7,
                child: custom_widgets.VideoWidget(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 0.7,
                ),
              ),
              Container(
                decoration: BoxDecoration(),
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(24.0, 40.0, 24.0, 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            FlutterFlowIconButton(
                              borderColor: FlutterFlowTheme.of(context).info,
                              borderRadius: 8.0,
                              borderWidth: 1.0,
                              buttonSize: 30.0,
                              fillColor: Colors.black,
                              icon: Icon(
                                Icons.arrow_back,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 15.0,
                              ),
                              onPressed: () async {
                                context.safePop();
                              },
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          'assets/images/Scan.png',
                          width: 342.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Stack(
                        children: [
                          if (!FFAppState().makePhoto)
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                FFAppState().makePhoto = true;
                                safeSetState(() {});
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/cameraBtn.png',
                                  width: 80.0,
                                  height: 80.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          if (FFAppState().makePhoto)
                            FlutterFlowIconButton(
                              borderRadius: 80.0,
                              buttonSize: 80.0,
                              fillColor: Color(0xFF361252),
                              icon: Icon(
                                Icons.stop_rounded,
                                color: FlutterFlowTheme.of(context).info,
                                size: 55.0,
                              ),
                              onPressed: () async {
                                FFAppState().makePhoto = false;
                                safeSetState(() {});
                                await Future.delayed(
                                    const Duration(milliseconds: 100));
                                _model.serverOutput =
                                    await actions.getRecognitionResponse(
                                  FFAppState().fileBase64List.toList(),
                                  FFAppState().vietnameseEnable,
                                  FFAppState().IPAddress,
                                );

                                context.pushNamed(
                                  'FPSchatPage',
                                  queryParameters: {
                                    'serverResponse': serializeParam(
                                      _model.serverOutput,
                                      ParamType.String,
                                    ),
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

                                safeSetState(() {});
                              },
                            ).animateOnPageLoad(animationsMap[
                                'iconButtonOnPageLoadAnimation']!),
                        ],
                      ),
                    ],
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
