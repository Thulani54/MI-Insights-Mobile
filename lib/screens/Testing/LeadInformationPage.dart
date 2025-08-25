import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';
import '../../constants/Constants.dart';
import '../../HomePage.dart';
import '../../services/sharedpreferences.dart';

class Category {
  final int id;
  final String name;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] ?? 0,
        name: json['name'] ?? "",
        description: json['description'] ?? "",
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
      };
}

class GetQuestion {
  final int id;
  final Category category;
  final String title;
  final String description;
  final bool isVisible;
  final DateTime timestamp;
  //final DateTime lastUpdate;
  final List<Option> options;

  GetQuestion({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.isVisible,
    required this.timestamp,
    //required this.lastUpdate,
    required this.options,
  });

  factory GetQuestion.fromJson(Map<String, dynamic> json) => GetQuestion(
        id: json['id'] ?? 0,
        category: Category.fromJson(json['category']),
        title: json['title'] ?? "",
        description: json['description'] ?? "",
        isVisible: json['is_visible'] ?? false,
        timestamp: DateTime.parse(json['timestamp']),
        // lastUpdate: DateTime.parse(json['last_update']),
        options:
            List<Option>.from(json['options'].map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category.toJson(),
        'title': title,
        'description': description,
        'is_visible': isVisible,
        'timestamp': timestamp.toIso8601String(),
        //'last_update': lastUpdate.toIso8601String(),
        'options': options.map((x) => x.toJson()).toList(),
      };
}

class Option {
  final int id;
  final String text;
  final int scaleValue;
  final double weightValue;
  final bool isVisible;
  final DateTime timestamp;
  final DateTime? lastUpdate;

