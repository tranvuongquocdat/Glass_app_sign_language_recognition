import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import 'slr_component_widget.dart' show SlrComponentWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SlrComponentModel extends FlutterFlowModel<SlrComponentWidget> {
  ///  Local state fields for this component.

  int _index = 0;
  set index(int value) {
    _index = value;
    debugLogWidgetClass(this);
  }

  int get index => _index;

  ///  State fields for stateful widgets in this component.

  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl = '';

  final Map<String, DebugDataField> debugGeneratorVariables = {};
  final Map<String, DebugDataField> debugBackendQueries = {};
  final Map<String, FlutterFlowModel> widgetBuilderComponents = {};
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  @override
  WidgetClassDebugData toWidgetClassDebugData() => WidgetClassDebugData(
        widgetParameters: {
          'inputSLR': debugSerializeParam(
            widget?.inputSLR,
            ParamType.Document,
            link:
                'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=slrComponent',
            searchReference:
                'reference=Sj0KEgoIaW5wdXRTTFISBjhyeTFuOHInCAcgASohCh8KE3NpZ25fbGFuZ3VhZ2VfdmlkZW8SCGJiaDJoZzlqUABaCGlucHV0U0xS',
            name: 'sign_language_video',
            nullable: true,
          )
        }.withoutNulls,
        localStates: {
          'index': debugSerializeParam(
            index,
            ParamType.int,
            link:
                'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=slrComponent',
            searchReference:
                'reference=QhYKDgoFaW5kZXgSBThzZXpmcgQIASABUABaBWluZGV4YgxzbHJDb21wb25lbnQ=',
            name: 'int',
            nullable: false,
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
            'https://app.flutterflow.io/project/chattest-fwf3ic/tab=uiBuilder&page=slrComponent',
        searchReference: 'reference=OgxzbHJDb21wb25lbnRQAFoMc2xyQ29tcG9uZW50',
        widgetClassName: 'slrComponent',
      );
}
