import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constants/Constants.dart';
import '../../models/ValutainmentModels.dart';
import '../../services/MyNoyifier.dart';
import 'Compliance.dart';

final compliancepage1Value = ValueNotifier<int>(0);
final compliancepage2Value = ValueNotifier<int>(0);
final compliancepage3Value = ValueNotifier<int>(0);
final compliancepage4Value = ValueNotifier<int>(0);
MyNotifier? myNotifier;

class page1 extends StatefulWidget {
  final int index;
  final String template;
  const page1({
    super.key,
    required this.index,
    required this.template,
  });

  @override
  State<page1> createState() => _page1State();
}

class _page1State extends State<page1> {
  @override
  Widget build(BuildContext context) {
    if (widget.template == "A001") {
      return Column(
        children: [
          Container(
            height: 330,
            child: Stack(children: [
              Container(
                height: 330,
                child: (Constants
                            .current_valuetainment_topicsList[selected_module]
                            .image !=
                        "")
                    ? Image.network(
                        Constants.InsightsReportsbaseUrl +
                            Constants
                                .current_valuetainment_topicsList[
                                    selected_module]
                                .image,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/valuetainment/backgrounds/Picture1_background.jpg",
                        fit: BoxFit.cover,
                      ),
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: (Constants
                                    .current_valuetainment_topicsList[
                                        selected_module]
                                    .image !=
                                "")
                            ? Container()
                            : Image.asset(
                                "assets/pop_and_spin/pop_and_spin4.png"),
                      )),
                  Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    Constants
                                        .current_valuetainment_topicsList[
                                            selected_module]
                                        .title,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Expanded(
                                    child: (Constants.logoUrl.isNotEmpty)
                                        ? Container(
                                            height: 130,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: CachedNetworkImage(
                                                imageUrl: Constants.logoUrl,
                                                fit: BoxFit.contain,
                                                placeholder: (context, url) =>
                                                    Container(
                                                        height: 50,
                                                        width: 50,
                                                        child: Container()),
                                                // errorWidget: (context, url, error) => Icon(Icons.error),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ),
                                ],
                              ),
                            ),
                          )),
                          SizedBox(
                            height: 24,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "HOSTED & ASSESSED BY",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ),
                              Container(
                                height: 70,
                                // color: Colors.black,
                                //width: MediaQuery.of(context).size.width,
                                child: Image.asset(
                                  "assets/static_logo_transparent (1).png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ))
                ],
              )
            ]),
          )
        ],
      );
    } else
      return Container();
  }

  @override
  void initState() {
    myNotifier = MyNotifier(compliancepage1Value, context);
    compliancepage1Value.addListener(() {
      uq1 = UniqueKey();

      if (mounted) setState(() {});
      Future.delayed(Duration(seconds: 2)).then((value) {
        if (mounted) setState(() {});
      });
    });
    super.initState();
  }
}

class page2 extends StatefulWidget {
  final int index;
  final String template;
  const page2({
    super.key,
    required this.index,
    required this.template,
  });

  @override
  State<page2> createState() => _page2State();
}

class _page2State extends State<page2> {
  @override
  Widget build(BuildContext context) {
    if (widget.template == "A001") {
      return Container(
        color: Colors.grey.withOpacity(0.1),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: 330,
              child: Stack(children: [
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container(
                          height: 330,
                          decoration: BoxDecoration(color: Color(0xff4F71BE)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                                "assets/pop_and_spin/pop_and_spin5.png"),
                          ),
                        )),
                    Expanded(
                        flex: 3,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ListView.builder(
                                    itemCount: Constants
                                        .current_valuetainment_topicsList[
                                            selected_module]
                                        .table_of_contents
                                        .length,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index1) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          360),
                                                  border: Border.all(
                                                    color: index1 % 2 == 0
                                                        ? Color(0xff4F71BE)
                                                        : Constants
                                                            .ctaColorLight,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    Constants
                                                        .current_valuetainment_topicsList[
                                                            selected_module]
                                                        .table_of_contents[
                                                            index1]
                                                        .index
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 11),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  Constants
                                                      .current_valuetainment_topicsList[
                                                          selected_module]
                                                      .table_of_contents[index1]
                                                      .text,
                                                  maxLines: 1,
                                                  style:
                                                      TextStyle(fontSize: 11),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            ],
                          ),
                        ))
                  ],
                )
              ]),
            )
          ],
        ),
      );
    } else
      return Container();
  }

  @override
  void initState() {
    myNotifier = MyNotifier(compliancepage2Value, context);
    compliancepage2Value.addListener(() {
      uq1 = UniqueKey();

      if (mounted) setState(() {});
      Future.delayed(Duration(seconds: 2)).then((value) {
        if (mounted) setState(() {});
      });
    });
    super.initState();
  }
}

class genericpage extends StatefulWidget {
  final String template;
  final int selected_mod;
  final int page_number;
  final List<PageContentItem> items;
  const genericpage(
      {super.key,
      required this.template,
      required this.page_number,
      required this.items,
      required this.selected_mod});

  @override
  State<genericpage> createState() => _genericpageState();
}

class _genericpageState extends State<genericpage> {
  @override
  void initState() {
    for (PageContentItem item in widget.items) {
      print("${item.id} ${item.text} ${item.type} ${item.page}");
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.template == "A001") {
      return Container(
        color: Colors.grey.withOpacity(0.1),
        child: Column(
          children: [
            SizedBox(height: 8),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    height: 55,
                    width: 55,
                    child: CachedNetworkImage(
                      imageUrl: Constants.logoUrl,
                      fit: BoxFit.fitHeight,
                      placeholder: (context, url) =>
                          SizedBox(height: 50, width: 50, child: Container()),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            formatWithLeadingZero(widget.page_number),
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            widget.items.isNotEmpty ? widget.items[0].text : '',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (widget.items.isNotEmpty && widget.items[0].topic.isNotEmpty)
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 12.0, right: 12, top: 4),
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 12),
                          child: Text(
                            widget.items[0].topic,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        for (PageContentItem contentItem in widget.items)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 4.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: contentItem.type.toLowerCase() == "heading"
                                  ? Text(
                                      contentItem.text,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : contentItem.type.toLowerCase() ==
                                          "paragraph"
                                      ? Text(
                                          contentItem.text,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        )
                                      : contentItem.type.toLowerCase() ==
                                              "bullet"
                                          ? Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("• ",
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                                Expanded(
                                                  child: Text(
                                                    contentItem.text,
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
