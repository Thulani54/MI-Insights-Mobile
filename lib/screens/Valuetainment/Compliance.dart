import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;
import 'package:iconsax/iconsax.dart';
import 'package:mi_insights/screens/page_flip/page_flip_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

import '../../constants/Constants.dart';
import '../../models/ValutainmentModels.dart';
import '../../services/MyNoyifier.dart';
import '../../services/inactivitylogoutmixin.dart';
import '../Sales Agent/ExecutiveMicrolearnReport.dart';
import 'FlipWidgets.dart';
import 'ResultsWidget.dart';
import 'StartQuestionaire.dart';

List<LearnItem> learn_item = [];
TextEditingController _searchContoller = TextEditingController();
UniqueKey uq1 = UniqueKey();
UniqueKey uq2 = UniqueKey();
UniqueKey uq3 = UniqueKey();
UniqueKey uq4 = UniqueKey();
List<Module> modules_list = [];
bool isLoadingModules = false;
List<String> assetPaths = [
  "assets/icons/sales_logo.svg",
  "assets/icons/collections_logo.svg",
  "assets/icons/claims_logo.svg",
  "assets/icons/customers.svg",
  "assets/icons/communications_logo.svg",
  "assets/icons/commission_logo.svg",
  "assets/icons/maintanence_report.svg",
  "assets/icons/attendance.svg",
  "assets/icons/policy_search.svg",
  "assets/icons/reprint_logo.svg",
  "assets/icons/people_matters.svg",
  "assets/icons/micro_l.svg",
];
String getRandomSvg() {
  final random = Random();
  int index = random.nextInt(assetPaths.length);
  return assetPaths[index];
}

class SectionGrid extends StatelessWidget {
  final List<Module> sections;

  SectionGrid({required this.sections});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 8,
        crossAxisCount: 4,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 1.4),
      ),
      itemCount: sections.length,
      padding: EdgeInsets.all(2.0),
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            if (Constants.account_type == "executive") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExecutiveComplianceReport(),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Compliance(
                    moduleid: sections[index].module_id,
                    modulename: sections[index].title,
                    duration: sections[index].duration,
                  ),
                ),
              );
            }
          },
          child: Container(
            height: 290,
            width: MediaQuery.of(context).size.width / 2.5,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 0.0, right: 8),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          child: Card(
                            elevation: 6,
                            surfaceTintColor: Colors.white,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(360),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.04),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: Offset(0, -2),
                                  ),
                                ],
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 370,
                              margin:
                                  EdgeInsets.only(right: 0, left: 0, bottom: 4),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SvgPicture.asset(
                                  getRandomSvg(),
                                  color: Constants.ctaColorLight,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 55,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              sections[index].title,
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SectionDetailPage extends StatelessWidget {
  final ModuleSectionModel section;

  SectionDetailPage({required this.section});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.current_valuetainment_sectionsList.length < 1
            ? section.title
            : Constants
                .current_valuetainment_sectionsList[selected_module].module),
      ),
      body: Constants.current_valuetainment_sectionsList.isNotEmpty
          ? SectionGrid(sections: modules_list)
          : Center(
              child: Text('No subsections available'),
            ),
    );
  }
}

class ModulesPage extends StatefulWidget {
  final String moduleid;
  const ModulesPage({Key? key, required this.moduleid}) : super(key: key);

  @override
  _ModulesPageState createState() => _ModulesPageState();
}

