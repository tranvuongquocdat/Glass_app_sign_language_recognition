import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/FPS_custom_functions.dart' as functions;
import '/pages/create_sign_language_name/create_sign_language_name_widget.dart';
import '/pages/slr_component/slr_component_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  final Map<String, Map<String, String>> labels = {
    'vi': {
      'search': 'Tìm kiếm...',
      'results': 'Tìm thấy',
      'vietnamese': 'Tiếng Việt',
      'english': 'Tiếng Anh',
    },
    'en': {
      'search': 'Search...',
      'results': 'Found',
      'vietnamese': 'Vietnamese',
      'english': 'English',
    },
  };

  String get currentLanguage => FFAppState().vietnameseEnable ? 'vi' : 'en';

  String getLabel(String key) => labels[currentLanguage]?[key] ?? '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignlanguageVideoModel());
  }

  @override
  void dispose() {
    searchController.dispose();
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
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset('assets/images/Background.png').image,
            ),
          ),
          child: Column(
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
                                FFAppState().vietnameseEnable ? 'Thư viện video thủ ngữ' : 'Sign Language Video Library',
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
                              borderColor: FlutterFlowTheme.of(context).primaryText,
                              borderRadius: 8.0,
                              borderWidth: 1.0,
                              buttonSize: 30.0,
                              icon: Icon(
                                Icons.language,
                                color: FlutterFlowTheme.of(context).info,
                                size: 15.0,
                              ),
                              onPressed: () async {
                                setState(() {
                                  FFAppState().vietnameseEnable = !FFAppState().vietnameseEnable;
                                });
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
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: getLabel('search'),
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value.toLowerCase();
                            });
                          },
                        ),
                      ),
                      TabBar(
                        isScrollable: false,
                        labelPadding: EdgeInsets.zero,
                        labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        tabs: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: _buildTab(
                              getLabel('vietnamese'),
                              functions.VideoConstants.wordSegments.length +
                                  functions.VideoConstants.VietnameseSentenceVideos.length
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: _buildTab(
                              getLabel('english'),
                              functions.VideoConstants.wordSegmentsEnglish.length +
                                  functions.VideoConstants.EnglishSentenceVideos.length
                            ),
                          ),
                        ],
                        labelColor: FlutterFlowTheme.of(context).primaryText,
                        unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
                        indicatorSize: TabBarIndicatorSize.tab,
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildVideoGrid([
                              ...functions.VideoConstants.wordSegments.entries
                                  .map((e) => VideoItem(title: e.key, path: e.value)),
                              ...functions.VideoConstants.VietnameseSentenceVideos.entries
                                  .map((e) => VideoItem(title: e.key, path: e.value)),
                            ].toList()),
                            
                            _buildVideoGrid([
                              ...functions.VideoConstants.wordSegmentsEnglish.entries
                                  .map((e) => VideoItem(title: e.key, path: e.value)),
                              ...functions.VideoConstants.EnglishSentenceVideos.entries
                                  .map((e) => VideoItem(title: e.key, path: e.value)),
                            ].toList()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String text, int count) {
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
          Text(
            '($count)',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoGrid(List<VideoItem> items) {
    final filteredItems = items.where((item) =>
        item.title.toLowerCase().contains(searchQuery)).toList();

    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          if (searchQuery.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                '${getLabel('results')} ${filteredItems.length} ${currentLanguage == 'vi' ? 'kết quả' : 'results'}',
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Expanded(
                        child: functions.CustomVideoPlayer(
                          assetPaths: [filteredItems[index].path],
                          fit: BoxFit.cover,
                          showControls: true,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          filteredItems[index].title,
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VideoItem {
  final String title;
  final String path;
  
  VideoItem({required this.title, required this.path});
}
