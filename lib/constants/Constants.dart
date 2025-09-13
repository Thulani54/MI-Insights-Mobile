import 'dart:async';

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
//import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart' as jst;
import 'package:mi_insights/models/notification.dart';

import '../config/EnvironmentConfig.dart';
import '../models/BusinessInfo.dart';
import '../models/ClaimStageCategory.dart';
import '../models/ClaimsSectionGridModel.dart';
import '../models/CustomerProfile.dart';
import '../models/GenderDistribution.dart' hide GenderDistribution;
import '../models/Lead.dart';
import '../models/MaintanaceCategory.dart';
import '../models/MoraleIndexCategory.dart';
import '../models/OrdinalSales.dart';
import '../models/Parlour.dart';
import '../models/PaymentHistoryItem.dart';
import '../models/PolicyDetails.dart';
import '../models/PolicyInfoLead.dart';
import '../models/Product.dart' as product;
import '../models/ReprintByAgent.dart';
import '../models/SalesByAgent.dart';
import '../models/SalesByBranch.dart';
import '../models/SalesDataResponse.dart';
import '../models/Segment2.dart';
import '../models/ValutainmentModels.dart';
import '../models/commsgridmodel.dart';
import '../models/map_class.dart';
import '../models/salesgridmodel.dart';
import '../screens/Reports/AttendanceReport.dart' as att;
import '../screens/Reports/Executive/ExecutiveCollectionsReport.dart' as cllc;

class Constants {
  static String selectedClientName = "";
  static String sales_formattedStartDate = "";
  static String sales_formattedEndDate = "";
  static int appBarValue = 0;
  static int tabIndex = 0;
  static List<String> debitDays =
      List<String>.generate(31, (index) => (index + 1).toString());
  static const List<Map<String, String>> banksListWithCountryCodes = [
    {"id": "632005", "name": "ABSA"},
    {"id": "430000", "name": "AFRICAN BANK"},
    {"id": "462005", "name": "Bidvest"},
    {"id": "470010", "name": "CAPITEC"},
    {"id": "250655", "name": "FNB"},
    {"id": "198765", "name": "NEDBANK"},
    {"id": "460005", "name": "POSTBANK"},
    {"id": "051001", "name": "STANDARD BANK"},
    {"id": "431010", "name": "UBANK"},
    {"id": "678910", "name": "TYMEBANK"},
    {"id": "584000", "name": "GRAINDROP BANK LIMITED"},
    {"id": "589000", "name": "FinBond Mutual Bank"},
    {"id": "754126", "name": "ABSA-ITHALA"},
    {"id": "462005", "name": "OLD MUTUAL BANK"},
  ];
  static const List<String> banksList = [
    "ABSA",
    "AFRICAN BANK",
    "Bidvest",
    "CAPITEC",
    "FNB",
    "NEDBANK",
    "POSTBANK", // value from <option>, replaces long display label
    "STANDARD BANK",
    "UBANK",
    "TYMEBANK",
    "GRAINDROP BANK LIMITED",
    "FinBond Mutual Bank",
    "ABSA-ITHALA",
    "OLD MUTUAL BANK",
  ];
  static int eventScreenValue = 0;
  static bool isIndividualVerified = false;
  static String appBarTitle = "";
  static String appBarTitleDescription = "";
  static int appBarValue2 = 0;
  static int currentStep = 0;
  static int currentLodgeClaimIndex = 0;
  static bool isPremiumPayerSaved = false;
  static bool IsAuthenticationVerified = false;
  static String logoUrl = "";
  static String querySearchByTitle = "";
  static bool isAscending = true;
  static bool isGridView = true;
  static String registrationType = "";
  static String myEmail = '';
  static bool is_showing_drawer = false;
  static String get insightsReportsBaseUrl => AppConfig.insightsReportsBaseUrl;

  static String get insightsBaseUrl => AppConfig.insightsBaseUrl;
  static String get hygieneBaseUrl => AppConfig.hygieneBaseUrl;

  static String get insightsBackendBaseUrl => AppConfig.insightsBackendBaseUrl;
  static String get fileIndexingUrl => AppConfig.fileIndexingUrl;

  static String get blackBrokerUrl => AppConfig.blackBrokerUrl;

  static String get commsEngineUrl => AppConfig.commsEngineUrl;
  static String get underwriterEndpoint => AppConfig.underwriterEndpoint;

  static String get insightsAdminBaseUrl => AppConfig.insightsAdminBaseUrl;

  static String get miChatsBaseUrl => AppConfig.miChatsBaseUrl;

  static String get insightsApiBusBaseUrl => AppConfig.insightsApiBusBaseUrl;
  static String get premiumCollectorUrl => AppConfig.premiumCollectorUrl;

  static String get parlourConfigBaseUrl => AppConfig.parlourConfigBaseUrl;
  static String reportsAppBaseUrl = "https://reportsapp.miinsightsapps.net";

  static String get cclApiEndpoint => AppConfig.cclApiEndpoint;

  static String get insightsBackendUrl => AppConfig.insightsBackendBaseUrl;

  static String get ecommerceApiEndpoint => AppConfig.ecommerceApiEndpoint;

  static String get InsightsReportsbaseUrl =>
      AppConfig.insightsReportsBaseUrl; // Note Cap
  static String get insightsbaseUrl => AppConfig.insightsBaseUrl;
  static List<String> yesNoOptionsList = [
    "Yes",
    "No",
  ];

  static String get insightsbaseBackendUrl => AppConfig
      .insightsBackendBaseUrl; // Mapping to distinct backend URL// Original name
  static String get InsightsAdminbaseUrl =>
      AppConfig.insightsAdminBaseUrl; // Note Cap

  static String get InsightsApiBusbaseUrl =>
      AppConfig.insightsApiBusBaseUrl; // Note Cap
  static String get parlourConfigbaseUrl => AppConfig.parlourConfigBaseUrl;
  static bool currentlyEmployed = false; // Note Cap
  static bool isEmployerDetailsSaved = false;

  // Computed Endpoints (using original names, mapping to AppConfig computed props)
  static String get API_ENDPOINT => AppConfig.cclApiEndpoint;

  static String get CCL_API_ENDPOINT => AppConfig
      .cclApiEndpoint; // Mapped same as API_ENDPOINT based on original logic
  static String get ECOMMERCE_API_ENDPOINT => AppConfig.ecommerceApiEndpoint;

  // Keep this if needed for backward compatibility temporarily

  static bool is_TestMode = false;

  static String session_id = "";
  static String myUserRoleLevel = "";
  static bool allowUploadvaluetainment = false;
  static bool isAdmin = false;
  static bool containsAppUpdate = false;
  static bool mandatoryUpdate = false;
  static bool hasGoldenWheelAccess = false;
  static bool isReleaseMode = false;
  static Map<String, dynamic>? currentSalesReportData;

  static String fieldSaleType = "Field Sale";
  static List<PolicyDetails1> selectedPolicydetails = [];
  static int pageLevel = 1;
  static double myLat = 1;
  static double myLong = 1;
  static Lead? currentleadAvailable;
  static PolicyInfoLead? currentPolicyInfoleadAvailable;
  static DateFormat formatter = DateFormat('yyyy-MM-dd');
  static DateFormat DateTimeFormatter = DateFormat('yyyy-MM-dd,HH:MM');
  static String manualDialType = "Field";
  static String queryingEmployee = "";
  static String appUpdatedownloadUrl = "";
  static String myAppVersion = "";
  static String baseUrl = "${Constants.insightsBackendBaseUrl}apibus/api";
  static String posAppBaseUrl = "${Constants.insightsBackendBaseUrl}apibus/api";
  static String baseUrl2 = "${Constants.insightsBackendBaseUrl}";
  static List<String> myUserRoles = [];
  static ParlourConfig? currentParlourConfig;

  //static String InsightsReportsbaseUrl = "https://insights.dedicated.co.za:808";
  //static FirebaseAnalytics? analytics_instance;
  //static FirebaseAnalyticsObserver? analytics_observer;

  static List<Map<String, dynamic>> cec_employees = [];
  static List<String> commssions_data_employees = [];
  static List<Map<String, dynamic>> all_branches = [];
  static List<ModuleSectionModel> current_valuetainment_sectionsList = [];
  static List<TopicItem> current_valuetainment_topicsList = [];
  static List<String> roles = [];
  static List<String> permissions = [];
  static List<String> modules = [];
  static int current_module_id = -1;
  static Module current_module = Module(
      module_id: -1,
      title: '',
      description: '',
      duration: -1,
      maximumAttempts: -1,
      likes: -1,
      views: -1,
      module: '',
      timestamp: '',
      isVisible: false,
      image_url: '');

  static String user_reference = "";

  static String account_type = "";
  static late BuildContext myContext;
  static String device_id = "";
  static String device_os_version = "";
  static String device_model = "";
  static String transaction_id = "";
  static List<Map<String, dynamic>> monthsPaidForList = [];
  //static String formattedStartDate = "";
  //static String formattedEndDate = "";

  static int cec_client_id = -1;
  static int organo_id = -1;
  static double percentage_completed = 0.0;
  static int cec_employeeid = -1;

  static String customer_id_number = "";
  static String user_role = "";

  static String customer_first_name = "";

  static String customer_last_name = "";
  static String assessmentKey = "";
  static String sectionsDataString = "";

  static var cell_number = "";

  static String cec_empname = "";

  static var cec_logo = "";
  static bool isLoggedIn = false;
  static bool isLoggedIn5 = false;

  static String myDisplayname = "";

  static String myCell = "";
  static Timer? inactivityTimer;

  static String myUid = "";

  static String analitixAppBaseUrl = AppConfig.analitixAppBaseUrl; // Note Cap

  static Color ctaColorLight = Color(0xFF1f3b57);
  static Color ctaColorLightYELLOW = Color(0xFF9BA17B);
  static Color ftaColorLight = const Color(0xFFf05223);
  static bool isAudioEnabled = false;

  static var cec_empid;
  static String business_name = "";
  static String current_quote = "";
  static String myUserRole = "";
  static String myUserFunction = "";
  static List<String> myUserModules = [];
  static bool requirePassword = false;
  static bool isTwoMountains = false;
  static bool accepted_terms = false;
  static bool allowed_add_assessments = false;
  static int timesOpened = 0;
  static double screenWidth = 0;
  static double screenHeight = 0;

  static BusinessInfo currentBusinessInfo = BusinessInfo(
    address_1: "",
    address_2: "",
    city: "",
    province: "",
    country: "",
    area_code: "",
    postal_address_1: "",
    postal_address_2: "",
    postal_city: "",
    postal_province: "",
    postal_country: "",
    postal_code: "",
    tel_no: "",
    cell_no: "",
    comp_name: "",
    client_fsp: "",
    vat_number: "",
    logo: "",
  );
  static List<PolicyDetails1> selectedPolicydetails1 = [];
  static List<PaymentHistoryItem> paymentHistoryList = [];

  static int sales_maxY = 0;
  static int sales_maxY2 = 0;
  static int sales_maxY3 = 0;
  static int sales_maxY4 = 0;
  static int sales_maxY5a = 0;
  static int sales_maxY5b = 0;
  static int sales_maxY5c = 0;
  static int sales_maxY5d = 0;
  static int sales_maxY6 = 0;
  static int sales_bar_maxY1a = 0;
  static int sales_bar_maxY1b = 0;
  static int sales_bar_maxY1c = 0;
  static int sales_bar_maxY2a = 0;
  static int sales_bar_maxY2b = 0;
  static int sales_bar_maxY2c = 0;
  static int sales_bar_maxY3a = 0;
  static int sales_bar_maxY3b = 0;
  static int sales_bar_maxY3c = 0;
  static int sales_bar_maxY4a = 0;
  static int sales_bar_maxY4b = 0;
  static int sales_bar_maxY4c = 0;
  static List<double> quoteAcceptance_rate = [
    0,
    0,
    0,
  ];
  static List<salesgridmodel> sales_sectionsList1a = [
    salesgridmodel("All Sales", 0),
    salesgridmodel("Inforced Sales", 0),
    salesgridmodel("Not Accepted", 0),
  ];
  static List<salesgridmodel> sales_sectionsList2a = [
    salesgridmodel("All Sales", 0),
    salesgridmodel("Inforced Sales", 0),
    salesgridmodel("Not Accepted", 0),
  ];
  static List<salesgridmodel> sales_sectionsList3a = [
    salesgridmodel("All Sales", 0),
    salesgridmodel("Inforced Sales", 0),
    salesgridmodel("Not Accepted", 0),
  ];
  static List<salesgridmodel> sales_sectionsList3b = [
    salesgridmodel("All Sales", 0),
    salesgridmodel("Inforced Sales", 0),
    salesgridmodel("Not Accepted", 0),
  ];
  static List<salesgridmodel> leads_sectionsList1a = [
    salesgridmodel("Submitted", 0),
    salesgridmodel("In-Progress", 0),
    salesgridmodel("Rejected", 0),
  ];
  static List<salesgridmodel> leads_sectionsList2a = [
    salesgridmodel("Submitted", 0),
    salesgridmodel("In-Progress", 0),
    salesgridmodel("Rejected", 0),
  ];
  static List<salesgridmodel> leads_sectionsList3a = [
    salesgridmodel("Submitted", 0),
    salesgridmodel("In-Progress", 0),
    salesgridmodel("Rejected", 0),
  ];
  static List<salesgridmodel> leads_sectionsList3b = [
    salesgridmodel("Submitted", 0),
    salesgridmodel("In-Progress", 0),
    salesgridmodel("Rejected", 0),
  ];
  static List<salesgridmodel3> exec_leads_sectionsList1a = [
    salesgridmodel3("Submitted", 0, 0),
    salesgridmodel3("Captured", 0, 0),
    salesgridmodel3("Declined", 0, 0),
  ];
  static List<salesgridmodel3> exec_leads_sectionsList2a = [
    salesgridmodel3("Submitted", 0, 0),
    salesgridmodel3("Captured", 0, 0),
    salesgridmodel3("Declined", 0, 0),
  ];
  static List<salesgridmodel3> exec_leads_sectionsList3a = [
    salesgridmodel3("Submitted", 0, 0),
    salesgridmodel3("Captured", 0, 0),
    salesgridmodel3("Declined", 0, 0),
  ];
  static List<salesgridmodel3> exec_leads_sectionsList3b = [
    salesgridmodel3("Submitted", 0, 0),
    salesgridmodel3("Captured", 0, 0),
    salesgridmodel3("Declined", 0, 0),
  ];

  static List<salesgridmodel> sales_sectionsList1a_sales_agent = [
    salesgridmodel("Inforced", 0),
    salesgridmodel("In-Progress", 0),
    salesgridmodel("Rejected", 0),
  ];
  static List<salesgridmodel> sales_sectionsList2a_sales_agent = [
    salesgridmodel("Inforced", 0),
    salesgridmodel("In-Progress", 0),
    salesgridmodel("Rejected", 0),
  ];
  static List<salesgridmodel> sales_sectionsList3a_sales_agent = [
    salesgridmodel("Inforced", 0),
    salesgridmodel("In-Progress", 0),
    salesgridmodel("Rejected", 0),
  ];
  static List<salesgridmodel> sales_sectionsList3b_sales_agent = [
    salesgridmodel("Inforced", 0),
    salesgridmodel("In-Progress", 0),
    salesgridmodel("Rejected", 0),
  ];
  static List<SalesByBranch> sales_salesbybranch1a = [];
  static List<SalesByBranch> sales_salesbybranch1b = [];
  static List<SalesByBranch> sales_salesbybranch1c = [];
  static List<SalesByBranch> sales_salesbybranch2a = [];
  static List<SalesByBranch> sales_salesbybranch2b = [];
  static List<SalesByBranch> sales_salesbybranch2c = [];
  static List<SalesByBranch> sales_salesbybranch3a = [];
  static List<SalesByBranch> sales_salesbybranch3b = [];
  static List<SalesByBranch> sales_salesbybranch3c = [];
  static List<SalesByBranch> sales_salesbybranch4a = [];
  static List<SalesByBranch> sales_salesbybranch4b = [];
  static List<SalesByBranch> sales_salesbybranch4c = [];
  static List<FieldsSalesByAgent> field_leadbyagent1a = [];
  static List<FieldsSalesByAgent> field_leadbyagent1b = [];
  static List<FieldsSalesByAgent> field_leadbyagent1c = [];
  static List<FieldsSalesByAgent> field_leadbyagent2a = [];
  static List<FieldsSalesByAgent> field_leadbyagent2b = [];
  static List<FieldsSalesByAgent> field_leadbyagent2c = [];
  static List<FieldsSalesByAgent> field_leadbyagent3a = [];
  static List<FieldsSalesByAgent> field_leadbyagent3b = [];
  static List<FieldsSalesByAgent> field_leadbyagent3c = [];
  static List<FieldsSalesByAgent> field_leadbyagent4a = [];
  static List<FieldsSalesByAgent> field_leadbyagent4b = [];
  static List<FieldsSalesByAgent> field_leadbyagent4c = [];