class _ModulesPageState extends State<ModulesPage> {
  List<ModuleSectionModel> generateSectionsList(String jsonString) {
    final data = jsonDecode(jsonString);
    if (data['sections'] != null) {
      return (data['sections'] as List)
          .map((item) => ModuleSectionModel.fromMap(item))
          .toList();
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    getModules(widget.moduleid);

    setState(() {});
    //add a listener her
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                // restartInactivityTimer();
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            widget.moduleid,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          elevation: 6,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black.withOpacity(0.6),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          // Constants.ctaColorLight,
                          //Constants.ctaColorLight.withOpacity(0.5),
                          Colors.grey.withOpacity(0.55),
                          Colors.white,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                  "assets/business_logos/pop_and_spin2.png")),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: Padding(
                      padding:
                          const EdgeInsets.only(left: 0.0, bottom: 4, top: 8),
                      child: Text(
                        "MODULES",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16, bottom: 12),
                  child: Container(
                    height: 1,
                    decoration:
                        BoxDecoration(color: Colors.grey.withOpacity(0.15)),
                  ),
                ),
                isLoadingModules == true
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Constants.ctaColorLight),
                        ),
                      )
                    : modules_list.length == 0
                        ? Center(
                            child: Text(
                              "No modules found",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16),
                            child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                key: uq4,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: modules_list.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Compliance(
                                                  moduleid: modules_list[index]
                                                      .module_id,
                                                  modulename:
                                                      modules_list[index].title,
                                                  duration: modules_list[index]
                                                      .duration,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(8)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 5,
                                                        blurRadius: 7,
                                                        offset: Offset(0, 3),
                                                      ),
                                                    ],
                                                  ),
                                                  height: 125,
                                                  width: 80,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(8),
                                                      topRight:
                                                          Radius.circular(8),
                                                      bottomLeft:
                                                          Radius.circular(8),
                                                      bottomRight:
                                                          Radius.circular(8),
                                                    ),
                                                    child: Image.network(
                                                        Constants
                                                                .InsightsReportsbaseUrl +
                                                            modules_list[index]
                                                                .image_url,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    modules_list[index].title,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: Text(
                                                      "Duration " +
                                                          modules_list[index]
                                                              .duration
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    "Added ${timeago.format(DateTime.parse(modules_list[index].timestamp))}",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {},
                                                        child: Icon(
                                                          Icons
                                                              .thumb_up_outlined,
                                                          size: 16,
                                                        ),
                                                      ),
                                                      Text(
                                                        "  ${modules_list[index].likes} Likes | ${modules_list[index].views} Views "
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Colors.black),
                                                        maxLines: 2,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 16, bottom: 12),
                                        child: Container(
                                          height: 1,
                                          decoration: BoxDecoration(
                                              color: Colors.grey
                                                  .withOpacity(0.15)),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getModules(String moduleType) async {
    setState(() {
      isLoadingModules = true;
    });

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'GET',
        Uri.parse(
            '${Constants.InsightsReportsbaseUrl}/api/valuetainment/valuetainment_modules/all?cec_client_id=${Constants.cec_client_id}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseString);
      print("uoiio0 $jsonResponse");

      setState(() {
        modules_list = (jsonResponse['modules'] as List)
            .map((item) => Module.fromJson(item))
            .where((module) =>
                module.module == moduleType) // Filter by module type
            .toList();
        isLoadingModules = false;
      });
    } else {
      print("uoiio1 ${response.reasonPhrase}");
      setState(() {
        isLoadingModules = false;
      });
    }
  }
}

class Compliance extends StatefulWidget {
  final int moduleid;
  final String modulename;
  final int duration;

  const Compliance({
    super.key,
    required this.moduleid,
    required this.modulename,
    required this.duration,
  });
  @override
  State<Compliance> createState() => _ComplianceState();
}

Widget total_flip_widget = Container();
int page_index = 0;
bool isLoadingAssessments = false;
int selected_module = 0;
Key key1 = UniqueKey();
Map<int, List<PageContentItem>> groupedContentItems = {};

class _ComplianceState extends State<Compliance> with InactivityLogoutMixin {
  String template = "A001";

  List<PageContentItem> content_items = [];
  List<PageContent> page_content = [];
  int topic_index = 0;

  bool isLoadingAssessments = false;
  bool isLoadingTopics = false;
  Map topicsData = {};
  TextEditingController _searchContoller = TextEditingController();
  List<TopicItem> generateTopicsList(String jsonString) {
    final data = jsonDecode(jsonString);
    if (data['topics'] != null) {
      return (data['topics'] as List)
          .map((item) => TopicItem.fromJson(item))
          .toList();
    }
    generate_topics_questions(selected_module);
    compliancepage3Value.value++;
    return [];
  }

