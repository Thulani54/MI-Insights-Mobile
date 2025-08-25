import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mi_insights/constants/Constants.dart';
import 'package:mi_insights/customwidgets/CustomCard.dart';

import '../../models/ValutainmentModels.dart';

class FAQs extends StatefulWidget {
  const FAQs({super.key});

  @override
  State<FAQs> createState() => _FAQsState();
}

class _FAQsState extends State<FAQs> {
  List<ValuetainmentFAQ> faqs = [];
  Map<String, List<ValuetainmentFAQ>> groupedFaqs = {};
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          shadowColor: Colors.grey.withOpacity(0.45),
          elevation: 6,
          backgroundColor: Colors.white,
          title: const Text(
            "Frequently Asked Questions",
            style: TextStyle(color: Colors.black),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              CupertinoIcons.back,
              color: Colors.black,
              size: 24,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display all categories
                ...groupedFaqs.keys.map((category) {
                  return Stack(
                    children: [
                      if (selectedCategory == category)
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0, left: 16),
                          child: Container(
                            constraints: BoxConstraints(minHeight: 200),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(0)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16.0),
                                ...groupedFaqs[selectedCategory!]!
                                    .map((faq) => Padding(
                                          padding:
                                              const EdgeInsets.only(top: 18.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.15)),
                                              color: Colors.white
                                                  .withOpacity(0.85),
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        faq.isExpanded =
                                                            !faq.isExpanded;
                                                      });
                                                    },
                                                    child: Row(children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Question ${(groupedFaqs[selectedCategory!]!.indexOf(faq) + 1)}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                              SizedBox(
                                                                height: 6,
                                                              ),
                                                              Text(
                                                                faq.question,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: InkWell(
                                                          child: Icon(
                                                            faq.isExpanded
                                                                ? Icons
                                                                    .keyboard_arrow_up
                                                                : Icons
                                                                    .keyboard_arrow_down,
                                                          ),
                                                          onTap: () {},
                                                        ),
                                                      ),
                                                    ]),
                                                  ),
                                                  if (faq.isExpanded)
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16.0,
                                                          vertical: 8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            height: 1,
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.15),
                                                          ),
                                                          SizedBox(height: 8.0),
                                                          Text(
                                                            "Answer:",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          SizedBox(height: 8.0),
                                                          Text(
                                                            faq.answer,
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                          ),
                                                          SizedBox(height: 8.0),
                                                          Text(
                                                            "Steps:",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          ...faq.howToSteps
                                                              .map(
                                                                  (step) =>
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            bottom:
                                                                                8.0),
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "${step.stepNo}. ",
                                                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(
                                                                                step.text,
                                                                                style: TextStyle(fontSize: 14),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ],
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory =
                                selectedCategory == category ? null : category;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: CustomCard2(
                            elevation: 6,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36),
                            ),
                            boderRadius: 36,
                            child: ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              horizontalTitleGap: 0,
                              minVerticalPadding: 0,
                              title: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  width: 60,
                                  child: Row(
                                    children: [
                                      Text(
                                        groupedFaqs[category]!
                                            .length
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Icon(
                                        selectedCategory == category
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getAllFaqs();
  }

  getAllFaqs() async {
    // Fetch all FAQs from the server and group them by category
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            '${Constants.InsightsReportsbaseUrl}/api/valuetainment/get_faqs_by_module/'));
    request.body = json.encode({"module_id": 76});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String faqResponse = await response.stream.bytesToString();
      Map<String, dynamic> faqsJson = jsonDecode(faqResponse);
      faqs = faqsJson['faqs']
          .map<ValuetainmentFAQ>((faq) => ValuetainmentFAQ.fromJson(faq))
          .toList();

      if (faqs.isNotEmpty) {
        for (ValuetainmentFAQ faq in faqs) {
          if (groupedFaqs.containsKey(faq.category)) {
            groupedFaqs[faq.category]!.add(faq);
          } else {
            groupedFaqs[faq.category] = [];
            groupedFaqs[faq.category]!.add(faq);
          }
        }
      }
      setState(() {});
    } else {
      print(response.reasonPhrase);
    }
  }
}

class CategoryWidget extends StatelessWidget {
  final String categoryName;
  final List<String> items;

  CategoryWidget({required this.categoryName, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            categoryName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: ListTile(
                  title: Text(items[index]),
                  trailing: Icon(Icons.keyboard_arrow_down_outlined),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
