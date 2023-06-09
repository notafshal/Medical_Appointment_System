import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfReport extends StatefulWidget {
  final String? pdfPath;
  PdfReport({Key? key, this.pdfPath}) : super(key: key);

  @override
  State<PdfReport> createState() => _PdfReportState();
}

class _PdfReportState extends State<PdfReport> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Completer<PDFViewController> _controller =
        Completer<PDFViewController>();
    int? pages = 0;
    int? currentPage = 0;
    bool isReady = false;
    String errorMessage = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investigation Report'),
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.pdfPath,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
                false, // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              log(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              log('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              log('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              log('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
        ],
      ),
    );
  }
}