  @override
  void initState() {
    super.initState();
    fetchTopics(widget.moduleid);
    Constants.assessmentKey = topic_index.toString();
    /* Constants.current_valuetainment_topicsList =
        generateTopicsList(topicsDataString);*/
    Constants.percentage_completed = 0;

    getQuestionnaires();

    myNotifier = MyNotifier(compliancepage4Value, context);
    generate_topics_questions(selected_module);
    compliancepage4Value.addListener(() {
      if (mounted) setState(() {});
    });
  }

  Future<void> fetchTopics(int moduleId) async {
    Constants.current_module_id = moduleId;
    print("dffgfgfhg ${moduleId}");
    final response = await http.get(
      Uri.parse(
          '${Constants.InsightsReportsbaseUrl}/api/valuetainment/get_topics_by_module_id/$moduleId/'),
    );
    print("dfgffgfhdfdfgfgf ${moduleId}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        Constants.current_valuetainment_topicsList = [];
        data['topics'].forEach((topic) {
          Constants.current_valuetainment_topicsList
              .add(TopicItem.fromJson(topic));
        });
        generate_topics_questions(selected_module);
        isLoadingTopics = false;
      });
    } else {
      print(response.body);
      Constants.current_valuetainment_topicsList = [];
      print('Failed to load topics');
      setState(() {
        isLoadingTopics = false;
      });
      _loadPageIndex().then((val) {
        Constants.percentage_completed = val;
      });
    }
  }

  void generate_topics_questions(int selected_module) {
    print("Module changed to $selected_module");
    groupedContentItems = {};
    total_flip_widget = Container();
    if (Constants.current_valuetainment_topicsList.isEmpty) {
      setState(() {});
      return;
    }

    for (var item in Constants
        .current_valuetainment_topicsList[selected_module].contentItems) {
      if (!groupedContentItems.containsKey(item.page)) {
        groupedContentItems[item.page] = [];
      }
      groupedContentItems[item.page]!.add(item);
    }
    key1 = UniqueKey();
    total_flip_widget = TopicFlipWidget(
        key: key1,
        template: template,
        onPageChanged: null,
        page_content: page_content,
        selected_module: selected_module);
    pf1.goToPage(0);

    setState(() {});
  }

  Future<double> _loadPageIndex() async {
    Constants.percentage_completed = 0;
    if (Constants.current_valuetainment_topicsList.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String assessment_id = Constants
          .current_valuetainment_topicsList[selected_module].id
          .toString();

      List<String>? visitedPages =
          prefs.getStringList('visited_pages13$assessment_id') ?? [];

      int totalSlides = Constants
          .current_valuetainment_topicsList[selected_module]
          .contentItems
          .length;
      double progressPercentage = visitedPages.length / totalSlides;

      setState(() {
        Constants.percentage_completed =
            progressPercentage > 1 ? 1 : progressPercentage;
      });
    }

    return Constants.percentage_completed;
  }

  bool is_partaking_assessment = false;
  bool displaying_video = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: InkWell(
                onTap: () {
                  restartInactivityTimer();
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
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
              Constants.current_valuetainment_sectionsList.length < 1
                  ? widget.modulename
                  : Constants
                      .current_valuetainment_sectionsList[selected_module]
                      .title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            elevation: 6,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.black.withOpacity(0.6),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (isLoadingAssessments == false)
                      Container(
                          child: displaying_video == true
                              ? VideoApp()
                              : total_flip_widget),

                    /* if (selected_module != -1)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget
                                .modules[selected_module].page_data.length,
                            itemBuilder: (context, index1) {
                              Map? m1 = widget
                                  .modules[selected_module].page_data[index1];
                              if (m1 != null) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (index1 == 0)
                                      SizedBox(
                                        height: 12,
                                      ),
                                    if (index1 == 0)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          "Topics",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    if (index1 == 0)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          height: 1,
                                          decoration: BoxDecoration(
                                              color: Colors.grey
                                                  .withOpacity(0.15)),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Text(
                                        "${index1 + 1})" + m1["title"] ?? "",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: page_index == index1
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                );
                              } else
                                Container();
                            }),
                      ),*/
                    if (isLoadingAssessments == false &&
                        Constants.current_valuetainment_topicsList.isEmpty)
                      Container(
                        height: MediaQuery.of(context).size.height - 150,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            "No topics available for the selected module",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    if (isLoadingAssessments == false &&
                        Constants.current_valuetainment_topicsList.isNotEmpty)
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, bottom: 8, top: 8, right: 8),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8, top: 0.0, bottom: 0),
                                  child: InkWell(
                                    onTap: () async {
                                      bool allow_start_assessment = true;

                                      List<Future<void>> futures = [];
                                      for (var item in Constants
                                          .current_valuetainment_topicsList) {
                                        futures.add(getProgressPercentage(
                                                item.id.toString())
                                            .then((val) {
                                          if (val < 1) {
                                            print("dggffg $val");
                                            allow_start_assessment = false;
                                          }
                                        }));
                                      }

                                      // Wait for all futures to complete
                                      await Future.wait(futures);

                                      if (allow_start_assessment) {
                                        checkAttemptsExhausted(
                                                widget.moduleid, context)
                                            .then((val) {
                                          print("fdgffg " + val.toString());
                                          if (val == true) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    StartQuestionaire(
                                                  assessmentname: 'Compliance',
                                                  assessmentid: widget.moduleid,
                                                  duration: widget.duration,
                                                ),
                                              ),
                                            );
                                          }
                                        });
                                      } else {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (dialogContext) {
                                            return StatefulBuilder(
                                              builder:
                                                  (BuildContext dialogContext,
                                                      StateSetter setState) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  surfaceTintColor:
                                                      Colors.white,
                                                  title:
                                                      const Text('Incomplete'),
                                                  content: Text(
                                                      'Please go through all the topics before starting the assessment'),
                                                  actions: <Widget>[
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      dialogContext)
                                                                  .pop();
                                                            },
                                                            child: Container(),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      dialogContext)
                                                                  .pop();
                                                            },
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Constants
                                                                    .ctaColorLight,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            360),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            14.0,
                                                                        right:
                                                                            14,
                                                                        top: 5,
                                                                        bottom:
                                                                            5),
                                                                child:
                                                                    const Text(
                                                                  'Close',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Constants.ctaColorLight,
                                            borderRadius:
                                                BorderRadius.circular(360)),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 24,
                                              top: 4.0,
                                              right: 24,
                                              bottom: 4),
                                          child: Center(
                                              child: Text(
                                            "Start Assessment",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                        )),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8, top: 0.0, bottom: 0),
                                  child: InkWell(
                                    onTap: () {
                                      viewResults(context, -1);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Constants.ctaColorLight,
                                            borderRadius:
                                                BorderRadius.circular(360)),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 24,
                                              top: 4.0,
                                              right: 24,
                                              bottom: 4),
                                          child: Center(
                                              child: Text(
                                            "My Results",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    if (isLoadingAssessments == false &&
                        Constants.current_valuetainment_topicsList.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 8, right: 8, top: 4, bottom: 4),
                                child: Container(
                                  height: 40,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(360),
                                    child: Material(
                                      elevation: 10,
                                      color: Colors.white,
                                      child: TextFormField(
                                        autofocus: false,
                                        decoration: InputDecoration(
                                          hintText: 'Topic Search',
                                          hintStyle: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          filled: true,
                                          fillColor:
                                              Colors.grey.withOpacity(0.09),
                                          contentPadding:
                                              EdgeInsets.only(left: 24),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.0)),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.0)),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        controller: _searchContoller,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16, bottom: 8, top: 12),
                      child: Container(
                        height: 1,
                        decoration:
                            BoxDecoration(color: Colors.grey.withOpacity(0.15)),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    isLoadingAssessments == true
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: CircularProgressIndicator(
                                color: Constants.ctaColorLight,
                                strokeWidth: 1.8,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16, bottom: 16),
                            child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                key: uq4,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: Constants
                                    .current_valuetainment_topicsList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: InkWell(
                                      onTap: () {
                                        is_partaking_assessment = true;
                                        selected_module = index;
                                        if (index == 0) {
                                          compliancepage1Value.value++;
                                        }
                                        if (index == 1) {
                                          compliancepage2Value.value++;
                                        }
                                        Constants.percentage_completed = 0;
                                        _loadPageIndex().then((val) {
                                          print("dfgffgfh $val");
                                          Constants.percentage_completed = val;
                                        });
                                        generate_topics_questions(
                                            selected_module);

                                        compliancepage3Value.value++;
                                        /* selected_module = Constants
                                            .current_valuetainment_sectionsList[
                                                index]
                                            .id;*/

                                        print("asgsjhsa ${selected_module}");
                                        uq1 = UniqueKey();
                                        setState(() {});
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 5,
                                                      blurRadius: 7,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                height: 120,
                                                width: 120,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                  child: Center(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            8),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            8)),
                                                                child: Image.network(
                                                                    Constants
                                                                            .InsightsReportsbaseUrl +
                                                                        Constants
                                                                            .current_valuetainment_topicsList[
                                                                                index]
                                                                            .image,
                                                                    fit: BoxFit
                                                                        .cover),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 4,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    FutureBuilder<
                                                                        double>(
                                                                  future: getProgressPercentage(Constants
                                                                      .current_valuetainment_topicsList[
                                                                          index]
                                                                      .id
                                                                      .toString()),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    if (snapshot
                                                                            .connectionState ==
                                                                        ConnectionState
                                                                            .waiting) {
                                                                      return LinearPercentIndicator(
                                                                        animation:
                                                                            false,
                                                                        lineHeight:
                                                                            4.0,
                                                                        animationDuration:
                                                                            500,
                                                                        percent:
                                                                            0,
                                                                        barRadius: const ui
                                                                            .Radius.circular(
                                                                            12),
                                                                        progressColor:
                                                                            Colors.green,
                                                                      );
                                                                    } else if (snapshot
                                                                        .hasError) {
                                                                      return Text(
                                                                          "Error loading progress");
                                                                    } else {
                                                                      double
                                                                          progress =
                                                                          snapshot.data ??
                                                                              0.0;
                                                                      return LinearPercentIndicator(
                                                                        animation:
                                                                            false,
                                                                        lineHeight:
                                                                            4.0,
                                                                        animationDuration:
                                                                            500,
                                                                        percent:
                                                                            progress,
                                                                        barRadius: const ui
                                                                            .Radius.circular(
                                                                            12),
                                                                        progressColor:
                                                                            Colors.green,
                                                                      );
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 4,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                Constants
                                                    .current_valuetainment_topicsList[
                                                        index]
                                                    .title,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Text(
                                                  "Duration " +
                                                      convertMinsToHoursMins(
                                                          Constants
                                                              .current_valuetainment_topicsList[
                                                                  index]
                                                              .duration),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                "Last Updated | ${timeago.format(DateTime.parse(Constants.current_valuetainment_topicsList[index].timestamp))}",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      updateModuleLikes(
                                                          Constants
                                                              .current_valuetainment_topicsList[
                                                                  index]
                                                              .id,
                                                          Constants
                                                              .cec_employeeid);
                                                    },
                                                    child: Icon(
                                                      Icons.thumb_up_outlined,
                                                      size: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    "  ${Constants.current_valuetainment_topicsList[index].likes} Likes | ${Constants.current_valuetainment_topicsList[index].views} Views "
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black),
                                                    maxLines: 2,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                  ]),
            ),
          ),
        ));
  }

  getTopicContent(int index) async {
    isLoadingAssessments = true;
    setState(() {});
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('${Constants.baseUrl2}/files/get-questionnaires/'));
    request.body = json.encode({"cec_client_id": 1});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      isLoadingAssessments = false;
      setState(() {});
      learn_item = [];
      String responseString = await response.stream.bytesToString();
      List l1 = jsonDecode(responseString);
      setState(() {
        learn_item = l1.map((json) => LearnItem.fromJson(json)).toList();
      });
      // print(learn_item);
    } else {
      isLoadingAssessments = false;
      setState(() {});
      print(response.reasonPhrase);
    }
  }

  Future<double> getProgressPercentage(String assessmentKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String assessment_id = Constants
        .current_valuetainment_topicsList[selected_module].id
        .toString();

    List<String>? visitedPages =
        prefs.getStringList('visited_pages13$assessmentKey') ?? [];

    int module_index = Constants.current_valuetainment_topicsList
        .indexWhere((element) => element.id.toString() == assessmentKey);

    if (module_index == -1) {
      // Handle the case where the module is not found
      return 0;
    }
    Map<int, List<PageContentItem>> groupedContentItems2 = {};
    for (var item in Constants
        .current_valuetainment_topicsList[selected_module].contentItems) {
      if (!groupedContentItems2.containsKey(item.page)) {
        groupedContentItems2[item.page] = [];
      }
      groupedContentItems2[item.page]!.add(item);
    }

    int totalSlides = groupedContentItems2.length + 3;

    // Ensure that totalSlides is not zero to avoid division by zero
    double progressPercentage =
        totalSlides > 0 ? visitedPages.length / totalSlides : 0;

    print(
        "module_index2 $assessmentKey ${visitedPages.length} / $totalSlides = $progressPercentage");

    return progressPercentage > 1 ? 1 : progressPercentage;
  }

  getQuestionnaires() async {
    isLoadingAssessments = true;
    setState(() {});
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('${Constants.baseUrl2}/files/get-questionnaires/'));
    getTopicContent(topic_index);
    request.body = json.encode({"cec_client_id": 1});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      isLoadingAssessments = false;
      setState(() {});
      learn_item = [];
      String responseString = await response.stream.bytesToString();
      List l1 = jsonDecode(responseString);
      setState(() {
        learn_item = l1.map((json) => LearnItem.fromJson(json)).toList();
      });
      // print(learn_item);
    } else {
      isLoadingAssessments = false;
      setState(() {});
      print(response.reasonPhrase);
    }
  }

  String convertMinsToHoursMins(int minutes) {
    int hours = minutes ~/ 60;
    int mins = minutes % 60;
    return '${hours}h ${mins}m';
  }

  Future<void> updateModuleLikes(int topicId, int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String viewedTopicsKey =
        Constants.cec_employeeid.toString() + "_" + 'liked_topics';
    List<String> viewedTopics = prefs.getStringList(viewedTopicsKey) ?? [];

    if (viewedTopics.contains(topicId.toString())) {
      print("Topic $topicId already viewed.");
      return; // If the topic was already viewed, do nothing.
    }

    // Add the topic to viewed topics list and update shared preferences.
    viewedTopics.add(topicId.toString());
    await prefs.setStringList(viewedTopicsKey, viewedTopics);

    String baseUrl = Constants.InsightsReportsbaseUrl +
        "/api/valuetainment/update_module_likes/";
    Map payload = {
      "topic_id": topicId,
      "user_id": userId,
    };

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        Map responseData = jsonDecode(response.body);
        if (responseData["success"] == true) {
          Fluttertoast.showToast(
            msg: "Topic liked!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Constants.current_valuetainment_topicsList
              .where((element) => element.id == topicId)
              .first
              .likes++;
          if (mounted) setState(() {});
          print(
              "Updated views successfully. Topic views: ${responseData["topic_views"]}, Module views: ${responseData["module_views"]}");
        } else {}
      } else {}
    } catch (error) {}
  }
}

