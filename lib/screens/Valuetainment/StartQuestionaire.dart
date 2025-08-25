import 'dart:async';
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/Constants.dart';
import '../../models/ValutainmentModels.dart';
import '../../services/log.dart';
import 'ResultsWidget.dart';

class StartQuestionaire extends StatefulWidget {
  final String assessmentname;
  final int assessmentid;
  final int duration;

  const StartQuestionaire({
    super.key,
    required this.assessmentname,
    required this.assessmentid,
    required this.duration,
  });

  @override
  State<StartQuestionaire> createState() => _StartQuestionaireState();
}

class _StartQuestionaireState extends State<StartQuestionaire>
    with SingleTickerProviderStateMixin {
  List<Question> questions = [];
  int currentIndex = 0;
  late Timer _timer;
  int _start = 3600; // 60 seconds for each assessment
  int _totalTime = 0;
  bool isLoading = true;
  double assesment_percentage_completed = 0;
  Key animate_do_key = UniqueKey();
  late AnimationController _animationController;
  late Animation<double> _animation;
  Future<List<Attempt>>? attemptsFuture;
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print("fgfg ${widget.assessmentid}");
    }

    onLogAction(-1, -1, "started", 0, "started");

    isLoading = true;
    setState(() {});
    _start = widget.duration * 60;

    fetchShuffledQuestions(Constants.cec_client_id, widget.assessmentid,
            Constants.cec_employeeid)
        .then((response) {
      if (response['success']) {
        attemptsFuture = loadAttempts();
        _loadProgress();
        currentIndex = 0;
        _startTimer();
      }
    });

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  void onLogAction(int questionId, int choiceId, String description,
      int? attemptId, String action) async {
    ValuetainmentLogResponseModel responseModel = await submitValuetainmentLog(
      cecClientId: Constants.cec_client_id,
      cecEmployeeId: Constants.cec_employeeid,
      moduleId: Constants.current_module_id,
      action: action,
      questionId: questionId,
      choiceId: choiceId,
      description: description,
      attemptId: attemptId,
    );
    print("responseModel ${responseModel.toJson()}");

    if (responseModel.timedOut) {
      if (kDebugMode) {
        print("Should submit attempt");
      }
      showCompletionDialog(
          context, responseModel.score ?? 0, responseModel.result ?? "passed");
    }

    if (responseModel.remainingTime != null) {
      double remainingTime = responseModel.remainingTime!;
      int minutes = remainingTime.floor();
      int seconds = ((remainingTime - minutes) * 60).round();

      int totalSeconds = (minutes * 60) + seconds;

      print("Remaining time in seconds: $totalSeconds");

      // If remaining time in total seconds is different from _start, update it
      if (_start != totalSeconds) {
        setState(() {
          _start = totalSeconds;
        });
      }
    }
  }

  Future<Map<String, dynamic>> fetchShuffledQuestions(
      int cecClientId, int moduleId, int employeeId) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${Constants.InsightsReportsbaseUrl}/api/valuetainment/shuffled_questions/all/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'cec_client_id': cecClientId,
          'module_type': "Compliance",
          'module_id': widget.assessmentid,
          'employee_id': employeeId,
        }),
      );
      if (kDebugMode) {
        print(response.body);
      }

      if (response.statusCode == 200) {
        isLoading = false;
        final jsonResponse = json.decode(response.body);
        bool allowAttempt = jsonResponse['allow_attempt'];
        questions = (jsonResponse['questions'] as List)
            .map((item) => Question.fromJson(item))
            .toList();
        setState(() {});
        print('questions: ${questions.length} ${questions.length}');
        return {
          'allow_attempt': allowAttempt,
          'questions': questions,
          'success': jsonResponse['success'],
        };
      } else {
        isLoading = false;
        setState(() {});
        print('Failed to load questions: ${response.reasonPhrase}');
        return {'success': false, 'error': response.reasonPhrase};
      }
    } catch (e) {
      print('Error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentIndex = 0;
      _totalTime = prefs.getInt('totalTime') ?? 0;

      for (var i = 0; i < questions.length; i++) {
        int? selectedChoice = prefs.getInt('selectedChoice_$i');
        if (selectedChoice != null) {
          questions[i].selectedChoice = selectedChoice;
        }
      }
      calculateProgress();
    });
  }

  void _saveProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentIndex', currentIndex);
    prefs.setInt('totalTime', _totalTime);

    for (var i = 0; i < questions.length; i++) {
      if (questions[i].selectedChoice != null) {
        prefs.setInt('${widget.assessmentid}_selectedChoice_$i',
            questions[i].selectedChoice!);
      }
    }

    MotionToast.success(
      height: 40,
      width: 300,
      onClose: () {},
      description: Text("Progress Saved."),
    ).show(context);
  }

  void _saveLastQuestion(int current_index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentIndex', current_index);
    prefs.setInt('totalTime', _totalTime);

    for (var i = 0; i < questions.length; i++) {
      if (questions[i].selectedChoice != null) {
        prefs.setInt('${widget.assessmentid}_selectedChoice_$i',
            questions[i].selectedChoice!);
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start > 0) {
        setState(() {
          _start--;
        });
      } else if (_start == 0.0) {
        _saveAttempt(context).then((value) async {
          if (value != null && value.statusCode == 200) {}
        });
      } else {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    animate_do_key = UniqueKey();
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
      });
      _saveLastQuestion(currentIndex);
    } else {
      // Handle quiz completion (e.g., show results)
    }
  }

  void _previousQuestion() {
    animate_do_key = UniqueKey();
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void _submitQuiz() {
    _timer.cancel();

    print('Quiz submitted. Total time: $_totalTime seconds');
    // _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Question question = Question(id: 0, text: '', choices: []);
    if (questions.length > 0) {
      question = questions[currentIndex];
    }

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
            widget.assessmentname,
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
        body: isLoading == true
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Constants.ctaColorLight),
                ),
              )
            : questions.length == 0
                ? Center(
                    child: Text(
                      "No questions available.",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            LinearProgressIndicator(
                              value: assesment_percentage_completed,
                              backgroundColor: Color(0xFFB4B4B4),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Constants.ctaColorLight,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 16.0, top: 8),
                                  child: Text(
                                    'Time left: ${convertSecondsToMins(_start)}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 8.0, top: 8),
                                  child: Text(
                                    'Question ${currentIndex + 1} of ${questions.length}',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 16, bottom: 16, top: 12),
                              child: Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FadeIn(
                                    duration: Duration(seconds: 3),
                                    key: animate_do_key,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          (1 + currentIndex).toString() +
                                              ") " +
                                              question.text,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 20),
                                        for (var choice in question.choices)
                                          ListTile(
                                            title: Text(choice.text),
                                            contentPadding:
                                                EdgeInsets.only(left: 0),
                                            dense: true,
                                            minLeadingWidth: 0,
                                            horizontalTitleGap: 0,
                                            leading: Radio<int>(
                                              value: choice.id,
                                              activeColor:
                                                  Constants.ctaColorLight,
                                              groupValue:
                                                  question.selectedChoice,
                                              onChanged: (value) {
                                                if (question.selectedChoice ==
                                                    null) {
                                                  onLogAction(
                                                      question.id,
                                                      choice.id,
                                                      "updated_submitted_question",
                                                      0,
                                                      "submitted_question_response");
                                                } else {
                                                  onLogAction(
                                                      question.id,
                                                      choice.id,
                                                      "submitted_question_response",
                                                      0,
                                                      "submitted_question_response");
                                                }
                                                int questionsLength =
                                                    questions.length;

                                                question.selectedChoice = value;
                                                print("choice_id " +
                                                    choice.id.toString());
                                                calculateProgress();

                                                setState(() {});
                                                if (currentIndex <
                                                    questionsLength - 1) {
                                                  _nextQuestion();
                                                }
                                              },
                                            ),
                                          ),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 100,
                              child: ElevatedButton(
                                onPressed: _previousQuestion,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: (currentIndex != 0)
                                        ? Constants.ctaColorLight
                                        : Colors.grey,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 4),
                                    textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal)),
                                child: Text(
                                  'Previous',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              ),
                            ),
                            Spacer(),
                            if (currentIndex < questions.length - 1)
                              Container(
                                width: 100,
                                child: ElevatedButton(
                                  onPressed: _nextQuestion,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Constants.ctaColorLight,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      textStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal)),
                                  child: Text(
                                    'Next',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (assesment_percentage_completed < 1.0)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: InkWell(
                                    onTap: () {
                                      _saveProgress();
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Constants.ctaColorLight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(360)),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text(
                                            "Save",
                                            style: TextStyle(
                                                color: Constants.ctaColorLight,
                                                fontWeight: FontWeight.w600),
                                          )),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (assesment_percentage_completed == 1.0)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (dialogContext) {
                                          return StatefulBuilder(
                                            builder:
                                                (BuildContext dailogcontext,
                                                    StateSetter setState) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                surfaceTintColor: Colors.white,
                                                title: const Text(
                                                    'Submit responses'),
                                                content: Text(
                                                    'Are you sure you would like to submit?'),
                                                actions: <Widget>[
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    dailogcontext)
                                                                .pop();
                                                            // Navigator.of(context).pop();
                                                          },
                                                          child: Text(
                                                            'Not now',
                                                            style: TextStyle(
                                                                color: Constants
                                                                    .ctaColorLight,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TextButton(
                                                          onPressed: () {
                                                            _saveAttempt(
                                                                    context)
                                                                .then(
                                                                    (value) async {
                                                              if (value !=
                                                                      null &&
                                                                  value.statusCode ==
                                                                      200) {}
                                                            });

                                                            //  _resetTimer();
                                                          },
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Constants
                                                                      .ctaColorLight,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              360)),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            24.0,
                                                                        right:
                                                                            24,
                                                                        top: 5,
                                                                        bottom:
                                                                            5),
                                                                child:
                                                                    const Text(
                                                                  'Submit',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              )),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Constants.ctaColorLight,
                                            borderRadius:
                                                BorderRadius.circular(360)),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text(
                                            "Submit",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
        /*  floatingActionButton: currentIndex < questions.length - 1
            ? FloatingActionButton(
                onPressed: _nextQuestion,
                child: Icon(Icons.arrow_forward),
              )
            : null,*/
      ),
    );
  }

  String convertSecondsToMins(int seconds) {
    if (seconds < 60) {
      return '$seconds seconds';
    } else {
      int mins = seconds ~/ 60; // Integer division to get the minutes
      int secs = seconds % 60; // Modulo to get the remaining seconds
      return '$mins minutes and $secs seconds';
    }
  }

  void calculateProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Calculate the number of completed questions
      int questionsLength = questions.length;
      int completedQuestions =
          questions.where((item) => item.selectedChoice != null).length;

      // Update the percentage of completed questions
      assesment_percentage_completed = completedQuestions / questionsLength;
      print(
          "Progress: $assesment_percentage_completed Completed Questions: $completedQuestions Total Questions: $questionsLength");

      // Store progress
      prefs.setInt('completedQuestions', completedQuestions);
      prefs.setInt('totalQuestions', questionsLength);

      // Store the selected choice for each question
      for (var i = 0; i < questions.length; i++) {
        if (questions[i].selectedChoice != null) {
          prefs.setInt('selectedChoice_$i', questions[i].selectedChoice!);
        }
      }
    });
  }

  Future<http.Response?> _saveAttempt(BuildContext context) async {
    List<Response> responses = questions
        .map((question) => Response(
              question: question.id.toString(),
              selectedChoice: question.selectedChoice.toString(),
              id: "0",
            ))
        .toList();

    Attempt newAttempt = Attempt(
      id: 0,
      cecClientId: Constants.cec_client_id,
      cecEmployeeId: Constants.cec_employeeid,
      employee: Constants.myDisplayname,
      module: Constants.current_module_id.toString(),
      score: 0,
      completedAt: DateTime.now().toString(),
      attempt: 0,
      attemptsLeft: 2,
      result: 'Passed',
      responses: responses,
      date: DateTime.now().toString(),
    );

    try {
      http.Response httpResponse = await http.post(
        Uri.parse(
            '${Constants.InsightsReportsbaseUrl}/api/valuetainment/submit_questionnaire/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(newAttempt.toJson()),
      );

      if (httpResponse.statusCode == 200) {
        print('Attempt saved successfully');
        Map m1 = jsonDecode(httpResponse.body);
        if (m1["success"] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          newAttempt.score = m1["score"] ?? 0;
          newAttempt.result = m1["result"] ?? "";
          List<String> attemptsString = prefs.getStringList('attempts') ?? [];
          attemptsString.add(jsonEncode(newAttempt.toJson()));
          prefs.setStringList('attempts', attemptsString);

          // Clear progress after successful submission
          prefs.remove('completedQuestions');
          prefs.remove('totalQuestions');
          for (var i = 0; i < questions.length; i++) {
            prefs.remove('selectedChoice_$i');
          }

          // Clear all selected choices
          for (var question in questions) {
            question.selectedChoice = null;
          }

          Fluttertoast.showToast(
            msg: "Attempt saved successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          showCompletionDialog(context, newAttempt.score, newAttempt.result);
        } else {
          print('Failed to save attempt');
          Fluttertoast.showToast(
            msg: "Failed to save attempt",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      }
    } catch (error) {
      print('Error: $error');
      Fluttertoast.showToast(
        msg: "An error occurred: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