  static List<FlSpot> sales_spots1 = [];
  static List<FlSpot> sales_spots1_1 = [];
  static List<FlSpot> sales_spots1a = [];
  static List<FlSpot> sales_spots1b = [];
  static List<FlSpot> sales_spots1c = [];
  static List<FlSpot> sales_spots2 = [];
  static List<FlSpot> sales_spots2_1 = []; //For targets.
  static List<FlSpot> sales_spots3_1 = []; //For targets.
  static List<FlSpot> sales_spots2a = [];
  static List<FlSpot> sales_spots2b = [];
  static List<FlSpot> sales_spots2c = [];
  static List<FlSpot> sales_spots3 = [];
  static List<FlSpot> sales_spots3a = [];
  static List<FlSpot> sales_spots3b = [];
  static List<FlSpot> sales_spots3c = [];
  static List<FlSpot> sales_spots4 = [];
  static List<FlSpot> sales_spots4_1 = [];
  static List<FlSpot> sales_spots4a = [];
  static List<FlSpot> sales_spots4b = [];
  static List<FlSpot> sales_spots4c = [];
  static List<FlSpot> leads_spots1 = [];
  static List<FlSpot> leads_spots1_1 = [];
  static List<FlSpot> leads_spots1a = [];
  static List<FlSpot> leads_spots1b = [];
  static List<FlSpot> leads_spots1c = [];
  static List<FlSpot> leads_spots2 = [];
  static List<FlSpot> leads_spots2_1 = []; //For targets.
  static List<FlSpot> leads_spots3_1 = []; //For targets.
  static List<FlSpot> leads_spots2a = [];
  static List<FlSpot> leads_spots2b = [];
  static List<FlSpot> leads_spots2c = [];
  static List<FlSpot> leads_spots3 = [];
  static List<FlSpot> leads_spots3a = [];
  static List<FlSpot> leads_spots3b = [];
  static List<FlSpot> leads_spots3c = [];
  static List<FlSpot> leads_spots4 = [];
  static List<FlSpot> leads_spots4_1 = [];
  static List<FlSpot> leads_spots4a = [];
  static List<FlSpot> leads_spots4b = [];
  static List<FlSpot> leads_spots4c = [];

  static List<FlSpot> d_leads_spots1 = [];
  static List<FlSpot> d_leads_spots1_1 = [];
  static List<FlSpot> d_leads_spots1a = [];
  static List<FlSpot> d_leads_spots1b = [];
  static List<FlSpot> d_leads_spots1c = [];
  static List<FlSpot> d_leads_spots2 = [];
  static List<FlSpot> d_leads_spots2_1 = []; //For targets.
  static List<FlSpot> d_leads_spots3_1 = []; //For targets.
  static List<FlSpot> d_leads_spots2a = [];
  static List<FlSpot> d_leads_spots2b = [];
  static List<FlSpot> d_leads_spots2c = [];
  static List<FlSpot> d_leads_spots3 = [];
  static List<FlSpot> d_leads_spots3a = [];
  static List<FlSpot> d_leads_spots3b = [];
  static List<FlSpot> d_leads_spots3c = [];
  static List<FlSpot> d_leads_spots4 = [];
  static List<FlSpot> d_leads_spots4_1 = [];
  static List<FlSpot> d_leads_spots4a = [];
  static List<FlSpot> d_leads_spots4b = [];
  static List<FlSpot> d_leads_spots4c = [];

  static Key leads_chartKey1a = UniqueKey();
  static Key leads_chartKey1b = UniqueKey();
  static Key leads_chartKey1c = UniqueKey();
  static Key leads_chartKey2a = UniqueKey();
  static Key leads_chartKey2b = UniqueKey();
  static Key leads_chartKey2c = UniqueKey();
  static Key leads_chartKey3a = UniqueKey();
  static Key leads_chartKey3b = UniqueKey();
  static Key leads_chartKey3c = UniqueKey();
  static Key leads_chartKey4a = UniqueKey();
  static Key leads_chartKey4b = UniqueKey();
  static Key leads_chartKey4c = UniqueKey();

  static Key d_leads_chartKey1a = UniqueKey();
  static Key d_leads_chartKey1b = UniqueKey();
  static Key d_leads_chartKey1c = UniqueKey();
  static Key d_leads_chartKey2a = UniqueKey();
  static Key d_leads_chartKey2b = UniqueKey();
  static Key d_leads_chartKey2c = UniqueKey();
  static Key d_leads_chartKey3a = UniqueKey();
  static Key d_leads_chartKey3b = UniqueKey();
  static Key d_leads_chartKey3c = UniqueKey();
  static Key d_leads_chartKey4a = UniqueKey();
  static Key d_leads_chartKey4b = UniqueKey();
  static Key d_leads_chartKey4c = UniqueKey();

  static GlobalKey<State<StatefulWidget>> sales_chartKey1a =
      GlobalKey<State<StatefulWidget>>();
  static GlobalKey<State<StatefulWidget>> sales_chartKey1b =
      GlobalKey<State<StatefulWidget>>();
  static GlobalKey<State<StatefulWidget>> sales_chartKey1c =
      GlobalKey<State<StatefulWidget>>();
  static GlobalKey<State<StatefulWidget>> sales_chartKey2a =
      GlobalKey<State<StatefulWidget>>();
  static GlobalKey<State<StatefulWidget>> sales_chartKey2b =
      GlobalKey<State<StatefulWidget>>();
  static GlobalKey<State<StatefulWidget>> sales_chartKey2c =
      GlobalKey<State<StatefulWidget>>();
  static GlobalKey<State<StatefulWidget>> sales_chartKey3a =
      GlobalKey<State<StatefulWidget>>();
  static GlobalKey<State<StatefulWidget>> sales_chartKey3b =
      GlobalKey<State<StatefulWidget>>();
  static GlobalKey<State<StatefulWidget>> sales_chartKey3c =
      GlobalKey<State<StatefulWidget>>();
  static GlobalKey<State<StatefulWidget>> sales_chartKey4a =
      GlobalKey<State<StatefulWidget>>();
  static GlobalKey<State<StatefulWidget>> sales_chartKey4b =
      GlobalKey<State<StatefulWidget>>();
  static GlobalKey<State<StatefulWidget>> sales_chartKey4c =
      GlobalKey<State<StatefulWidget>>();
  static List<OrdinalSales> sales_ordinary_sales1a = [];
  static List<OrdinalSales> sales_ordinary_sales1b = [];
  static List<OrdinalSales> sales_ordinary_sales1c = [];
  static List<OrdinalSales> sales_ordinary_sales2a = [];
  static List<OrdinalSales> sales_ordinary_sales2b = [];
  static List<OrdinalSales> sales_ordinary_sales2c = [];
  static List<OrdinalSales> sales_ordinary_sales3a = [];
  static List<OrdinalSales> sales_ordinary_sales3b = [];
  static List<OrdinalSales> sales_ordinary_sales3c = [];
  static List<OrdinalSales> sales_ordinary_sales4a = [];
  static List<OrdinalSales> sales_ordinary_sales4b = [];
  static List<OrdinalSales> sales_ordinary_sales4c = [];
  static Key sales_bardata1a_key = UniqueKey();
  static Key sales_bardata1b_key = UniqueKey();
  static Key sales_bardata1c_key = UniqueKey();
  static Key sales_bardata2a_key = UniqueKey();
  static Key sales_bardata2b_key = UniqueKey();
  static Key sales_bardata2c_key = UniqueKey();
  static Key sales_bardata3a_key = UniqueKey();
  static Key sales_bardata3b_key = UniqueKey();
  static Key sales_bardata3c_key = UniqueKey();
  static Key sales_bardata4a_key = UniqueKey();
  static Key sales_bardata4b_key = UniqueKey();
  static Key sales_bardata4c_key = UniqueKey();
  static Key sales_product_type_key = UniqueKey();
  static Key sales_tree_key1a = UniqueKey();
  static Key sales_tree_key2a = UniqueKey();
  static Key sales_tree_key3a = UniqueKey();
  static Key sales_tree_key4a = UniqueKey();

  static Key leads_tree_key3a = UniqueKey();
  static Key leads_tree_key4a = UniqueKey();
  static Map<String, List<dynamic>> ages_list1a = {};
  static Map<String, List<dynamic>> ages_list1a_1_1 = {};
  static Map<String, List<dynamic>> ages_list1a_1_2 = {};
  static Map<String, List<dynamic>> ages_list1a_1_3 = {};
  static Map<String, List<dynamic>> ages_list1a_2_1 = {};
  static Map<String, List<dynamic>> ages_list1a_2_2 = {};
  static Map<String, List<dynamic>> ages_list1a_2_3 = {};
  static Map<String, List<dynamic>> ages_list1a_3 = {};
  static Map<String, List<dynamic>> ages_list2a = {};
  static Map<String, List<dynamic>> ages_list2a_1_1 = {};
  static Map<String, List<dynamic>> ages_list2a_1_2 = {};
  static Map<String, List<dynamic>> ages_list2a_1_3 = {};
  static Map<String, List<dynamic>> ages_list2a_2 = {};
  static Map<String, List<dynamic>> ages_list2a_3 = {};
  static Map<String, List<dynamic>> ages_list3a = {};
  static Map<String, List<dynamic>> ages_list3a_1_1 = {};
  static Map<String, List<dynamic>> ages_list3a_1_2 = {};
  static Map<String, List<dynamic>> ages_list3a_1_3 = {};
  static Map<String, List<dynamic>> ages_list3a_2 = {};
  static Map<String, List<dynamic>> ages_list3a_3 = {};
  static Map<String, List<dynamic>> ages_list3b = {};
  static Map<String, List<dynamic>> ages_list3b_2 = {};
  static Map<String, List<dynamic>> ages_list3b_3 = {};
  static double sales_percentage_with_ext_policy1a = 0.0;
  static double sales_percentage_with_ext_policy2a = 0.0;
  static double sales_percentage_with_ext_policy3a = 0.0;
  static double sales_percentage_with_ext_policy3b = 0.0;
  static double leads_rejection_rate1a = 0.0;
  static double leads_rejection_rate2a = 0.0;
  static double leads_rejection_rate3a = 0.0;
  static double leads_rejection_rate3b = 0.0;
  static List<FlSpot> lapse_result_list2 = [];
  static List<FlSpot> lapse_result_list2a = [];
  static List<FlSpot> lapse_result_list2a_target = [];
  static List<FlSpot> lapse_result_list2b = [];
  static List<FlSpot> lapse_result_list2c = [];
  static List<FlSpot> lapse_result_list2d = [];
  static Key sales_lapsechartKey2a = UniqueKey();
  static int sales_lapse_maxY2 = 0;
  static List<FlSpot> ntu_result_list2 = [];
  static List<FlSpot> ntu_result_list2_target = [];
  static List<FlSpot> ntu_result_list2a = [];
  static List<FlSpot> ntu_result_list2a_target = [];
  static Map<String, dynamic> salesInfo1a = {};
  static Map<String, dynamic> salesInfo3a = {};
  static Map<String, dynamic> salesInfo4a = {};

  static List<charts.Series<GenderDistribution, String>>
      sales_age_distributions_barGroups1a = [];
  static List<charts.Series<GenderDistribution, String>>
      sales_age_distributions_barGroups1b = [];
  static List<charts.Series<GenderDistribution, String>>
      sales_age_distributions_barGroups2a = [];
  static List<charts.Series<GenderDistribution, String>>
      sales_age_distributions_barGroups2b = [];
  static List<charts.Series<GenderDistribution, String>>
      sales_age_distributions_barGroups3a = [];
  static List<charts.Series<GenderDistribution, String>>
      sales_age_distributions_barGroups3b = [];
  static List<charts.Series<GenderDistribution, String>>
      sales_age_distributions_barGroups4a = [];
  static List<charts.Series<GenderDistribution, String>>
      sales_age_distributions_barGroups4b = [];

  static List<product.Product> salesProductsGrouped1a = [];
  static List<product.Product> salesProductsGrouped2a = [];
  static List<product.Product> salesProductsGrouped3a = [];
  static List<product.Product> salesProductsGrouped4a = [];
  static List<SalesByAgentSale> salesByAgentSales1a = [];
  static List<SalesByAgentSale> salesByAgentSales1b = [];
  static List<SalesByAgentSale> salesByAgentSales1c = [];
  static List<SalesByAgentSale> salesByAgentSales2a = [];
  static List<SalesByAgentSale> salesByAgentSales2b = [];
  static List<SalesByAgentSale> salesByAgentSales2c = [];
  static List<SalesByAgentSale> salesByAgentSales3a = [];
  static List<SalesByAgentSale> salesByAgentSales3b = [];
  static List<SalesByAgentSale> salesByAgentSales3c = [];
  static List<SalesByAgentSale> salesByAgentSales4b = [];
  static List<SalesByAgentSale> salesByAgentSales4a = [];
  static List<SalesByAgentSale> salesByAgentSales4c = [];

  static List<SalesByAgentLead> leadsByAgentSales1a = [];
  static List<SalesByAgentLead> leadsByAgentSales1b = [];
  static List<SalesByAgentLead> leadsByAgentSales1c = [];
  static List<SalesByAgentLead> leadsByAgentSales2a = [];
  static List<SalesByAgentLead> leadsByAgentSales2b = [];
  static List<SalesByAgentLead> leadsByAgentSales2c = [];
  static List<SalesByAgentLead> leadsByAgentSales3a = [];
  static List<SalesByAgentLead> leadsByAgentSales3b = [];
  static List<SalesByAgentLead> leadsByAgentSales3c = [];
  static List<SalesByAgentLead> leadsByAgentSales4b = [];
  static List<SalesByAgentLead> leadsByAgentSales4a = [];
  static List<SalesByAgentLead> leadsByAgentSales4c = [];
  static List<LineChartBarData> lines = [];
  static List<charts.Series<dynamic, String>> sales_seriesList2a = [];
  static List<charts.Series<dynamic, String>> sales_seriesList4a = [];

  //Collections
  static Key collections_tree_key1a = UniqueKey();
  static Key collections_tree_key2a = UniqueKey();
  static Key collections_tree_key3a = UniqueKey();
  static Key collections_tree_key4a = UniqueKey();

  //Maintenance
  static int maintenance_maxY = 0;
  static int maintenance_maxY2 = 0;
  static int maintenance_maxY3 = 0;
  static int maintenance_maxY4 = 0;
  static int maintenance_maxY5a = 0;
  static int maintenance_maxY5b = 0;
  static int maintenance_maxY5c = 0;
  static int maintenance_maxY5d = 0;
  static int maintenance_maxY6 = 0;
  static List<salesgridmodel> maintenance_sectionsList1a = [];
  static List<salesgridmodel> maintenance_sectionsList2a = [];
  static List<salesgridmodel> maintenance_sectionsList3a = [];
  static List<salesgridmodel> maintenance_sectionsList3b = [];
  static List<SalesByBranch> maintenance_salesbybranch1a = [];
  static List<SalesByBranch> maintenance_salesbybranch2a = [];
  static List<SalesByBranch> maintenance_salesbybranch3a = [];
  static List<SalesByBranch> maintenance_salesbybranch3b = [];
  static List<SalesByAgent> maintenance_salesbyagent1a = [];
  static List<SalesByAgent> maintenance_salesbyagent1b = [];
  static List<SalesByAgent> maintenance_salesbyagent1c = [];
  static List<SalesByAgent> maintenance_salesbyagent2a = [];
  static List<SalesByAgent> maintenance_salesbyagent2b = [];
  static List<SalesByAgent> maintenance_salesbyagent2c = [];
  static List<SalesByAgent> maintenance_salesbyagent3a = [];
  static List<SalesByAgent> maintenance_salesbyagent3b = [];
  static List<SalesByAgent> maintenance_salesbyagent3c = [];
  static List<BarChartGroupData> maintenance_barData = [];
  static List<PieChartSectionData> maintenance_pieData = [];
  static List<String> maintenance_bottomTitles1a = [];
  static List<String> maintenance_bottomTitles2a = [];
  static List<String> maintenance_bottomTitles3a = [];
  static List<String> maintenance_bottomTitles3b = [];
  static String maintenance_formattedStartDate = "";
  static String maintenance_formattedEndDate = "";
  static String maintenance_jsonData4a = "";
  static List<charts.Series<dynamic, String>> maintenance_seriesList = [];
  static List<charts.Series<OrdinalSales, String>> maintenance_bardata5a = [];
  static List<charts.Series<OrdinalSales, String>> maintenance_bardata5b = [];
  static List<charts.Series<OrdinalSales, String>> maintenance_bardata5c = [];
  static List<charts.Series<OrdinalSales, String>> maintenance_bardata5d = [];
  static List<FlSpot> maintenance_spots1a = [];
  static List<FlSpot> maintenance_spots1b = [];
  static List<FlSpot> maintenance_spots1c = [];
  static List<FlSpot> maintenance_spots2a = [];
  static List<FlSpot> maintenance_spots2b = [];
  static List<FlSpot> maintenance_spots2c = [];
  static List<FlSpot> maintenance_spots3a = [];
  static List<FlSpot> maintenance_spots3b = [];
  static List<FlSpot> maintenance_spots3c = [];
  static List<FlSpot> maintenance_spots4a = [];
  static List<FlSpot> maintenance_spots4b = [];
  static List<FlSpot> maintenance_spots4c = [];
  static Key maintenance_chartKey1a = UniqueKey();
  static Key maintenance_chartKey1b = UniqueKey();
  static Key maintenance_chartKey1c = UniqueKey();
  static Key maintenance_chartKey2a = UniqueKey();
  static Key maintenance_chartKey2b = UniqueKey();
  static Key maintenance_chartKey2c = UniqueKey();
  static Key maintenance_chartKey3a = UniqueKey();
  static Key maintenance_chartKey3b = UniqueKey();
  static Key maintenance_chartKey3c = UniqueKey();
  static List<OrdinalSales> maintenance_ordinary_sales1a = [];
  static List<OrdinalSales> maintenance_ordinary_sales2a = [];
  static List<OrdinalSales> maintenance_ordinary_sales3a = [];
  static List<OrdinalSales> maintenance_ordinary_sales3b = [];
  static List<BarChartGroupData> maintenance_barChartData1 = [];
  static List<BarChartGroupData> maintenance_barChartData2 = [];
  static List<BarChartGroupData> maintenance_barChartData3 = [];
  static List<BarChartGroupData> maintenance_barChartData4 = [];

  static List<MaintanaceCategory> maintenance_droupedChartData1 = [];
  static List<MaintanaceCategory> maintenance_droupedChartData2 = [];
  static List<MaintanaceCategory> maintenance_droupedChartData3 = [];
  static List<MaintanaceCategory> maintenance_droupedChartData4 = [];

