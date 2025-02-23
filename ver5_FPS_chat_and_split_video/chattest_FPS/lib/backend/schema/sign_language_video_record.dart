import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SignLanguageVideoRecord extends FirestoreRecord {
  SignLanguageVideoRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "video" field.
  String? _video;
  String get video => _video ?? '';
  bool hasVideo() => _video != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _video = snapshotData['video'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('sign_language_video');

  static Stream<SignLanguageVideoRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SignLanguageVideoRecord.fromSnapshot(s));

  static Future<SignLanguageVideoRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => SignLanguageVideoRecord.fromSnapshot(s));

  static SignLanguageVideoRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SignLanguageVideoRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SignLanguageVideoRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SignLanguageVideoRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SignLanguageVideoRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SignLanguageVideoRecord &&
      reference.path.hashCode == other.reference.path.hashCode;

  @override
  Map<String, DebugDataField> toDebugSerializableMap() => {
        'reference': debugSerializeParam(
          reference,
          ParamType.DocumentReference,
          link:
              'https://app.flutterflow.io/project/chattest-fwf3ic?tab=database',
          name: '',
          nullable: false,
        ),
        'name': debugSerializeParam(
          name,
          ParamType.String,
          link:
              'https://app.flutterflow.io/project/chattest-fwf3ic?tab=database',
          name: 'String',
          nullable: false,
        ),
        'video': debugSerializeParam(
          video,
          ParamType.String,
          link:
              'https://app.flutterflow.io/project/chattest-fwf3ic?tab=database',
          name: 'String',
          nullable: false,
        )
      };
}

Map<String, dynamic> createSignLanguageVideoRecordData({
  String? name,
  String? video,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'video': video,
    }.withoutNulls,
  );

  return firestoreData;
}

class SignLanguageVideoRecordDocumentEquality
    implements Equality<SignLanguageVideoRecord> {
  const SignLanguageVideoRecordDocumentEquality();

  @override
  bool equals(SignLanguageVideoRecord? e1, SignLanguageVideoRecord? e2) {
    return e1?.name == e2?.name && e1?.video == e2?.video;
  }

  @override
  int hash(SignLanguageVideoRecord? e) =>
      const ListEquality().hash([e?.name, e?.video]);

  @override
  bool isValidKey(Object? o) => o is SignLanguageVideoRecord;
}
