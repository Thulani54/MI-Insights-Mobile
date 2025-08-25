import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../constants/Constants.dart';
import '../../customwidgets/CustomCard.dart';
import '../../models/ValutainmentModels.dart';

void viewResults(context, int score) {
  /* Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SalesAgentComplianceReport(),
    ),
  );*/
  showCompletionDialog(context, 0, "");
}

void showCompletionDialog(BuildContext context, double score, String result) {
  showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            buttonPadding: EdgeInsets.only(top: 0.0, left: 0, right: 0),
            insetPadding: EdgeInsets.only(left: 8.0, right: 8),
            titlePadding: EdgeInsets.only(right: 0),
            surfaceTintColor: Colors.white,
            contentPadding: const EdgeInsets.only(left: 0.0),
            content: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  /*   Text(
                    Constants.current_valuetainment_topicsList[selected_module]
                        .title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,*/
                  //),
                  //),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Icon(Iconsax.close_circle),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  if (score > 0)
                    Center(
                      child: Icon(Iconsax.tick_circle,
                          size: 60, color: Constants.ctaColorLight),
                    ),
                  SizedBox(height: 12),
                  if (score > 0)
                    Center(
                      child: Text(
                        "Completed!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (score > 0) SizedBox(height: 20),
                  if (score > 0)
                    Center(
                      child: Text(
                        'Your Score for this assessment is ${score.toInt()}%',
                        style: TextStyle(
                          color: Constants.ctaColorLight,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (score > 0) SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Previous Attempts',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Divider(color: Colors.grey.withOpacity(0.25)),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: FutureBuilder<List<Attempt>>(
                      future: loadAttempts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 200,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: Constants.ctaColorLight,
                                    strokeWidth: 1.8,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error loading attempts',
                            style: TextStyle(color: Colors.black),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text(
                            'No attempts found',
                            style: TextStyle(color: Colors.black),
                          );
                        } else {
                          final attempts = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: attempts.take(3).map((attempt) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Container(
                                  child: CustomCard(
                                    color: Colors.white,
                                    elevation: 6,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 12),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  attempt.score >=
                                                          Constants
                                                              .valuetainment_pass_mark
                                                      ? "Passed"
                                                      : "Failed",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                Spacer(),
                                                Text(
                                                  "${attempt.score}%",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                )
                                              ],
                                            ),
                                          ),
                                          LinearPercentIndicator(
                                            animation: false,
                                            lineHeight: 20.0,
                                            animationDuration: 500,
                                            center: Text(
                                              "${attempt.score}%",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: attempt.score > 50
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            percent: attempt.score / 100,
                                            barRadius: const Radius.circular(0),
                                            progressColor: attempt.score > 50
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                          SizedBox(height: 12),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16.0,
                                                            right: 16),
                                                    child: Center(
                                                      child: Text(
                                                        "# of Attempt",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Container(
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16.0,
                                                            right: 16),
                                                    child: Center(
                                                      child: Text(
                                                        "${attempt.attempt}",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  "${Constants.valuetainment_pass_mark}% Pass Mark",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                  Divider(color: Colors.white),
                  if (score > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: InkWell(
                                onTap: () {
                                  // _saveProgress();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Constants.ctaColorLight),
                                    borderRadius: BorderRadius.circular(360),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        "Attempt again",
                                        style: TextStyle(
                                          color: Constants.ctaColorLight,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (score > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(ctx).pop();
                                  Navigator.of(ctx).pop();
                                  // viewResults(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Constants.ctaColorLight,
                                    borderRadius: BorderRadius.circular(360),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        "Back to Home",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
      });
}

Future<List<Attempt>> loadAttempts() async {
  try {
    final url = Uri.parse(
        '${Constants.InsightsReportsbaseUrl}/api/valuetainment/get_employee_results/?cec_client_id=${Constants.cec_client_id}&cec_employeeid=${Constants.cec_employeeid}');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['success'] == true) {
        List<Attempt> attempts = [];
        var results = jsonResponse['results'] as List;

        for (var result in results) {
          var moduleAttempts = result['attempts'] as List;
          for (var attemptJson in moduleAttempts) {
            if (kDebugMode) {
              print("attemptJson1 $attemptJson");
            }
            attempts.add(Attempt.fromJson(attemptJson));
            if (kDebugMode) {
              print("attempts_length ${attempts.length}");
            }
          }
        }

        return attempts;
      } else {
        throw Exception('Failed to load attempts: ${jsonResponse['error']}');
      }
    } else {
      throw Exception(
          'Failed to load attempts with status code: ${response.statusCode}');
    }
  } catch (e) {
    print("Error: $e");
    throw Exception('Failed to load attempts: $e');
  }
}