  static String maintenance_most_frequent_upgrades1a = "0";
  static String maintenance_most_frequent_upgrades2a = "0";
  static String maintenance_most_frequent_upgrades3a = "0";
  static String maintenance_most_frequent_upgrades3b = "0";

  static String maintenance_most_frequent_downgrades1a = "0";
  static String maintenance_most_frequent_downgrades2a = "0";
  static String maintenance_most_frequent_downgrades3a = "0";
  static String maintenance_most_frequent_downgrades3b = "0";

  static int maintenance_most_frequent_upgrades1a_count = 0;
  static int maintenance_most_frequent_upgrades2a_count = 0;
  static int maintenance_most_frequent_upgrades3a_count = 0;
  static int maintenance_most_frequent_upgrades3b_count = 0;

  static int maintenance_most_frequent_downgrades1a_count = 0;
  static int maintenance_most_frequent_downgrades2a_count = 0;
  static int maintenance_most_frequent_downgrades3a_count = 0;
  static int maintenance_most_frequent_downgrades3b_count = 0;

  //Claims
  static double claims_ratio1a = 0;
  static double claims_ratio2a = 0;
  static double claims_ratio3a = 0;
  static double claims_ratio3b = 0;
  static int claims_maxY = 0;
  static int claims_maxY2 = 0;
  static int claims_maxY3 = 0;
  static int claims_maxY4 = 0;
  static int claims_maxY5a = 0;
  static int claims_maxY5b = 0;
  static int claims_maxY5c = 0;
  static int claims_maxY5d = 0;
  static int claims_maxY6 = 0;
  static List<claims_sections_gridmodel> claims_sectionsList1a = [];
  static List<claims_sections_gridmodel> claims_sectionsList1a_1 = [];
  static List<claims_sections_gridmodel> claims_sectionsList1b = [];
  static List<claims_sections_gridmodel> claims_sectionsList1b_1 = [];
  static List<claims_sections_gridmodel> claims_sectionsList1c = [];
  static List<claims_sections_gridmodel> claims_sectionsList1c_1 = [];
  static List<claims_sections_gridmodel> claims_sectionsList1d = [];
  static List<claims_sections_gridmodel> claims_sectionsList1d_1 = [];

  static List<claims_sections_gridmodel> claims_sectionsList2a = [];
  static List<claims_sections_gridmodel> claims_sectionsList2a_1 = [];
  static List<claims_sections_gridmodel> claims_sectionsList2b = [];
  static List<claims_sections_gridmodel> claims_sectionsList2b_1 = [];
  static List<claims_sections_gridmodel> claims_sectionsList2c = [];
  static List<claims_sections_gridmodel> claims_sectionsList2c_1 = [];
  static List<claims_sections_gridmodel> claims_sectionsList2d = [];
  static List<claims_sections_gridmodel> claims_sectionsList2d_1 = [];
  static List<claims_sections_gridmodel> claims_sectionsList3a = [];
  static List<claims_sections_gridmodel> claims_sectionsList3a_1 = [];
  static List<claims_sections_gridmodel> claims_sectionsList3a_2 = [];
  static List<claims_sections_gridmodel> claims_sectionsList3b = [];
  static List<claims_sections_gridmodel> claims_sectionsList3b_1 = [];
  static List<claims_sections_gridmodel> claims_sectionsList3c = [];
  static List<claims_sections_gridmodel> claims_sectionsList3c_1 = [];
  static List<claims_sections_gridmodel> claims_sectionsList3d = [];
  static List<claims_sections_gridmodel> claims_sectionsList3d_1 = [];
  static List<SalesByBranch> claims_salesbybranch1a = [];
  static List<SalesByBranch> claims_salesbybranch2a = [];
  static List<SalesByBranch> claims_salesbybranch3a = [];
  static List<SalesByBranch> claims_salesbybranch3b = [];
  static List<SalesByAgent> claims_salesbyagent1a = [];
  static List<SalesByAgent> claims_salesbyagent1b = [];
  static List<SalesByAgent> claims_salesbyagent1c = [];
  static List<SalesByAgent> claims_salesbyagent2a = [];
  static List<SalesByAgent> claims_salesbyagent2b = [];
  static List<SalesByAgent> claims_salesbyagent2c = [];
  static List<SalesByAgent> claims_salesbyagent3a = [];
  static List<SalesByAgent> claims_salesbyagent3b = [];
  static List<SalesByAgent> claims_salesbyagent3c = [];
  static List<BarChartGroupData> claims_barData = [];
  static List<PieChartSectionData> claims_pieData = [];
  static List<String> claims_bottomTitles1a = [];
  static List<String> claims_bottomTitles2a = [];
  static List<String> claims_bottomTitles3a = [];
  static List<String> claims_bottomTitles3b = [];
  static String claims_formattedStartDate = "";
  static String claims_formattedEndDate = "";
  static List<charts.Series<dynamic, String>> claims_seriesList = [];
  static List<charts.Series<OrdinalSales, String>> claims_bardata5a = [];
  static List<charts.Series<OrdinalSales, String>> claims_bardata5b = [];
  static List<charts.Series<OrdinalSales, String>> claims_bardata5c = [];
  static List<charts.Series<OrdinalSales, String>> claims_bardata5d = [];
  static List<FlSpot> claims_spots1a = [];
  static List<FlSpot> claims_spots1b = [];
  static List<FlSpot> claims_spots1c = [];
  static List<FlSpot> claims_spots2a = [];
  static List<FlSpot> claims_spots2b = [];
  static List<FlSpot> claims_spots2c = [];
  static List<FlSpot> claims_spots3a = [];
  static List<FlSpot> claims_spots3b = [];
  static List<FlSpot> claims_spots3c = [];
  static List<FlSpot> claims_spots4a = [];
  static List<FlSpot> claims_spots4b = [];
  static List<FlSpot> claims_spots4c = [];
  static Key claims_chartKey1a = UniqueKey();
  static Key claims_chartKey1b = UniqueKey();
  static Key claims_chartKey1c = UniqueKey();
  static Key claims_chartKey2a = UniqueKey();
  static Key claims_chartKey2b = UniqueKey();
  static Key claims_chartKey2c = UniqueKey();
  static Key claims_chartKey3a = UniqueKey();
  static Key claims_chartKey3b = UniqueKey();
  static Key claims_chartKey3c = UniqueKey();
  static List<OrdinalSales> claims_ordinary_sales1a = [];
  static List<OrdinalSales> claims_ordinary_sales2a = [];
  static List<OrdinalSales> claims_ordinary_sales3a = [];
  static List<OrdinalSales> claims_ordinary_sales3b = [];
  static List<BarChartGroupData> claims_barChartData1 = [];
  static List<BarChartGroupData> claims_barChartData2 = [];
  static List<BarChartGroupData> claims_barChartData3 = [];
  static List<BarChartGroupData> claims_barChartData4 = [];

  static double claims_paid_claims_amount1a = 0.0;
  static double claims_paid_claims_amount1b = 0.0;
  static double claims_paid_claims_amount1c = 0.0;
  static double claims_paid_claims_amount1d = 0.0;
  static double claims_paid_claims_amount2a = 0.0;
  static double claims_paid_claims_amount3a = 0.0;
  static double claims_paid_claims_amount3b = 0.0;
  static double claims_outstanding_claims_amount1a = 0.0;
  static double claims_outstanding_claims_amount1b = 0.0;
  static double claims_outstanding_claims_amount1c = 0.0;
  static double claims_outstanding_claims_amount1d = 0.0;
  static double claims_repudiated_claims_amount1a = 0.0;
  static double claims_repudiated_claims_amount1b = 0.0;
  static double claims_repudiated_claims_amount1c = 0.0;
  static double claims_repudiated_claims_amount1d = 0.0;
  static List<ClaimStageCategory> claims_droupedChartData1 = [];
  static List<ClaimStageCategory> claims_droupedChartData2 = [];
  static List<ClaimStageCategory> claims_droupedChartData3 = [];
  static List<ClaimStageCategory> claims_droupedChartData4 = [];
  static double claims_sum_paid1a = 0;
  static double claims_sum_paid2a = 0;
  static double claims_sum_paid3a = 0;
  static double claims_sum_paid3b = 0;

  static Map claims_by_category1a = {};
  static Map claims_by_category2a = {};
  static Map claims_by_category3a = {};
  static Map claims_by_category3b = {};

  static Map claims_sum_by_category1a = {};
  static Map claims_sum_by_category2a = {};
  static Map claims_sum_by_category3a = {};
  static Map claims_sum_by_category3b = {};

  static double claims_sum_ongoing1a = 0;
  static double claims_sum_ongoing2a = 0;
  static double claims_sum_ongoing3a = 0;
  static double claims_sum_ongoing3b = 0;

  static double claims_sum_declined1a = 0;
  static double claims_sum_declined2a = 0;
  static double claims_sum_declined3a = 0;
  static double claims_sum_declined3b = 0;

  static double myClaimsSumOfPremiums1 = 0.0;
  static double myClaimsSumOfPremiums2 = 0.0;
  static double myClaimsSumOfPremiums3 = 0.0;

  static double claims_count_paid1a = 0;
  static double claims_count_paid2a = 0;
  static double claims_count_paid3a = 0;
  static double claims_count_paid3b = 0;

  static double claims_count_ongoing1a = 0;
  static double claims_count_ongoing2a = 0;
  static double claims_count_ongoing3a = 0;
  static double claims_count_ongoing3b = 0;

  static double claims_count_declined1a = 0;
  static double claims_count_declined2a = 0;
  static double claims_count_declined3a = 0;
  static double claims_count_declined3b = 0;

  static List<int> claims_deceased_ages_list1a = [];
  static List<int> claims_deceased_ages_list2a = [];
  static List<int> claims_deceased_ages_list3a = [];
  static List<int> claims_deceased_ages_list3b = [];

  static Map claims_section_list1a = {};
  static Map claims_section_list2a = {};
  static Map claims_section_list3a = {};
  static Map claims_section_list3b = {};

  //Morale Index
  static int moral_index_maxY = 0;
  static int moral_index_maxY2 = 0;
  static int moral_index_maxY3 = 0;
  static int moral_index_maxY4 = 0;
  static int moral_index_maxY5a = 0;
  static int moral_index_maxY5b = 0;
  static int moral_index_maxY5c = 0;
  static int moral_index_maxY5d = 0;
  static int moral_index_maxY6 = 0;
  static List<salesgridmodel> moral_index_sectionsList1a = [];
  static List<salesgridmodel> moral_index_sectionsList2a = [];
  static List<salesgridmodel> moral_index_sectionsList3a = [];
  static List<salesgridmodel> moral_index_sectionsList3b = [];
  static List<SalesByBranch> moral_index_salesbybranch1a = [];
  static List<SalesByBranch> moral_index_salesbybranch2a = [];
  static List<SalesByBranch> moral_index_salesbybranch3a = [];
  static List<SalesByBranch> moral_index_salesbybranch3b = [];
  static List<SalesByAgent> moral_index_salesbyagent1a = [];
  static List<SalesByAgent> moral_index_salesbyagent1b = [];
  static List<SalesByAgent> moral_index_salesbyagent1c = [];
  static List<SalesByAgent> moral_index_salesbyagent2a = [];
  static List<SalesByAgent> moral_index_salesbyagent2b = [];
  static List<SalesByAgent> moral_index_salesbyagent2c = [];
  static List<SalesByAgent> moral_index_salesbyagent3a = [];
  static List<SalesByAgent> moral_index_salesbyagent3b = [];
  static List<SalesByAgent> moral_index_salesbyagent3c = [];
  static List<BarChartGroupData> moral_index_barData = [];
  static List<PieChartSectionData> moral_index_pieData_1 = [];
  static List<PieChartSectionData> moral_index_pieData_2 = [];
  static List<PieChartSectionData> moral_index_pieData_3 = [];
  static List<PieChartSectionData> moral_index_pieData_4 = [];
  static List<String> moral_index_bottomTitles1a = [];
  static List<String> moral_index_bottomTitles2a = [];
  static List<String> moral_index_bottomTitles3a = [];
  static List<String> moral_index_bottomTitles3b = [];
  static String moral_index_formattedStartDate = "";
  static String moral_index_formattedEndDate = "";
  static List<charts.Series<dynamic, String>> moral_index_seriesList = [];
  static List<charts.Series<OrdinalSales, String>> moral_index_bardata5a = [];
  static List<charts.Series<OrdinalSales, String>> moral_index_bardata5b = [];
  static List<charts.Series<OrdinalSales, String>> moral_index_bardata5c = [];
  static List<charts.Series<OrdinalSales, String>> moral_index_bardata5d = [];
  static List<FlSpot> moral_index_spots1a = [];
  static List<FlSpot> moral_index_spots1b = [];
  static List<FlSpot> moral_index_spots1c = [];
  static List<FlSpot> moral_index_spots2a = [];
  static List<FlSpot> moral_index_spots2b = [];
  static List<FlSpot> moral_index_spots2c = [];
  static List<FlSpot> moral_index_spots3a = [];
  static List<FlSpot> moral_index_spots3b = [];
  static List<FlSpot> moral_index_spots3c = [];
  static List<FlSpot> moral_index_spots4a = [];
  static List<FlSpot> moral_index_spots4b = [];
  static List<FlSpot> moral_index_spots4c = [];
  static Key moral_index_chartKey1a = UniqueKey();
  static Key moral_index_chartKey1b = UniqueKey();
  static Key moral_index_chartKey1c = UniqueKey();
  static Key moral_index_chartKey2a = UniqueKey();
  static Key moral_index_chartKey2b = UniqueKey();
  static Key moral_index_chartKey2c = UniqueKey();
  static Key moral_index_chartKey3a = UniqueKey();
  static Key moral_index_chartKey3b = UniqueKey();
  static Key moral_index_chartKey3c = UniqueKey();
  static List<OrdinalSales> moral_index_ordinary_sales1a = [];
  static List<OrdinalSales> moral_index_ordinary_sales2a = [];
  static List<OrdinalSales> moral_index_ordinary_sales3a = [];
  static List<OrdinalSales> moral_index_ordinary_sales3b = [];
  static List<BarChartGroupData> moral_index_barChartData1 = [];
  static List<BarChartGroupData> moral_index_barChartData2 = [];
  static List<BarChartGroupData> moral_index_barChartData3 = [];
  static List<BarChartGroupData> moral_index_barChartData4 = [];

  static List<MoraleIndexCategory> moral_index_groupedChartData1 = [];
  static List<MoraleIndexCategory> moral_index_droupedChartData2 = [];
  static List<MoraleIndexCategory> moral_index_droupedChartData3 = [];
  static List<MoraleIndexCategory> moral_index_droupedChartData4 = [];

  static int new_timesOpened = 0;
  static bool showOnboardingScreen = false;
  static List random_colors = [
    Color(0xFF2196F3),
    Color(0xFFFFC300),
    Color(0xFFFF683B),
    Color(0xFF3BFF49),
    Color(0xFF6E1BFF),
    Color(0xFFFF3AF2),
    Color(0xFFE80054),
    Color(0xFF50E4FF),
    Color(0xFF2196F3),
    Color(0xFFFFC300),
    Color(0xFFFF683B),
    Color(0xFF3BFF49),
    Color(0xFF6E1BFF),
    Color(0xFFFF3AF2),
    Color(0xFFE80054),
    Color(0xFF50E4FF),
    Color(0xFF2196F3),
    Color(0xFFFFC300),
    Color(0xFFFF683B),
    Color(0xFF3BFF49),
    Color(0xFF6E1BFF),
    Color(0xFFFF3AF2),
    Color(0xFFE80054),
    Color(0xFF50E4FF),
    Color(0xFF2196F3),
    Color(0xFFFFC300),
    Color(0xFFFF683B),
    Color(0xFF3BFF49),
    Color(0xFF6E1BFF),
    Color(0xFFFF3AF2),
    Color(0xFFE80054),
    Color(0xFF50E4FF),
    Color(0xFF2196F3),
    Color(0xFFFFC300),
    Color(0xFFFF683B),
    Color(0xFF3BFF49),
    Color(0xFF6E1BFF),
    Color(0xFFFF3AF2),
    Color(0xFFE80054),
    Color(0xFF50E4FF),
    Color(0xFF2196F3),
    Color(0xFFFFC300),
    Color(0xFFFF683B),
    Color(0xFF3BFF49),
    Color(0xFF6E1BFF),
    Color(0xFFFF3AF2),
    Color(0xFFE80054),
    Color(0xFF50E4FF),
    Color(0xFF2196F3),
    Color(0xFFFFC300),
    Color(0xFFFF683B),
    Color(0xFF3BFF49),
    Color(0xFF6E1BFF),
    Color(0xFFFF3AF2),
    Color(0xFFE80054),
    Color(0xFF50E4FF),
    Color(0xFF2196F3),
    Color(0xFFFFC300),
    Color(0xFFFF683B),
    Color(0xFF3BFF49),
    Color(0xFF6E1BFF),
    Color(0xFFFF3AF2),
    Color(0xFFE80054),
    Color(0xFF50E4FF),
    Color(0xFF2196F3),
    Color(0xFFFFC300),
    Color(0xFFFF683B),
    Color(0xFF3BFF49),
    Color(0xFF6E1BFF),
    Color(0xFFFF3AF2),
    Color(0xFFE80054),
    Color(0xFF50E4FF),
    Color(0xFF2196F3),
    Color(0xFFFFC300),
    Color(0xFFFF683B),
    Color(0xFF3BFF49),
    Color(0xFF6E1BFF),
    Color(0xFFFF3AF2),
    Color(0xFFE80054),
    Color(0xFF50E4FF),
    Color(0xFF2196F3),
    Color(0xFFFFC300),
    Color(0xFFFF683B),
    Color(0xFF3BFF49),
    Color(0xFF6E1BFF),
    Color(0xFFFF3AF2),
    Color(0xFFE80054),
    Color(0xFF50E4FF),
  ];