PageFlipController pf1 = PageFlipController();

class TopicFlipWidget extends StatefulWidget {
  final int selected_module;
  final String template;
  final void Function(int)? onPageChanged;
  final List page_content;

  const TopicFlipWidget({
    super.key,
    required this.template,
    required this.onPageChanged,
    required this.page_content,
    required this.selected_module,
  });

  @override
  State<TopicFlipWidget> createState() => _TopicFlipWidgetState();
}

class _TopicFlipWidgetState extends State<TopicFlipWidget> {
  int topic_index = 0;
  void onPageChanged1(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String assessment_id = Constants
        .current_valuetainment_topicsList[selected_module].id
        .toString();

    List<String>? visitedPages =
        prefs.getStringList('visited_pages13$assessment_id') ?? [];

    if (!visitedPages.contains(value.toString())) {
      visitedPages.add(value.toString());
    }

    await prefs.setStringList('visited_pages13$assessment_id', visitedPages);

    int totalSlides = groupedContentItems.length + 3;

    double progressPercentage =
        totalSlides > 0 ? visitedPages.length / (totalSlides) : 0;

    setState(() {
      topic_index = value;
      Constants.percentage_completed =
          progressPercentage > 1 ? 1 : progressPercentage;
    });
    compliancepage4Value.value++;

    print(
        "Page1 changed to $value visitedPages :${visitedPages} $totalSlides percentage_completed1 ${Constants.percentage_completed}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 330,
          child: PageFlipWidget(
            key: ValueKey("flipw-${widget.selected_module}"),
            backgroundColor: Colors.white,
            initialIndex: 0,
            onPageChanged: widget.onPageChanged ?? onPageChanged1,
            lastPage: Container(
                color: Colors.white,
                child: const Center(child: Text('Last Page!'))),
            controller: pf1,
            children: <Widget>[
              page1(
                key: ValueKey("page1-${widget.selected_module}"),
                index: widget.selected_module,
                template: widget.template,
              ),
              page2(
                key: ValueKey("page2-${widget.selected_module}"),
                template: widget.template,
                index: widget.selected_module,
              ),
              for (int page in groupedContentItems.keys)
                genericpage(
                  key:
                      ValueKey("generic-page${page}-${widget.selected_module}"),
                  selected_mod: widget.selected_module,
                  template: widget.template,
                  page_number: page,
                  items: groupedContentItems[page]!,
                ),
            ],
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  if (topic_index > 0) {
                    setState(() {
                      topic_index--;
                    });
                    pf1.goToPage(topic_index);
                  }
                },
                child: Text(
                  "Previous Page",
                  style: TextStyle(
                      color: (topic_index > 0)
                          ? Constants.ctaColorLight
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: (topic_index > 0)
                          ? Constants.ctaColorLight
                          : Colors.grey),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  int totalSlides = Constants
                      .current_valuetainment_topicsList[widget.selected_module]
                      .contentItems
                      .length;
                  if (topic_index < totalSlides - 1) {
                    setState(() {
                      topic_index++;
                    });
                    pf1.goToPage(topic_index);
                  }
                },
                child: Text(
                  "Next Page",
                  style: TextStyle(
                      color: Constants.ctaColorLight,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Constants.ctaColorLight),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          Constants
              .current_valuetainment_topicsList[widget.selected_module].title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 16.0, right: 16, bottom: 8, top: 24),
          child: Container(
            height: 1,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.15)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8),
          child: Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              const Text("Study Progress"),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FutureBuilder<double>(
                    future: getProgressPercentage1(Constants
                        .current_valuetainment_topicsList[selected_module].id
                        .toString()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LinearPercentIndicator(
                          animation: false,
                          lineHeight: 20.0,
                          animationDuration: 500,
                          center: Text(
                            "0%",
                            style: const TextStyle(fontSize: 11),
                          ),
                          barRadius: const ui.Radius.circular(12),
                          percent: 0,
                          progressColor: Colors.green,
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error loading progress");
                      } else {
                        double progress = snapshot.data ?? 0.0;
                        return LinearPercentIndicator(
                          animation: false,
                          lineHeight: 20.0,
                          animationDuration: 500,
                          center: Text(
                            "${(progress * 100).toStringAsFixed(1)}%",
                            style: const TextStyle(fontSize: 11),
                          ),
                          percent: progress,
                          barRadius: const ui.Radius.circular(12),
                          progressColor: Colors.green,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    myNotifier = MyNotifier(compliancepage3Value, context);
    compliancepage3Value.addListener(() {
      if (mounted) setState(() {});
      Future.delayed(Duration(seconds: 2)).then((value) {
        if (mounted) setState(() {});
      });
    });
  }

  Future<double> getProgressPercentage1(String assessmentKey) async {
    print("dfdf ${assessmentKey}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? visitedPages =
        prefs.getStringList('visited_pages13$assessmentKey') ?? [];

    int module_index = Constants.current_valuetainment_topicsList
        .indexWhere((element) => element.id.toString() == assessmentKey);

    if (module_index == -1) {
      // Handle the case where the module is not found
      return 0;
    }
    Map<int, List<PageContentItem>> groupedContentItems2 = {};
    if (kDebugMode) {
      print(
          "fggfgh $assessmentKey $selected_module${Constants.current_valuetainment_topicsList[selected_module].title} contentItems ${Constants.current_valuetainment_topicsList[selected_module].contentItems.length}");
    }
    updateModuleViews(int.parse(assessmentKey), Constants.cec_client_id);
    for (var item in Constants
        .current_valuetainment_topicsList[selected_module].contentItems) {
      if (!groupedContentItems2.containsKey(item.page)) {
        groupedContentItems2[item.page] = [];
      }
      groupedContentItems2[item.page]!.add(item);
    }

    int totalSlides = groupedContentItems2.length + 2;

    // Ensure that totalSlides is not zero to avoid division by zero
    double progressPercentage =
        totalSlides > 0 ? visitedPages.length / totalSlides : 0;

    if (kDebugMode) {
      print(
          "module_index1 $assessmentKey ${visitedPages.length} / $totalSlides = $progressPercentage");
    }

    return progressPercentage > 1 ? 1 : progressPercentage;
  }

  Future<void> updateModuleViews(int topicId, int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String viewedTopicsKey =
        Constants.cec_employeeid.toString() + "_" + 'viewed_topics';
    List<String> viewedTopics = prefs.getStringList(viewedTopicsKey) ?? [];

    if (viewedTopics.contains(topicId.toString())) {
      print("Topic $topicId already viewed.");
      return; // If the topic was already viewed, do nothing.
    }

    // Add the topic to viewed topics list and update shared preferences.
    viewedTopics.add(topicId.toString());
    await prefs.setStringList(viewedTopicsKey, viewedTopics);

    String baseUrl = Constants.InsightsReportsbaseUrl +
        "/api/valuetainment/update_module_views/";
    Map payload = {
      "topic_id": topicId,
      "user_id": userId,
    };

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        Map responseData = jsonDecode(response.body);
        if (responseData["success"] == true) {
          Constants.current_valuetainment_topicsList
              .where((element) => element.id == topicId)
              .first
              .likes++;
          setState(() {});
          print(
              "Updated views successfully. Topic views: ${responseData["topic_views"]}, Module views: ${responseData["module_views"]}");
        } else {}
      } else {}
    } catch (error) {}
  }
}

String convertMinsToHoursMins(int totalMinutes) {
  int hours = totalMinutes ~/ 60;
  int minutes = totalMinutes % 60;
  if (hours > 0) {
    return '${hours}h ${minutes}m';
  } else {
    return '${minutes} min';
  }
}

String formatWithLeadingZero(int number) {
  if (number < 10 && number >= 0) {
    return '0$number';
  } else {
    return number.toString();
  }
}

Future<bool> checkAttemptsExhausted(int moduleId, BuildContext context) async {
  String baseUrl = Constants.InsightsReportsbaseUrl +
      "/api/valuetainment/check_attempts_exhausted/";
  Map payload = {
    "employee_id": Constants.cec_employeeid,
    "cec_client_id": Constants.cec_client_id,
    "module_id": moduleId,
  };

  try {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      Map responseData = jsonDecode(response.body);
      if (responseData["exhausted"] == true) {
        print(" Remaining attempts: ${responseData["remaining_attempts"]}");
        MotionToast.success(
          onClose: () {},
          description: Text(
            "Attempts completed!",
            style: TextStyle(color: Colors.white),
          ),
        ).show(context);

        return false;
      } else {
        //Constants.currentAttempt = responseData["remaining_attempts"];
        print(
            "Attempts not exhausted. Remaining attempts: ${responseData["remaining_attempts"]}");
        Fluttertoast.showToast(
          msg:
              "Attempts not exhausted. Remaining attempts: ${responseData["remaining_attempts"]}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return true;
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to your check attempts",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return true;
    }
  } catch (error) {
    Fluttertoast.showToast(
      msg: "An error occurred: $error",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return true;
  }
}

class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
