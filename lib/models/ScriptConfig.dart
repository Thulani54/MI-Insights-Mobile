class ScriptConfig {
  List<PageModel> pages;
  Map<String, List<Paragraph>> paragraphs;
  List<dynamic> features;
  List<String> pageSetupList;

  ScriptConfig({
    required this.pages,
    required this.paragraphs,
    required this.features,
    required this.pageSetupList,
  });

  factory ScriptConfig.fromJson(Map<String, dynamic> json) {
    // Parsing Pages
    List<PageModel> parsedPages = List<PageModel>.from(
      (json['Pages'] as List<dynamic>? ?? []).map<PageModel>(
        (pageJson) => PageModel.fromJson(pageJson),
      ),
    );

    // Parsing Paragraphs with proper key types
    Map<String, List<Paragraph>> parsedParagraphs = {};
    if (json['Paragraphs'] != null) {
      json['Paragraphs'].forEach((key, value) {
        parsedParagraphs[key.toString()] = (value as List<dynamic>)
            .map((paragraphJson) => Paragraph.fromJson(paragraphJson))
            .toList();
      });
    }

    // Parsing Features
    List<dynamic> parsedFeatures = [];
    if (json['features'] != null) {
      parsedFeatures = List<dynamic>.from(json['features']);
    }

    // Parsing Page Setup List
    List<String> parsedPageSetupList = [];
    if (json['page_setup_list'] != null) {
      parsedPageSetupList =
          List<String>.from(json['page_setup_list'].map((x) => x.toString()));
    }

    return ScriptConfig(
      pages: parsedPages,
      paragraphs: parsedParagraphs,
      features: parsedFeatures,
      pageSetupList: parsedPageSetupList,
    );
  }
}

class PageModel {
  int id;
  String pageName;
  int pageNumber;

  PageModel({
    required this.id,
    required this.pageName,
    required this.pageNumber,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      id: json['id'] as int,
      pageName: json['page_name'] as String,
      pageNumber: json['page_number'] as int,
    );
  }
}

class Paragraph {
  int id;
  String paragraph;
  int paragraphNumber;
  bool conditional;
  String conditionalStatement;

  Paragraph({
    required this.id,
    required this.paragraph,
    required this.paragraphNumber,
    required this.conditional,
    required this.conditionalStatement,
  });

  factory Paragraph.fromJson(Map<String, dynamic> json) {
    return Paragraph(
      id: json['id'] as int,
      paragraph: json['paragraph'] as String,
      paragraphNumber: json['paragraph_number'] ?? 1,
      conditional: json['conditional'] ?? false,
      conditionalStatement: json['conditional_statement'] ?? "",
    );
  }
}