  static List<List<int>> dailySales8a = [];

  static Map<DateTime, double> dailySalesCount_new = {};

  static var jsonMonthlySalesData1;
  static var jsonMonthlySalesData2;
  static var jsonMonthlySalesData3;
  static var jsonMonthlySalesData4;

  static var jsonMonthlyMaintanenceData1;
  static var jsonMonthlyMaintanenceData2;
  static var jsonMonthlyMaintanenceData3;
  static var jsonMonthlyMaintanenceData4;

  static var jsonMonthlyClaimsData1;
  static var jsonMonthlyClaimsData2;
  static var jsonMonthlyClaimsData3;
  static var jsonMonthlyClaimsData4;

  static var jsonMonthlyClaimsPremiumData1;
  static var jsonMonthlyClaimsPremiumData2;
  static var jsonMonthlyClaimsPremiumData3;
  static var jsonMonthlyClaimsPremiumData4;

  static var claims_by_category1;

  static int comms_maxY = 0;
  static int comms_maxY2 = 0;
  static int comms_maxY3 = 0;
  static int comms_maxY4 = 0;
  static int comms_maxY5a = 0;
  static int comms_maxY5b = 0;
  static int comms_maxY5c = 0;
  static int comms_maxY5d = 0;
  static int comms_maxY6 = 0;
  static List<commsgridmodel> comms_sectionsList1a_a = [];
  static List<commsgridmodel> comms_sectionsList1a_b = [];
  static List<commsgridmodel> comms_sectionsList1a_c = [];
  static List<commsgridmodel> comms_sectionsList2a_a = [];
  static List<commsgridmodel> comms_sectionsList2a_b = [];
  static List<commsgridmodel> comms_sectionsList2a_c = [];
  static List<commsgridmodel> comms_sectionsList3a_a = [];
  static List<commsgridmodel> comms_sectionsList3a_b = [];
  static List<commsgridmodel> comms_sectionsList3a_c = [];
  static List<commsgridmodel> comms_sectionsList4a_a = [];
  static List<commsgridmodel> comms_sectionsList4a_b = [];
  static List<commsgridmodel> comms_sectionsList4a_c = [];
  static List<commsgridmodel> comms_sectionsList3b_a = [];
  static List<commsgridmodel> comms_sectionsList3b_b = [];
  static List<commsgridmodel> comms_sectionsList3b_c = [];
  static List<commsgridmodel> comms_sectionsList_1_1a = [];
  static List<commsgridmodel> comms_sectionsList_1_2a = [];
  static List<commsgridmodel> comms_sectionsList_1_3a = [];
  static List<commsgridmodel> comms_sectionsList_1_4a = [];
  static List<commsgridmodel> comms_sectionsList_1_3b = [];

  static List<commsgridmodel> comms_sectionsList_2_1a = [];
  static List<commsgridmodel> comms_sectionsList_2_2a = [];
  static List<commsgridmodel> comms_sectionsList_2_3a = [];
  static List<commsgridmodel> comms_sectionsList_2_4a = [];
  static List<commsgridmodel> comms_sectionsList_2_3b = [];

  static List<commsgridmodel> comms_sectionsList_3_1a = [];
  static List<commsgridmodel> comms_sectionsList_3_2a = [];
  static List<commsgridmodel> comms_sectionsList_3_3a = [];
  static List<commsgridmodel> comms_sectionsList_3_4a = [];
  static List<commsgridmodel> comms_sectionsList_3_3b = [];

  static List<commsgridmodel> comms_sectionsList1a = [];
  static List<commsgridmodel> comms_sectionsList2a = [];
  static List<commsgridmodel> comms_sectionsList3a = [];
  static List<commsgridmodel> comms_sectionsList3b = [];

  static double percentage_delivered1a = 0.0;
  static double percentage_delivered2a = 0.0;
  static double percentage_delivered3a = 0.0;
  static double percentage_delivered3b = 0.0;

  static List<Claims_Details> claims_details1a = [];
  static List<Claims_Details> claims_details2a = [];
  static List<Claims_Details> claims_details3a = [];
  static List<Claims_Details> claims_details3b = [];

  static List<SalesByBranch> comms_salesbybranch1a = [];
  static List<SalesByBranch> comms_salesbybranch2a = [];
  static List<SalesByBranch> comms_salesbybranch3a = [];
  static List<SalesByBranch> comms_salesbybranch3b = [];
  static List<SalesByAgent> comms_salesbyagent1a = [];
  static List<SalesByAgent> comms_salesbyagent1b = [];
  static List<SalesByAgent> comms_salesbyagent1c = [];
  static List<SalesByAgent> comms_salesbyagent2a = [];
  static List<SalesByAgent> comms_salesbyagent2b = [];
  static List<SalesByAgent> comms_salesbyagent2c = [];
  static List<SalesByAgent> comms_salesbyagent3a = [];
  static List<SalesByAgent> comms_salesbyagent3b = [];
  static List<SalesByAgent> comms_salesbyagent3c = [];
  static List<BarChartGroupData> comms_barData = [];
  static List<PieChartSectionData> comms_pieData1a = [];
  static List<PieChartSectionData> comms_pieData2a = [];
  static List<PieChartSectionData> comms_pieData3a = [];
  static List<PieChartSectionData> comms_pieData4a = [];
  static Widget comms_treeMap1a = Container();
  static Widget comms_treeMap1a_1 = Container();
  static Widget comms_treeMap1a_2 = Container();
  static Widget comms_treeMap1a_3 = Container();
  static Widget comms_treeMap1a_4 = Container();
  static List<String> comms_bottomTitles1a = [];
  static List<String> comms_bottomTitles2a = [];
  static List<String> comms_bottomTitles3a = [];
  static List<String> comms_bottomTitles3b = [];
  static String comms_formattedStartDate = "";
  static String comms_formattedEndDate = "";
  static List<charts.Series<dynamic, String>> comms_seriesList = [];
  static List<charts.Series<OrdinalSales, String>> comms_bardata5a = [];
  static List<charts.Series<OrdinalSales, String>> comms_bardata5b = [];
  static List<charts.Series<OrdinalSales, String>> comms_bardata5c = [];
  static List<charts.Series<OrdinalSales, String>> comms_bardata5d = [];
  static List<FlSpot> comms_spots1a = [];
  static List<FlSpot> comms_spots1b = [];
  static List<FlSpot> comms_spots1c = [];
  static List<FlSpot> comms_spots2a = [];
  static List<FlSpot> comms_spots2b = [];
  static List<FlSpot> comms_spots2c = [];
  static List<FlSpot> comms_spots3a = [];
  static List<FlSpot> comms_spots3b = [];
  static List<FlSpot> comms_spots3c = [];
  static List<FlSpot> comms_spots4a = [];
  static List<FlSpot> comms_spots4b = [];
  static List<FlSpot> comms_spots4c = [];
  static Key comms_chartKey1a = UniqueKey();
  static Key comms_chartKey1b = UniqueKey();
  static Key comms_chartKey1c = UniqueKey();
  static Key comms_chartKey2a = UniqueKey();
  static Key comms_chartKey2b = UniqueKey();
  static Key comms_chartKey2c = UniqueKey();
  static Key comms_chartKey3a = UniqueKey();
  static Key comms_chartKey3b = UniqueKey();
  static Key comms_chartKey3c = UniqueKey();
  static Key comms_chartKey4a = UniqueKey();
  static Key comms_chartKey4b = UniqueKey();
  static Key comms_chartKey4c = UniqueKey();
  static Key comms_tree_key3a = UniqueKey();
  static Key comms_tree_key4a = UniqueKey();
  static List<OrdinalSales> comms_ordinary_sales1a = [];
  static List<OrdinalSales> comms_ordinary_sales2a = [];
  static List<OrdinalSales> comms_ordinary_sales3a = [];
  static List<OrdinalSales> comms_ordinary_sales3b = [];
  static Map<String, dynamic> comms_jsonResponse1a = {};
  static Map<String, dynamic> comms_jsonResponse2a = {};
  static Map<String, dynamic> comms_jsonResponse3a = {};
  static Map<String, dynamic> comms_jsonResponse4a = {};

  static int reprints_and_cancellations_bar_maxY1a = 0;
  static int reprints_and_cancellations_bar_maxY1b = 0;
  static int reprints_and_cancellations_bar_maxY1c = 0;
  static int reprints_and_cancellations_bar_maxY2a = 0;
  static int reprints_and_cancellations_bar_maxY2b = 0;
  static int reprints_and_cancellations_bar_maxY2c = 0;
  static int reprints_and_cancellations_bar_maxY3a = 0;
  static int reprints_and_cancellations_bar_maxY3b = 0;
  static int reprints_and_cancellations_bar_maxY3c = 0;
  static int reprints_and_cancellations_bar_maxY4a = 0;
  static int reprints_and_cancellations_bar_maxY4b = 0;
  static int reprints_and_cancellations_bar_maxY4c = 0;

  static List<charts.Series<OrdinalSales, String>>
      reprints_and_cancellations_bardata1a = [];
  static List<charts.Series<OrdinalSales, String>>
      reprints_and_cancellations_bardata1b = [];
  static List<charts.Series<OrdinalSales, String>>
      reprints_and_cancellations_bardata1c = [];
  static List<charts.Series<OrdinalSales, String>>
      reprints_and_cancellations_bardata2a = [];
  static List<charts.Series<OrdinalSales, String>>
      reprints_and_cancellations_bardata2b = [];
  static List<charts.Series<OrdinalSales, String>>
      reprints_and_cancellations_bardata2c = [];
  static List<charts.Series<OrdinalSales, String>>
      reprints_and_cancellations_bardata3a = [];
  static List<charts.Series<OrdinalSales, String>>
      reprints_and_cancellations_bardata3b = [];
  static List<charts.Series<OrdinalSales, String>>
      reprints_and_cancellations_bardata3c = [];
  static List<charts.Series<OrdinalSales, String>>
      reprints_and_cancellations_bardata4a = [];
  static List<charts.Series<OrdinalSales, String>>
      reprints_and_cancellations_bardata4b = [];
  static List<charts.Series<OrdinalSales, String>>
      reprints_and_cancellations_bardata4c = [];
  static String reprints_formattedStartDate = "";
  static String reprints_formattedEndDate = "";
  static List<cllc.gridmodel1> reprints_sectionsList1a = [];
  static List<cllc.gridmodel1> reprints_sectionsList2a = [];
  static List<cllc.gridmodel1> reprints_sectionsList3a = [];
  static List<cllc.gridmodel1> reprints_sectionsList3b = [];

  static double reprints_request_approval_rate1a = 0.0;
  static double reprints_request_approval_rate2a = 0.0;
  static double reprints_request_approval_rate3a = 0.0;
  static double reprints_request_approval_rate3b = 0.0;

  static double cancellations_request_approval_rate1a = 0.0;
  static double cancellations_request_approval_rate2a = 0.0;
  static double cancellations_request_approval_rate3a = 0.0;
  static double cancellations_request_approval_rate3b = 0.0;

  static List<cllc.gridmodel1> reprints_sectionsList1a_1 = [];
  static List<cllc.gridmodel1> reprints_sectionsList2a_1 = [];
  static List<cllc.gridmodel1> reprints_sectionsList3a_1 = [];
  static List<cllc.gridmodel1> reprints_sectionsList3b_1 = [];

  static List<cllc.gridmodel1> cancellations_sectionsList1a = [
    cllc.gridmodel1("Approved", 0, 0),
    cllc.gridmodel1("Exp. & Decl.", 0, 0),
    cllc.gridmodel1("Pending", 0, 0),
  ];
  static List<cllc.gridmodel1> cancellations_sectionsList2a = [
    cllc.gridmodel1("Approved", 0, 0),
    cllc.gridmodel1("Exp. & Decl.", 0, 0),
    cllc.gridmodel1("Pending", 0, 0),
  ];
  static List<cllc.gridmodel1> cancellations_sectionsList3a = [
    cllc.gridmodel1("Approved", 0, 0),
    cllc.gridmodel1("Exp. & Decl.", 0, 0),
    cllc.gridmodel1("Pending", 0, 0),
  ];
  static List<cllc.gridmodel1> cancellations_sectionsList3b = [
    cllc.gridmodel1("Approved", 0, 0),
    cllc.gridmodel1("Exp. & Decl.", 0, 0),
    cllc.gridmodel1("Pending", 0, 0),
  ];

  static List<cllc.gridmodel1> cancellations_sectionsList1a_1 = [];
  static List<cllc.gridmodel1> cancellations_sectionsList2a_1 = [];
  static List<cllc.gridmodel1> cancellations_sectionsList3a_1 = [];
  static List<cllc.gridmodel1> cancellations_sectionsList3b_1 = [];

  static List<ReprintByAgent> reprintbyagent = [];
  static List<ReprintByAgent> reprintbyagent1a = [];
  static List<ReprintByAgent> reprintbyagent2a = [];
  static List<ReprintByAgent> reprintbyagent3a = [];
  static List<ReprintByAgent> reprintbyagent3b = [];
  static List<ReprintByAgent> bottomsreprintbyagent = [];
  static List<ReprintByAgent> bottomsreprintbyagent1a = [];
  static List<ReprintByAgent> bottomsreprintbyagent2a = [];
  static List<ReprintByAgent> bottomsreprintbyagent3a = [];
  static List<ReprintByAgent> bottomsreprintbyagent3b = [];

  static List<ReprintByAgent> top_10_cancellations_agents1a = [];
  static List<ReprintByAgent> cancellations_agents1a = [];
  static List<ReprintByAgent> cancellations_agents2a = [];
  static List<ReprintByAgent> cancellations_agents3a = [];
  static List<ReprintByAgent> cancellations_agents3b = [];
  static List<ReprintByAgent> bottomscancellations_agentst = [];
  static List<ReprintByAgent> bottomscancellations_agents1a = [];
  static List<ReprintByAgent> bottomscancellations_agents2a = [];
  static List<ReprintByAgent> bottomscancellations_agents3a = [];
  static List<ReprintByAgent> bottomscancellations_agents3b = [];

  static List<ReprintByAgent> reprints_agents1a = [];
  static List<ReprintByAgent> reprints_agents2a = [];
  static List<ReprintByAgent> reprints_agents3a = [];
  static List<ReprintByAgent> reprints_agents3b = [];
  static List<ReprintByAgent> reprints_agentst = [];
  static List<ReprintByAgent> bottomsreprints_agents1a = [];
  static List<ReprintByAgent> bottomsreprints_agents2a = [];
  static List<ReprintByAgent> bottomsreprints_agents3a = [];
  static List<ReprintByAgent> bottomsreprints_agents3b = [];

  static int attendance_bar_maxY1a = 0;
  static int attendance_bar_maxY1b = 0;
  static int attendance_bar_maxY1c = 0;
  static int attendance_bar_maxY2a = 0;
  static int attendance_bar_maxY2b = 0;
  static int attendance_bar_maxY2c = 0;
  static int attendance_bar_maxY3a = 0;
  static int attendance_bar_maxY3b = 0;
  static int attendance_bar_maxY3c = 0;
  static int attendance_bar_maxY4a = 0;
  static int attendance_bar_maxY4b = 0;
  static int attendance_bar_maxY4c = 0;

  static List<charts.Series<OrdinalSales, String>> attendance_bardata1a = [];
  static List<charts.Series<OrdinalSales, String>> attendance_bardata1b = [];
  static List<charts.Series<OrdinalSales, String>> attendance_bardata1c = [];
  static List<charts.Series<OrdinalSales, String>> attendance_bardata2a = [];
  static List<charts.Series<OrdinalSales, String>> attendance_bardata2b = [];
  static List<charts.Series<OrdinalSales, String>> attendance_bardata2c = [];
  static List<charts.Series<OrdinalSales, String>> attendance_bardata3a = [];
  static List<charts.Series<OrdinalSales, String>> attendance_bardata3b = [];
  static List<charts.Series<OrdinalSales, String>> attendance_bardata3c = [];
  static List<charts.Series<OrdinalSales, String>> attendance_bardata4a = [];
  static List<charts.Series<OrdinalSales, String>> attendance_bardata4b = [];
  static List<charts.Series<OrdinalSales, String>> attendance_bardata4c = [];
  static String attendance_formattedStartDate = "";
  static String attendance_formattedEndDate = "";
  static List<att.attendance_gridmodel> attendance_sectionsList1a = [
    att.attendance_gridmodel("Total Staff", 0, 0),
    att.attendance_gridmodel("Present", 0, 0),
    att.attendance_gridmodel("Absent", 0, 0),
  ];
  static List<att.attendance_gridmodel> attendance_sectionsList2a = [];
  static List<att.attendance_gridmodel> attendance_sectionsList3a = [];
  static List<att.attendance_gridmodel> attendance_sectionsList3b = [];