  Option({
    required this.id,
    required this.text,
    required this.scaleValue,
    required this.weightValue,
    required this.isVisible,
    required this.timestamp,
    this.lastUpdate,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json['id'] ?? 0,
        text: json['text'] ?? "",
        scaleValue: json['scale_value'] ?? 0,
        weightValue: json['weight_value'] ?? 0.0,
        isVisible: json['is_visible'] ?? false,
        timestamp: DateTime.parse(json['timestamp']),
        lastUpdate: json['last_update'] != null
            ? DateTime.tryParse(json['last_update'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'scale_value': scaleValue,
        'weight_value': weightValue,
        'is_visible': isVisible,
        'timestamp': timestamp.toIso8601String(),
        'last_update': lastUpdate?.toIso8601String(),
      };
}

class Question {
  final int id;
  final String title;
  final String? description;
  final bool isVisible;
  final String timestamp;
  final String? lastUpdate;
  final List<Option> options;

  Question({
    required this.id,
    required this.title,
    this.description,
    required this.isVisible,
    required this.timestamp,
    this.lastUpdate,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var optionsJson = json['options'] as List;
    List<Option> optionsList =
        optionsJson.map((i) => Option.fromJson(i)).toList();

    return Question(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isVisible: json['is_visible'],
      timestamp: json['timestamp'],
      lastUpdate: json['last_update'],
      options: optionsList,
    );
  }
}

class LeadInformationPage extends StatefulWidget {
  const LeadInformationPage({Key? key}) : super(key: key);

  @override
  State<LeadInformationPage> createState() => _LeadInformationPageState();
}

class _LeadInformationPageState extends State<LeadInformationPage> {
  PageController _pageController = PageController();
  List<GetQuestion> _allQuestions = [];
  Map<int, Option?> _selectedOptions = {};
  Map<int, List<GetQuestion>> groupedByCategoryId = {};
  int currentQuestionIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyCompleted();
    fetchAndGroupQuestions();
  }

  Future<void> _checkIfAlreadyCompleted() async {
    bool? isCompleted = await Sharedprefs.getLeadCompletedSharedPreference();
    if (isCompleted == true) {
      // Navigate to MyHomePage if already completed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MyHomePage()));
      });
    }
  }

  Future<void> _loadSavedProgress() async {
    // Load saved responses
    String? savedResponsesJson =
        await Sharedprefs.getLeadResponsesSharedPreference();
    if (savedResponsesJson != null) {
      Map<String, dynamic> savedData = jsonDecode(savedResponsesJson);
      Map<int, Map<String, dynamic>> savedResponses = {};

      savedData.forEach((key, value) {
        savedResponses[int.parse(key)] = Map<String, dynamic>.from(value);
      });

      // Restore selected options
      for (var entry in savedResponses.entries) {
        int questionId = entry.key;
        Map<String, dynamic> optionData = entry.value;

        // Find the question and option
        for (var question in _allQuestions) {
          if (question.id == questionId) {
            for (var option in question.options) {
              if (option.id == optionData['id']) {
                _selectedOptions[questionId] = option;
                break;
              }
            }
            break;
          }
        }
      }
    }

    // Load saved progress
    int? savedProgress = await Sharedprefs.getLeadProgressSharedPreference();
    if (savedProgress != null && savedProgress < _allQuestions.length) {
      setState(() {
        currentQuestionIndex = savedProgress;
      });
      // Move to the saved position
      _pageController.animateToPage(
        savedProgress,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _saveProgress() async {
    // Save current responses
    Map<String, Map<String, dynamic>> responsesToSave = {};
    _selectedOptions.forEach((questionId, option) {
      if (option != null) {
        responsesToSave[questionId.toString()] = {
          'id': option.id,
          'text': option.text,
          'scaleValue': option.scaleValue,
          'weightValue': option.weightValue,
        };
      }
    });

    String responsesJson = jsonEncode(responsesToSave);
    await Sharedprefs.saveLeadResponsesSharedPreference(responsesJson);

    // Save current progress
    await Sharedprefs.saveLeadProgressSharedPreference(currentQuestionIndex);
  }

  Future<void> _clearSavedData() async {
    // Clear saved responses and progress
    await Sharedprefs.saveLeadResponsesSharedPreference('');
    await Sharedprefs.saveLeadProgressSharedPreference(0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchAndGroupQuestions() async {
    final url =
        Uri.parse('${Constants.blackBrokerUrl}micro_distribution/questions/');

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<GetQuestion> questions =
            data.map((item) => GetQuestion.fromJson(item)).toList();

        // Group questions by category
        for (var question in questions) {
          final categoryId = question.category.id;
          if (!groupedByCategoryId.containsKey(categoryId)) {
            groupedByCategoryId[categoryId] = [];
          }
          groupedByCategoryId[categoryId]!.add(question);
        }

        // Flatten all questions into a single list
        _allQuestions = [];
        groupedByCategoryId.values.forEach((questionList) {
          _allQuestions.addAll(questionList);
        });

        setState(() {
          isLoading = false;
        });

        // Load saved progress after questions are loaded
        await _loadSavedProgress();
      } else {
        print('Failed to fetch questions. Status Code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('An error occurred: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _nextQuestion() {
    if (currentQuestionIndex < _allQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _saveProgress(); // Save progress when moving to next question
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _saveProgress(); // Save progress when moving to previous question
    }
  }

  bool get canProceed {
    if (_allQuestions.isEmpty) return false;
    final currentQuestion = _allQuestions[currentQuestionIndex];
    return _selectedOptions.containsKey(currentQuestion.id) &&
        _selectedOptions[currentQuestion.id] != null;
  }

  Future<void> _submitForm() async {
    // Store context before async operations
    final BuildContext currentContext = context;

    String? uid = Constants.myUid;
    List<Map<String, dynamic>> responses =
        _selectedOptions.entries.map((entry) {
      Option? selectedOption = entry.value;
      return {
        'question': entry.key,
        'selected_option': selectedOption?.id,
        'weighted_score': selectedOption?.weightValue,
      };
    }).toList();

    var clientId = 123;
    var payload = {
      'client_id': clientId,
      'responses': responses,
    };

    TextStyle toastTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 13,
      fontWeight: FontWeight.w500,
      fontFamily: 'YuGothic',
    );

    try {
      var response = await http.post(
        Uri.parse('${Constants.blackBrokerUrl}micro_distribution/responses/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Responses submitted successfully ${response.body}');
        var resp = json.decode(response.body);

        // Mark as completed and clear saved data
        await Sharedprefs.saveLeadCompletedSharedPreference(true);
        await _clearSavedData();

        createOtp('$uid', "email");
        Sharedprefs.saveSignUpStepsIndexSharedPreference(3);

        if (currentContext.mounted) {
          MotionToast.success(
            height: 40,
            description: Text("${resp['message']}", style: toastTextStyle),
          ).show(currentContext);

          // Navigate to MyHomePage when completed
          Navigator.push(currentContext,
              MaterialPageRoute(builder: (context) => const MyHomePage()));
        }
      } else {
        print('Failed to submit responses');
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (currentContext.mounted) {
          MotionToast.error(
            height: 40,
            description:
                Text("Failed to submit responses", style: toastTextStyle),
          ).show(currentContext);
        }
      }
    } catch (e) {
      print('Error submitting form: $e');
      if (currentContext.mounted) {
        MotionToast.error(
          height: 40,
          description: Text("Network error occurred", style: toastTextStyle),
        ).show(currentContext);
      }
    }
  }

  Future<void> createOtp(String userId, String otpType) async {
    String url = '${Constants.blackBrokerUrl}create_otp/';

    Map<String, String> requestData = {
      'user': userId,
      'type': otpType,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = json.decode(response.body);
        Constants.currentStep = 3;
        // microDistributionRegValuePlus7.value++;
        print('OTP created successfully: ${responseData['otp_id']}');
      } else {
        final errorData = json.decode(response.body);
        print('Error creating OTP: ${errorData['error']}');
      }
    } catch (e) {
      print('Failed to send OTP request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          shadowColor: Colors.grey.withOpacity(0.3),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: Text('Lead Information'),
          foregroundColor: Colors.black,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_allQuestions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Lead Information'),
          shadowColor: Colors.grey.withOpacity(0.3),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Center(
          child: Text('No questions available'),
        ),
      );
    }

    final currentQuestion = _allQuestions[currentQuestionIndex];
    final isLastQuestion = currentQuestionIndex == _allQuestions.length - 1;
    final totalQuestions = _allQuestions.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Lead Information'),
        shadowColor: Colors.grey.withOpacity(0.3),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${currentQuestionIndex + 1} of $totalQuestions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${((currentQuestionIndex + 1) / totalQuestions * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Constants.ftaColorLight,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (currentQuestionIndex + 1) / totalQuestions,
                  backgroundColor: Colors.grey[300],
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Constants.ftaColorLight),
                ),
              ],
            ),
          ),

          // Question content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentQuestionIndex = index;
                });
              },
              itemCount: _allQuestions.length,
              itemBuilder: (context, index) {
                final question = _allQuestions[index];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Constants.ftaColorLight.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          question.category.name,
                          style: TextStyle(
                            color: Constants.ftaColorLight,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(height: 24),

                      // Question title
                      Text(
                        question.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),

                      SizedBox(height: 32),

                      // Options
                      Column(
                        children: question.options.map((option) {
                          final isSelected =
                              _selectedOptions[question.id] == option;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedOptions[question.id] = option;
                              });
                              _saveProgress(); // Save progress when option is selected
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 12),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Constants.ftaColorLight.withOpacity(0.1)
                                    : Colors.grey[50],
                                border: Border.all(
                                  color: isSelected
                                      ? Constants.ftaColorLight
                                      : Colors.grey[300]!,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? Constants.ftaColorLight
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: isSelected
                                            ? Constants.ftaColorLight
                                            : Colors.grey[400]!,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Icon(
                                            Icons.check,
                                            size: 12,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      option.text,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: isSelected
                                            ? Constants.ftaColorLight
                                            : Colors.black87,
                                        fontWeight: isSelected
                                            ? FontWeight.w500
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Navigation buttons
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Previous button
                if (currentQuestionIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousQuestion,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Constants.ftaColorLight),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Previous',
                        style: TextStyle(
                          color: Constants.ftaColorLight,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                if (currentQuestionIndex > 0) SizedBox(width: 12),

                // Next/Submit button
                Expanded(
                  child: ElevatedButton(
                    onPressed: canProceed
                        ? (isLastQuestion ? _submitForm : _nextQuestion)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.ftaColorLight,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isLastQuestion ? 'Submit' : 'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
