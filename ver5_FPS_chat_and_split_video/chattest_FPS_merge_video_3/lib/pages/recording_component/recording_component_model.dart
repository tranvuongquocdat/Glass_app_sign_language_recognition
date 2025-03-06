import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:math';
import 'dart:ui';
import 'recording_component_widget.dart' show RecordingComponentWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

class RecordingComponentModel
    extends FlutterFlowModel<RecordingComponentWidget> {
  ///  State fields for stateful widgets in this component.

  AudioRecorder? audioRecorder;
  String? currentRecordFile;
  FFUploadedFile recordedFileBytes =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  final Map<String, DebugDataField> debugGeneratorVariables = {};
  final Map<String, DebugDataField> debugBackendQueries = {};
  final Map<String, FlutterFlowModel> widgetBuilderComponents = {};
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  @override
  WidgetClassDebugData toWidgetClassDebugData() => WidgetClassDebugData(
        actionOutputs: {
          'currentRecordFile': debugSerializeParam(
            currentRecordFile,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=recordingComponent',
            name: 'String',
            nullable: true,
          )
        },
        generatorVariables: debugGeneratorVariables,
        backendQueries: debugBackendQueries,
        componentStates: {
          ...widgetBuilderComponents.map(
            (key, value) => MapEntry(
              key,
              value.toWidgetClassDebugData(),
            ),
          ),
        }.withoutNulls,
        link:
            'https://app.flutterflow.io/project/chattest-fwf3ic/tab=uiBuilder&page=recordingComponent',
        searchReference:
            'reference=OhJyZWNvcmRpbmdDb21wb25lbnRQAFoScmVjb3JkaW5nQ29tcG9uZW50',
        widgetClassName: 'recordingComponent',
      );
}