  static List<att.attendance_gridmodel> attendance_sectionsList1a_1 = [];
  static List<att.attendance_gridmodel> attendance_sectionsList2a_1 = [];
  static List<att.attendance_gridmodel> attendance_sectionsList3a_1 = [];
  static List<att.attendance_gridmodel> attendance_sectionsList3b_1 = [];
  static List<att.AttendanceTypeGridItem> attendanceTypes1a = [
    att.AttendanceTypeGridItem('PRESENT', Colors.green, Icons.check, 0),
    att.AttendanceTypeGridItem(
        'ANNUAL LEAVE', Colors.indigo, Icons.calendar_today_sharp, 0),
    att.AttendanceTypeGridItem(
        'LATE COMING', Colors.black, Icons.timer_sharp, 0),
    att.AttendanceTypeGridItem(
        'MATERNITY LEAVE', Colors.indigo[400]!, Icons.local_hospital, 0),
    att.AttendanceTypeGridItem(
        'SUSPENDED', Colors.orange, Icons.timer_off_outlined, 0),
    att.AttendanceTypeGridItem('PATERNITY LEAVE', Colors.indigo[400]!,
        Icons.local_hospital_outlined, 0),
    att.AttendanceTypeGridItem(
        'NOT MARKED', Colors.grey, Icons.settings_outlined, 0),
    att.AttendanceTypeGridItem(
        'SICK LEAVE', Colors.orange[300]!, Icons.calendar_today_outlined, 0),
    att.AttendanceTypeGridItem('AWOL', Colors.red[400]!, Icons.help, 0),
    att.AttendanceTypeGridItem(
        'TRAINING', Colors.orangeAccent[400]!, Icons.access_time_rounded, 0),
    att.AttendanceTypeGridItem(
        'DAY OFF', Colors.redAccent, Icons.access_time_rounded, 0),
    att.AttendanceTypeGridItem(
        'RESIGNED', Colors.red, Icons.timelapse_rounded, 0),
    att.AttendanceTypeGridItem('FAMILY RESPONSIBILITY', Colors.indigoAccent,
        Icons.calendar_today_sharp, 0),
  ];
  static List<att.AttendanceTypeGridItem> attendanceTypes2a = [
    att.AttendanceTypeGridItem('PRESENT', Colors.green, Icons.check, 0),
    att.AttendanceTypeGridItem(
        'ANNUAL LEAVE', Colors.indigo, Icons.calendar_today_sharp, 0),
    att.AttendanceTypeGridItem(
        'LATE COMING', Colors.black, Icons.timer_sharp, 0),
    att.AttendanceTypeGridItem(
        'MATERNITY LEAVE', Colors.indigo[400]!, Icons.local_hospital, 0),
    att.AttendanceTypeGridItem(
        'SUSPENDED', Colors.orange, Icons.timer_off_outlined, 0),
    att.AttendanceTypeGridItem('PATERNITY LEAVE', Colors.indigo[400]!,
        Icons.local_hospital_outlined, 0),
    att.AttendanceTypeGridItem(
        'NOT MARKED', Colors.grey, Icons.settings_outlined, 0),
    att.AttendanceTypeGridItem(
        'SICK LEAVE', Colors.orange[300]!, Icons.calendar_today_outlined, 0),
    att.AttendanceTypeGridItem('AWOL', Colors.red[400]!, Icons.help, 0),
    att.AttendanceTypeGridItem(
        'TRAINING', Colors.orangeAccent[400]!, Icons.access_time_rounded, 0),
    att.AttendanceTypeGridItem(
        'DAY OFF', Colors.redAccent, Icons.access_time_rounded, 0),
    att.AttendanceTypeGridItem(
        'RESIGNED', Colors.red, Icons.timelapse_rounded, 0),
    att.AttendanceTypeGridItem('FAMILY RESPONSIBILITY', Colors.indigoAccent,
        Icons.calendar_today_sharp, 0),
  ];
  static List<att.AttendanceTypeGridItem> attendanceTypes3a = [
    att.AttendanceTypeGridItem('PRESENT', Colors.green, Icons.check, 0),
    att.AttendanceTypeGridItem(
        'ANNUAL LEAVE', Colors.indigo, Icons.calendar_today_sharp, 0),
    att.AttendanceTypeGridItem(
        'LATE COMING', Colors.black, Icons.timer_sharp, 0),
    att.AttendanceTypeGridItem(
        'MATERNITY LEAVE', Colors.indigo[400]!, Icons.local_hospital, 0),
    att.AttendanceTypeGridItem(
        'SUSPENDED', Colors.orange, Icons.timer_off_outlined, 0),
    att.AttendanceTypeGridItem('PATERNITY LEAVE', Colors.indigo[400]!,
        Icons.local_hospital_outlined, 0),
    att.AttendanceTypeGridItem(
        'NOT MARKED', Colors.grey, Icons.settings_outlined, 0),
    att.AttendanceTypeGridItem(
        'SICK LEAVE', Colors.orange[300]!, Icons.calendar_today_outlined, 0),
    att.AttendanceTypeGridItem('AWOL', Colors.red[400]!, Icons.help, 0),
    att.AttendanceTypeGridItem(
        'TRAINING', Colors.orangeAccent[400]!, Icons.access_time_rounded, 0),
    att.AttendanceTypeGridItem(
        'DAY OFF', Colors.redAccent, Icons.access_time_rounded, 0),
    att.AttendanceTypeGridItem(
        'RESIGNED', Colors.red, Icons.timelapse_rounded, 0),
    att.AttendanceTypeGridItem('FAMILY RESPONSIBILITY', Colors.indigoAccent,
        Icons.calendar_today_sharp, 0),
  ];
  static List<att.AttendanceTypeGridItem> attendanceTypes3b = [
    att.AttendanceTypeGridItem('PRESENT', Colors.green, Icons.check, 0),
    att.AttendanceTypeGridItem(
        'ANNUAL LEAVE', Colors.indigo, Icons.calendar_today_sharp, 0),
    att.AttendanceTypeGridItem(
        'LATE COMING', Colors.black, Icons.timer_sharp, 0),
    att.AttendanceTypeGridItem(
        'MATERNITY LEAVE', Colors.indigo[400]!, Icons.local_hospital, 0),
    att.AttendanceTypeGridItem(
        'SUSPENDED', Colors.orange, Icons.timer_off_outlined, 0),
    att.AttendanceTypeGridItem('PATERNITY LEAVE', Colors.indigo[400]!,
        Icons.local_hospital_outlined, 0),
    att.AttendanceTypeGridItem(
        'NOT MARKED', Colors.grey, Icons.settings_outlined, 0),
    att.AttendanceTypeGridItem(
        'SICK LEAVE', Colors.orange[300]!, Icons.calendar_today_outlined, 0),
    att.AttendanceTypeGridItem('AWOL', Colors.red[400]!, Icons.help, 0),
    att.AttendanceTypeGridItem(
        'TRAINING', Colors.orangeAccent[400]!, Icons.access_time_rounded, 0),
    att.AttendanceTypeGridItem(
        'DAY OFF', Colors.redAccent, Icons.access_time_rounded, 0),
    att.AttendanceTypeGridItem(
        'RESIGNED', Colors.red, Icons.timelapse_rounded, 0),
    att.AttendanceTypeGridItem('FAMILY RESPONSIBILITY', Colors.indigoAccent,
        Icons.calendar_today_sharp, 0),
  ];
  static double absenteeism_ratio1a = 0;
  static double absenteeism_ratio2a = 0;
  static double absenteeism_ratio3a = 0;
  static double absenteeism_ratio3b = 0;

  static bool isDataSynced = false;

  //Customer Profile
  static int customers_maleCount1a_1_1 = 0;
  static int customers_maleCount1a_1_2 = 0;
  static int customers_maleCount1a_1_3 = 0;
  static int customers_maleCount1a_1_4 = 0;
  static int customers_maleCount1a_2_1 = 0;
  static int customers_maleCount1a_2_2 = 0;
  static int customers_maleCount1a_2_3 = 0;
  static int customers_maleCount1a_2_4 = 0;
  static int customers_maleCount1a_3_1 = 0;
  static int customers_maleCount1a_3_2 = 0;
  static int customers_maleCount1a_3_3 = 0;
  static int customers_maleCount1a_3_4 = 0;

  static int customers_maleCount2a_1_1 = 0;
  static int customers_maleCount2a_1_2 = 0;
  static int customers_maleCount2a_1_3 = 0;
  static int customers_maleCount2a_1_4 = 0;
  static int customers_maleCount3a_1_1 = 0;
  static int customers_maleCount3a_1_2 = 0;
  static int customers_maleCount3a_1_3 = 0;
  static int customers_maleCount3a_1_4 = 0;
  static int customers_maleCount3b_1_1 = 0;
  static int customers_maleCount3b_1_2 = 0;
  static int customers_maleCount3b_1_3 = 0;
  static int customers_maleCount3b_1_4 = 0;

  static int customers_maleCount2a_2_1 = 0;
  static int customers_maleCount2a_2_2 = 0;
  static int customers_maleCount2a_2_3 = 0;
  static int customers_maleCount2a_2_4 = 0;
  static int customers_maleCount3a_2_1 = 0;
  static int customers_maleCount3a_2_2 = 0;
  static int customers_maleCount3a_2_3 = 0;
  static int customers_maleCount3a_2_4 = 0;
  static int customers_maleCount3b_2_1 = 0;
  static int customers_maleCount3b_2_2 = 0;
  static int customers_maleCount3b_2_3 = 0;
  static int customers_maleCount3b_2_4 = 0;

  static int customers_maleCount2a_3_1 = 0;
  static int customers_maleCount2a_3_2 = 0;
  static int customers_maleCount2a_3_3 = 0;
  static int customers_maleCount2a_3_4 = 0;
  static int customers_maleCount3a_3_1 = 0;
  static int customers_maleCount3a_3_2 = 0;
  static int customers_maleCount3a_3_3 = 0;
  static int customers_maleCount3a_3_4 = 0;
  static int customers_maleCount3b_3_1 = 0;
  static int customers_maleCount3b_3_2 = 0;
  static int customers_maleCount3b_3_3 = 0;
  static int customers_maleCount3b_3_4 = 0;

  static double customers_malePercentage1a_1_1 = 0;
  static double customers_malePercentage1a_1_2 = 0;
  static double customers_malePercentage1a_1_3 = 0;
  static double customers_malePercentage1a_1_4 = 0;
  static double customers_malePercentage2a_1_1 = 0;
  static double customers_malePercentage2a_1_2 = 0;
  static double customers_malePercentage2a_1_3 = 0;
  static double customers_malePercentage2a_1_4 = 0;
  static double customers_malePercentage3a_1_1 = 0;
  static double customers_malePercentage3a_1_2 = 0;
  static double customers_malePercentage3a_1_3 = 0;
  static double customers_malePercentage3a_1_4 = 0;
  static double customers_malePercentage3b_1_1 = 0;
  static double customers_malePercentage3b_1_2 = 0;
  static double customers_malePercentage3b_1_3 = 0;
  static double customers_malePercentage3b_1_4 = 0;

  static double customers_malePercentage1a_2_1 = 0;
  static double customers_malePercentage1a_2_2 = 0;
  static double customers_malePercentage1a_2_3 = 0;
  static double customers_malePercentage1a_2_4 = 0;
  static double customers_malePercentage2a_2_1 = 0;
  static double customers_malePercentage2a_2_2 = 0;
  static double customers_malePercentage2a_2_3 = 0;
  static double customers_malePercentage2a_2_4 = 0;
  static double customers_malePercentage3a_2_1 = 0;
  static double customers_malePercentage3a_2_2 = 0;
  static double customers_malePercentage3a_2_3 = 0;
  static double customers_malePercentage3a_2_4 = 0;
  static double customers_malePercentage3b_2_1 = 0;
  static double customers_malePercentage3b_2_2 = 0;
  static double customers_malePercentage3b_2_3 = 0;
  static double customers_malePercentage3b_2_4 = 0;

  static double customers_malePercentage1a_3_1 = 0;
  static double customers_malePercentage1a_3_2 = 0;
  static double customers_malePercentage1a_3_3 = 0;
  static double customers_malePercentage1a_3_4 = 0;
  static double customers_malePercentage2a_3_1 = 0;
  static double customers_malePercentage2a_3_2 = 0;
  static double customers_malePercentage2a_3_3 = 0;
  static double customers_malePercentage2a_3_4 = 0;
  static double customers_malePercentage3a_3_1 = 0;
  static double customers_malePercentage3a_3_2 = 0;
  static double customers_malePercentage3a_3_3 = 0;
  static double customers_malePercentage3a_3_4 = 0;
  static double customers_malePercentage3b_3_1 = 0;
  static double customers_malePercentage3b_3_2 = 0;
  static double customers_malePercentage3b_3_3 = 0;
  static double customers_malePercentage3b_3_4 = 0;

  static int customers_femaleCount1a_1_1 = 0;
  static int customers_femaleCount1a_1_2 = 0;
  static int customers_femaleCount1a_1_3 = 0;
  static int customers_femaleCount1a_1_4 = 0;
  static int customers_femaleCount2a_1_1 = 0;
  static int customers_femaleCount2a_1_2 = 0;
  static int customers_femaleCount2a_1_3 = 0;
  static int customers_femaleCount2a_1_4 = 0;
  static int customers_femaleCount3a_1_1 = 0;
  static int customers_femaleCount3a_1_2 = 0;
  static int customers_femaleCount3a_1_3 = 0;
  static int customers_femaleCount3a_1_4 = 0;
  static int customers_femaleCount3b_1_1 = 0;
  static int customers_femaleCount3b_1_2 = 0;
  static int customers_femaleCount3b_1_3 = 0;
  static int customers_femaleCount3b_1_4 = 0;

  static int customers_femaleCount1a_2_1 = 0;
  static int customers_femaleCount1a_2_2 = 0;
  static int customers_femaleCount1a_2_3 = 0;
  static int customers_femaleCount1a_2_4 = 0;
  static int customers_femaleCount2a_2_1 = 0;
  static int customers_femaleCount2a_2_2 = 0;
  static int customers_femaleCount2a_2_3 = 0;
  static int customers_femaleCount2a_2_4 = 0;
  static int customers_femaleCount3a_2_1 = 0;
  static int customers_femaleCount3a_2_2 = 0;
  static int customers_femaleCount3a_2_3 = 0;
  static int customers_femaleCount3a_2_4 = 0;
  static int customers_femaleCount3b_2_1 = 0;
  static int customers_femaleCount3b_2_2 = 0;
  static int customers_femaleCount3b_2_3 = 0;
  static int customers_femaleCount3b_2_4 = 0;

  static int customers_femaleCount1a_3_1 = 0;
  static int customers_femaleCount1a_3_2 = 0;
  static int customers_femaleCount1a_3_3 = 0;
  static int customers_femaleCount1a_3_4 = 0;
  static int customers_femaleCount2a_3_1 = 0;
  static int customers_femaleCount2a_3_2 = 0;
  static int customers_femaleCount2a_3_3 = 0;
  static int customers_femaleCount2a_3_4 = 0;
  static int customers_femaleCount3a_3_1 = 0;
  static int customers_femaleCount3a_3_2 = 0;
  static int customers_femaleCount3a_3_3 = 0;
  static int customers_femaleCount3a_3_4 = 0;
  static int customers_femaleCount3b_3_1 = 0;
  static int customers_femaleCount3b_3_2 = 0;
  static int customers_femaleCount3b_3_3 = 0;
  static int customers_femaleCount3b_3_4 = 0;

  static double customers_femalePercentage1a_1_1 = 0;
  static double customers_femalePercentage1a_1_2 = 0;
  static double customers_femalePercentage1a_1_3 = 0;
  static double customers_femalePercentage1a_1_4 = 0;
  static double customers_femalePercentage2a_1_1 = 0;
  static double customers_femalePercentage2a_1_2 = 0;
  static double customers_femalePercentage2a_1_3 = 0;
  static double customers_femalePercentage2a_1_4 = 0;
  static double customers_femalePercentage3a_1_1 = 0;
  static double customers_femalePercentage3a_1_2 = 0;
  static double customers_femalePercentage3a_1_3 = 0;
  static double customers_femalePercentage3a_1_4 = 0;
  static double customers_femalePercentage3b_1_1 = 0;
  static double customers_femalePercentage3b_1_2 = 0;
  static double customers_femalePercentage3b_1_3 = 0;
  static double customers_femalePercentage3b_1_4 = 0;

  static double customers_femalePercentage1a_2_1 = 0;
  static double customers_femalePercentage1a_2_2 = 0;
  static double customers_femalePercentage1a_2_3 = 0;
  static double customers_femalePercentage1a_2_4 = 0;
  static double customers_femalePercentage2a_2_1 = 0;
  static double customers_femalePercentage2a_2_2 = 0;
  static double customers_femalePercentage2a_2_3 = 0;
  static double customers_femalePercentage2a_2_4 = 0;
  static double customers_femalePercentage3a_2_1 = 0;
  static double customers_femalePercentage3a_2_2 = 0;
  static double customers_femalePercentage3a_2_3 = 0;
  static double customers_femalePercentage3a_2_4 = 0;
  static double customers_femalePercentage3b_2_1 = 0;
  static double customers_femalePercentage3b_2_2 = 0;
  static double customers_femalePercentage3b_2_3 = 0;
  static double customers_femalePercentage3b_2_4 = 0;

  static double customers_femalePercentage1a_3_1 = 0;
  static double customers_femalePercentage1a_3_2 = 0;
  static double customers_femalePercentage1a_3_3 = 0;
  static double customers_femalePercentage1a_3_4 = 0;
  static double customers_femalePercentage2a_3_1 = 0;
  static double customers_femalePercentage2a_3_2 = 0;
  static double customers_femalePercentage2a_3_3 = 0;
  static double customers_femalePercentage2a_3_4 = 0;
  static double customers_femalePercentage3a_3_1 = 0;
  static double customers_femalePercentage3a_3_2 = 0;
  static double customers_femalePercentage3a_3_3 = 0;
  static double customers_femalePercentage3a_3_4 = 0;
  static double customers_femalePercentage3b_3_1 = 0;
  static double customers_femalePercentage3b_3_2 = 0;
  static double customers_femalePercentage3b_3_3 = 0;
  static double customers_femalePercentage3b_3_4 = 0;

  //selected_button//inforced//grid_index

