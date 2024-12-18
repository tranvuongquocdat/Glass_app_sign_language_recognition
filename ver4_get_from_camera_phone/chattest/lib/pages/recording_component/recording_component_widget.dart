import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'recording_component_model.dart';
export 'recording_component_model.dart';

class RecordingComponentWidget extends StatefulWidget {
  const RecordingComponentWidget({super.key});

  @override
  State<RecordingComponentWidget> createState() =>
      _RecordingComponentWidgetState();
}

class _RecordingComponentWidgetState extends State<RecordingComponentWidget>
    with TickerProviderStateMixin, RouteAware {
  late RecordingComponentModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecordingComponentModel());

    animationsMap.addAll({
      'iconButtonOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 500.0.ms,
            begin: 0.5,
            end: 1.0,
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DebugFlutterFlowModelContext.maybeOf(context)
        ?.parentModelCallback
        ?.call(_model);
    context.watch<FFAppState>();

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 100.0,
              child: Divider(
                thickness: 2.0,
                color: FlutterFlowTheme.of(context).alternate,
              ),
            ),
            Text(
              'Click button to Start/Stop\n voice record!!!',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Stack(
              children: [
                if (FFAppState().isRecording &&
                    FFAppState().processingSpeechToText)
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
                    child: FlutterFlowIconButton(
                      borderRadius: 8.0,
                      buttonSize: 50.0,
                      fillColor: Color(0xFF332788),
                      icon: Icon(
                        Icons.mic,
                        color: FlutterFlowTheme.of(context).info,
                        size: 30.0,
                      ),
                      onPressed: () async {
                        await startAudioRecording(
                          context,
                          audioRecorder: _model.audioRecorder ??=
                              AudioRecorder(),
                        );

                        FFAppState().isRecording =
                            !(FFAppState().isRecording ?? true);
                        safeSetState(() {});
                      },
                    ),
                  ),
                if (FFAppState().isRecording &&
                    !FFAppState().processingSpeechToText)
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
                    child: FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 8.0,
                      buttonSize: 50.0,
                      fillColor: Color(0xFF332788),
                      icon: Icon(
                        Icons.stop_sharp,
                        color: FlutterFlowTheme.of(context).info,
                        size: 30.0,
                      ),
                      onPressed: () async {
                        await stopAudioRecording(
                          audioRecorder: _model.audioRecorder,
                          audioName: 'recordedFileBytes',
                          onRecordingComplete: (audioFilePath, audioBytes) {
                            _model.currentRecordFile = audioFilePath;
                            _model.recordedFileBytes = audioBytes;
                          },
                        );

                        FFAppState().isRecording =
                            !(FFAppState().isRecording ?? true);
                        FFAppState().processingSpeechToText =
                            !(FFAppState().processingSpeechToText ?? true);
                        safeSetState(() {});

                        safeSetState(() {});
                      },
                    ).animateOnPageLoad(
                        animationsMap['iconButtonOnPageLoadAnimation']!),
                  ),
                if (FFAppState().processingSpeechToText)
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
            if (FFAppState().processingSpeechToText)
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                child: Text(
                  'Processing Speech to Text',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
          ].divide(SizedBox(height: 20.0)),
        ),
      ),
    );
  }
}
