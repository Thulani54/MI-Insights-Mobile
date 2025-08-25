class Lead2 {
  int onololeadid;
  int cec_client_id;
  String LeadGuid;
  String CampaignName;
  String cell_number;
  String alt_cell_number;
  String telephone;
  String title;
  String first_name;
  String last_name;
  String status;
  int assigned_to;
  String is_good_time_to_talk;
  String is_conversation_in_english;
  String prefered_language;
  String is_valid_bank;
  String is_valid_ID_Number;
  String customer_id_number;
  String id_search_result;
  String credit_offering;
  String legal_plan;
  String legal_combo;
  String hollard_money_loan;
  String accept_loan;
  String loan_cell_number;
  String is_requesting_email;
  String client_email;
  String permission_to_collect;
  String cancelling_policy;
  String is_policy_active;
  String communication_preference;
  String receive_documents;
  String list_of_exclusions;
  String does_customer_understand;
  DateTime timestamp;
  String last_position;
  String call_back_date;
  String call_back_time;
  String hang_up_reason;
  String hang_up_desc1;

  Lead2({
    required this.onololeadid,
    required this.cec_client_id,
    required this.LeadGuid,
    required this.CampaignName,
    required this.cell_number,
    required this.alt_cell_number,
    required this.telephone,
    required this.title,
    required this.first_name,
    required this.last_name,
    required this.status,
    required this.assigned_to,
    required this.is_good_time_to_talk,
    required this.is_conversation_in_english,
    required this.prefered_language,
    required this.is_valid_bank,
    required this.is_valid_ID_Number,
    required this.customer_id_number,
    required this.id_search_result,
    required this.credit_offering,
    required this.legal_plan,
    required this.legal_combo,
    required this.hollard_money_loan,
    required this.accept_loan,
    required this.loan_cell_number,
    required this.is_requesting_email,
    required this.client_email,
    required this.permission_to_collect,
    required this.cancelling_policy,
    required this.is_policy_active,
    required this.communication_preference,
    required this.receive_documents,
    required this.list_of_exclusions,
    required this.does_customer_understand,
    required this.timestamp,
    required this.last_position,
    required this.call_back_date,
    required this.call_back_time,
    required this.hang_up_reason,
    required this.hang_up_desc1,
  });

  factory Lead2.fromJson(Map<String, dynamic> json) {
    return Lead2(
      onololeadid: json['onololeadid'],
      cec_client_id: json['cec_client_id'] ?? 0,
      LeadGuid: json['LeadGuid'] ?? "",
      CampaignName: json['CampaignName'] ?? "",
      cell_number: json['cell_number'] ?? "",
      alt_cell_number: json['alt_cell_number'] ?? "",
      telephone: json['telephone'] ?? "",
      title: json['title'] ?? "",
      first_name: json['first_name'] ?? "",
      last_name: json['last_name'] ?? "",
      status: json['status'] ?? "",
      assigned_to: json['assigned_to'] ?? 0,
      is_good_time_to_talk: json['is_good_time_to_talk'] ?? "",
      is_conversation_in_english: json['is_conversation_in_english'] ?? "",
      prefered_language: json['prefered_language'] ?? "",
      is_valid_bank: json['is_valid_bank'] ?? "",
      is_valid_ID_Number: json['is_valid_ID_Number'] ?? "",
      customer_id_number: json['customer_id0_number'] ?? "",
      id_search_result: json['id_search_result'] ?? "",
      credit_offering: json['credit_offering'] ?? "",
      legal_plan: json['legal_plan'] ?? "",
      legal_combo: json['legal_combo'] ?? "",
      hollard_money_loan: json['hollard_money_loan'] ?? "",
      accept_loan: json['accept_loan'] ?? "",
      loan_cell_number: json['loan_cell_number'] ?? "",
      is_requesting_email: json['is_requesting_email'] ?? "",
      client_email: json['client_email'] ?? "",
      permission_to_collect: json['permission_to_collect'] ?? "",
      cancelling_policy: json['cancelling_policy'] ?? "",
      is_policy_active: json['is_policy_active'] ?? "",
      communication_preference: json['communication_preference'] ?? "",
      receive_documents: json['receive_documents'] ?? "",
      list_of_exclusions: json['list_of_exclusions'] ?? "",
      does_customer_understand: json['does_customer_understand'] ?? "",
      timestamp: DateTime.parse(json['timestamp']),
      last_position: json['last_position'],
      call_back_date: json['call_back_date'] ?? "",
      call_back_time: json['call_back_time'] ?? "",
      hang_up_reason: json['hang_up_reason'] ?? "",
      hang_up_desc1: json['hang_up_desc1'] ?? "",
    );
  }
}