  static double customers_maxPercentage1a_1_1 = 0;
  static double customers_maxPercentage1a_1_2 = 0;
  static double customers_maxPercentage1a_1_3 = 0;
  static double customers_maxPercentage1a_1_4 = 0;
  static double customers_maxPercentage1a_2_1 = 0;
  static double customers_maxPercentage1a_2_2 = 0;
  static double customers_maxPercentage1a_2_3 = 0;
  static double customers_maxPercentage1a_2_4 = 0;
  static double customers_maxPercentage1a_3_1 = 0;
  static double customers_maxPercentage1a_3_2 = 0;
  static double customers_maxPercentage1a_3_3 = 0;
  static double customers_maxPercentage1a_3_4 = 0;
  static double customers_maxPercentage1b_1_1 = 0;
  static double customers_maxPercentage1b_1_2 = 0;
  static double customers_maxPercentage1b_1_3 = 0;
  static double customers_maxPercentage1b_1_4 = 0;
  static double customers_maxPercentage1b_2_1 = 0;
  static double customers_maxPercentage1b_2_2 = 0;
  static double customers_maxPercentage1b_2_3 = 0;
  static double customers_maxPercentage1b_2_4 = 0;
  static double customers_maxPercentage1b_3_1 = 0;
  static double customers_maxPercentage1b_3_2 = 0;
  static double customers_maxPercentage1b_3_3 = 0;
  static double customers_maxPercentage1b_3_4 = 0;
  static double customers_maxPercentage1c_1_1 = 0;
  static double customers_maxPercentage1c_1_2 = 0;
  static double customers_maxPercentage1c_1_3 = 0;
  static double customers_maxPercentage1c_1_4 = 0;
  static double customers_maxPercentage1c_2_1 = 0;
  static double customers_maxPercentage1c_2_2 = 0;
  static double customers_maxPercentage1c_2_3 = 0;
  static double customers_maxPercentage1c_2_4 = 0;
  static double customers_maxPercentage1c_3_1 = 0;
  static double customers_maxPercentage1c_3_2 = 0;
  static double customers_maxPercentage1c_3_3 = 0; //
  static double customers_maxPercentage1c_3_4 = 0; //
  static double customers_maxPercentage2a_1_1 = 0;
  static double customers_maxPercentage2a_1_2 = 0;
  static double customers_maxPercentage2a_1_3 = 0;
  static double customers_maxPercentage2a_1_4 = 0;
  static double customers_maxPercentage2a_2_1 = 0;
  static double customers_maxPercentage2a_2_2 = 0;
  static double customers_maxPercentage2a_2_3 = 0;
  static double customers_maxPercentage2a_2_4 = 0;
  static double customers_maxPercentage2a_3_1 = 0;
  static double customers_maxPercentage2a_3_2 = 0;
  static double customers_maxPercentage2a_3_3 = 0;
  static double customers_maxPercentage2a_3_4 = 0;
  static double customers_maxPercentage2b_1_1 = 0;
  static double customers_maxPercentage2b_1_2 = 0;
  static double customers_maxPercentage2b_1_3 = 0;
  static double customers_maxPercentage2b_1_4 = 0;
  static double customers_maxPercentage2b_2_1 = 0;
  static double customers_maxPercentage2b_2_2 = 0;
  static double customers_maxPercentage2b_2_3 = 0;
  static double customers_maxPercentage2b_2_4 = 0;
  static double customers_maxPercentage2b_3_1 = 0;
  static double customers_maxPercentage2c_1_1 = 0;
  static double customers_maxPercentage2c_2_1 = 0;
  static double customers_maxPercentage2c_3_1 = 0;
  static double customers_maxPercentage3a_1_1 = 0;
  static double customers_maxPercentage3a_1_2 = 0;
  static double customers_maxPercentage3a_1_3 = 0;
  static double customers_maxPercentage3a_1_4 = 0;
  static double customers_maxPercentage3a_2_1 = 0;
  static double customers_maxPercentage3a_2_2 = 0;
  static double customers_maxPercentage3a_2_3 = 0;
  static double customers_maxPercentage3a_2_4 = 0;
  static double customers_maxPercentage3b_1_1 = 0;
  static double customers_maxPercentage3b_1_2 = 0;
  static double customers_maxPercentage3b_1_3 = 0;
  static double customers_maxPercentage3b_1_4 = 0;
  static double customers_maxPercentage3b_2_1 = 0;
  static double customers_maxPercentage3b_2_2 = 0;
  static double customers_maxPercentage3b_2_3 = 0;
  static double customers_maxPercentage3b_2_4 = 0;
  static double customers_maxPercentage3a_3_1 = 0;
  static double customers_maxPercentage3a_3_2 = 0;
  static double customers_maxPercentage3a_3_3 = 0;
  static double customers_maxPercentage3a_3_4 = 0;

  //change structure
  static double customers_maxPercentage3a_2 = 0;
  static double customers_maxPercentage3a_3 = 0;
  static double customers_maxPercentage3b_1 = 0;
  static double customers_maxPercentage3b_2 = 0;
  static double customers_maxPercentage3b_3 = 0;

  static List<Segment2> customers_segment_1a = [];
  static List<Segment2> customers_segment_2a = [];
  static List<Segment2> customers_segment_3a = [];
  static List<Segment2> customers_segment_3b = [];

