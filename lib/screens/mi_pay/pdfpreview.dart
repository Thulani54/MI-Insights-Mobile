import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PDFScreen extends StatefulWidget {
  final String? path;

  PDFScreen({Key? key, this.path}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  String? pdfPath; // Store the path to the PDF

  @override
  void initState() {
    super.initState();
    loadPDFFromAssets(); // Load PDF when the widget initializes
  }

  // Load PDF from assets
  Future<void> loadPDFFromAssets() async {
    final pdfData =
        await rootBundle.load(widget.path!); // Replace with your PDF asset path
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/sample.pdf');
    await tempFile.writeAsBytes(pdfData.buffer.asUint8List());
    setState(() {
      pdfPath = tempFile.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MI Pay Training Guide"),
        actions: <Widget>[],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          if (pdfPath != null)
            PDFView(
              filePath: pdfPath,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: true,
              pageSnap: true,
              defaultPage: currentPage!,
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
                print(error.toString());
              },
              onPageError: (page, error) {
                setState(() {
                  errorMessage = '$page: ${error.toString()}';
                });
                print('$page: ${error.toString()}');
              },
              onViewCreated: (PDFViewController pdfViewController) {
                _controller.complete(pdfViewController);
              },
              onLinkHandler: (String? uri) {
                print('goto uri: $uri');
              },
              onPageChanged: (int? page, int? total) {
                print('page change: $page/$total');
                setState(() {
                  currentPage = page;
                });
              },
            ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              label: Text("Next page"),
              onPressed: () async {
                if (currentPage! < pages!) {
                  int nextpage = currentPage! + 1;
                  await snapshot.data!.setPage(nextpage);
                }
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
