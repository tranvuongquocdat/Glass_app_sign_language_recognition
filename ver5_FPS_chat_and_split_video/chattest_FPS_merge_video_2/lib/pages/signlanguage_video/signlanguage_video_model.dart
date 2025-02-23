import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/create_sign_language_name/create_sign_language_name_widget.dart';
import '/pages/slr_component/slr_component_widget.dart';
import 'dart:ui';
import 'signlanguage_video_widget.dart' show SignlanguageVideoWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignlanguageVideoModel extends FlutterFlowModel<SignlanguageVideoWidget> {
  ///  State fields for stateful widgets in this page.

  // Models for slrComponent dynamic component.
  Map<String, FlutterFlowModel> slrComponentModels = {};

  final Map<String, DebugDataField> debugGeneratorVariables = {};
  final Map<String, DebugDataField> debugBackendQueries = {};
  final Map<String, FlutterFlowModel> widgetBuilderComponents = {};
  @override
  void initState(BuildContext context) {
    debugLogWidgetClass(this);
  }

  @override
  void dispose() {}

  @override
  WidgetClassDebugData toWidgetClassDebugData() => WidgetClassDebugData(
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
        dynamicComponentStates: {
          'slrComponentModels (List<slrComponent>)':
              DynamicWidgetClassDebugData(
            componentStates: Map.fromIterables(
              List.generate(slrComponentModels.length, (index) => '[$index]'),
              slrComponentModels.values.map((e) => e.toWidgetClassDebugData()),
            ),
          ),
        }.withoutNulls,
        link:
            'https://app.flutterflow.io/project/chattest-fwf3ic/tab=uiBuilder&page=SignlanguageVideo',
        searchReference:
            'reference=OhFTaWdubGFuZ3VhZ2VWaWRlb1ABWhFTaWdubGFuZ3VhZ2VWaWRlbw==',
        widgetClassName: 'SignlanguageVideo',
      );
}