  static List<salesgridmodel> customers_sectionsList1a_1_1 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList1a_1_2 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList1a_1_3 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList1a_1_4 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList1a_2_1 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList1a_2_2 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList1a_2_3 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList1a_2_4 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList1a_3_1 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList1a_3_2 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList1a_3_3 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList1a_3_4 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList2a_1_1 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList2a_1_2 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList2a_1_3 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList2a_1_4 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList2a_2_1 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList2a_2_2 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList2a_2_3 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList2a_2_4 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList2a_3_1 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList2a_3_2 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList2a_3_3 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList2a_3_4 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3a_1_1 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3a_1_2 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3a_1_3 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3a_1_4 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3a_2_1 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3a_2_2 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3a_2_3 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3a_2_4 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3a_3_1 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3a_3_2 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3a_3_3 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3a_3_4 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];

  static List<salesgridmodel> customers_sectionsList3b_1_1 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3b_1_2 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3b_1_3 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3b_1_4 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3b_2_1 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3b_2_2 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3b_2_3 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3b_2_4 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3b_3_1 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3b_3_2 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3b_3_3 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_sectionsList3b_3_4 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<BarChartGroupData> cutomers_banks_barChartData1a = [];
  static List<BarChartGroupData> cutomers_banks_barChartData2a = [];
  static List<BarChartGroupData> cutomers_banks_barChartData3a = [];
  static List<BarChartGroupData> cutomers_banks_barChartData4a = [];
  static List<Map> cutomers_banks_names1a = [];
  static List<Map> cutomers_banks_names2a = [];
  static List<Map> cutomers_banks_names3a = [];
  static List<Map> cutomers_banks_names4a = [];

  //Customers Claims

  //Customer Profile
  static int customers_claims_maleCount1a_1_1 = 0;
  static int customers_claims_maleCount1a_1_2 = 0;
  static int customers_claims_maleCount1a_1_3 = 0;
  static int customers_claims_maleCount1a_1_4 = 0;
  static int customers_claims_maleCount1a_2_1 = 0;
  static int customers_claims_maleCount1a_2_2 = 0;
  static int customers_claims_maleCount1a_2_3 = 0;
  static int customers_claims_maleCount1a_2_4 = 0;
  static int customers_claims_maleCount1a_3_1 = 0;
  static int customers_claims_maleCount1a_3_2 = 0;
  static int customers_claims_maleCount1a_3_3 = 0;
  static int customers_claims_maleCount1a_3_4 = 0;

  static int customers_claims_maleCount2a_1_1 = 0;
  static int customers_claims_maleCount2a_1_2 = 0;
  static int customers_claims_maleCount2a_1_3 = 0;
  static int customers_claims_maleCount2a_1_4 = 0;
  static int customers_claims_maleCount3a_1_1 = 0;
  static int customers_claims_maleCount3a_1_2 = 0;
  static int customers_claims_maleCount3a_1_3 = 0;
  static int customers_claims_maleCount3a_1_4 = 0;
  static int customers_claims_maleCount3b_1_1 = 0;
  static int customers_claims_maleCount3b_1_2 = 0;
  static int customers_claims_maleCount3b_1_3 = 0;
  static int customers_claims_maleCount3b_1_4 = 0;

  static int customers_claims_maleCount2a_2_1 = 0;
  static int customers_claims_maleCount2a_2_2 = 0;
  static int customers_claims_maleCount2a_2_3 = 0;
  static int customers_claims_maleCount2a_2_4 = 0;
  static int customers_claims_maleCount3a_2_1 = 0;
  static int customers_claims_maleCount3a_2_2 = 0;
  static int customers_claims_maleCount3a_2_3 = 0;
  static int customers_claims_maleCount3a_2_4 = 0;
  static int customers_claims_maleCount3b_2_1 = 0;
  static int customers_claims_maleCount3b_2_2 = 0;
  static int customers_claims_maleCount3b_2_3 = 0;
  static int customers_claims_maleCount3b_2_4 = 0;

  static int customers_claims_maleCount2a_3_1 = 0;
  static int customers_claims_maleCount2a_3_2 = 0;
  static int customers_claims_maleCount2a_3_3 = 0;
  static int customers_claims_maleCount2a_3_4 = 0;
  static int customers_claims_maleCount3a_3_1 = 0;
  static int customers_claims_maleCount3a_3_2 = 0;
  static int customers_claims_maleCount3a_3_3 = 0;
  static int customers_claims_maleCount3a_3_4 = 0;
  static int customers_claims_maleCount3b_3_1 = 0;
  static int customers_claims_maleCount3b_3_2 = 0;
  static int customers_claims_maleCount3b_3_3 = 0;
  static int customers_claims_maleCount3b_3_4 = 0;

  static double customers_claims_malePercentage1a_1_1 = 0;
  static double customers_claims_malePercentage1a_1_2 = 0;
  static double customers_claims_malePercentage1a_1_3 = 0;
  static double customers_claims_malePercentage1a_1_4 = 0;
  static double customers_claims_malePercentage2a_1_1 = 0;
  static double customers_claims_malePercentage2a_1_2 = 0;
  static double customers_claims_malePercentage2a_1_3 = 0;
  static double customers_claims_malePercentage2a_1_4 = 0;
  static double customers_claims_malePercentage3a_1_1 = 0;
  static double customers_claims_malePercentage3a_1_2 = 0;
  static double customers_claims_malePercentage3a_1_3 = 0;
  static double customers_claims_malePercentage3a_1_4 = 0;
  static double customers_claims_malePercentage3b_1_1 = 0;
  static double customers_claims_malePercentage3b_1_2 = 0;
  static double customers_claims_malePercentage3b_1_3 = 0;
  static double customers_claims_malePercentage3b_1_4 = 0;

  static double customers_claims_malePercentage1a_2_1 = 0;
  static double customers_claims_malePercentage1a_2_2 = 0;
  static double customers_claims_malePercentage1a_2_3 = 0;
  static double customers_claims_malePercentage1a_2_4 = 0;
  static double customers_claims_malePercentage2a_2_1 = 0;
  static double customers_claims_malePercentage2a_2_2 = 0;
  static double customers_claims_malePercentage2a_2_3 = 0;
  static double customers_claims_malePercentage2a_2_4 = 0;
  static double customers_claims_malePercentage3a_2_1 = 0;
  static double customers_claims_malePercentage3a_2_2 = 0;
  static double customers_claims_malePercentage3a_2_3 = 0;
  static double customers_claims_malePercentage3a_2_4 = 0;
  static double customers_claims_malePercentage3b_2_1 = 0;
  static double customers_claims_malePercentage3b_2_2 = 0;
  static double customers_claims_malePercentage3b_2_3 = 0;
  static double customers_claims_malePercentage3b_2_4 = 0;

  static double customers_claims_malePercentage1a_3_1 = 0;
  static double customers_claims_malePercentage1a_3_2 = 0;
  static double customers_claims_malePercentage1a_3_3 = 0;
  static double customers_claims_malePercentage1a_3_4 = 0;
  static double customers_claims_malePercentage2a_3_1 = 0;
  static double customers_claims_malePercentage2a_3_2 = 0;
  static double customers_claims_malePercentage2a_3_3 = 0;
  static double customers_claims_malePercentage2a_3_4 = 0;
  static double customers_claims_malePercentage3a_3_1 = 0;
  static double customers_claims_malePercentage3a_3_2 = 0;
  static double customers_claims_malePercentage3a_3_3 = 0;
  static double customers_claims_malePercentage3a_3_4 = 0;
  static double customers_claims_malePercentage3b_3_1 = 0;
  static double customers_claims_malePercentage3b_3_2 = 0;
  static double customers_claims_malePercentage3b_3_3 = 0;
  static double customers_claims_malePercentage3b_3_4 = 0;

  static int customers_claims_femaleCount1a_1_1 = 0;
  static int customers_claims_femaleCount1a_1_2 = 0;
  static int customers_claims_femaleCount1a_1_3 = 0;
  static int customers_claims_femaleCount1a_1_4 = 0;
  static int customers_claims_femaleCount2a_1_1 = 0;
  static int customers_claims_femaleCount2a_1_2 = 0;
  static int customers_claims_femaleCount2a_1_3 = 0;
  static int customers_claims_femaleCount2a_1_4 = 0;
  static int customers_claims_femaleCount3a_1_1 = 0;
  static int customers_claims_femaleCount3a_1_2 = 0;
  static int customers_claims_femaleCount3a_1_3 = 0;
  static int customers_claims_femaleCount3a_1_4 = 0;
  static int customers_claims_femaleCount3b_1_1 = 0;
  static int customers_claims_femaleCount3b_1_2 = 0;
  static int customers_claims_femaleCount3b_1_3 = 0;
  static int customers_claims_femaleCount3b_1_4 = 0;

  static int customers_claims_femaleCount1a_2_1 = 0;
  static int customers_claims_femaleCount1a_2_2 = 0;
  static int customers_claims_femaleCount1a_2_3 = 0;
  static int customers_claims_femaleCount1a_2_4 = 0;
  static int customers_claims_femaleCount2a_2_1 = 0;
  static int customers_claims_femaleCount2a_2_2 = 0;
  static int customers_claims_femaleCount2a_2_3 = 0;
  static int customers_claims_femaleCount2a_2_4 = 0;
  static int customers_claims_femaleCount3a_2_1 = 0;
  static int customers_claims_femaleCount3a_2_2 = 0;
  static int customers_claims_femaleCount3a_2_3 = 0;
  static int customers_claims_femaleCount3a_2_4 = 0;
  static int customers_claims_femaleCount3b_2_1 = 0;
  static int customers_claims_femaleCount3b_2_2 = 0;
  static int customers_claims_femaleCount3b_2_3 = 0;
  static int customers_claims_femaleCount3b_2_4 = 0;

  static int customers_claims_femaleCount1a_3_1 = 0;
  static int customers_claims_femaleCount1a_3_2 = 0;
  static int customers_claims_femaleCount1a_3_3 = 0;
  static int customers_claims_femaleCount1a_3_4 = 0;
  static int customers_claims_femaleCount2a_3_1 = 0;
  static int customers_claims_femaleCount2a_3_2 = 0;
  static int customers_claims_femaleCount2a_3_3 = 0;
  static int customers_claims_femaleCount2a_3_4 = 0;
  static int customers_claims_femaleCount3a_3_1 = 0;
  static int customers_claims_femaleCount3a_3_2 = 0;
  static int customers_claims_femaleCount3a_3_3 = 0;
  static int customers_claims_femaleCount3a_3_4 = 0;
  static int customers_claims_femaleCount3b_3_1 = 0;
  static int customers_claims_femaleCount3b_3_2 = 0;
  static int customers_claims_femaleCount3b_3_3 = 0;
  static int customers_claims_femaleCount3b_3_4 = 0;

  static double customers_claims_femalePercentage1a_1_1 = 0;
  static double customers_claims_femalePercentage1a_1_2 = 0;
  static double customers_claims_femalePercentage1a_1_3 = 0;
  static double customers_claims_femalePercentage1a_1_4 = 0;
  static double customers_claims_femalePercentage2a_1_1 = 0;
  static double customers_claims_femalePercentage2a_1_2 = 0;
  static double customers_claims_femalePercentage2a_1_3 = 0;
  static double customers_claims_femalePercentage2a_1_4 = 0;
  static double customers_claims_femalePercentage3a_1_1 = 0;
  static double customers_claims_femalePercentage3a_1_2 = 0;
  static double customers_claims_femalePercentage3a_1_3 = 0;
  static double customers_claims_femalePercentage3a_1_4 = 0;
  static double customers_claims_femalePercentage3b_1_1 = 0;
  static double customers_claims_femalePercentage3b_1_2 = 0;
  static double customers_claims_femalePercentage3b_1_3 = 0;
  static double customers_claims_femalePercentage3b_1_4 = 0;

  static double customers_claims_femalePercentage1a_2_1 = 0;
  static double customers_claims_femalePercentage1a_2_2 = 0;
  static double customers_claims_femalePercentage1a_2_3 = 0;
  static double customers_claims_femalePercentage1a_2_4 = 0;
  static double customers_claims_femalePercentage2a_2_1 = 0;
  static double customers_claims_femalePercentage2a_2_2 = 0;
  static double customers_claims_femalePercentage2a_2_3 = 0;
  static double customers_claims_femalePercentage2a_2_4 = 0;
  static double customers_claims_femalePercentage3a_2_1 = 0;
  static double customers_claims_femalePercentage3a_2_2 = 0;
  static double customers_claims_femalePercentage3a_2_3 = 0;
  static double customers_claims_femalePercentage3a_2_4 = 0;
  static double customers_claims_femalePercentage3b_2_1 = 0;
  static double customers_claims_femalePercentage3b_2_2 = 0;
  static double customers_claims_femalePercentage3b_2_3 = 0;
  static double customers_claims_femalePercentage3b_2_4 = 0;

  static double customers_claims_femalePercentage1a_3_1 = 0;
  static double customers_claims_femalePercentage1a_3_2 = 0;
  static double customers_claims_femalePercentage1a_3_3 = 0;
  static double customers_claims_femalePercentage1a_3_4 = 0;
  static double customers_claims_femalePercentage2a_3_1 = 0;
  static double customers_claims_femalePercentage2a_3_2 = 0;
  static double customers_claims_femalePercentage2a_3_3 = 0;
  static double customers_claims_femalePercentage2a_3_4 = 0;
  static double customers_claims_femalePercentage3a_3_1 = 0;
  static double customers_claims_femalePercentage3a_3_2 = 0;
  static double customers_claims_femalePercentage3a_3_3 = 0;
  static double customers_claims_femalePercentage3a_3_4 = 0;
  static double customers_claims_femalePercentage3b_3_1 = 0;
  static double customers_claims_femalePercentage3b_3_2 = 0;
  static double customers_claims_femalePercentage3b_3_3 = 0;
  static double customers_claims_femalePercentage3b_3_4 = 0;

  //selected_button//inforced//grid_index

  static double customers_claims_maxPercentage1a_1_1 = 0;
  static double customers_claims_maxPercentage1a_1_2 = 0;
  static double customers_claims_maxPercentage1a_1_3 = 0;
  static double customers_claims_maxPercentage1a_1_4 = 0;
  static double customers_claims_maxPercentage1a_2_1 = 0;
  static double customers_claims_maxPercentage1a_2_2 = 0;
  static double customers_claims_maxPercentage1a_2_3 = 0;
  static double customers_claims_maxPercentage1a_2_4 = 0;
  static double customers_claims_maxPercentage1a_3_1 = 0;
  static double customers_claims_maxPercentage1a_3_2 = 0;
  static double customers_claims_maxPercentage1a_3_3 = 0;
  static double customers_claims_maxPercentage1a_3_4 = 0;
  static double customers_claims_maxPercentage1b_1_1 = 0;
  static double customers_claims_maxPercentage1b_1_2 = 0;
  static double customers_claims_maxPercentage1b_1_3 = 0;
  static double customers_claims_maxPercentage1b_1_4 = 0;
  static double customers_claims_maxPercentage1b_2_1 = 0;
  static double customers_claims_maxPercentage1b_2_2 = 0;
  static double customers_claims_maxPercentage1b_2_3 = 0;
  static double customers_claims_maxPercentage1b_2_4 = 0;
  static double customers_claims_maxPercentage1b_3_1 = 0;
  static double customers_claims_maxPercentage1b_3_2 = 0;
  static double customers_claims_maxPercentage1b_3_3 = 0;
  static double customers_claims_maxPercentage1b_3_4 = 0;
  static double customers_claims_maxPercentage1c_1_1 = 0;
  static double customers_claims_maxPercentage1c_1_2 = 0;
  static double customers_claims_maxPercentage1c_1_3 = 0;
  static double customers_claims_maxPercentage1c_1_4 = 0;
  static double customers_claims_maxPercentage1c_2_1 = 0;
  static double customers_claims_maxPercentage1c_2_2 = 0;
  static double customers_claims_maxPercentage1c_2_3 = 0;
  static double customers_claims_maxPercentage1c_2_4 = 0;
  static double customers_claims_maxPercentage1c_3_1 = 0;
  static double customers_claims_maxPercentage1c_3_2 = 0;
  static double customers_claims_maxPercentage1c_3_3 = 0; //
  static double customers_claims_maxPercentage1c_3_4 = 0; //
  static double customers_claims_maxPercentage2a_1_1 = 0;
  static double customers_claims_maxPercentage2a_1_2 = 0;
  static double customers_claims_maxPercentage2a_1_3 = 0;
  static double customers_claims_maxPercentage2a_1_4 = 0;
  static double customers_claims_maxPercentage2a_2_1 = 0;
  static double customers_claims_maxPercentage2a_2_2 = 0;
  static double customers_claims_maxPercentage2a_2_3 = 0;
  static double customers_claims_maxPercentage2a_2_4 = 0;
  static double customers_claims_maxPercentage2a_3_1 = 0;
  static double customers_claims_maxPercentage2a_3_2 = 0;
  static double customers_claims_maxPercentage2a_3_3 = 0;
  static double customers_claims_maxPercentage2a_3_4 = 0;
  static double customers_claims_maxPercentage2b_1_1 = 0;
  static double customers_claims_maxPercentage2b_1_2 = 0;
  static double customers_claims_maxPercentage2b_1_3 = 0;
  static double customers_claims_maxPercentage2b_1_4 = 0;
  static double customers_claims_maxPercentage2b_2_1 = 0;
  static double customers_claims_maxPercentage2b_2_2 = 0;
  static double customers_claims_maxPercentage2b_2_3 = 0;
  static double customers_claims_maxPercentage2b_2_4 = 0;
  static double customers_claims_maxPercentage2b_3_1 = 0;
  static double customers_claims_maxPercentage2c_1_1 = 0;
  static double customers_claims_maxPercentage2c_2_1 = 0;
  static double customers_claims_maxPercentage2c_3_1 = 0;
  static double customers_claims_maxPercentage3a_1_1 = 0;
  static double customers_claims_maxPercentage3a_1_2 = 0;
  static double customers_claims_maxPercentage3a_1_3 = 0;
  static double customers_claims_maxPercentage3a_1_4 = 0;
  static double customers_claims_maxPercentage3a_2_1 = 0;
  static double customers_claims_maxPercentage3a_2_2 = 0;
  static double customers_claims_maxPercentage3a_2_3 = 0;
  static double customers_claims_maxPercentage3a_2_4 = 0;
  static double customers_claims_maxPercentage3b_1_1 = 0;
  static double customers_claims_maxPercentage3b_1_2 = 0;
  static double customers_claims_maxPercentage3b_1_3 = 0;
  static double customers_claims_maxPercentage3b_1_4 = 0;
  static double customers_claims_maxPercentage3b_2_1 = 0;
  static double customers_claims_maxPercentage3b_2_2 = 0;
  static double customers_claims_maxPercentage3b_2_3 = 0;
  static double customers_claims_maxPercentage3b_2_4 = 0;
  static double customers_claims_maxPercentage3a_3_1 = 0;
  static double customers_claims_maxPercentage3a_3_2 = 0;
  static double customers_claims_maxPercentage3a_3_3 = 0;
  static double customers_claims_maxPercentage3a_3_4 = 0;

  //change structure
  static double customers_claims_maxPercentage3a_2 = 0;
  static double customers_claims_maxPercentage3a_3 = 0;
  static double customers_claims_maxPercentage3a_4 = 0;
  static double customers_claims_maxPercentage3b_1 = 0;
  static double customers_claims_maxPercentage3b_2 = 0;
  static double customers_claims_maxPercentage3b_3 = 0;
  static double customers_claims_maxPercentage3b_4 = 0;

  static List<Segment2> customers_claims_segment_1a = [];
  static List<Segment2> customers_claims_segment_2a = [];
  static List<Segment2> customers_claims_segment_3a = [];
  static List<Segment2> customers_claims_segment_3b = [];

  static List<salesgridmodel> customers_claims_sectionsList1a_1_1 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_claims_sectionsList1a_1_2 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_claims_sectionsList1a_1_3 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_claims_sectionsList1a_1_4 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_claims_sectionsList2a_1_1 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_claims_sectionsList2a_1_2 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_claims_sectionsList2a_1_3 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_claims_sectionsList2a_1_4 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];

  static List<salesgridmodel> customers_claims_sectionsList3a_1_1 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_claims_sectionsList3a_1_2 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_claims_sectionsList3a_1_3 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_claims_sectionsList3a_1_4 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_claims_sectionsList3b_1_1 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_claims_sectionsList3b_1_2 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_claims_sectionsList3b_1_3 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<salesgridmodel> customers_claims_sectionsList3b_1_4 = [
    salesgridmodel("Acquired ", 0),
    salesgridmodel("Active ", 0),
    salesgridmodel("In-Active", 0),
  ];
  static List<BarChartGroupData> cutomers_claims_banks_barChartData1a = [];
  static List<BarChartGroupData> cutomers_claims_banks_barChartData2a = [];
  static List<BarChartGroupData> cutomers_claims_banks_barChartData3a = [];
  static List<BarChartGroupData> cutomers_claims_banks_barChartData4a = [];
  static List<String> cutomers_claims_banks_names1a = [];
  static List<String> cutomers_claims_banks_names2a = [];
  static List<String> cutomers_claims_banks_names3a = [];
  static List<String> cutomers_claims_banks_names4a = [];

  static List<GenderDistribution> customers_age_barGroup_dist_data1a_1_1 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data1a_1_2 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data1a_1_3 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data1a_1_4 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data1a_2_1 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data1a_2_2 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data1a_2_3 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data1a_2_4 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data1a_3_1 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data1a_3_2 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data1a_3_3 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data1a_3_4 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data1b_1 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data1b_2 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data1b_3 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data1b_4 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data1c_1 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data1c_2 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data1c_3 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2a_1_1 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2a_1_2 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2a_1_3 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2a_1_4 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2a_2_1 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2a_3_1 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2b_1_1 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2b_2_1 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2b_3_1 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2c_1_1 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2c_1_2 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2c_1_3 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2c_1_4 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2c_2_1 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2c_2_2 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2c_2_3 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2c_2_4 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2c_3_1 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2c_3_2 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2c_3_3 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2c_3_4 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2a_2_3 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2a_2_4 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2a_3_2 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2a_3_3 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data2a_3_4 = [];
  //change structure
  static List<GenderDistribution> customers_age_barGroup_dist_data3a_1_1 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3a_1_2 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3a_1_3 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3a_1_4 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3a_2_1 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3a_2_2 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3a_2_3 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3a_2_4 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3a_3_1 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3a_3_2 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3a_3_3 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3a_3_4 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3b_1_1 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3b_1_2 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3b_1_3 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3b_1_4 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3b_2_1 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3b_2_2 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3b_2_3 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3b_2_4 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3b_3_1 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3b_3_2 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3b_3_3 = [];
  static List<GenderDistribution> customers_age_barGroup_dist_data3b_3_4 = [];
  static List<BarChartGroupData> customers_age_barGroups1a_1_1 = [];
  static List<BarChartGroupData> customers_age_barGroups1a_1_2 = [];
  static List<BarChartGroupData> customers_age_barGroups1a_1_3 = [];
  static List<BarChartGroupData> customers_age_barGroups1a_1_4 = [];
  static List<BarChartGroupData> customers_age_barGroups1a_2_1 = [];
  static List<BarChartGroupData> customers_age_barGroups1a_2_2 = [];
  static List<BarChartGroupData> customers_age_barGroups1a_2_3 = [];
  static List<BarChartGroupData> customers_age_barGroups1a_2_4 = [];
  static List<BarChartGroupData> customers_age_barGroups1a_3_1 = [];
  static List<BarChartGroupData> customers_age_barGroups1a_3_2 = [];
  static List<BarChartGroupData> customers_age_barGroups1a_3_3 = [];
  static List<BarChartGroupData> customers_age_barGroups1a_3_4 = [];
  static List<BarChartGroupData> customers_age_barGroups1b_1_1 = [];
  static List<BarChartGroupData> customers_age_barGroups1b_1_2 = [];
  static List<BarChartGroupData> customers_age_barGroups1b_1_3 = [];
  static List<BarChartGroupData> customers_age_barGroups1b_1_4 = [];
  static List<BarChartGroupData> customers_age_barGroups1b_2_1 = [];
  static List<BarChartGroupData> customers_age_barGroups1b_2_2 = [];
  static List<BarChartGroupData> customers_age_barGroups1b_2_3 = [];
  static List<BarChartGroupData> customers_age_barGroups1b_2_4 = [];
  static List<BarChartGroupData> customers_age_barGroups1b_3_1 = [];
  static List<BarChartGroupData> customers_age_barGroups1b_3_2 = [];
  static List<BarChartGroupData> customers_age_barGroups1b_3_3 = [];
  static List<BarChartGroupData> customers_age_barGroups1b_3_4 = [];
  static List<BarChartGroupData> customers_age_barGroups2a_1_1 = [];
  static List<BarChartGroupData> customers_age_barGroups2a_1_2 = [];
  static List<BarChartGroupData> customers_age_barGroups2a_1_3 = [];
  static List<BarChartGroupData> customers_age_barGroups2a_1_4 = [];
  static List<BarChartGroupData> customers_age_barGroups2a_2_1 = [];
  static List<BarChartGroupData> customers_age_barGroups2a_2_2 = [];
  static List<BarChartGroupData> customers_age_barGroups2a_2_3 = [];
  static List<BarChartGroupData> customers_age_barGroups2a_2_4 = [];
  static List<BarChartGroupData> customers_age_barGroups2a_3_1 = [];
  static List<BarChartGroupData> customers_age_barGroups2a_3_2 = [];
  static List<BarChartGroupData> customers_age_barGroups2a_3_3 = [];
  static List<BarChartGroupData> customers_age_barGroups2a_3_4 = [];
  static List<BarChartGroupData> customers_age_barGroups2b_1_1 = [];
  static List<BarChartGroupData> customers_age_barGroups2b_1_2 = [];
  static List<BarChartGroupData> customers_age_barGroups2b_1_3 = [];
  static List<BarChartGroupData> customers_age_barGroups2b_1_4 = [];
  static List<BarChartGroupData> customers_age_barGroups2b_2_1 = [];
  static List<BarChartGroupData> customers_age_barGroups2b_2_2 = [];
  static List<BarChartGroupData> customers_age_barGroups2b_2_3 = [];
  static List<BarChartGroupData> customers_age_barGroups2b_2_4 = [];
  static List<BarChartGroupData> customers_age_barGroups2b_3_1 = [];
  static List<BarChartGroupData> customers_age_barGroups2b_3_2 = [];
  static List<BarChartGroupData> customers_age_barGroups2b_3_3 = [];
  static List<BarChartGroupData> customers_age_barGroups2b_3_4 = [];
  static List<BarChartGroupData> customers_age_barGroups3a_1_1 = [];
  static List<BarChartGroupData> customers_age_barGroups3a_1_2 = [];
  static List<BarChartGroupData> customers_age_barGroups3a_1_3 = [];
  static List<BarChartGroupData> customers_age_barGroups3a_1_4 = [];
  static List<BarChartGroupData> customers_age_barGroups3a_2_1 = [];
  static List<BarChartGroupData> customers_age_barGroups3a_2_2 = [];
  static List<BarChartGroupData> customers_age_barGroups3a_2_3 = [];
  static List<BarChartGroupData> customers_age_barGroups3a_2_4 = [];
  static List<BarChartGroupData> customers_age_barGroups3a_3_1 = [];
  static List<BarChartGroupData> customers_age_barGroups3a_3_2 = [];
  static List<BarChartGroupData> customers_age_barGroups3a_3_3 = [];
  static List<BarChartGroupData> customers_age_barGroups3a_3_4 = [];
  static List<BarChartGroupData> customers_age_barGroups3b_1_1 = [];
  static List<BarChartGroupData> customers_age_barGroups3b_1_2 = [];
  static List<BarChartGroupData> customers_age_barGroups3b_1_3 = [];
  static List<BarChartGroupData> customers_age_barGroups3b_1_4 = [];
  static List<BarChartGroupData> customers_age_barGroups3b_2_1 = [];
  static List<BarChartGroupData> customers_age_barGroups3b_2_2 = [];
  static List<BarChartGroupData> customers_age_barGroups3b_2_3 = [];
  static List<BarChartGroupData> customers_age_barGroups3b_2_4 = [];
  static List<BarChartGroupData> customers_age_barGroups3b_3_1 = [];
  static List<BarChartGroupData> customers_age_barGroups3b_3_2 = [];
  static List<BarChartGroupData> customers_age_barGroups3b_3_3 = [];
  static List<BarChartGroupData> customers_age_barGroups3b_3_4 = [];
  static List<BarChartGroupData> customers_age_barGroups4a_1 = [];
  static List<BarChartGroupData> customers_age_barGroups4a_2 = [];
  static List<BarChartGroupData> customers_age_barGroups4a_3 = [];
  static List<BarChartGroupData> customers_age_barGroups4a_4 = [];
  static List<BarChartGroupData> customers_age_barGroups4b_1 = [];
  static List<BarChartGroupData> customers_age_barGroups4b_2 = [];
  static List<BarChartGroupData> customers_age_barGroups4b_3 = [];
  static List<BarChartGroupData> customers_age_barGroups4b_4 = [];

  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data1a_1_1 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data1a_1_2 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data1a_1_3 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data1a_1_4 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data1a_2_1 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data1a_2_2 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data1a_2_3 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data1a_2_4 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data1a_3_1 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data1a_3_2 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data1a_3_3 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data1a_3_4 = [];
  static List<GenderDistribution> customers_claims_age_barGroup_dist_data1b_1 =
      [];
  static List<GenderDistribution> customers_claims_age_barGroup_dist_data1b_2 =
      [];
  static List<GenderDistribution> customers_claims_age_barGroup_dist_data1b_3 =
      [];
  static List<GenderDistribution> customers_claims_age_barGroup_dist_data1b_4 =
      [];
  static List<GenderDistribution> customers_claims_age_barGroup_dist_data1c_1 =
      [];
  static List<GenderDistribution> customers_claims_age_barGroup_dist_data1c_2 =
      [];
  static List<GenderDistribution> customers_claims_age_barGroup_dist_data1c_3 =
      [];
  static List<GenderDistribution> customers_claims_age_barGroup_dist_data1c_4 =
      [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2a_1_1 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2a_1_2 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2a_1_3 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2a_1_4 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2a_2_1 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2a_3_1 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2b_1_1 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2b_2_1 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2b_3_1 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2c_1_1 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2c_1_2 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2c_1_3 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2c_1_4 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2c_2_1 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2c_2_2 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2c_2_3 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2c_2_4 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2c_3_1 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2c_3_2 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2c_3_3 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2c_3_4 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2a_2_3 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2a_3_2 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2a_3_3 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data2a_3_4 = [];
  //change structure
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3a_1_1 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3a_1_2 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3a_1_3 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3a_1_4 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3a_2_1 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3a_2_2 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3a_2_3 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3a_2_4 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3a_3_1 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3a_3_2 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3a_3_3 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3a_3_4 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3b_1_1 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3b_1_2 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3b_1_3 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3b_1_4 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3b_2_1 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3b_2_2 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3b_2_3 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3b_2_4 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3b_3_1 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3b_3_2 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3b_3_3 = [];
  static List<GenderDistribution>
      customers_claims_age_barGroup_dist_data3b_3_4 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1a_1_1 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1a_1_2 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1a_1_3 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1a_1_4 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1a_2_1 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1a_2_2 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1a_2_3 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1a_2_4 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1a_3_1 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1a_3_2 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1a_3_3 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1a_3_4 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1b_1_1 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1b_1_2 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1b_1_3 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1b_1_4 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1b_2_1 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1b_2_2 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1b_2_3 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1b_2_4 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1b_3_1 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1b_3_2 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1b_3_3 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups1b_3_4 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2a_1_1 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2a_1_2 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2a_1_3 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2a_1_4 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2a_2_1 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2a_2_2 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2a_2_3 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2a_2_4 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2a_3_1 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2a_3_2 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2a_3_3 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2a_3_4 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2b_1_1 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2b_1_2 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2b_1_3 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2b_1_4 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2b_2_1 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2b_2_2 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2b_2_3 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2b_2_4 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2b_3_1 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2b_3_2 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2b_3_3 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups2b_3_4 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3a_1_1 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3a_1_2 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3a_1_3 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3a_1_4 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3a_2_1 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3a_2_2 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3a_2_3 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3a_2_4 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3a_3_1 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3a_3_2 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3a_3_3 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3a_3_4 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3b_1_1 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3b_1_2 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3b_1_3 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3b_1_4 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3b_2_1 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3b_2_2 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3b_2_3 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3b_2_4 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3b_3_1 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3b_3_2 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3b_3_3 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups3b_3_4 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups4a_1 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups4a_2 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups4a_3 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups4a_4 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups4b_1 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups4b_2 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups4b_3 = [];
  static List<BarChartGroupData> customers_claims_age_barGroups4b_4 = [];

  static double customers_claims_1a = 0.0;
  static double customers_claims_2a = 0.0;
  static double customers_claims_3a = 0.0;

  static List<int> customers_claims_deceased_ages_list1a = [];
  static List<int> customers_claims_deceased_ages_list2a = [];
  static List<int> customers_claims_deceased_ages_list3a = [];
  static List<int> customers_claims_deceased_ages_list3b = [];

  static List<double> age_distribution_lists_1a_1_1 = [];
  static List<double> age_distribution_lists_1a_1_2 = [];
  static List<double> age_distribution_lists_1a_1_3 = [];
  static List<double> age_distribution_lists_1a_2_1 = [];
  static List<double> age_distribution_lists_1a_2_2 = [];
  static List<double> age_distribution_lists_1a_2_3 = [];
  static List<double> age_distribution_lists_1a_3_1 = [];
  static List<double> age_distribution_lists_1a_3_2 = [];
  static List<double> age_distribution_lists_1a_3_3 = [];
  static List<double> age_distribution_lists_1a_4_1 = [];
  static List<double> age_distribution_lists_1a_4_2 = [];
  static List<double> age_distribution_lists_1a_4_3 = [];
  static List<double> age_distribution_lists_2a_1_1 = [];
  static List<double> age_distribution_lists_2a_1_2 = [];
  static List<double> age_distribution_lists_2a_1_3 = [];
  static List<double> age_distribution_lists_2a_2_1 = [];
  static List<double> age_distribution_lists_2a_2_2 = [];
  static List<double> age_distribution_lists_2a_2_3 = [];
  static List<double> age_distribution_lists_2a_3_1 = [];
  static List<double> age_distribution_lists_2a_3_2 = [];
  static List<double> age_distribution_lists_2a_3_3 = [];
  static List<double> age_distribution_lists_2a_4_1 = [];
  static List<double> age_distribution_lists_2a_4_2 = [];
  static List<double> age_distribution_lists_2a_4_3 = [];
  static List<double> age_distribution_lists_3a_1_1 = [];
  static List<double> age_distribution_lists_3a_1_2 = [];
  static List<double> age_distribution_lists_3a_1_3 = [];
  static List<double> age_distribution_lists_3a_2_1 = [];
  static List<double> age_distribution_lists_3a_2_2 = [];
  static List<double> age_distribution_lists_3a_2_3 = [];
  static List<double> age_distribution_lists_3a_3_1 = [];
  static List<double> age_distribution_lists_3a_3_2 = [];
  static List<double> age_distribution_lists_3a_3_3 = [];
  static List<double> age_distribution_lists_3a_4_1 = [];
  static List<double> age_distribution_lists_3a_4_2 = [];
  static List<double> age_distribution_lists_3a_4_3 = [];
  static List<double> age_distribution_lists_3b_1_1 = [];
  static List<double> age_distribution_lists_3b_1_2 = [];
  static List<double> age_distribution_lists_3b_1_3 = [];
  static List<double> age_distribution_lists_3b_2_1 = [];
  static List<double> age_distribution_lists_3b_2_2 = [];
  static List<double> age_distribution_lists_3b_2_3 = [];
  static List<double> age_distribution_lists_3b_3_1 = [];
  static List<double> age_distribution_lists_3b_3_2 = [];
  static List<double> age_distribution_lists_3b_3_3 = [];
  static List<double> age_distribution_lists_3b_4_1 = [];
  static List<double> age_distribution_lists_3b_4_2 = [];
  static List<double> age_distribution_lists_3b_4_3 = [];

  static Map<String, dynamic> age_distribution_by_gender_and_type_1a_1 = {};
  static Map<String, dynamic> age_distribution_by_gender_and_type_1a_2 = {};
  static Map<String, dynamic> age_distribution_by_gender_and_type_1a_3 = {};
  static Map<String, dynamic> age_distribution_by_gender_and_type_2a_1 = {};
  static Map<String, dynamic> age_distribution_by_gender_and_type_2a_2 = {};
  static Map<String, dynamic> age_distribution_by_gender_and_type_2a_3 = {};
  static Map<String, dynamic> age_distribution_by_gender_and_type_3a_1 = {};
  static Map<String, dynamic> age_distribution_by_gender_and_type_3a_2 = {};
  static Map<String, dynamic> age_distribution_by_gender_and_type_3a_3 = {};
  static Map<String, dynamic> age_distribution_by_gender_and_type_3b_1 = {};
  static Map<String, dynamic> age_distribution_by_gender_and_type_3b_2 = {};
  static Map<String, dynamic> age_distribution_by_gender_and_type_3b_3 = {};

  static List<double> claims_age_distribution_lists_1a_1_1 = [];
  static List<double> claims_age_distribution_lists_1a_1_2 = [];
  static List<double> claims_age_distribution_lists_1a_1_3 = [];
  static List<double> claims_age_distribution_lists_1a_2_1 = [];
  static List<double> claims_age_distribution_lists_1a_2_2 = [];
  static List<double> claims_age_distribution_lists_1a_2_3 = [];
  static List<double> claims_age_distribution_lists_1a_3_1 = [];
  static List<double> claims_age_distribution_lists_1a_3_2 = [];
  static List<double> claims_age_distribution_lists_1a_3_3 = [];
  static List<double> claims_age_distribution_lists_1a_4_1 = [];
  static List<double> claims_age_distribution_lists_1a_4_2 = [];
  static List<double> claims_age_distribution_lists_1a_4_3 = [];
  static List<double> claims_age_distribution_lists_2a_1_1 = [];
  static List<double> claims_age_distribution_lists_2a_1_2 = [];
  static List<double> claims_age_distribution_lists_2a_1_3 = [];
  static List<double> claims_age_distribution_lists_2a_2_1 = [];
  static List<double> claims_age_distribution_lists_2a_2_2 = [];
  static List<double> claims_age_distribution_lists_2a_2_3 = [];
  static List<double> claims_age_distribution_lists_2a_3_1 = [];
  static List<double> claims_age_distribution_lists_2a_3_2 = [];
  static List<double> claims_age_distribution_lists_2a_3_3 = [];
  static List<double> claims_age_distribution_lists_2a_4_1 = [];
  static List<double> claims_age_distribution_lists_2a_4_2 = [];
  static List<double> claims_age_distribution_lists_2a_4_3 = [];
  static List<double> claims_age_distribution_lists_3a_1_1 = [];
  static List<double> claims_age_distribution_lists_3a_1_2 = [];
  static List<double> claims_age_distribution_lists_3a_1_3 = [];
  static List<double> claims_age_distribution_lists_3a_2_1 = [];
  static List<double> claims_age_distribution_lists_3a_2_2 = [];
  static List<double> claims_age_distribution_lists_3a_2_3 = [];
  static List<double> claims_age_distribution_lists_3a_3_1 = [];
  static List<double> claims_age_distribution_lists_3a_3_2 = [];
  static List<double> claims_age_distribution_lists_3a_3_3 = [];
  static List<double> claims_age_distribution_lists_3a_4_1 = [];
  static List<double> claims_age_distribution_lists_3a_4_2 = [];
  static List<double> claims_age_distribution_lists_3a_4_3 = [];
  static List<double> claims_age_distribution_lists_3b_1_1 = [];
  static List<double> claims_age_distribution_lists_3b_1_2 = [];
  static List<double> claims_age_distribution_lists_3b_1_3 = [];
  static List<double> claims_age_distribution_lists_3b_2_1 = [];
  static List<double> claims_age_distribution_lists_3b_2_2 = [];
  static List<double> claims_age_distribution_lists_3b_2_3 = [];
  static List<double> claims_age_distribution_lists_3b_3_1 = [];
  static List<double> claims_age_distribution_lists_3b_3_2 = [];
  static List<double> claims_age_distribution_lists_3b_3_3 = [];
  static List<double> claims_age_distribution_lists_3b_4_1 = [];
  static List<double> claims_age_distribution_lists_3b_4_2 = [];
  static List<double> claims_age_distribution_lists_3b_4_3 = [];

  static Map<String, dynamic> claims_age_distribution_by_gender_and_type_1a_1 =
      {};
  static Map<String, dynamic> claims_age_distribution_by_gender_and_type_1a_2 =
      {};
  static Map<String, dynamic> claims_age_distribution_by_gender_and_type_1a_3 =
      {};
  static Map<String, dynamic> claims_age_distribution_by_gender_and_type_2a_1 =
      {};
  static Map<String, dynamic> claims_age_distribution_by_gender_and_type_2a_2 =
      {};
  static Map<String, dynamic> claims_age_distribution_by_gender_and_type_2a_3 =
      {};
  static Map<String, dynamic> claims_age_distribution_by_gender_and_type_3a_1 =
      {};
  static Map<String, dynamic> claims_age_distribution_by_gender_and_type_3a_2 =
      {};
  static Map<String, dynamic> claims_age_distribution_by_gender_and_type_3a_3 =
      {};
  static Map<String, dynamic> claims_age_distribution_by_gender_and_type_3b_1 =
      {};
  static Map<String, dynamic> claims_age_distribution_by_gender_and_type_3b_2 =
      {};
  static Map<String, dynamic> claims_age_distribution_by_gender_and_type_3b_3 =
      {};

  static List<salesgridmodel> commision_sectionsList1a = [
    salesgridmodel("All Sales", 0),
    salesgridmodel("Total Comm.", 0),
    salesgridmodel("# Agents", 0),
  ];
  static List<salesgridmodel> commision_sectionsList2a = [
    salesgridmodel("All Sales", 0),
    salesgridmodel("Total Comm.", 0),
    salesgridmodel("# Agents", 0),
  ];
  static List<salesgridmodel> commision_sectionsList3a = [
    salesgridmodel("All Sales", 0),
    salesgridmodel("Total Comm.", 0),
    salesgridmodel("# Agents", 0),
  ];
  static List<salesgridmodel> commision_sectionsList3b = [
    salesgridmodel("All Sales", 0),
    salesgridmodel("Total Comm.", 0),
    salesgridmodel("# Agents", 0),
  ];

  static var player2 = jst.AudioPlayer();
  static var player3 = jst.AudioPlayer();

  static String paymentmethod = "";

  static double valuetainment_pass_mark = 80.0;

  static List<SalesByAgent2> micro_learn1a = [];
  static List<SalesByAgent2> micro_learn1b = [];
  static List<SalesByAgent2> micro_learn1c = [];
  static List<SalesByAgent2> micro_learn2a = [];
  static List<SalesByAgent2> micro_learn2b = [];
  static List<SalesByAgent2> micro_learn2c = [];
  static List<SalesByAgent2> micro_learn3a = [];
  static List<SalesByAgent2> micro_learn3b = [];
  static List<SalesByAgent2> micro_learn3c = [];
  static List<SalesByAgent2> micro_learn4a = [];
  static List<SalesByAgent2> micro_learn4b = [];
  static List<SalesByAgent2> micro_learn4c = [];

  static List<SalesByAgent2> micro_learn5a = [];
  static List<SalesByAgent2> micro_learn5b = [];
  static List<SalesByAgent2> micro_learn5c = [];
  static List<SalesByAgent2> micro_learn6a = [];
  static List<SalesByAgent2> micro_learn6b = [];
  static List<SalesByAgent2> micro_learn6c = [];
  static List<SalesByAgent2> micro_learn7a = [];
  static List<SalesByAgent2> micro_learn7b = [];
  static List<SalesByAgent2> micro_learn7c = [];
  static List<SalesByAgent2> micro_learn8a = [];
  static List<SalesByAgent2> micro_learn8b = [];
  static List<SalesByAgent2> micro_learn8c = [];
  static double micro_learn_line_1a = 0.0;
  static double micro_learn_line_2a = 0.0;
  static double micro_learn_line_3a = 0.0;
  static double micro_learn_line_3b = 0.0;

  //Marketing
  //Collections
  static Key marketing_tree_key1a = UniqueKey();
  static Key marketing_tree_key2a = UniqueKey();
  static Key marketing_tree_key3a = UniqueKey();
  static Key marketing_tree_key4a = UniqueKey();

  static Notification2 latestNotification = Notification2(
      id: -1,
      title: "",
      content: "",
      notificationType: "",
      cecClientId: 0,
      uploadedBy: 0,
      displayFrom: "",
      displayUntil: "",
      isActive: false,
      eventDate: "");

  static List customers_maleCount = [];
  static List customers_femaleCount = [];
  static List customers_malePercentage = [];
  static List customers_femalePercentage = [];
  static List customers_sectionsList = [];
  static List customers_age_barGroup_dist_data = [];
  static List customers_age_barGroups = [];

  static CustomerProfile currentCustomerProfile = CustomerProfile.empty();
  static SalesDataResponse currentSalesDataResponse = SalesDataResponse.empty();
  static String trueOrFalseStringValue = "";
  static String trueOrFalseStringValue1 = "";
  static String trueOrFalseStringValueA = "";
  static String trueOrFalseStringValueB = "";
  static String trueOrFalseStringValueC = "";
  static String trueOrFalseStringValueD = "";
  static String trueOrFalseStringValueE = "";
  static String trueOrFalseStringValueF = "";
  static String trueOrFalseStringValueG = "";
  static String trueOrFalseStringValueH = "";
  static String trueOrFalseStringValueI = "";
  static String trueOrFalseStringValueJ = "";
  static String trueOrFalseStringValueL = "";
  static String documentsIndexedPolicyDocuments = '';
  static String isDeclarationsRead = '';

  static int partnerAGE = 0;
  static String mainDOB = "";
  static String idP = "";
  static int mainAGE = 0;
  static String partnerDOB = "";
  static String searchKey = "";
  static String partnerName = "";
  static String partnerCover = "";
  static String partnerPremium = "";
  static String partnerDob = "";
  static String status = "my";
  static String type = "field";
  static String dateOfBirth = "";
  static String isAffordable = '';
  static String proceedProduct = '';
  static String isGoodTimeToTalk = '';
  static List<EmployeeDetails> agentList = [];
  static List<AdditionalMember> additionalMember = [];
  static List<String> titleList = [
    "Mr",
    "Mrs",
    "Ms",
    "Miss",
  ];
  static List<String> relationshipList = [
    "Self/Payer",
    "Partner",
    "Parent",
    "Child",
    "Sister",
    "Brother",
    "Aunt",
    "Niece",
    "Nephew",
    "Adult child",
    "GrandFather",
    "GrandMother",
    "Cousin",
    "Uncle",
  ];
  static String cellNumber = '';
  static String altCellNumber = '';
  static String clientEmail = '';
  static String easyPayRef = "";
  static String easyPayReference = '';
  static String paymentType = '';
  static String doesCustomerUnderstand = '';
  static String clientAcceptSms = '';
  static String clientReceiveSms = '';
  static String fieldSalesPhone = "";
  static List<dynamic> allRidersOrBeneficiaries = [];
  static List<Lead> leadAvailable = [];
  static List<Member> member = [];
  static int fromWhatsAppNumberId = 291328650730634;
  static double whatsapApiVersion = 19.0;
  static String fbToken =
      "EAANikCZC1uY0BO0GAM2207Ps8DBqJaMGKkW5gOjwYusRiT0ZBnJouqDr9WiNBVW4BXeRduAB8OY11V6PRrVlLk74ZCBcjgzLhXh0bmlFxetqQSLyQz91E8dcxOTZBvNM2IsKqPEsjSuJAlS5TkEOCoJgILdP0A0ExVirojEWQx0i6FP147H7VHQaExtugPA5mSO951NmG6W4eXgH";

  static String currentUserLanguage = "English";

  static List<String> accountTypes = [
    "ChequeAccount",
    "SavingsAccount",
    "CurrentAccount",
    "BondAccount",
    "SubscriptionAccount",
    "TransmissionAccount"
  ];
}
