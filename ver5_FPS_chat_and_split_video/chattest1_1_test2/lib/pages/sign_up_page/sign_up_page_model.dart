import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'sign_up_page_widget.dart' show SignUpPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUpPageModel extends FlutterFlowModel<SignUpPageWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for SignUpEmail widget.
  FocusNode? signUpEmailFocusNode;
  TextEditingController? signUpEmailTextController;
  String? Function(BuildContext, String?)? signUpEmailTextControllerValidator;
  // State field(s) for SignInPass widget.
  FocusNode? signInPassFocusNode;
  TextEditingController? signInPassTextController;
  late bool signInPassVisibility;
  String? Function(BuildContext, String?)? signInPassTextControllerValidator;
  // State field(s) for SignUpConfitm widget.
  FocusNode? signUpConfitmFocusNode;
  TextEditingController? signUpConfitmTextController;
  late bool signUpConfitmVisibility;
  String? Function(BuildContext, String?)? signUpConfitmTextControllerValidator;

  final Map<String, DebugDataField> debugGeneratorVariables = {};
  final Map<String, DebugDataField> debugBackendQueries = {};
  final Map<String, FlutterFlowModel> widgetBuilderComponents = {};
  @override
  void initState(BuildContext context) {
    signInPassVisibility = false;
    signUpConfitmVisibility = false;

    debugLogWidgetClass(this);
  }

  @override
  void dispose() {
    signUpEmailFocusNode?.dispose();
    signUpEmailTextController?.dispose();

    signInPassFocusNode?.dispose();
    signInPassTextController?.dispose();

    signUpConfitmFocusNode?.dispose();
    signUpConfitmTextController?.dispose();
  }

  @override
  WidgetClassDebugData toWidgetClassDebugData() => WidgetClassDebugData(
        widgetStates: {
          'signUpEmailText': debugSerializeParam(
            signUpEmailTextController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=signUpPage',
            name: 'String',
            nullable: true,
          ),
          'signInPassText': debugSerializeParam(
            signInPassTextController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=signUpPage',
            name: 'String',
            nullable: true,
          ),
          'signUpConfitmText': debugSerializeParam(
            signUpConfitmTextController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=signUpPage',
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
            'https://app.flutterflow.io/project/chattest-fwf3ic/tab=uiBuilder&page=signUpPage',
        searchReference: 'reference=OgpzaWduVXBQYWdlUAFaCnNpZ25VcFBhZ2U=',
        widgetClassName: 'signUpPage',
      );
}
