// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownWidget extends StatefulWidget {
  const MarkdownWidget({
    Key? key,
    this.width,
    this.height,
    required this.mdcolor,
    required this.data,
    required this.fontFamily,
    required this.fontSize,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String data;
  final Color mdcolor;
  final String fontFamily;
  final double fontSize;

  @override
  _MarkdownWidgetState createState() => _MarkdownWidgetState();
}

class _MarkdownWidgetState extends State<MarkdownWidget> {
  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: widget.data,
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(
          fontFamily: widget.fontFamily,
          fontSize: widget.fontSize,
          color: widget.mdcolor,
        ),
        listBullet: TextStyle(
          fontFamily: widget.fontFamily,
          fontSize: widget.fontSize,
          color: widget.mdcolor,
        ),
        code: TextStyle(
          backgroundColor: Colors.transparent,
          fontFamily: widget.fontFamily,
          fontSize: widget.fontSize,
          color: widget.mdcolor,
        ),
        codeblockPadding: EdgeInsets.all(4),
        codeblockDecoration: BoxDecoration(
          color: widget.mdcolor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        blockquote: TextStyle(
          fontFamily: widget.fontFamily,
          fontSize: widget.fontSize,
          color: widget.mdcolor,
          fontStyle: FontStyle.italic,
        ),
        h1: TextStyle(
          fontFamily: widget.fontFamily,
          fontSize: widget.fontSize * 2,
          color: widget.mdcolor,
          fontWeight: FontWeight.bold,
        ),
        h2: TextStyle(
          fontFamily: widget.fontFamily,
          fontSize: widget.fontSize * 1.5,
          color: widget.mdcolor,
          fontWeight: FontWeight.bold,
        ),
        h3: TextStyle(
          fontFamily: widget.fontFamily,
          fontSize: widget.fontSize * 1.2,
          color: widget.mdcolor,
          fontWeight: FontWeight.bold,
        ),
        h4: TextStyle(
          fontFamily: widget.fontFamily,
          fontSize: widget.fontSize * 1.1,
          color: widget.mdcolor,
          fontWeight: FontWeight.bold,
        ),
        h5: TextStyle(
          fontFamily: widget.fontFamily,
          fontSize: widget.fontSize,
          color: widget.mdcolor,
          fontWeight: FontWeight.bold,
        ),
        h6: TextStyle(
          fontFamily: widget.fontFamily,
          fontSize: widget.fontSize,
          color: widget.mdcolor,
          fontWeight: FontWeight.bold,
        ),
        em: TextStyle(
          fontFamily: widget.fontFamily,
          fontSize: widget.fontSize,
          color: widget.mdcolor,
          fontStyle: FontStyle.italic,
        ),
        strong: TextStyle(
          fontFamily: widget.fontFamily,
          fontSize: widget.fontSize,
          color: widget.mdcolor,
          fontWeight: FontWeight.bold,
        ),
        del: TextStyle(
          fontFamily: widget.fontFamily,
          fontSize: widget.fontSize,
          color: widget.mdcolor,
          decoration: TextDecoration.lineThrough,
        ),
        tableHead: TextStyle(
          fontFamily: widget.fontFamily,
          fontSize: widget.fontSize,
          color: widget.mdcolor,
          fontWeight: FontWeight.bold,
        ),
        tableBody: TextStyle(
          fontFamily: widget.fontFamily,
          fontSize: widget.fontSize,
          color: widget.mdcolor,
        ),
      ),
    );
  }
}
