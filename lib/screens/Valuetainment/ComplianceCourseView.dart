import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/Constants.dart';
import '../../models/ValutainmentModels.dart';
import '../page_flip/page_flip_widget.dart';

class ComplianceCourseView extends StatefulWidget {
  final String modulename;
  final List<ModuleSectionModel> modules;

  ComplianceCourseView({required this.modulename, required this.modules});

  @override
  _ComplianceCourseViewState createState() => _ComplianceCourseViewState();
}

int current_index = 0;

class _ComplianceCourseViewState extends State<ComplianceCourseView> {
  List<File> pptxFiles = [];
  List<String> imagePaths = [];
  final _controller = GlobalKey<PageFlipWidgetState>();

  String template = "A001";

  Future<void> getAssessmentFilesList() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse('${Constants.baseUrl2}/files/get-files-for-assessment/'));
    request.body = json.encode({"cec_client_id": 1, "questionnaire_id": 1});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> data = jsonDecode(responseString);
      print("qww ${data}");

      if (data["files"] != null) {
        for (var file in data["files"]) {
          int id = file["id"];
          await getAssessmentFile(id);
        }
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> getAssessmentFile(int id) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('${Constants.baseUrl2}/files/get_assessment_file/'));
    request.body =
        json.encode({"cec_client_id": 1, "questionnaire_id": 1, "file_id": id});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      List<int> bytes = await response.stream.toBytes();
      Directory tempDir = await getTemporaryDirectory();
      File file = File('${tempDir.path}/$id.pptx');
      await file.writeAsBytes(bytes);

      setState(() {
        pptxFiles.add(file);
      });

      // Convert PPTX to images (this should be handled by a backend service or third-party library)
      List<String> images = await convertPptxToImages(file);
      setState(() {
        imagePaths.addAll(images);
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<List<String>> convertPptxToImages(File file) async {
    // Implement PPTX to images conversion logic (this might involve calling a backend service)
    // For demonstration, returning an empty list.
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          actions: [
            Constants.isAudioEnabled
                ? Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: InkWell(
                        borderRadius: BorderRadius.circular(360),
                        onTap: () {
                          Constants.isAudioEnabled = false;
                          setState(() {});
                          Constants.player3.setAsset(
                              "lib/assets/audio/Ambient Chill Music [Full Tracks]  Royalty Free Background Music.mp3");
                          Constants.player3.play();
                        },
                        child: Icon(Iconsax.volume_high)))
                : Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: InkWell(
                        borderRadius: BorderRadius.circular(360),
                        onTap: () {
                          Constants.isAudioEnabled = true;
                          setState(() {});
                          Constants.player3.stop();
                        },
                        child: Icon(Iconsax.volume_cross)),
                  ),
          ],
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            widget.modulename,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          elevation: 6,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black.withOpacity(0.6),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
