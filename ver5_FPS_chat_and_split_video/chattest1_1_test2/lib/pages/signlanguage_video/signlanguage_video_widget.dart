import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/create_sign_language_name/create_sign_language_name_widget.dart';
import '/pages/slr_component/slr_component_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'signlanguage_video_model.dart';
export 'signlanguage_video_model.dart';

class SignlanguageVideoWidget extends StatefulWidget {
  const SignlanguageVideoWidget({super.key});

  @override
  State<SignlanguageVideoWidget> createState() =>
      _SignlanguageVideoWidgetState();
}

class _SignlanguageVideoWidgetState extends State<SignlanguageVideoWidget>
    with RouteAware {
  late SignlanguageVideoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignlanguageVideoModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, DebugModalRoute.of(context)!);
    debugLogGlobalProperty(context);
  }

  @override
  void didPopNext() {
    safeSetState(() => _model.isRouteVisible = true);
    debugLogWidgetClass(_model);
  }

  @override
  void didPush() {
    safeSetState(() => _model.isRouteVisible = true);
    debugLogWidgetClass(_model);
  }

  @override
  void didPop() {
    _model.isRouteVisible = false;
  }

  @override
  void didPushNext() {
    _model.isRouteVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    DebugFlutterFlowModelContext.maybeOf(context)
        ?.parentModelCallback
        ?.call(_model);
    _model.slrComponentModels.clear();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(
                'assets/images/Background.png',
              ).image,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(0.0, -1.0),
                child: Stack(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      height: 107.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: Image.asset(
                            'assets/images/header_fix3.png',
                          ).image,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, -1.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            15.0, 15.0, 15.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlutterFlowIconButton(
                              borderColor: FlutterFlowTheme.of(context).info,
                              borderRadius: 8.0,
                              borderWidth: 1.0,
                              buttonSize: 30.0,
                              icon: Icon(
                                Icons.arrow_back,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 15.0,
                              ),
                              onPressed: () async {
                                context.safePop();
                              },
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  25.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Sign Language Video',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                            ),
                            FlutterFlowIconButton(
                              borderColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              borderRadius: 8.0,
                              borderWidth: 1.0,
                              buttonSize: 30.0,
                              icon: Icon(
                                Icons.add,
                                color: FlutterFlowTheme.of(context).info,
                                size: 12.0,
                              ),
                              onPressed: () async {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  enableDrag: false,
                                  context: context,
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      child: Padding(
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
                                        child: CreateSignLanguageNameWidget(),
                                      ),
                                    );
                                  },
                                ).then((value) => safeSetState(() {}));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: StreamBuilder<List<SignLanguageVideoRecord>>(
                      stream: querySignLanguageVideoRecord(),
                      builder: (context, snapshot) {
                        // Customize what your widget looks like when it's loading.
                        if (!snapshot.hasData) {
                          return Center(
                            child: SizedBox(
                              width: 50.0,
                              height: 50.0,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            ),
                          );
                        }
                        List<SignLanguageVideoRecord>
                            columnSignLanguageVideoRecordList = snapshot.data!;

                        _model.debugBackendQueries[
                                'columnSignLanguageVideoRecordList_Column_0uc7qygv${columnSignLanguageVideoRecordList.length > 100 ? ' (first 100)' : ''}'] =
                            debugSerializeParam(
                          columnSignLanguageVideoRecordList.take(100),
                          ParamType.Document,
                          isList: true,
                          link:
                              'https://app.flutterflow.io/project/chattest-fwf3ic?tab=uiBuilder&page=SignlanguageVideo',
                          name: 'sign_language_video',
                          nullable: false,
                        );
                        debugLogWidgetClass(_model);

                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: List.generate(
                                columnSignLanguageVideoRecordList.length,
                                (columnIndex) {
                              final columnSignLanguageVideoRecord =
                                  columnSignLanguageVideoRecordList[
                                      columnIndex];
                              return Builder(builder: (_) {
                                return DebugFlutterFlowModelContext(
                                  rootModel: _model.rootModel,
                                  parentModelCallback: (m) {
                                    _model.slrComponentModels[
                                        'Key0ba_${columnIndex}_of_${columnSignLanguageVideoRecordList.length}'] = m;
                                  },
                                  child: SlrComponentWidget(
                                    key: Key(
                                        'Key0ba_${columnIndex}_of_${columnSignLanguageVideoRecordList.length}'),
                                    inputSLR: columnSignLanguageVideoRecord,
                                  ),
                                );
                              });
                            }).divide(SizedBox(height: 12.0)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
