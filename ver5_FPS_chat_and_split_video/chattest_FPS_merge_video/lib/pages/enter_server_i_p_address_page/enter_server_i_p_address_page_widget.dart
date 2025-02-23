import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'enter_server_i_p_address_page_model.dart';
import 'package:http/http.dart' as http;
export 'enter_server_i_p_address_page_model.dart';

class EnterServerIPAddressPageWidget extends StatefulWidget {
  const EnterServerIPAddressPageWidget({super.key});

  @override
  State<EnterServerIPAddressPageWidget> createState() =>
      _EnterServerIPAddressPageWidgetState();
}

class _EnterServerIPAddressPageWidgetState
    extends State<EnterServerIPAddressPageWidget> with RouteAware {
  late EnterServerIPAddressPageModel _model;
  final TextEditingController _ip1Controller = TextEditingController();
  final TextEditingController _ip2Controller = TextEditingController();
  final TextEditingController _ip3Controller = TextEditingController();
  final TextEditingController _ip4Controller = TextEditingController();
  final FocusNode _ip1Focus = FocusNode();
  final FocusNode _ip2Focus = FocusNode();
  final FocusNode _ip3Focus = FocusNode();
  final FocusNode _ip4Focus = FocusNode();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EnterServerIPAddressPageModel());
    
    // Phân tách IP address hiện tại thành các phần
    if (FFAppState().IPAddress.isNotEmpty) {
      final parts = FFAppState().IPAddress.split('.');
      if (parts.length == 4) {
        _ip1Controller.text = parts[0];
        _ip2Controller.text = parts[1];
        _ip3Controller.text = parts[2];
        _ip4Controller.text = parts[3];
      }
    }
  }

  @override
  void dispose() {
    _ip1Controller.dispose();
    _ip2Controller.dispose();
    _ip3Controller.dispose();
    _ip4Controller.dispose();
    _ip1Focus.dispose();
    _ip2Focus.dispose();
    _ip3Focus.dispose();
    _ip4Focus.dispose();
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

  Widget _buildIPInput(TextEditingController controller, FocusNode focusNode, FocusNode? nextFocus) {
    return Container(
      width: 55,
      height: 55,
      margin: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Color(0xFF151217),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 3,
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary,
              width: 2,
            ),
          ),
        ),
        style: FlutterFlowTheme.of(context).bodyMedium.override(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          LengthLimitingTextInputFormatter(3),
        ],
        onChanged: (value) {
          if (value.length > 0) {
            int? number = int.tryParse(value);
            if (number != null && number > 255) {
              controller.text = '255';
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            }
            if (value.length >= 3 && nextFocus != null) {
              nextFocus.requestFocus();
            }
          }
        },
      ),
    );
  }

  Future<bool> checkConnection(String ipAddress) async {
    try {
      final response = await http.get(
        Uri.parse('http://$ipAddress:8000/test'),
      ).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    DebugFlutterFlowModelContext.maybeOf(context)
        ?.parentModelCallback
        ?.call(_model);

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            Text(
                              FFAppState().vietnameseEnable 
                                ? 'Địa Chỉ IP' 
                                : 'IP Address',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.asset(
                        'assets/images/Background.png',
                      ).image,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          FFAppState().vietnameseEnable 
                            ? 'Nhập Địa Chỉ IP Máy Chủ' 
                            : 'Enter Server IP Address',
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                fontFamily: 'Poppins',
                                fontSize: 26.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                        Text(
                          FFAppState().vietnameseEnable 
                            ? 'Vui lòng nhập địa chỉ IP của máy chủ để kết nối' 
                            : 'Please enter the IP address of the server to connect',
                          style: FlutterFlowTheme.of(context)
                              .bodyLarge
                              .override(
                                fontFamily: 'Poppins',
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w300,
                              ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildIPInput(_ip1Controller, _ip1Focus, _ip2Focus),
                                Text(
                                  '.',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                                _buildIPInput(_ip2Controller, _ip2Focus, _ip3Focus),
                                Text(
                                  '.',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                                _buildIPInput(_ip3Controller, _ip3Focus, _ip4Focus),
                                Text(
                                  '.',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                                _buildIPInput(_ip4Controller, _ip4Focus, null),
                              ],
                            ),
                          ),
                        ),
                        FFButtonWidget(
                          onPressed: () async {
                            HapticFeedback.heavyImpact();
                            
                            // Kiểm tra xem tất cả các ô đã được nhập chưa
                            if (_ip1Controller.text.isEmpty || 
                                _ip2Controller.text.isEmpty || 
                                _ip3Controller.text.isEmpty || 
                                _ip4Controller.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    FFAppState().vietnameseEnable
                                      ? 'Vui lòng nhập đầy đủ địa chỉ IP'
                                      : 'Please enter complete IP address',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return;
                            }

                            // Tạo địa chỉ IP đầy đủ
                            final ipAddress = '${_ip1Controller.text}.${_ip2Controller.text}.${_ip3Controller.text}.${_ip4Controller.text}';
                            
                            // Hiển thị loading indicator
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );

                            // Kiểm tra kết nối
                            final isConnected = await checkConnection(ipAddress);
                            
                            // Đóng loading indicator
                            Navigator.pop(context);

                            if (isConnected) {
                              FFAppState().IPAddress = ipAddress;
                              context.pushNamed('chatPage');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    FFAppState().vietnameseEnable
                                      ? 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra lại địa chỉ IP và đảm bảo máy chủ đang hoạt động.'
                                      : 'Cannot connect to server. Please check the IP address and make sure the server is running.',
                                  ),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                          text: FFAppState().vietnameseEnable ? 'Kết Nối' : 'Connect',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 55,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'Inter Tight',
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                            elevation: 3,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ].divide(SizedBox(height: 10.0)),
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
