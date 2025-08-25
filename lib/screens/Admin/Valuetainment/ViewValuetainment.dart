import 'package:flutter/material.dart';

import '../../../constants/Constants.dart';
import '../../../customwidgets/custom_input.dart';
import '../../../models/ValutainmentModels.dart';

class ViewValuetainment extends StatefulWidget {
  final Module module_info;
  const ViewValuetainment({super.key, required this.module_info});

  @override
  State<ViewValuetainment> createState() => _ViewValuetainmentState();
}

class _ViewValuetainmentState extends State<ViewValuetainment> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController maximumAttemptsController = TextEditingController();
  TextEditingController attemptsQuestionsController = TextEditingController();
  TextEditingController passPercentageController = TextEditingController();
  TextEditingController likesController = TextEditingController();
  TextEditingController viewsController = TextEditingController();
  TextEditingController moduleController = TextEditingController();
  TextEditingController timestampController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode durationFocusNode = FocusNode();
  FocusNode maximumAttemptsFocusNode = FocusNode();
  FocusNode attemptsQuestionsFocusNode = FocusNode();
  FocusNode passMarkFocusNode = FocusNode();
  FocusNode moduleFocusNode = FocusNode();
  FocusNode timestampFocusNode = FocusNode();
  FocusNode imageFocusNode = FocusNode();
  FocusNode dataFocusNode = FocusNode();
  FocusNode pageDataFocusNode = FocusNode();
  FocusNode subSectionsFocusNode = FocusNode();
  String moduleEndDate = "Select Date";
  String moduleStartDate = "Select Date";
  bool isLoading = false;
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
              )),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Manage Course Structure",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            if (Constants.allowed_add_assessments)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(360),
                        color: Constants.ctaColorLight),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    )),
              ),
          ],
          elevation: 6,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black.withOpacity(0.6),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 24, bottom: 12),
                child: Row(
                  children: [
                    Text(
                      "Title",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: CustomInputTransparent(
                  controller: titleController,
                  hintText: "Title",
                  focusNode: titleFocusNode,
                  textInputAction: TextInputAction.next,
                  onChanged: (String) {},
                  onSubmitted: (String) {},
                  isPasswordField: false,
                ),
              ),
              // Description
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 24, bottom: 12),
                child: Row(
                  children: [
                    Text(
                      "Description",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: CustomInputTransparent(
                  controller: descriptionController,
                  hintText: "Description",
                  focusNode: descriptionFocusNode,
                  textInputAction: TextInputAction.next,
                  onChanged: (String) {},
                  onSubmitted: (String) {},
                  isPasswordField: false,
                ),
              ),
              // Duration
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 24, bottom: 12),
                child: Row(
                  children: [
                    Text(
                      "Duration (in minutes)",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: CustomInputTransparent(
                  controller: durationController,
                  hintText: "Duration (in minutes)",
                  focusNode: durationFocusNode,
                  textInputAction: TextInputAction.next,
                  onChanged: (String) {},
                  onSubmitted: (String) {},
                  isPasswordField: false,
                  integersOnly: true,
                ),
              ),
              // Maximum Attempts
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 24, bottom: 12),
                child: Row(
                  children: [
                    Text(
                      "Maximum Attempts",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: CustomInputTransparent(
                  controller: maximumAttemptsController,
                  hintText: "Maximum Attempts",
                  focusNode: maximumAttemptsFocusNode,
                  textInputAction: TextInputAction.next,
                  onChanged: (String) {},
                  onSubmitted: (String) {},
                  isPasswordField: false,
                  integersOnly: true,
                ),
              ),
              // Attempt Questions
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 24, bottom: 12),
                child: Row(
                  children: [
                    Text(
                      "Attempt Questions",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: CustomInputTransparent(
                  controller: attemptsQuestionsController,
                  hintText: "Number of questions for each attempt",
                  focusNode: attemptsQuestionsFocusNode,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {},
                  onSubmitted: (value) {},
                  isPasswordField: false,
                  integersOnly: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.module_info.title;
    descriptionController.text = widget.module_info.description;
    durationController.text = widget.module_info.duration.toString();
    maximumAttemptsController.text =
        widget.module_info.maximumAttempts.toString();
    //attemptsQuestionsController.text = widget.module_info.attempts_questions.toString();
    //passPercentageController.text = widget.module_info.pass.toString();
    likesController.text = widget.module_info.likes.toString();
    viewsController.text = widget.module_info.views.toString();
    moduleController.text = widget.module_info.module.toString();
    timestampController.text = widget.module_info.timestamp.toString();
    imageController.text = widget.module_info.image_url.toString();
    dataController.text = widget.module_info.data.toString();
    //notesController.text = widget.module_info.notes.toString();
  }
}
