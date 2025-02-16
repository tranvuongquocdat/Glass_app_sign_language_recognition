import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'chatrecord_video_page_widget.dart' show ChatrecordVideoPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatrecordVideoPageModel
    extends FlutterFlowModel<ChatrecordVideoPageWidget> {
  ///  Local state fields for this page.

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

  int? _messageIndex;
  set messageIndex(int? value) {
    _messageIndex = value;
    debugLogWidgetClass(this);
  }

  int? get messageIndex => _messageIndex;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getRecognitionResponse] action in IconButton widget.
  String? _serverOutput;
  set serverOutput(String? value) {
    _serverOutput = value;
    debugLogWidgetClass(this);
  }

  String? get serverOutput => _serverOutput;

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
        widgetParameters: {
          'chatHistory': debugSerializeParam(
            widget?.chatHistory,
            ParamType.String,
            isList: true,
            link:
                'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=chatrecordVideoPage',
            searchReference:
                'reference=Sh8KFQoLY2hhdEhpc3RvcnkSBnJ2NjBhbnIGEgIIAyAAUAFaC2NoYXRIaXN0b3J5',
            name: 'String',
            nullable: true,
          ),
          'messageIndex': debugSerializeParam(
            widget?.messageIndex,
            ParamType.int,
            link:
                'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=chatrecordVideoPage',
            searchReference:
                'reference=SiMKFgoMbWVzc2FnZUluZGV4EgZzY29mMjEqAxIBMHIECAEgAVABWgxtZXNzYWdlSW5kZXg=',
            name: 'int',
            nullable: false,
          )
        }.withoutNulls,
        localStates: {
          'chatHistory': debugSerializeParam(
            chatHistory,
            ParamType.String,
            isList: true,
            link:
                'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=chatrecordVideoPage',
            searchReference:
                'reference=Qh4KFAoLY2hhdEhpc3RvcnkSBTlsbWQ5cgYSAggDIAFQAVoLY2hhdEhpc3RvcnliE2NoYXRyZWNvcmRWaWRlb1BhZ2U=',
            name: 'String',
            nullable: false,
          ),
          'messageIndex': debugSerializeParam(
            messageIndex,
            ParamType.int,
            link:
                'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=chatrecordVideoPage',
            searchReference:
                'reference=QhsKFQoMbWVzc2FnZUluZGV4EgV4bWoybXICCAFQAVoMbWVzc2FnZUluZGV4YhNjaGF0cmVjb3JkVmlkZW9QYWdl',
            name: 'int',
            nullable: true,
          )
        },
        actionOutputs: {
          'serverOutput': debugSerializeParam(
            serverOutput,
            ParamType.String,
            link:
                'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=chatrecordVideoPage',
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
            'https://app.flutterflow.io/project/chattest-fwf3ic/tab=uiBuilder&page=chatrecordVideoPage',
        searchReference:
            'reference=OhNjaGF0cmVjb3JkVmlkZW9QYWdlUAFaE2NoYXRyZWNvcmRWaWRlb1BhZ2U=',
        widgetClassName: 'chatrecordVideoPage',
      );
}
