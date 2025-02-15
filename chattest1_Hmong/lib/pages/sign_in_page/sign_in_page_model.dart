import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'sign_in_page_widget.dart' show SignInPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignInPageModel extends FlutterFlowModel<SignInPageWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for SignInEmail widget.
  FocusNode? signInEmailFocusNode;
  TextEditingController? signInEmailTextController;
  String? Function(BuildContext, String?)? signInEmailTextControllerValidator;
  // State field(s) for SignInPass widget.
  FocusNode? signInPassFocusNode;
  TextEditingController? signInPassTextController;
  late bool signInPassVisibility;
  String? Function(BuildContext, String?)? signInPassTextControllerValidator;

  final Map<String, DebugDataField> debugGeneratorVariables = {};
  final Map<String, DebugDataField> debugBackendQueries = {};
  final Map<String, FlutterFlowModel> widgetBuilderComponents = {};
  @override
  void initState(BuildContext context) {
    signInPassVisibility = false;

    debugLogWidgetClass(this);
  }

  @override
  void dispose() {
    signInEmailFocusNode?.dispose();
    signInEmailTextController?.dispose();

    signInPassFocusNode?.dispose();
    signInPassTextController?.dispose();
  }

  @override
  WidgetClassDebugData toWidgetClassDebugData() => WidgetClassDebugData(
        widgetStates: {
          'signInEmailText': debugSerializeParam(
            signInEmailTextController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=SignInPage',
            name: 'String',
            nullable: true,
          ),
          'signInPassText': debugSerializeParam(
            signInPassTextController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=SignInPage',
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
            'https://app.flutterflow.io/project/chattest-fwf3ic/tab=uiBuilder&page=SignInPage',
        searchReference: 'reference=OgpTaWduSW5QYWdlUAFaClNpZ25JblBhZ2U=',
        widgetClassName: 'SignInPage',
      );
}
