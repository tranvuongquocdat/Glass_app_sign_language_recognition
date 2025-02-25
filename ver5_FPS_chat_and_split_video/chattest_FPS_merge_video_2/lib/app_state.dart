import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _IPAddress = prefs.getString('ff_IPAddress') ?? _IPAddress;
    });
    _safeInit(() {
      _GeminiAPIKey = prefs.getString('ff_GeminiAPIKey') ?? _GeminiAPIKey;
    });
    _safeInit(() {
      _enableText2Speech =
          prefs.getBool('ff_enableText2Speech') ?? _enableText2Speech;
    });
    _safeInit(() {
      _vietnameseEnable =
          prefs.getBool('ff_vietnameseEnable') ?? _vietnameseEnable;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _IPAddress = '192.168.1.1';
  String get IPAddress => _IPAddress;
  set IPAddress(String value) {
    _IPAddress = value;
    prefs.setString('ff_IPAddress', value);
    debugLogAppState(this);
  }

  String _GeminiAPIKey = 'AIzaSyBvtOpz_xQTxaCYJGMyT9OIKtu-nlAPdvw';
  String get GeminiAPIKey => _GeminiAPIKey;
  set GeminiAPIKey(String value) {
    _GeminiAPIKey = value;
    prefs.setString('ff_GeminiAPIKey', value);
    debugLogAppState(this);
  }

  bool _makeSpeech = false;
  bool get makeSpeech => _makeSpeech;
  set makeSpeech(bool value) {
    _makeSpeech = value;

    debugLogAppState(this);
  }

  String _textToSpeechInput = '';
  String get textToSpeechInput => _textToSpeechInput;
  set textToSpeechInput(String value) {
    _textToSpeechInput = value;

    debugLogAppState(this);
  }

  bool _makePhoto = false;
  bool get makePhoto => _makePhoto;
  set makePhoto(bool value) {
    _makePhoto = value;

    debugLogAppState(this);
  }

  bool _enableText2Speech = true;
  bool get enableText2Speech => _enableText2Speech;
  set enableText2Speech(bool value) {
    _enableText2Speech = value;
    prefs.setBool('ff_enableText2Speech', value);
    debugLogAppState(this);
  }

  bool _vietnameseEnable = true;
  bool get vietnameseEnable => _vietnameseEnable;
  set vietnameseEnable(bool value) {
    _vietnameseEnable = value;
    prefs.setBool('ff_vietnameseEnable', value);
    debugLogAppState(this);
  }

  bool _isRecording = false;
  bool get isRecording => _isRecording;
  set isRecording(bool value) {
    _isRecording = value;

    debugLogAppState(this);
  }

  bool _processingSpeechToText = false;
  bool get processingSpeechToText => _processingSpeechToText;
  set processingSpeechToText(bool value) {
    _processingSpeechToText = value;

    debugLogAppState(this);
  }

  String _speechToTextOutput = '';
  String get speechToTextOutput => _speechToTextOutput;
  set speechToTextOutput(String value) {
    _speechToTextOutput = value;

    debugLogAppState(this);
  }

  late LoggableList<String> _fileBase64List = LoggableList([]);
  List<String> get fileBase64List =>
      _fileBase64List?..logger = () => debugLogAppState(this);
  set fileBase64List(List<String> value) {
    if (value != null) {
      _fileBase64List = LoggableList(value);
    }

    debugLogAppState(this);
  }

  void addToFileBase64List(String value) {
    fileBase64List.add(value);
  }

  void removeFromFileBase64List(String value) {
    fileBase64List.remove(value);
  }

  void removeAtIndexFromFileBase64List(int index) {
    fileBase64List.removeAt(index);
  }

  void updateFileBase64ListAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    fileBase64List[index] = updateFn(_fileBase64List[index]);
  }

  void insertAtIndexInFileBase64List(int index, String value) {
    fileBase64List.insert(index, value);
  }

  String _fileBase64 = '';
  String get fileBase64 => _fileBase64;
  set fileBase64(String value) {
    _fileBase64 = value;

    debugLogAppState(this);
  }

  String _serverOutput = '';
  String get serverOutput => _serverOutput;
  set serverOutput(String value) {
    _serverOutput = value;
    debugLogAppState(this);
  }

  void appendToServerOutput(String value) {
    serverOutput = serverOutput + value;
  }

  Map<String, DebugDataField> toDebugSerializableMap() => {
        'IPAddress': debugSerializeParam(
          IPAddress,
          ParamType.String,
          link:
              'https://app.flutterflow.io/project/chattest-fwf3ic?tab=appValues&appValuesTab=state',
          searchReference:
              'reference=ChsKFQoJSVBBZGRyZXNzEgh4dWtucDVxZnICCANaCUlQQWRkcmVzcw==',
          name: 'String',
          nullable: false,
        ),
        'GeminiAPIKey': debugSerializeParam(
          GeminiAPIKey,
          ParamType.String,
          link: 'https://app.flutterflow.io/project/chattest-fwf3ic?tab=appValues&appValuesTab=state',
          name: 'String',
          nullable: false,
        ),
        'makeSpeech': debugSerializeParam(
          makeSpeech,
          ParamType.bool,
          link:
              'https://app.flutterflow.io/project/chattest-fwf3ic?tab=appValues&appValuesTab=state',
          searchReference:
              'reference=ChwKFgoKbWFrZVNwZWVjaBIIN29qMjBldTlyAggFWgptYWtlU3BlZWNo',
          name: 'bool',
          nullable: false,
        ),
        'textToSpeechInput': debugSerializeParam(
          textToSpeechInput,
          ParamType.String,
          link:
              'https://app.flutterflow.io/project/chattest-fwf3ic?tab=appValues&appValuesTab=state',
          searchReference:
              'reference=CiMKHQoRdGV4dFRvU3BlZWNoSW5wdXQSCGwxcjU4bDZ5cgIIA1oRdGV4dFRvU3BlZWNoSW5wdXQ=',
          name: 'String',
          nullable: false,
        ),
        'makePhoto': debugSerializeParam(
          makePhoto,
          ParamType.bool,
          link:
              'https://app.flutterflow.io/project/chattest-fwf3ic?tab=appValues&appValuesTab=state',
          searchReference:
              'reference=ChsKFQoJbWFrZVBob3RvEgg4cnhrMGlmenICCAVaCW1ha2VQaG90bw==',
          name: 'bool',
          nullable: false,
        ),
        'enableText2Speech': debugSerializeParam(
          enableText2Speech,
          ParamType.bool,
          link:
              'https://app.flutterflow.io/project/chattest-fwf3ic?tab=appValues&appValuesTab=state',
          searchReference:
              'reference=CiMKHQoRZW5hYmxlVGV4dDJTcGVlY2gSCDB4aWhiZmtwcgIIBVoRZW5hYmxlVGV4dDJTcGVlY2g=',
          name: 'bool',
          nullable: false,
        ),
        'vietnameseEnable': debugSerializeParam(
          vietnameseEnable,
          ParamType.bool,
          link:
              'https://app.flutterflow.io/project/chattest-fwf3ic?tab=appValues&appValuesTab=state',
          searchReference:
              'reference=CiIKHAoQdmlldG5hbWVzZUVuYWJsZRIIYW4zZDIyMzNyAggFWhB2aWV0bmFtZXNlRW5hYmxl',
          name: 'bool',
          nullable: false,
        ),
        'isRecording': debugSerializeParam(
          isRecording,
          ParamType.bool,
          link:
              'https://app.flutterflow.io/project/chattest-fwf3ic?tab=appValues&appValuesTab=state',
          searchReference:
              'reference=Ch0KFwoLaXNSZWNvcmRpbmcSCHNheTdmaHc3cgIIBVoLaXNSZWNvcmRpbmc=',
          name: 'bool',
          nullable: false,
        ),
        'processingSpeechToText': debugSerializeParam(
          processingSpeechToText,
          ParamType.bool,
          link:
              'https://app.flutterflow.io/project/chattest-fwf3ic?tab=appValues&appValuesTab=state',
          searchReference:
              'reference=CigKIgoWcHJvY2Vzc2luZ1NwZWVjaFRvVGV4dBIINzNsczdmMm5yAggFWhZwcm9jZXNzaW5nU3BlZWNoVG9UZXh0',
          name: 'bool',
          nullable: false,
        ),
        'speechToTextOutput': debugSerializeParam(
          speechToTextOutput,
          ParamType.String,
          link:
              'https://app.flutterflow.io/project/chattest-fwf3ic?tab=appValues&appValuesTab=state',
          searchReference:
              'reference=CiQKHgoSc3BlZWNoVG9UZXh0T3V0cHV0EggzNWh5cTA5Z3ICCANaEnNwZWVjaFRvVGV4dE91dHB1dA==',
          name: 'String',
          nullable: false,
        ),
        'fileBase64List': debugSerializeParam(
          fileBase64List,
          ParamType.String,
          isList: true,
          link:
              'https://app.flutterflow.io/project/chattest-fwf3ic?tab=appValues&appValuesTab=state',
          searchReference:
              'reference=CiIKGgoOZmlsZUJhc2U2NExpc3QSCHAzMTN3eThicgQSAggDWg5maWxlQmFzZTY0TGlzdA==',
          name: 'String',
          nullable: false,
        ),
        'fileBase64': debugSerializeParam(
          fileBase64,
          ParamType.String,
          link:
              'https://app.flutterflow.io/project/chattest-fwf3ic?tab=appValues&appValuesTab=state',
          searchReference:
              'reference=ChwKFgoKZmlsZUJhc2U2NBIIMWp0ZzlwanlyAggDWgpmaWxlQmFzZTY0',
          name: 'String',
          nullable: false,
        ),
        'serverOutput': debugSerializeParam(
          serverOutput,
          ParamType.String,
          link:
              'https://app.flutterflow.io/project/chattest-fwf3ic?tab=appValues&appValuesTab=state',
          searchReference:
              'reference=CiIKGgoOZmlsZUJhc2U2NExpc3QSCHAzMTN3eThicgQSAggDWg5maWxlQmFzZTY0TGlzdA==',
          name: 'String',
          nullable: false,
        )
      };
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

