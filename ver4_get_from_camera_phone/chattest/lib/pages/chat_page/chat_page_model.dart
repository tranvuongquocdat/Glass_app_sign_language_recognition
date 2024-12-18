import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/more_options/more_options_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'chat_page_widget.dart' show ChatPageWidget;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ChatPageModel extends FlutterFlowModel<ChatPageWidget> {
  ///  Local state fields for this page.

  String? _inputContent;
  set inputContent(String? value) {
    _inputContent = value;
    debugLogWidgetClass(this);
  }

  String? get inputContent => _inputContent;

  late LoggableList<String> _chatHistory = LoggableList([]);
  set chatHistory(List<String> value) {
    if (value != null) {
      _chatHistory = LoggableList(value);
    }

    debugLogWidgetClass(this);
  }

  List<String> get chatHistory =>
      _chatHistory?..logger = () => debugLogWidgetClass(this);
  void addToChatHistory(String item) => chatHistory.add(item);
  void removeFromChatHistory(String item) => chatHistory.remove(item);
  void removeAtIndexFromChatHistory(int index) => chatHistory.removeAt(index);
  void insertAtIndexInChatHistory(int index, String item) =>
      chatHistory.insert(index, item);
  void updateChatHistoryAtIndex(int index, Function(String) updateFn) =>
      chatHistory[index] = updateFn(chatHistory[index]);

  String? _threadId;
  set threadId(String? value) {
    _threadId = value;
    debugLogWidgetClass(this);
  }

  String? get threadId => _threadId;

  int _messageIndex = 0;
  set messageIndex(int value) {
    _messageIndex = value;
    debugLogWidgetClass(this);
  }

  int get messageIndex => _messageIndex;

  String? _userInfo;
  set userInfo(String? value) {
    _userInfo = value;
    debugLogWidgetClass(this);
  }

  String? get userInfo => _userInfo;

  ///  State fields for stateful widgets in this page.

  // State field(s) for ListView widget.
  ScrollController? listViewController;
  // State field(s) for UserInput widget.
  FocusNode? userInputFocusNode;
  TextEditingController? userInputTextController;
  String? Function(BuildContext, String?)? userInputTextControllerValidator;

  final Map<String, DebugDataField> debugGeneratorVariables = {};
  final Map<String, DebugDataField> debugBackendQueries = {};
  final Map<String, FlutterFlowModel> widgetBuilderComponents = {};
  @override
  void initState(BuildContext context) {
    listViewController = ScrollController();

    debugLogWidgetClass(this);
  }

  @override
  void dispose() {
    listViewController?.dispose();
    userInputFocusNode?.dispose();
    userInputTextController?.dispose();
  }

  @override
  WidgetClassDebugData toWidgetClassDebugData() => WidgetClassDebugData(
        localStates: {
          'inputContent': debugSerializeParam(
            inputContent,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=chatPage',
            searchReference:
                'reference=QiEKFQoMaW5wdXRDb250ZW50EgVldW96cSoCEgByBAgDIABQAVoMaW5wdXRDb250ZW50YghjaGF0UGFnZQ==',
            name: 'String',
            nullable: true,
          ),
          'chatHistory': debugSerializeParam(
            chatHistory,
            ParamType.String,
            isList: true,
            link:
                'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=chatPage',
            searchReference:
                'reference=Qh4KFAoLY2hhdEhpc3RvcnkSBXI3OTU2cgYSAggDIAFQAVoLY2hhdEhpc3RvcnliCGNoYXRQYWdl',
            name: 'String',
            nullable: false,
          ),
          'threadId': debugSerializeParam(
            threadId,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=chatPage',
            searchReference:
                'reference=Qh0KEQoIdGhyZWFkSWQSBWc1YnQ2KgISAHIECAMgAFABWgh0aHJlYWRJZGIIY2hhdFBhZ2U=',
            name: 'String',
            nullable: true,
          ),
          'messageIndex': debugSerializeParam(
            messageIndex,
            ParamType.int,
            link:
                'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=chatPage',
            searchReference:
                'reference=Qh0KFQoMbWVzc2FnZUluZGV4EgVjb25hNnIECAEgAVABWgxtZXNzYWdlSW5kZXhiCGNoYXRQYWdl',
            name: 'int',
            nullable: false,
          ),
          'userInfo': debugSerializeParam(
            userInfo,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=chatPage',
            searchReference:
                'reference=Qh0KEQoIdXNlckluZm8SBXpnYXNmKgISAHIECAMgAFABWgh1c2VySW5mb2IIY2hhdFBhZ2U=',
            name: 'String',
            nullable: true,
          )
        },
        widgetStates: {
          'userInputText': debugSerializeParam(
            userInputTextController?.text,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=chatPage',
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
            'https://app.flutterflow.io/project/chattest-fwf3ic/tab=uiBuilder&page=chatPage',
        searchReference: 'reference=OghjaGF0UGFnZVABWghjaGF0UGFnZQ==',
        widgetClassName: 'chatPage',
      );
}
