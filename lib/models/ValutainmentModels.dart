class ValuetainmentFile {
  final int id;
  final String title;
  final String format;
  final int duration;
  final String file;
  final String description;

  ValuetainmentFile({
    required this.id,
    required this.title,
    required this.format,
    required this.duration,
    required this.file,
    required this.description,
  });

  factory ValuetainmentFile.fromJson(Map<String, dynamic> json) {
    return ValuetainmentFile(
      id: json['id'],
      title: json['title'],
      format: json['format'],
      duration: json['duration'],
      file: json['file'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'format': format,
        'duration': duration,
        'file': file,
        'description': description,
      };
}

class Choice {
  final int id;
  final String text;
  final bool isCorrect;

  Choice({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      id: json['id'],
      text: json['text'],
      isCorrect: json['is_correct'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'is_correct': isCorrect,
      };
}

class ValuetainmentQuestion {
  final int id;
  final String text;
  final List<Choice> choices;

  ValuetainmentQuestion({
    required this.id,
    required this.text,
    required this.choices,
  });

  factory ValuetainmentQuestion.fromJson(Map<String, dynamic> json) {
    var choicesJson = json['choices'] as List;
    List<Choice> choicesList =
        choicesJson.map((choice) => Choice.fromJson(choice)).toList();

    return ValuetainmentQuestion(
      id: json['id'],
      text: json['text'],
      choices: choicesList,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'choices': choices.map((choice) => choice.toJson()).toList(),
      };
}

class Questionnaire {
  final int id;
  final int cecClientId;
  final int cecEmployeeId;
  final String title;
  final String description;
  final List<ValuetainmentQuestion> questions;
  final int duration;
  final int maximumAttempts;
  final List<ValuetainmentFile> files;

  Questionnaire({
    required this.id,
    required this.cecClientId,
    required this.cecEmployeeId,
    required this.title,
    required this.description,
    required this.questions,
    required this.duration,
    required this.maximumAttempts,
    required this.files,
  });

  factory Questionnaire.fromJson(Map<String, dynamic> json) {
    var questionsJson = json['questions'] as List;
    List<ValuetainmentQuestion> questionsList = questionsJson
        .map((question) => ValuetainmentQuestion.fromJson(question))
        .toList();

    var filesJson = json['files'] as List;
    List<ValuetainmentFile> filesList =
        filesJson.map((file) => ValuetainmentFile.fromJson(file)).toList();

    return Questionnaire(
      id: json['id'],
      cecClientId: json['cec_client_id'],
      cecEmployeeId: json['cec_employeeid'],
      title: json['title'],
      description: json['description'],
      questions: questionsList,
      duration: json['duration'],
      maximumAttempts: json['maximum_attempts'],
      files: filesList,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cec_client_id': cecClientId,
        'cec_employeeid': cecEmployeeId,
        'title': title,
        'description': description,
        'questions': questions.map((question) => question.toJson()).toList(),
        'duration': duration,
        'maximum_attempts': maximumAttempts,
        'files': files.map((file) => file.toJson()).toList(),
      };
}

class Response {
  final String question;
  final String selectedChoice;
  final String id;

  Response({
    required this.question,
    required this.selectedChoice,
    required this.id,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      question: json['question'],
      selectedChoice: json['selected_choice'],
      id: json['id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'question': question,
        'selected_choice': selectedChoice,
        'id': id,
      };
}

class Attempt {
  final int id;
  final int cecClientId;
  final int cecEmployeeId;
  final String employee;
  final String module;
  final String date;
  double score;
  final String completedAt;
  final int attemptsLeft;
  final int attempt;
  String result;
  final List<Response> responses;

  Attempt({
    required this.id,
    required this.cecClientId,
    required this.cecEmployeeId,
    required this.employee,
    required this.module,
    required this.score,
    required this.completedAt,
    required this.attempt,
    required this.attemptsLeft,
    required this.result,
    required this.responses,
    required this.date,
  });

  factory Attempt.fromJson(Map<String, dynamic> json) {
    var responsesJson = json['responses'] as List;
    List<Response> responsesList =
        responsesJson.map((response) => Response.fromJson(response)).toList();
    print("responsesList2: $responsesList");

    return Attempt(
      id: json['attempt_id'] ?? 0,
      cecClientId: json['cec_client_id'] ?? 0,
      cecEmployeeId: json['cec_employeeid'] ?? 0,
      employee: json['employee'] ?? "",
      module: json['module'] ?? "",
      score: double.parse((json['score'] ?? 0.0).toString()),
      attempt: json['attempt'] ?? 0,
      completedAt: json['completed_at'],
      attemptsLeft: json['attempts_left'] ?? 0,
      result: json['status'] ?? "",
      responses: responsesList,
      date: json['date'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cec_client_id': cecClientId,
        'employee_id': cecEmployeeId,
        'employee_name': employee,
        'module_id': module,
        'score': score,
        'completed_at': completedAt,
        'attempts_left': attemptsLeft,
        'status': result,
        'date': date,
        'responses': responses.map((response) => response.toJson()).toList(),
      };
}

class ModuleSectionModel {
  int id;
  String title;
  String description;
  int duration;
  int maximum_attempts;
  int likes;
  int views;
  String module;
  String timestamp;
  bool is_visible;
  List page_data;
  String image;

  ModuleSectionModel(
    this.id,
    this.title,
    this.description,
    this.duration,
    this.maximum_attempts,
    this.likes,
    this.views,
    this.module,
    this.timestamp,
    this.is_visible,
    this.page_data,
    this.image,
  );

  factory ModuleSectionModel.fromMap(Map<String, dynamic> map) {
    return ModuleSectionModel(
      map['id'],
      map['title'],
      map['description'] ?? '',
      map['duration'] ?? 0,
      map['maximum_attempts'] ?? 0,
      map['likes'] ?? 0,
      map['views'] ?? 0,
      map['module'] ?? '',
      map['timestamp'] ?? '',
      map['is_visible'] ?? true,
      map['page_data'] ?? [] as List,
      map['image'] ?? '',
    );
  }
}

class PageContentItem {
  final int id;
  String text;
  final String subtext;
  int page;
  final String type;
  final String topic;

  PageContentItem(
      this.id, this.text, this.subtext, this.page, this.type, this.topic);

  factory PageContentItem.fromJson(Map<String, dynamic> json) {
    return PageContentItem(
      json['id'],
      json['text'],
      json['subtext'] ?? "",
      json['page'],
      json['type'],
      json['topic'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'subtext': subtext,
        'page': page,
        'type': type,
        'topic': topic,
      };
}

class PageContent {
  final int id;
  final int page;
  final String topic;
  final List<PageContentItem> content;

  const PageContent(this.id, this.page, this.topic, this.content);

  factory PageContent.fromJson(Map<String, dynamic> json) {
    var list = json['content'] as List;
    List<PageContentItem> contentList =
        list.map((i) => PageContentItem.fromJson(i)).toList();

    return PageContent(
      json['id'],
      json['page'],
      json['topic'],
      contentList,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'page': page,
        'topic': topic,
        'content': content.map((e) => e.toJson()).toList(),
      };
}

class TableOfContentsItem {
  final int id;
  final int index;
  final String text;
  final int page;
  final String type;

  const TableOfContentsItem(
      this.id, this.index, this.text, this.page, this.type);

  factory TableOfContentsItem.fromJson(Map<String, dynamic> json) {
    return TableOfContentsItem(
      json['id'],
      json['index'],
      json['text'],
      json['page'],
      json['type'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'index': index,
        'text': text,
        'page': page,
        'type': type,
      };
}

class TopicItem {
  final int id;
  final String title;
  final String description;
  final int pages;
  final int duration;
  int likes;
  final int views;
  final String timestamp;
  final String image;
  final bool is_visible;
  final List<TableOfContentsItem> table_of_contents;
  final List<PageContentItem> contentItems;

  TopicItem(
    this.id,
    this.title,
    this.description,
    this.pages,
    this.duration,
    this.likes,
    this.views,
    this.timestamp,
    this.is_visible,
    this.image,
    this.table_of_contents,
    this.contentItems,
  );

  factory TopicItem.fromJson(Map<String, dynamic> json) {
    List<TableOfContentsItem> tableOfContents =
        (json['table_of_contents'] as List)
            .map((item) => TableOfContentsItem.fromJson(item))
            .toList();
    List<PageContentItem> contentItems = (json['contentItems'] as List)
        .map((item) => PageContentItem.fromJson(item))
        .toList();
    return TopicItem(
        json['id'],
        json['title'],
        json['description'],
        json['pages'],
        json['duration'],
        json['likes'],
        json['views'],
        json['timestamp'],
        json['is_visible'],
        json['image'] ?? "",
        tableOfContents,
        contentItems);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'pages': pages,
        'duration': duration,
        'likes': likes,
        'views': views,
        'timestamp': timestamp,
        'is_visible': is_visible,
        'image': image,
        'table_of_contents':
            table_of_contents.map((item) => item.toJson()).toList(),
        'contentItems': contentItems.map((item) => item.toJson()).toList(),
      };
}

class LearnItem {
  final int id;
  final int cecClientId;
  final int cecEmployeeId;
  final String module;
  final String title;
  final String description;
  final List<dynamic>
      questions; // Adjust as needed based on actual data structure
  final int duration;
  final int maximumAttempts;
  final List<dynamic> files; // Adjust as needed based on actual data structure
  final String timestamp;
  final String? dateModified;

  LearnItem({
    required this.id,
    required this.cecClientId,
    required this.cecEmployeeId,
    required this.module,
    required this.title,
    required this.description,
    required this.questions,
    required this.duration,
    required this.maximumAttempts,
    required this.files,
    required this.timestamp,
    this.dateModified,
  });

  factory LearnItem.fromJson(Map<String, dynamic> json) {
    return LearnItem(
      id: json['id'],
      cecClientId: json['cec_client_id'],
      cecEmployeeId: json['cec_employeeid'],
      module: json['module'] ?? '',
      title: json['title'],
      description: json['description'],
      questions: json['questions'],
      duration: json['duration'],
      maximumAttempts: json['maximum_attempts'],
      files: json['files'],
      timestamp: json['timestamp'] ?? "",
      dateModified: json['date_modified'],
    );
  }
}

class Question {
  final int id;
  final String text;
  final List<Choice> choices;
  int? selectedChoice;

  Question(
      {required this.id,
      required this.text,
      required this.choices,
      this.selectedChoice});

  factory Question.fromJson(Map<String, dynamic> json) {
    var list = json['choices'] as List;
    List<Choice> choicesList = list.map((i) => Choice.fromJson(i)).toList();

    return Question(
      id: json['id'],
      text: json['text'],
      choices: choicesList,
    );
  }
}

class Module {
  int module_id;
  String title;
  String description;
  int duration;
  int maximumAttempts;
  int likes;
  int views;
  String module;
  String timestamp;
  bool isVisible;
  String image_url;
  Map<String, dynamic>? data;
  List<dynamic>? pageData;
  List<dynamic>? subSections;

  Module({
    required this.module_id,
    required this.title,
    required this.description,
    required this.duration,
    required this.maximumAttempts,
    required this.likes,
    required this.views,
    required this.module,
    required this.timestamp,
    required this.isVisible,
    required this.image_url,
    this.data,
    this.pageData,
    this.subSections,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      module_id: json['module_id'] ?? 0,
      title: json['title'] ?? '-',
      description: json['description'] ?? '',
      duration: json['duration'] ?? 0,
      maximumAttempts: json['maximum_attempts'] ?? 0,
      likes: json['likes'] ?? 0,
      views: json['views'] ?? 0,
      module: json['module_type'] ?? '',
      timestamp: json['timestamp'] ?? '',
      isVisible: json['is_visible'] ?? false,
      image_url: json['image_url'] ?? '',
      data: json['data'] ?? {},
      pageData: json['page_data'] ?? [],
      subSections: json['sub_sections'] ?? [],
    );
  }
}

class ValuetainmentLogResponseModel {
  int logId;
  bool timedOut;
  double? score;
  String? result;
  double? remainingTime;

  ValuetainmentLogResponseModel({
    required this.logId,
    this.timedOut = false,
    this.score,
    this.result,
    this.remainingTime,
  });

  factory ValuetainmentLogResponseModel.fromJson(Map<String, dynamic> json) {
    return ValuetainmentLogResponseModel(
      logId: json['log_id'] ?? 0,
      timedOut: json['timed_out'] ?? false,
      score: double.parse((json['score'] ?? 0).toString()),
      result: json['result'],
      remainingTime: json['remaining_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'log_id': logId,
      'timed_out': timedOut,
      'score': score,
      'result': result,
      'remaining_time': remainingTime,
    };
  }
}

class ValuetainmentFAQ {
  final int faqId;
  final String category;
  final int moduleId;
  final String question;
  final String answer;
  final bool isVisible;
  final int? imageId;
  final DateTime timestamp;
  final DateTime lastModified;
  final List<ValuetainmentHowTo> howToSteps;
  bool isExpanded;

  ValuetainmentFAQ({
    required this.faqId,
    required this.category,
    required this.moduleId,
    required this.question,
    required this.answer,
    required this.isVisible,
    this.imageId,
    required this.timestamp,
    required this.lastModified,
    required this.howToSteps,
    required this.isExpanded,
  });

  factory ValuetainmentFAQ.fromJson(Map<String, dynamic> json) {
    return ValuetainmentFAQ(
        faqId: json['faq_id'],
        category: json['category'],
        moduleId: json['module_id'] ?? 0,
        question: json['question'],
        answer: json['answer'],
        isVisible: json['is_visible'],
        imageId: json['image_id'] ?? 0,
        timestamp: DateTime.parse(json['timestamp']),
        lastModified: DateTime.parse(json['last_modified']),
        howToSteps: List<ValuetainmentHowTo>.from((json['how_to_steps'] ?? [])
            .map((step) => ValuetainmentHowTo.fromJson(step))
            .toList()),
        isExpanded: false);
  }

  Map<String, dynamic> toJson() {
    return {
      'faq_id': faqId,
      'category': category,
      'module_id': moduleId,
      'question': question,
      'answer': answer,
      'is_visible': isVisible,
      'image_id': imageId,
      'timestamp': timestamp.toIso8601String(),
      'last_modified': lastModified.toIso8601String(),
      'how_to_steps': howToSteps.map((step) => step.toJson()).toList(),
    };
  }
}

class ValuetainmentHowTo {
  final int howToId;
  final String stepNo;
  final String text;
  final bool isVisible;
  final int? imageId;
  final DateTime timestamp;
  final DateTime lastModified;

  ValuetainmentHowTo({
    required this.howToId,
    required this.stepNo,
    required this.text,
    required this.isVisible,
    this.imageId,
    required this.timestamp,
    required this.lastModified,
  });

  factory ValuetainmentHowTo.fromJson(Map<String, dynamic> json) {
    return ValuetainmentHowTo(
      howToId: json['how_to_id'] ?? 0,
      stepNo: json['step_no'],
      text: json['text'],
      isVisible: json['is_visible'],
      imageId: json['image_id'] ?? 0,
      timestamp: DateTime.parse(json['timestamp']),
      lastModified: DateTime.parse(json['last_modified']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'how_to_id': howToId,
      'step_no': stepNo,
      'text': text,
      'is_visible': isVisible,
      'image_id': imageId,
      'timestamp': timestamp.toIso8601String(),
      'last_modified': lastModified.toIso8601String(),
    };
  }
}
