import 'package:flutter/material.dart';

String? formattedStartDate;
String? formattedEndDate;

class EmployeeDetails {
  String employeeTitle;
  String employeeName;
  String employeeSurname;
  String employeeEmail;
  String userImage;
  String cecEmployeeId;
  String mipUsername;
  String agentEmail;

  EmployeeDetails({
    required this.employeeTitle,
    required this.employeeName,
    required this.employeeSurname,
    required this.employeeEmail,
    required this.userImage,
    required this.cecEmployeeId,
    required this.mipUsername,
    required this.agentEmail,
  });

  // Factory constructor to create an Employee instance from a JSON map
  factory EmployeeDetails.fromJson(Map<String, dynamic> json) {
    return EmployeeDetails(
      employeeTitle: json['employee_title'],
      employeeName: json['employee_name'],
      employeeSurname: json['employee_surname'],
      employeeEmail: json['employee_email'],
      userImage: json['userImage'],
      cecEmployeeId: json['cec_employeeid'],
      mipUsername: json['mip_username'],
      agentEmail: json['agent_email'],
    );
  }

  // Method to convert an Employee instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'employee_title': employeeTitle,
      'employee_name': employeeName,
      'employee_surname': employeeSurname,
      'employee_email': employeeEmail,
      'userImage': userImage,
      'cec_employeeid': cecEmployeeId,
      'mip_username': mipUsername,
      'agent_email': agentEmail,
    };
  }
}

class Lead {
  final LeadObject leadObject;
  final List<AdditionalMember> additionalMembers;
   Employer? employer;
  final Replacement? replacement;
  final MipLogin? login;
  Addresses? addresses;
  BeneficiaryAddress? beneficiaryAddress;
  final List<Policy> policies;
  final String? documentPath;

  Lead({
    required this.leadObject,
    required this.additionalMembers,
    this.employer,
    this.replacement,
    this.login,
    this.addresses,
    this.beneficiaryAddress,
    required this.policies,
    this.documentPath,
  });

  // fromJson method
  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      leadObject: LeadObject.fromJson(json['lead']),
      additionalMembers: (json['additional_members'] as List<dynamic>?)
              ?.map((item) => AdditionalMember.fromJson(item))
              .toList() ??
          [],
      employer:
          json['employer'] != null ? Employer.fromJson(json['employer']) : null,
      replacement: json['replacement'] != null
          ? Replacement.fromJson(json['replacement'])
          : null,
      login: json['login'] != null ? MipLogin.fromJson(json['login']) : null,
      addresses: json['addresses'] != null
          ? Addresses.fromJson(json['addresses'])
          : null,
      beneficiaryAddress: json['beneficiary_Address'] != null
          ? BeneficiaryAddress.fromJson(json['beneficiary_Address'])
          : null,
      policies: (json['policy'] as List<dynamic>?)
              ?.map((item) => Policy.fromJson(item))
              .toList() ??
          [],
      documentPath: json['DocumentPath'] as String?,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'lead': leadObject.toJson(),
      'additional_members':
          additionalMembers.map((member) => member.toJson()).toList(),
      'employer': employer?.toJson(),
      'replacement': replacement?.toJson(),
      'login': login?.toJson(),
      'addresses': addresses?.toJson(),
      'beneficiary_Address': beneficiaryAddress?.toJson(),
      'policy': policies.map((policy) => policy.toJson()).toList(),
      'DocumentPath': documentPath,
    };
  }
}

class MipLogin {
  int mipLoginId;
  int onoloLeadId;
  String mipUsername;
  String campaignCode;
  String agentEmail;
  String? updatedBy;

  MipLogin({
    required this.mipLoginId,
    required this.onoloLeadId,
    required this.mipUsername,
    required this.campaignCode,
    required this.agentEmail,
    this.updatedBy,
  });

  // Factory constructor for creating a `Login` object from JSON
  factory MipLogin.fromJson(Map<String, dynamic> json) {
    return MipLogin(
      mipLoginId: json['miploginid'] ?? 0,
      onoloLeadId: json['onololeadid'] ?? 0,
      mipUsername: json['mip_username'] ?? '',
      campaignCode: json['campaign_code'] ?? '',
      agentEmail: json['agent_email'] ?? '',
      updatedBy: json['updated_by'],
    );
  }

  // Method to convert a `Login` object to JSON
  Map<String, dynamic> toJson() {
    return {
      'miploginid': mipLoginId,
      'onololeadid': onoloLeadId,
      'mip_username': mipUsername,
      'campaign_code': campaignCode,
      'agent_email': agentEmail,
      'updated_by': updatedBy,
    };
  }
}

class LeadObject {
  // ---------------------------------------------------------------------------------------------
  // Fields
  // ---------------------------------------------------------------------------------------------
  int onololeadid; // public int onololeadid
  int? cecClientId; // public Nullable<int> cec_client_id
  String leadGuid; // public string LeadGuid
  String campaignName; // public string CampaignName
  String cellNumber; // public string cell_number
  String altCellNumber; // public string alt_cell_number
  String telephone; // public string telephone
  String title; // public string title
  String firstName; // public string first_name
  String lastName; // public string last_name
  String status; // public string status
  int? assignedTo; // public Nullable<int> assigned_to
  String isGoodTimeToTalk; // public string is_good_time_to_talk
  String isConversationInEnglish; // public string is_conversation_in_english
  String preferedLanguage; // public string prefered_language
  String isValidBank; // public string is_valid_bank
  String isValidIDNumber; // public string is_valid_ID_Number
  String customerIdNumber; // public string customer_id_number
  String idSearchResult; // public string id_search_result
  String creditOffering; // public string credit_offering
  String legalPlan; // public string legal_plan
  String legalCombo; // public string legal_combo
  String hollardMoneyLoan; // public string hollard_money_loan
  String acceptLoan; // public string accept_loan
  String loanCellNumber; // public string loan_cell_number
  String isRequestingEmail; // public string is_requesting_email
  String clientEmail; // public string client_email
  String permissionToCollect; // public string permission_to_collect
  String cancellingPolicy; // public string cancelling_policy
  String isPolicyActive; // public string is_policy_active
  String communicationPreference; // public string communication_preference
  String receiveDocuments; // public string receive_documents
  String listOfExclusions; // public string list_of_exclusions
  String doesCustomerUnderstand; // public string does_customer_understand
  String? timestamp; // public Nullable<System.DateTime> timestamp
  String lastPosition; // public string last_position
  String? callBackDate; // public Nullable<System.DateTime> call_back_date
  String?
      callBackTime; // public Nullable<System.TimeSpan> call_back_time -> store as String?
  String hangUpReason; // public string hang_up_reason
  String hangUpDesc1; // public string hang_up_desc1
  String hangUpDesc2; // public string hang_up_desc2
  String hangUpDesc3; // public string hang_up_desc3
  String notes; // public string notes
  String isAffordable; // public string is_affordable
  String proceedProduct; // public string proceed_product
  int? callCount; // public Nullable<int> call_count
  int? callAttempt; // public Nullable<int> call_attempt
  String callTimeElapsed; // public string call_time_ellapsed
  String? saleDate; // public Nullable<System.DateTime> sale_date
  String? lastUpdate; // public Nullable<System.DateTime> last_update
  String leadType; // public string lead_type
  String existingClient; // public string existing_client
  String allocation; // public string allocation
  int? branchLeaderId; // public Nullable<int> branch_leader_id
  int? branchId; // public Nullable<int> branch_id
  String branchLeaderName; // public string branch_leader_name
  String branchSaleType; // public string branch_sale_type
  String teleSaleType; // public string teleSale_type
  int? accessedBy; // public Nullable<int> accessed_by
  String claimantRelationship; // public string claimantRelationship
  int?
      parentLeadid; // public Nullable<long> parentLeadid  (long => int in Dart if within range)
  String queryType; // public string query_type
  int? createdBy; // public Nullable<int> created_by
  String?
      saleTime; // public Nullable<System.TimeSpan> sale_time -> store as String?
  String? saleDatetime; // public Nullable<System.DateTime> sale_datetime
  String idSearchResults; // public string id_search_results
  int? qaDoneBy; // public Nullable<int> qa_done_by
  String qaStatus; // public string qa_status
  double? qaScore; // public Nullable<double> qa_score
  String? qaStartDate; // public Nullable<System.DateTime> qa_start_date
  String? qaEndDate; // public Nullable<System.DateTime> qa_end_date
  String qaHangUpReason; // public string qa_hang_up_reason
  int? verificationDoneBy; // public Nullable<int> verification_done_by
  double? verificationScore; // public Nullable<double> verification_score
  String verificationStatus; // public string verification_status
  String?
      verificationStartDate; // public Nullable<System.DateTime> verification_start_date
  String?
      verificationEndDate; // public Nullable<System.DateTime> verification_end_date
  String verificationHangUpReason; // public string verification_hang_up_reason
  String verificationDataError; // public string verification_data_error
  String verificationDataAgent; // public string verification_data_agent
  int? capturedBy; // public Nullable<int> captured_by
  String isDeclarationsRead; // public string is_declarations_read
  String documentsIndexed; // public string documents_indexed
  String?
      documentsIndexedDate; // public Nullable<System.DateTime> documents_indexed_date
  int? documentsIndexedBy; // public Nullable<int> documents_indexed_by
  String
      documentsIndexedPolicyDocuments; // public string documents_indexed_policy_documents
  String
      documentsIndexedTermsAndConditions; // public string documents_indexed_terms_and_conditions
  String
      documentsIndexedFuneralBenefit; // public string documents_indexed_funeral_benefit
  String
      documentsIndexedAdditionalInformation; // public string documents_indexed_additional_information
  String
      documentsIndexedVabPamphlets; // public string documents_indexed_vab_pamphlets
  String
      documentsIndexedQueryFormUploaded; // public string documents_indexed_query_form_uploaded
  String
      documentsIndexedDeclarationFormUploaded; // public string documents_indexed_declaration_form_uploaded
  String
      documentsIndexedAcknowledgementUploaded; // public string documents_indexed_acknowledgement_uploaded
  String
      documentsIndexedFieldFormUploaded; // public string documents_indexed_field_form_uploaded
  String documentsIndexedExtention; // public string documents_indexed_extention
  String? agentSaleDate; // public Nullable<System.DateTime> agent_sale_date
  String isUpgrade; // public string is_upgrade
  String upgradeReferenceNumber; // public string upgrade_reference_number
  int?
      documentsIndexedFieldFormCount; // public Nullable<int> documents_indexed_field_form_count
  int? qaErrors; // public Nullable<int> qa_errors
  int? qaCriticalErrors; // public Nullable<int> qa_critical_errors
  int? verificationErrors; // public Nullable<int> verification_errors
  String easyPayReference; // public string easyPay_reference
  String paymentType; // public string payment_type
  String posId; // public string pos_id
  String receiptNumber; // public string receipt_number
  String maintenanceList; // public string maintenance_list
  String mipIdSearchObj; // public string mip_id_search_obj
  String maintenanceListDone; // public string maintenance_list_done
  int? updatedBy; // public Nullable<int> updated_by
  String
      maintenanceListDoneCapture; // public string maintenance_list_done_capture
  String version; // public string version
  String isPremiumDeduct; // public string is_premium_deduct
  String isSalaryDeduct; // public string is_salary_deduct
  String isGovernmentEmployee; // public string is_government_employee
  String isPersal; // public string is_persal
  String liveInSa; // public string live_in_sa
  String continueWithSale; // public string continue_with_sale
  String clientReceiveSms; // public string client_receive_sms
  String clientAcceptSms; // public string client_accept_sms
  String uploadType; // public string upload_type
  String newLeadType; // public string new_lead_type
  String leadFrom; // public string lead_from
  String productName; // public string ProductName
  int? referalAgentId; // public Nullable<int> referal_agent_id
  String referalAgentName; // public string referal_agent_name
  int? referalRetentionId; // public Nullable<int> referal_retention_id
  String referalCustomerName; // public string referal_customer_name
  String? wakeUpDate; // public Nullable<System.DateTime> wake_up_date
  int? wakeUpCount; // public Nullable<int> wake_up_count
  int? year; // public Nullable<int> year
  int? month; // public Nullable<int> month
  int? day; // public Nullable<int> day
  int? isHidden; // public Nullable<int> isHidden

  // ---------------------------------------------------------------------------------------------
  // Constructor
  // ---------------------------------------------------------------------------------------------
  LeadObject({
    required this.onololeadid,
    this.cecClientId,
    required this.leadGuid,
    required this.campaignName,
    required this.cellNumber,
    required this.altCellNumber,
    required this.telephone,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.status,
    this.assignedTo,
    required this.isGoodTimeToTalk,
    required this.isConversationInEnglish,
    required this.preferedLanguage,
    required this.isValidBank,
    required this.isValidIDNumber,
    required this.customerIdNumber,
    required this.idSearchResult,
    required this.creditOffering,
    required this.legalPlan,
    required this.legalCombo,
    required this.hollardMoneyLoan,
    required this.acceptLoan,
    required this.loanCellNumber,
    required this.isRequestingEmail,
    required this.clientEmail,
    required this.permissionToCollect,
    required this.cancellingPolicy,
    required this.isPolicyActive,
    required this.communicationPreference,
    required this.receiveDocuments,
    required this.listOfExclusions,
    required this.doesCustomerUnderstand,
    this.timestamp,
    required this.lastPosition,
    this.callBackDate,
    this.callBackTime,
    required this.hangUpReason,
    required this.hangUpDesc1,
    required this.hangUpDesc2,
    required this.hangUpDesc3,
    required this.notes,
    required this.isAffordable,
    required this.proceedProduct,
    this.callCount,
    this.callAttempt,
    required this.callTimeElapsed,
    this.saleDate,
    this.lastUpdate,
    required this.leadType,
    required this.existingClient,
    required this.allocation,
    this.branchLeaderId,
    this.branchId,
    required this.branchLeaderName,
    required this.branchSaleType,
    required this.teleSaleType,
    this.accessedBy,
    required this.claimantRelationship,
    this.parentLeadid,
    required this.queryType,
    this.createdBy,
    this.saleTime,
    this.saleDatetime,
    required this.idSearchResults,
    this.qaDoneBy,
    required this.qaStatus,
    this.qaScore,
    this.qaStartDate,
    this.qaEndDate,
    required this.qaHangUpReason,
    this.verificationDoneBy,
    this.verificationScore,
    required this.verificationStatus,
    this.verificationStartDate,
    this.verificationEndDate,
    required this.verificationHangUpReason,
    required this.verificationDataError,
    required this.verificationDataAgent,
    this.capturedBy,
    required this.isDeclarationsRead,
    required this.documentsIndexed,
    this.documentsIndexedDate,
    this.documentsIndexedBy,
    required this.documentsIndexedPolicyDocuments,
    required this.documentsIndexedTermsAndConditions,
    required this.documentsIndexedFuneralBenefit,
    required this.documentsIndexedAdditionalInformation,
    required this.documentsIndexedVabPamphlets,
    required this.documentsIndexedQueryFormUploaded,
    required this.documentsIndexedDeclarationFormUploaded,
    required this.documentsIndexedAcknowledgementUploaded,
    required this.documentsIndexedFieldFormUploaded,
    required this.documentsIndexedExtention,
    this.agentSaleDate,
    required this.isUpgrade,
    required this.upgradeReferenceNumber,
    this.documentsIndexedFieldFormCount,
    this.qaErrors,
    this.qaCriticalErrors,
    this.verificationErrors,
    required this.easyPayReference,
    required this.paymentType,
    required this.posId,
    required this.receiptNumber,
    required this.maintenanceList,
    required this.mipIdSearchObj,
    required this.maintenanceListDone,
    this.updatedBy,
    required this.maintenanceListDoneCapture,
    required this.version,
    required this.isPremiumDeduct,
    required this.isSalaryDeduct,
    required this.isGovernmentEmployee,
    required this.isPersal,
    required this.liveInSa,
    required this.continueWithSale,
    required this.clientReceiveSms,
    required this.clientAcceptSms,
    required this.uploadType,
    required this.newLeadType,
    required this.leadFrom,
    required this.productName,
    this.referalAgentId,
    required this.referalAgentName,
    this.referalRetentionId,
    required this.referalCustomerName,
    this.wakeUpDate,
    this.wakeUpCount,
    this.year,
    this.month,
    this.day,
    this.isHidden,
  });

  // ---------------------------------------------------------------------------------------------
  // fromJson
  // ---------------------------------------------------------------------------------------------
  factory LeadObject.fromJson(Map<String, dynamic> json) {
    // Helper to parse string -> DateTime?
    DateTime? parseDateTime(dynamic value) {
      if (value == null) return null;
      // Adjust parsing logic depending on your actual JSON date format:
      return DateTime.tryParse(value.toString());
    }

    return LeadObject(
      onololeadid: json['onololeadid'] ?? 0,
      cecClientId: json['cec_client_id'] as int?,
      leadGuid: json['LeadGuid'] ?? '',
      campaignName: json['CampaignName'] ?? '',
      cellNumber: json['cell_number'] ?? '',
      altCellNumber: json['alt_cell_number'] ?? '',
      telephone: json['telephone'] ?? '',
      title: json['title'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      status: json['status'] ?? '',
      assignedTo: json['assigned_to'] as int?,
      isGoodTimeToTalk: json['is_good_time_to_talk'] ?? '',
      isConversationInEnglish: json['is_conversation_in_english'] ?? '',
      preferedLanguage: json['prefered_language'] ?? '',
      isValidBank: json['is_valid_bank'] ?? '',
      isValidIDNumber: json['is_valid_ID_Number'] ?? '',
      customerIdNumber: json['customer_id_number'] ?? '',
      idSearchResult: json['id_search_result'] ?? '',
      creditOffering: json['credit_offering'] ?? '',
      legalPlan: json['legal_plan'] ?? '',
      legalCombo: json['legal_combo'] ?? '',
      hollardMoneyLoan: json['hollard_money_loan'] ?? '',
      acceptLoan: json['accept_loan'] ?? '',
      loanCellNumber: json['loan_cell_number'] ?? '',
      isRequestingEmail: json['is_requesting_email'] ?? '',
      clientEmail: json['client_email'] ?? '',
      permissionToCollect: json['permission_to_collect'] ?? '',
      cancellingPolicy: json['cancelling_policy'] ?? '',
      isPolicyActive: json['is_policy_active'] ?? '',
      communicationPreference: json['communication_preference'] ?? '',
      receiveDocuments: json['receive_documents'] ?? '',
      listOfExclusions: json['list_of_exclusions'] ?? '',
      doesCustomerUnderstand: json['does_customer_understand'] ?? '',
      timestamp: json['timestamp'],
      lastPosition: json['last_position'] ?? '',
      callBackDate: json['call_back_date'],
      callBackTime: json['call_back_time'],
      hangUpReason: json['hang_up_reason'] ?? '',
      hangUpDesc1: json['hang_up_desc1'] ?? '',
      hangUpDesc2: json['hang_up_desc2'] ?? '',
      hangUpDesc3: json['hang_up_desc3'] ?? '',
      notes: json['notes'] ?? '',
      isAffordable: json['is_affordable'] ?? '',
      proceedProduct: json['proceed_product'] ?? '',
      callCount: json['call_count'] as int?,
      callAttempt: json['call_attempt'] as int?,
      callTimeElapsed: json['call_time_ellapsed'] ?? '',
      saleDate: json['sale_date'],
      lastUpdate: json['last_update'],
      leadType: json['lead_type'] ?? '',
      existingClient: json['existing_client'] ?? '',
      allocation: json['allocation'] ?? '',
      branchLeaderId: json['branch_leader_id'] as int?,
      branchId: json['branch_id'] as int?,
      branchLeaderName: json['branch_leader_name'] ?? '',
      branchSaleType: json['branch_sale_type'] ?? '',
      teleSaleType: json['teleSale_type'] ?? '',
      accessedBy: json['accessed_by'] as int?,
      claimantRelationship: json['claimantRelationship'] ?? '',
      parentLeadid: json['parentLeadid'] == null
          ? null
          : int.tryParse(json['parentLeadid'].toString()),
      queryType: json['query_type'] ?? '',
      createdBy: json['created_by'] as int?,
      saleTime: json['sale_time'],
      saleDatetime: json['sale_datetime'],
      idSearchResults: json['id_search_results'] ?? '',
      qaDoneBy: json['qa_done_by'] as int?,
      qaStatus: json['qa_status'] ?? '',
      qaScore: json['qa_score'] == null
          ? null
          : double.tryParse(json['qa_score'].toString()),
      qaStartDate: json['qa_start_date'],
      qaEndDate: json['qa_end_date'],
      qaHangUpReason: json['qa_hang_up_reason'] ?? '',
      verificationDoneBy: json['verification_done_by'] as int?,
      verificationScore: json['verification_score'] == null
          ? null
          : double.tryParse(json['verification_score'].toString()),
      verificationStatus: json['verification_status'] ?? '',
      verificationStartDate: json['verification_start_date'],
      verificationEndDate: json['verification_end_date'],
      verificationHangUpReason: json['verification_hang_up_reason'] ?? '',
      verificationDataError: json['verification_data_error'] ?? '',
      verificationDataAgent: json['verification_data_agent'] ?? '',
      capturedBy: json['captured_by'] as int?,
      isDeclarationsRead: json['is_declarations_read'] ?? '',
      documentsIndexed: json['documents_indexed'] ?? '',
      documentsIndexedDate: json['documents_indexed_date'],
      documentsIndexedBy: json['documents_indexed_by'] as int?,
      documentsIndexedPolicyDocuments:
          json['documents_indexed_policy_documents'] ?? '',
      documentsIndexedTermsAndConditions:
          json['documents_indexed_terms_and_conditions'] ?? '',
      documentsIndexedFuneralBenefit:
          json['documents_indexed_funeral_benefit'] ?? '',
      documentsIndexedAdditionalInformation:
          json['documents_indexed_additional_information'] ?? '',
      documentsIndexedVabPamphlets:
          json['documents_indexed_vab_pamphlets'] ?? '',
      documentsIndexedQueryFormUploaded:
          json['documents_indexed_query_form_uploaded'] ?? '',
      documentsIndexedDeclarationFormUploaded:
          json['documents_indexed_declaration_form_uploaded'] ?? '',
      documentsIndexedAcknowledgementUploaded:
          json['documents_indexed_acknowledgement_uploaded'] ?? '',
      documentsIndexedFieldFormUploaded:
          json['documents_indexed_field_form_uploaded'] ?? '',
      documentsIndexedExtention: json['documents_indexed_extention'] ?? '',
      agentSaleDate: json['agent_sale_date'],
      isUpgrade: json['is_upgrade'] ?? '',
      upgradeReferenceNumber: json['upgrade_reference_number'] ?? '',
      documentsIndexedFieldFormCount:
          json['documents_indexed_field_form_count'] as int?,
      qaErrors: json['qa_errors'] as int?,
      qaCriticalErrors: json['qa_critical_errors'] as int?,
      verificationErrors: json['verification_errors'] as int?,
      easyPayReference: json['easyPay_reference'] ?? '',
      paymentType: json['payment_type'] ?? '',
      posId: json['pos_id'] ?? '',
      receiptNumber: json['receipt_number'] ?? '',
      maintenanceList: json['maintenance_list'] ?? '',
      mipIdSearchObj: json['mip_id_search_obj'] ?? '',
      maintenanceListDone: json['maintenance_list_done'] ?? '',
      updatedBy: json['updated_by'] as int?,
      maintenanceListDoneCapture: json['maintenance_list_done_capture'] ?? '',
      version: json['version'] ?? '',
      isPremiumDeduct: json['is_premium_deduct'] ?? '',
      isSalaryDeduct: json['is_salary_deduct'] ?? '',
      isGovernmentEmployee: json['is_government_employee'] ?? '',
      isPersal: json['is_persal'] ?? '',
      liveInSa: json['live_in_sa'] ?? '',
      continueWithSale: json['continue_with_sale'] ?? '',
      clientReceiveSms: json['client_receive_sms'] ?? '',
      clientAcceptSms: json['client_accept_sms'] ?? '',
      uploadType: json['upload_type'] ?? '',
      newLeadType: json['new_lead_type'] ?? '',
      leadFrom: json['lead_from'] ?? '',
      productName: json['ProductName'] ?? '',
      referalAgentId: json['referal_agent_id'] as int?,
      referalAgentName: json['referal_agent_name'] ?? '',
      referalRetentionId: json['referal_retention_id'] as int?,
      referalCustomerName: json['referal_customer_name'] ?? '',
      wakeUpDate: json['wake_up_date'],
      wakeUpCount: json['wake_up_count'] ?? 0 as int?,
      year: json['year'] as int?,
      month: json['month'] as int?,
      day: json['day'] as int?,
      isHidden: json['isHidden'] as int?,
    );
  }

  // ---------------------------------------------------------------------------------------------
  // toJson
  // ---------------------------------------------------------------------------------------------
  Map<String, dynamic> toJson() {
    // Helper to convert DateTime? -> String?
    String? dateTimeToString(DateTime? dt) {
      return dt?.toIso8601String();
    }

    return {
      'onololeadid': onololeadid,
      'cec_client_id': cecClientId,
      'LeadGuid': leadGuid,
      'CampaignName': campaignName,
      'cell_number': cellNumber,
      'alt_cell_number': altCellNumber,
      'telephone': telephone,
      'title': title,
      'first_name': firstName,
      'last_name': lastName,
      'status': status,
      'assigned_to': assignedTo,
      'is_good_time_to_talk': isGoodTimeToTalk,
      'is_conversation_in_english': isConversationInEnglish,
      'prefered_language': preferedLanguage,
      'is_valid_bank': isValidBank,
      'is_valid_ID_Number': isValidIDNumber,
      'customer_id_number': customerIdNumber,
      'id_search_result': idSearchResult,
      'credit_offering': creditOffering,
      'legal_plan': legalPlan,
      'legal_combo': legalCombo,
      'hollard_money_loan': hollardMoneyLoan,
      'accept_loan': acceptLoan,
      'loan_cell_number': loanCellNumber,
      'is_requesting_email': isRequestingEmail,
      'client_email': clientEmail,
      'permission_to_collect': permissionToCollect,
      'cancelling_policy': cancellingPolicy,
      'is_policy_active': isPolicyActive,
      'communication_preference': communicationPreference,
      'receive_documents': receiveDocuments,
      'list_of_exclusions': listOfExclusions,
      'does_customer_understand': doesCustomerUnderstand,
      'timestamp': timestamp,
      'last_position': lastPosition,
      'call_back_date': callBackDate,
      'call_back_time': callBackTime,
      'hang_up_reason': hangUpReason,
      'hang_up_desc1': hangUpDesc1,
      'hang_up_desc2': hangUpDesc2,
      'hang_up_desc3': hangUpDesc3,
      'notes': notes,
      'is_affordable': isAffordable,
      'proceed_product': proceedProduct,
      'call_count': callCount,
      'call_attempt': callAttempt,
      'call_time_ellapsed': callTimeElapsed,
      'sale_date': saleDate,
      'last_update': lastUpdate,
      'lead_type': leadType,
      'existing_client': existingClient,
      'allocation': allocation,
      'branch_leader_id': branchLeaderId,
      'branch_id': branchId,
      'branch_leader_name': branchLeaderName,
      'branch_sale_type': branchSaleType,
      'teleSale_type': teleSaleType,
      'accessed_by': accessedBy,
      'claimantRelationship': claimantRelationship,
      'parentLeadid': parentLeadid,
      'query_type': queryType,
      'created_by': createdBy,
      'sale_time': saleTime,
      'sale_datetime': saleDatetime,
      'id_search_results': idSearchResults,
      'qa_done_by': qaDoneBy,
      'qa_status': qaStatus,
      'qa_score': qaScore,
      'qa_start_date': qaStartDate,
      'qa_end_date': qaEndDate,
      'qa_hang_up_reason': qaHangUpReason,
      'verification_done_by': verificationDoneBy,
      'verification_score': verificationScore,
      'verification_status': verificationStatus,
      'verification_start_date': verificationStartDate,
      'verification_end_date': verificationEndDate,
      'verification_hang_up_reason': verificationHangUpReason,
      'verification_data_error': verificationDataError,
      'verification_data_agent': verificationDataAgent,
      'captured_by': capturedBy,
      'is_declarations_read': isDeclarationsRead,
      'documents_indexed': documentsIndexed,
      'documents_indexed_date': documentsIndexedDate,
      'documents_indexed_by': documentsIndexedBy,
      'documents_indexed_policy_documents': documentsIndexedPolicyDocuments,
      'documents_indexed_terms_and_conditions':
          documentsIndexedTermsAndConditions,
      'documents_indexed_funeral_benefit': documentsIndexedFuneralBenefit,
      'documents_indexed_additional_information':
          documentsIndexedAdditionalInformation,
      'documents_indexed_vab_pamphlets': documentsIndexedVabPamphlets,
      'documents_indexed_query_form_uploaded':
          documentsIndexedQueryFormUploaded,
      'documents_indexed_declaration_form_uploaded':
          documentsIndexedDeclarationFormUploaded,
      'documents_indexed_acknowledgement_uploaded':
          documentsIndexedAcknowledgementUploaded,
      'documents_indexed_field_form_uploaded':
          documentsIndexedFieldFormUploaded,
      'documents_indexed_extention': documentsIndexedExtention,
      'agent_sale_date': agentSaleDate,
      'is_upgrade': isUpgrade,
      'upgrade_reference_number': upgradeReferenceNumber,
      'documents_indexed_field_form_count': documentsIndexedFieldFormCount,
      'qa_errors': qaErrors,
      'qa_critical_errors': qaCriticalErrors,
      'verification_errors': verificationErrors,
      'easyPay_reference': easyPayReference,
      'payment_type': paymentType,
      'pos_id': posId,
      'receipt_number': receiptNumber,
      'maintenance_list': maintenanceList,
      'mip_id_search_obj': mipIdSearchObj,
      'maintenance_list_done': maintenanceListDone,
      'updated_by': updatedBy,
      'maintenance_list_done_capture': maintenanceListDoneCapture,
      'version': version,
      'is_premium_deduct': isPremiumDeduct,
      'is_salary_deduct': isSalaryDeduct,
      'is_government_employee': isGovernmentEmployee,
      'is_persal': isPersal,
      'live_in_sa': liveInSa,
      'continue_with_sale': continueWithSale,
      'client_receive_sms': clientReceiveSms,
      'client_accept_sms': clientAcceptSms,
      'upload_type': uploadType,
      'new_lead_type': newLeadType,
      'lead_from': leadFrom,
      'ProductName': productName,
      'referal_agent_id': referalAgentId,
      'referal_agent_name': referalAgentName,
      'referal_retention_id': referalRetentionId,
      'referal_customer_name': referalCustomerName,
      'wake_up_date': wakeUpDate,
      'wake_up_count': wakeUpCount,
      'year': year,
      'month': month,
      'day': day,
      'isHidden': isHidden,
    };
  }
}

void checkTypeMismatch(
    Map<String, dynamic> json, Map<String, Type> expectedTypes) {
  json.forEach((key, value) {
    if (expectedTypes.containsKey(key)) {
      final expectedType = expectedTypes[key];
      if (value != null && value.runtimeType != expectedType) {
        print(
            'Type mismatch for key "$key": Expected $expectedType, got ${value.runtimeType}');
      }
    }
  });
}

class AdditionalMember {
  String memberType;
  int autoNumber;
  String id;
  String contact;
  String dob;
  String gender;
  String name;
  String surname;
  String title;
  int onololeadid;
  String altContact;
  String email;
  int percentage;
  String maritalStatus;
  String relationship;
  String mipCover;
  String mipStatus;
  int updatedBy;
  String memberQueryType;
  String memberQueryTypeOldNew;
  String memberQueryTypeOldAutoNumber;
  String membersAutoNumber;
  String sourceOfIncome;
  String sourceOfWealth;
  String otherUnknownIncome;
  String otherUnknownWealth;
  String timestamp;
  String lastUpdate;

  AdditionalMember({
    required this.memberType,
    required this.autoNumber,
    required this.id,
    required this.contact,
    required this.dob,
    required this.gender,
    required this.name,
    required this.surname,
    required this.title,
    required this.onololeadid,
    required this.altContact,
    required this.email,
    required this.percentage,
    required this.maritalStatus,
    required this.relationship,
    required this.mipCover,
    required this.mipStatus,
    required this.updatedBy,
    required this.memberQueryType,
    required this.memberQueryTypeOldNew,
    required this.memberQueryTypeOldAutoNumber,
    required this.membersAutoNumber,
    required this.sourceOfIncome,
    required this.sourceOfWealth,
    required this.otherUnknownIncome,
    required this.otherUnknownWealth,
    required this.timestamp,
    required this.lastUpdate,
  });

  factory AdditionalMember.empty() {
    return AdditionalMember(
      memberType: "",
      autoNumber: 0,
      id: "",
      contact: "",
      dob: "",
      gender: "",
      name: "",
      surname: "",
      title: "",
      onololeadid: 0,
      altContact: "",
      email: "",
      percentage: 0,
      maritalStatus: "",
      relationship: "",
      mipCover: "",
      mipStatus: "",
      updatedBy: 0,
      memberQueryType: "",
      memberQueryTypeOldNew: "",
      memberQueryTypeOldAutoNumber: "",
      membersAutoNumber: "",
      sourceOfIncome: "",
      sourceOfWealth: "",
      otherUnknownIncome: "",
      otherUnknownWealth: "",
      timestamp: "",
      lastUpdate: "",
    );
  }

  factory AdditionalMember.fromJson(Map<String, dynamic> json) {
    return AdditionalMember(
      memberType: json['member_type'] ??
          'default', // Add default since it's missing in JSON
      autoNumber: json['auto_number'] ?? 0,
      id: json['id'] ?? '',
      contact: json['contact'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      title: json['title'] ?? '',
      onololeadid: json['onololeadid'] ?? 0,
      altContact: json['alt_contact'] ?? '', // Fixed key name
      email: json['email'] ?? '',
      percentage: json['percentage'] ?? 0,
      maritalStatus: json['maritalStatus'] ?? '',
      relationship: json['relationship'] ?? '',
      mipCover: json['mip_cover'] ?? '',
      mipStatus: json['mip_status'] ?? '',
      updatedBy: json['updated_by'] ?? 0,
      memberQueryType: json['member_query_type'] ?? '',
      memberQueryTypeOldNew: json['member_query_type_old_new'] ?? '',
      memberQueryTypeOldAutoNumber:
          json['member_query_type_old_auto_number'] ?? '',
      membersAutoNumber: json['members_auto_number'] ?? '',
      sourceOfIncome: json['source_of_income'] ?? '',
      sourceOfWealth: json['source_of_wealth'] ?? '',
      otherUnknownIncome: json['other_unknown_income'] ?? '',
      otherUnknownWealth: json['other_unknown_wealth'] ?? '',
      timestamp: json['timestamp'] ?? '',
      lastUpdate: json['last_update'] ?? '', // Fixed key name
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberType': memberType,
      'autoNumber': autoNumber,
      'id': id,
      'contact': contact,
      'dob': dob,
      'gender': gender,
      'name': name,
      'surname': surname,
      'title': title,
      'onololeadid': onololeadid,
      'altContact': altContact,
      'email': email,
      'percentage': percentage,
      'maritalStatus': maritalStatus,
      'relationship': relationship,
      'mipCover': mipCover,
      'mipStatus': mipStatus,
      'updatedBy': updatedBy,
      'memberQueryType': memberQueryType,
      'memberQueryTypeOldNew': memberQueryTypeOldNew,
      'memberQueryTypeOldAutoNumber': memberQueryTypeOldAutoNumber,
      'membersAutoNumber': membersAutoNumber,
      'sourceOfIncome': sourceOfIncome,
      'sourceOfWealth': sourceOfWealth,
      'otherUnknownIncome': otherUnknownIncome,
      'otherUnknownWealth': otherUnknownWealth,
      'timestamp': timestamp,
      'lastUpdate': lastUpdate,
    };
  }
}

class Employer {
  int onoloEmployerid;
  int onololeadid;
  String employerName;
  String occupation;
  String employeeNumber;
  String salaryRange;
  String salaryFrequency;
  String salaryDay;
  String updatedBy;
  String employerQueryType;
  String employerQueryTypeOldNew;
  String employerQueryTypeOldAutoNumber;
  String employerTimestamp;
  String employerLastUpdate;
  String employmentStatus;
  String incomeSource;
  String specifySource;

  Employer({
    required this.onoloEmployerid,
    required this.onololeadid,
    required this.employerName,
    required this.occupation,
    required this.employeeNumber,
    required this.salaryRange,
    required this.salaryFrequency,
    required this.salaryDay,
    required this.updatedBy,
    required this.employerQueryType,
    required this.employerQueryTypeOldNew,
    required this.employerQueryTypeOldAutoNumber,
    required this.employerTimestamp,
    required this.employerLastUpdate,
    required this.employmentStatus,
    required this.incomeSource,
    required this.specifySource,
  });

  factory Employer.fromJson(Map<String, dynamic> json) {
    return Employer(
      onoloEmployerid: json['onoloEmployerid'] ?? 0,
      onololeadid: json['onololeadid'] ?? 0,
      employerName: json['employerName'] ?? '',
      occupation: json['occupation'] ?? '',
      employeeNumber: json['employeeNumber'] ?? '',
      salaryRange: json['salaryRange'] ?? '',
      salaryFrequency: json['salaryFrequency'] ?? '',
      salaryDay: json['salaryDay'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      employerQueryType: json['employerQueryType'] ?? '',
      employerQueryTypeOldNew: json['employerQueryTypeOldNew'] ?? '',
      employerQueryTypeOldAutoNumber:
          json['employerQueryTypeOldAutoNumber'] ?? '',
      employerTimestamp: json['employerTimestamp'] ?? '',
      employerLastUpdate: json['employerLastUpdate'] ?? '',
      employmentStatus: json['employmentStatus'] ?? '',
      incomeSource: json['incomeSource'] ?? '',
      specifySource: json['specifySource'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'onoloEmployerid': onoloEmployerid,
      'onololeadid': onololeadid,
      'employerName': employerName,
      'occupation': occupation,
      'employeeNumber': employeeNumber,
      'salaryRange': salaryRange,
      'salaryFrequency': salaryFrequency,
      'salaryDay': salaryDay,
      'updatedBy': updatedBy,
      'employerQueryType': employerQueryType,
      'employerQueryTypeOldNew': employerQueryTypeOldNew,
      'employerQueryTypeOldAutoNumber': employerQueryTypeOldAutoNumber,
      'employerTimestamp': employerTimestamp,
      'employerLastUpdate': employerLastUpdate,
      'employmentStatus': employmentStatus,
      'incomeSource': incomeSource,
      'specifySource': specifySource,
    };
  }
}

class Replacement {
  int onoloPolicyReplacementid;
  int onololeadid;
  String insurersNumber;
  String coverType;
  String coverDuration;

  Replacement({
    required this.onoloPolicyReplacementid,
    required this.onololeadid,
    required this.insurersNumber,
    required this.coverType,
    required this.coverDuration,
  });

  factory Replacement.fromJson(Map<String, dynamic> json) {
    return Replacement(
      onoloPolicyReplacementid: json["onolo_policy_replacementid"] ?? 0,
      onololeadid: json['onololeadid'] ?? 0,
      insurersNumber: json['insurers_number'] ?? '',
      coverType: json['cover_type'] ?? '',
      coverDuration: json['cover_duration'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'onoloPolicyReplacementid': onoloPolicyReplacementid,
      'onololeadid': onololeadid,
      'insurersNumber': insurersNumber,
      'coverType': coverType,
      'coverDuration': coverDuration,
    };
  }
}

class Addresses {
  int autoNumber;
  int onololeadid;
  String postaddressLine1;
  String postaddressLine2;
  String postaddressLine3;
  String postaddressCode;
  String postaddressProvince;
  String physaddressLine1;
  String physaddressLine2;
  String physaddressLine3;
  String physaddressCode;
  String physaddressProvince;
  String latitude;
  String longitude;
  String validated;
  String updatedBy;
  String addressQueryType;
  String addressQueryTypeOldNew;
  String addressQueryTypeOldAutoNumber;
  String addressTimestamp;
  String addressLastUpdate;
  String addressAutoNumber;
  String physaddressCountry;
  String postaddressCountry;

  Addresses({
    required this.autoNumber,
    required this.onololeadid,
    required this.postaddressLine1,
    required this.postaddressLine2,
    required this.postaddressLine3,
    required this.postaddressCode,
    required this.postaddressProvince,
    required this.physaddressLine1,
    required this.physaddressLine2,
    required this.physaddressLine3,
    required this.physaddressCode,
    required this.physaddressProvince,
    required this.latitude,
    required this.longitude,
    required this.validated,
    required this.updatedBy,
    required this.addressQueryType,
    required this.addressQueryTypeOldNew,
    required this.addressQueryTypeOldAutoNumber,
    required this.addressTimestamp,
    required this.addressLastUpdate,
    required this.addressAutoNumber,
    required this.physaddressCountry,
    required this.postaddressCountry,
  });

  factory Addresses.fromJson(Map<String, dynamic> json) {
    return Addresses(
      autoNumber: json['autoNumber'] ?? 0,
      onololeadid: json['onololeadid'] ?? 0,
      postaddressLine1: json['postaddressLine1'] ?? '',
      postaddressLine2: json['postaddressLine2'] ?? '',
      postaddressLine3: json['postaddressLine3'] ?? '',
      postaddressCode: json['postaddressCode'] ?? '',
      postaddressProvince: json['postaddressProvince'] ?? '',
      physaddressLine1: json['physaddressLine1'] ?? '',
      physaddressLine2: json['physaddressLine2'] ?? '',
      physaddressLine3: json['physaddressLine3'] ?? '',
      physaddressCode: json['physaddressCode'] ?? '',
      physaddressProvince: json['physaddressProvince'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      validated: json['validated'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      addressQueryType: json['addressQueryType'] ?? '',
      addressQueryTypeOldNew: json['addressQueryTypeOldNew'] ?? '',
      addressQueryTypeOldAutoNumber:
          json['addressQueryTypeOldAutoNumber'] ?? '',
      addressTimestamp: json['addressTimestamp'] ?? '',
      addressLastUpdate: json['addressLastUpdate'] ?? '',
      addressAutoNumber: json['addressAutoNumber'] ?? '',
      physaddressCountry: json['physaddressCountry'] ?? '',
      postaddressCountry: json['postaddressCountry'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autoNumber': autoNumber,
      'onololeadid': onololeadid,
      'postaddressLine1': postaddressLine1,
      'postaddressLine2': postaddressLine2,
      'postaddressLine3': postaddressLine3,
      'postaddressCode': postaddressCode,
      'postaddressProvince': postaddressProvince,
      'physaddressLine1': physaddressLine1,
      'physaddressLine2': physaddressLine2,
      'physaddressLine3': physaddressLine3,
      'physaddressCode': physaddressCode,
      'physaddressProvince': physaddressProvince,
      'latitude': latitude,
      'longitude': longitude,
      'validated': validated,
      'updatedBy': updatedBy,
      'addressQueryType': addressQueryType,
      'addressQueryTypeOldNew': addressQueryTypeOldNew,
      'addressQueryTypeOldAutoNumber': addressQueryTypeOldAutoNumber,
      'addressTimestamp': addressTimestamp,
      'addressLastUpdate': addressLastUpdate,
      'addressAutoNumber': addressAutoNumber,
      'physaddressCountry': physaddressCountry,
      'postaddressCountry': postaddressCountry,
    };
  }
}

class BeneficiaryAddress {
  int id;
  int onololeadid;
  String physaddressLine1;
  String physaddressLine2;
  String physaddressLine3;
  String physaddressCode;
  String physaddressProvince;
  String timestamp;

  BeneficiaryAddress({
    required this.id,
    required this.onololeadid,
    required this.physaddressLine1,
    required this.physaddressLine2,
    required this.physaddressLine3,
    required this.physaddressCode,
    required this.physaddressProvince,
    required this.timestamp,
  });

  factory BeneficiaryAddress.fromJson(Map<String, dynamic> json) {
    print("dfgfgh $json");
    return BeneficiaryAddress(
      id: json['id'] ?? 0,
      onololeadid: json['onololeadid'] ?? 0,
      physaddressLine1: json['physaddressLine1'] ?? '',
      physaddressLine2: json['physaddressLine2'] ?? '',
      physaddressLine3: json['physaddressLine3'] ?? '',
      physaddressCode: json['physaddressCode'] ?? '',
      physaddressProvince: json['physaddressProvince'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'onololeadid': onololeadid,
      'physaddressLine1': physaddressLine1,
      'physaddressLine2': physaddressLine2,
      'physaddressLine3': physaddressLine3,
      'physaddressCode': physaddressCode,
      'physaddressProvince': physaddressProvince,
      'timestamp': timestamp,
    };
  }
}

class PremiumPayer {
  int autoNumber;
  String bankname;
  String branchname;
  String branchcode;
  String accno;
  String accounttype;
  String salarydate;
  String collectionday;
  String naedosexplained;
  String commencementDate;
  String naedosconset;
  String timestamp;
  String lastUpdate;
  String reference;
  int onololeadid;
  String acountHolder;
  String combinePremium;
  String validated;
  String errorMessage;
  int updatedBy;
  String payerQueryTypeOldNew;
  String payerQueryType;
  String payerQueryTypeOldAutoNumber;
  String payerAutoNumberOld;
  String isSpecialDebit;
  String specialDebitDate;

  PremiumPayer({
    required this.autoNumber,
    required this.bankname,
    required this.branchname,
    required this.branchcode,
    required this.accno,
    required this.accounttype,
    required this.salarydate,
    required this.collectionday,
    required this.naedosexplained,
    required this.commencementDate,
    required this.naedosconset,
    required this.timestamp,
    required this.lastUpdate,
    required this.reference,
    required this.onololeadid,
    required this.acountHolder,
    required this.combinePremium,
    required this.validated,
    required this.errorMessage,
    required this.updatedBy,
    required this.payerQueryTypeOldNew,
    required this.payerQueryType,
    required this.payerQueryTypeOldAutoNumber,
    required this.payerAutoNumberOld,
    required this.isSpecialDebit,
    required this.specialDebitDate,
  });

  factory PremiumPayer.fromJson(Map<String, dynamic> json) {
    //  print("fgfgffg1a $json");

    return PremiumPayer(
      autoNumber: json['autoNumber'] ?? 0,
      bankname: json['bankname'] ?? '',
      branchname: json['branchname'] ?? '',
      branchcode: json['branchcode'] ?? '',
      accno: json['accno'] ?? '',
      accounttype: json['accounttype'] ?? '',
      salarydate: json['salarydate'] ?? '',
      collectionday: json['collectionday'] ?? '',
      naedosexplained: json['naedosexplained'] ?? '',
      commencementDate: json['commencementDate'] ?? '',
      naedosconset: json['naedosconset'] ?? '',
      timestamp: json['timestamp'] ?? '',
      lastUpdate: json['lastUpdate'] ?? '',
      reference: json['reference'] ?? '',
      onololeadid: json['onololeadid'] ?? 0,
      acountHolder: json['acountHolder'] ?? '',
      combinePremium: json['combinePremium'] ?? '',
      validated: json['validated'] ?? '',
      errorMessage: json['errorMessage'] ?? '',
      updatedBy: json['updated_by'] ?? 0,
      payerQueryTypeOldNew: json['payerQueryTypeOldNew'] ?? '',
      payerQueryType: json['payerQueryType'] ?? '',
      payerQueryTypeOldAutoNumber: json['payerQueryTypeOldAutoNumber'] ?? '',
      payerAutoNumberOld: json['payerAutoNumberOld'] ?? '',
      isSpecialDebit: json['isSpecialDebit'] ?? '',
      specialDebitDate: json['specialDebitDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autoNumber': autoNumber,
      'bankname': bankname,
      'branchname': branchname,
      'branchcode': branchcode,
      'accno': accno,
      'accounttype': accounttype,
      'salarydate': salarydate,
      'collectionday': collectionday,
      'naedosexplained': naedosexplained,
      'commencementDate': commencementDate,
      'naedosconset': naedosconset,
      'timestamp': timestamp,
      'lastUpdate': lastUpdate,
      'reference': reference,
      'onololeadid': onololeadid,
      'acountHolder': acountHolder,
      'combinePremium': combinePremium,
      'validated': validated,
      'errorMessage': errorMessage,
      'updatedBy': updatedBy,
      'payerQueryTypeOldNew': payerQueryTypeOldNew,
      'payerQueryType': payerQueryType,
      'payerQueryTypeOldAutoNumber': payerQueryTypeOldAutoNumber,
      'payerAutoNumberOld': payerAutoNumberOld,
      'isSpecialDebit': isSpecialDebit,
      'specialDebitDate': specialDebitDate,
    };
  }
}

class Quote {
  int autoNumber;
  double? policyFee;
  double? vabServiceFee;
  int? childrenCount;
  double? childrenPremium;
  double? familyFuneralRiderPremium;
  DateTime? inceptionDate;
  double? sumAssuredFamilyCover;
  double? totalAmountPayable;
  double? totalBenefitPremium;
  double? totalPremium;
  String? lastUpdate;
  String? timestamp;
  String reference;
  int? cecEmployeeId;
  String? cecEmployeeName;
  double? mainIsuredCover;
  bool? isMainInsured;
  String? mainIsuredDob;
  double? childrenSumAssured;
  bool? extendedFamilysInsured;
  int? mainIsuredAge;
  double? mainIsuredPremium;
  bool? mainLifeInsured;
  bool? parentsInsured;
  bool? parentsextendedFamilysInsured;
  bool? partnerChildrenRider;
  bool? partnerCovered;
  String? ridersAdded;
  double? childrenFuneralPremium;
  int? extendedChildrenCount;
  double? extendedChildrenPremium;
  double? childrenFuneralSumAssured;
  double? partnerFuneralRiderPremium;
  double? partnerFuneralSumAssured;
  String? familyFuneralRider;
  double? partnerPremium;
  double? mainIsuredFuneralCover;
  double? mainIsuredFuneralPremium;
  double? mainIsuredCoverTotal;
  String product;
  String abbr;
  int? cecClientId;
  int onololeadid;
  String productType;
  String? acceptPolicy;
  String policyNumber;
  String? status;
  DateTime? inforceDate;
  String? mipDescription;
  int? inforcedBy;
  String? leadReference;
  int? debitDay;
  bool? isWaitingPeriodRead;
  String? indexingStatusQueryForm;
  DateTime? indexingDateQueryForm;
  String? indexingByQueryForm;
  String? indexingCallLogQueryForm;
  String? indexingStatusDeclarationForm;
  DateTime? indexingDateDeclarationForm;
  String? indexingByDeclarationForm;
  String? indexingCallLogDeclarationForm;
  String? indexingStatusAcknowledgementForm;
  DateTime? indexingDateAcknowledgementForm;
  String? indexingByAcknowledgementForm;
  String? indexingCallLogAcknowledgementForm;
  bool? isUpgrade;
  String? upgradeReferenceNumber;
  DateTime? debitDueDateP1;
  DateTime? debitDueDateP2;
  DateTime? debitDueDateP3;
  DateTime? debitDueDateSpecial;
  String? debitStatusP1;
  String? debitStatusP2;
  String? debitStatusP3;
  String? debitStatusSpecial;
  String? rejectionStatus;
  DateTime? rejectionStatusDate;
  String? mipStatus;
  DateTime? mipStatusDate;
  String? mipChanges;
  String? maintenanceStatus;
  String? partnerWithPaidUp;
  String? policyUpdates;
  String? policyUpdates1;
  String? policyUpdates2;
  String? policyUpdates3;
  String? policyUpdates4;
  String? policyUpdates5;
  String? policyUpdates6;
  int? updatedBy;
  bool? policyDocPrinted;
  DateTime? policyDocPrintDate;
  String? failedAllocatedTo;
  String? failedAllocatedToDesc;
  String? failedAllocatedToDoneBy;
  DateTime? failedAllocatedToDate;
  int? autoNumberOld;
  DateTime? nextCollection;

  Quote({
    required this.autoNumber,
    this.policyFee,
    this.vabServiceFee,
    this.childrenCount,
    this.childrenPremium,
    this.familyFuneralRiderPremium,
    this.inceptionDate,
    this.sumAssuredFamilyCover,
    this.totalAmountPayable,
    this.totalBenefitPremium,
    this.totalPremium,
    this.lastUpdate,
    this.timestamp,
    required this.reference,
    this.cecEmployeeId,
    this.cecEmployeeName,
    this.mainIsuredCover,
    this.isMainInsured,
    this.mainIsuredDob,
    this.childrenSumAssured,
    this.extendedFamilysInsured,
    this.mainIsuredAge,
    this.mainIsuredPremium,
    this.mainLifeInsured,
    this.parentsInsured,
    this.parentsextendedFamilysInsured,
    this.partnerChildrenRider,
    this.partnerCovered,
    this.ridersAdded,
    this.childrenFuneralPremium,
    this.extendedChildrenCount,
    this.extendedChildrenPremium,
    this.childrenFuneralSumAssured,
    this.partnerFuneralRiderPremium,
    this.partnerFuneralSumAssured,
    this.familyFuneralRider,
    this.partnerPremium,
    this.mainIsuredFuneralCover,
    this.mainIsuredFuneralPremium,
    this.mainIsuredCoverTotal,
    required this.product,
    required this.abbr,
    this.cecClientId,
    required this.onololeadid,
    required this.productType,
    this.acceptPolicy,
    required this.policyNumber,
    this.status,
    this.inforceDate,
    this.mipDescription,
    this.inforcedBy,
    this.leadReference,
    this.debitDay,
    this.isWaitingPeriodRead,
    this.indexingStatusQueryForm,
    this.indexingDateQueryForm,
    this.indexingByQueryForm,
    this.indexingCallLogQueryForm,
    this.indexingStatusDeclarationForm,
    this.indexingDateDeclarationForm,
    this.indexingByDeclarationForm,
    this.indexingCallLogDeclarationForm,
    this.indexingStatusAcknowledgementForm,
    this.indexingDateAcknowledgementForm,
    this.indexingByAcknowledgementForm,
    this.indexingCallLogAcknowledgementForm,
    this.isUpgrade,
    this.upgradeReferenceNumber,
    this.debitDueDateP1,
    this.debitDueDateP2,
    this.debitDueDateP3,
    this.debitDueDateSpecial,
    this.debitStatusP1,
    this.debitStatusP2,
    this.debitStatusP3,
    this.debitStatusSpecial,
    this.rejectionStatus,
    this.rejectionStatusDate,
    this.mipStatus,
    this.mipStatusDate,
    this.mipChanges,
    this.maintenanceStatus,
    this.partnerWithPaidUp,
    this.policyUpdates,
    this.policyUpdates1,
    this.policyUpdates2,
    this.policyUpdates3,
    this.policyUpdates4,
    this.policyUpdates5,
    this.policyUpdates6,
    this.updatedBy,
    this.policyDocPrinted,
    this.policyDocPrintDate,
    this.failedAllocatedTo,
    this.failedAllocatedToDesc,
    this.failedAllocatedToDoneBy,
    this.failedAllocatedToDate,
    this.autoNumberOld,
    this.nextCollection,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    print("fgfgffg1b JSON Parsing Fields with Types: $json");

    return Quote(
      autoNumber: json['auto_number'] ?? 0,
      policyFee: (json['PolicyFee'] != null)
          ? (json['PolicyFee'] as num).toDouble()
          : null,
      vabServiceFee: (json['VABServiceFee'] != null)
          ? (json['VABServiceFee'] as num).toDouble()
          : null,
      childrenCount: json['childrenCount'],
      childrenPremium: (json['childrenPremium'] != null)
          ? (json['childrenPremium'] as num).toDouble()
          : null,
      familyFuneralRiderPremium: (json['familyFuneralRiderPremium'] != null)
          ? (json['familyFuneralRiderPremium'] as num).toDouble()
          : null,
      inceptionDate: json['inceptionDate'] == null
          ? null
          : DateTime.parse(json['inceptionDate']),
      sumAssuredFamilyCover: (json['sumAssuredFamilyCover'] != null)
          ? (json['sumAssuredFamilyCover'] as num).toDouble()
          : null,
      totalAmountPayable: (json['totalAmountPayable'] != null)
          ? (json['totalAmountPayable'] as num).toDouble()
          : null,
      totalBenefitPremium: (json['totalBenefitPremium'] != null)
          ? (json['totalBenefitPremium'] as num).toDouble()
          : null,
      totalPremium: (json['totalPremium'] != null)
          ? (json['totalPremium'] as num).toDouble()
          : null,
      lastUpdate: json['last_update'],
      timestamp: json['timestamp'],
      reference: json['reference'] ?? '',
      cecEmployeeId: json['cec_employeeid'],
      cecEmployeeName: json['cec_employee_name'],
      mainIsuredCover: (json['mainIsuredCover'] != null)
          ? (json['mainIsuredCover'] as num).toDouble()
          : null,
      isMainInsured: (json['isMainInsured'] != null)
          ? (json['isMainInsured'].toString().toLowerCase() == 'true')
          : null,
      mainIsuredDob: json['mainIsuredDob'],
      childrenSumAssured: (json['childrenSumAssured'] != null)
          ? (json['childrenSumAssured'] as num).toDouble()
          : null,
      extendedFamilysInsured: (json['extendedFamilysInsured'] != null)
          ? json['extendedFamilysInsured'].toString().toLowerCase() == 'true'
          : null,
      mainIsuredAge: json['mainIsuredAge'],
      mainIsuredPremium: (json['mainIsuredPremium'] != null)
          ? (json['mainIsuredPremium'] as num).toDouble()
          : null,
      mainLifeInsured: (json['mainLifeInsured'] != null)
          ? json['mainLifeInsured'].toString().toLowerCase() == 'true'
          : null,
      parentsInsured: (json['parentsInsured'] != null)
          ? json['parentsInsured'].toString().toLowerCase() == 'true'
          : null,
      parentsextendedFamilysInsured: (json['parentsextendedFamilysInsured'] !=
              null)
          ? json['parentsextendedFamilysInsured'].toString().toLowerCase() ==
              'true'
          : null,
      partnerChildrenRider: (json['partnerChildrenRider'] != null)
          ? json['partnerChildrenRider'].toString().toLowerCase() == 'true'
          : null,
      partnerCovered: (json['partnerCovered'] != null)
          ? json['partnerCovered'].toString().toLowerCase() == 'true'
          : null,
      ridersAdded: json['ridersAdded'],
      childrenFuneralPremium: (json['childrenFuneralPremium'] != null)
          ? (json['childrenFuneralPremium'] as num).toDouble()
          : null,
      extendedChildrenCount: json['extendedChildrenCount'],
      extendedChildrenPremium: (json['extendedChildrenPremium'] != null)
          ? (json['extendedChildrenPremium'] as num).toDouble()
          : null,
      childrenFuneralSumAssured: (json['childrenFuneralSumAssured'] != null)
          ? (json['childrenFuneralSumAssured'] as num).toDouble()
          : null,
      partnerFuneralRiderPremium: (json['partnerFuneralRiderPremium'] != null)
          ? (json['partnerFuneralRiderPremium'] as num).toDouble()
          : null,
      partnerFuneralSumAssured: (json['partnerFuneralSumAssured'] != null)
          ? (json['partnerFuneralSumAssured'] as num).toDouble()
          : null,
      familyFuneralRider: json['familyFuneralRider'],
      partnerPremium: (json['partnerPremium'] != null)
          ? (json['partnerPremium'] as num).toDouble()
          : null,
      mainIsuredFuneralCover: (json['mainIsuredFuneralCover'] != null)
          ? (json['mainIsuredFuneralCover'] as num).toDouble()
          : null,
      mainIsuredFuneralPremium: (json['mainIsuredFuneralPremium'] != null)
          ? (json['mainIsuredFuneralPremium'] as num).toDouble()
          : null,
      mainIsuredCoverTotal: (json['mainIsuredCoverTotal'] != null)
          ? (json['mainIsuredCoverTotal'] as num).toDouble()
          : null,
      product: json['product'] ?? '',
      abbr: json['abbr'] ?? '',
      cecClientId: json['cec_client_id'],
      onololeadid: json['onololeadid'] ?? 0,
      productType: json['product_type'] ?? '',
      acceptPolicy: json['accept_policy'],
      policyNumber: json['policy_number'] ?? '',
      status: json['status'],
      inforceDate: json['inforce_date'] == null
          ? null
          : DateTime.parse(json['inforce_date']),
      mipDescription: json['mip_description'],
      inforcedBy: json['inforced_by'],
      leadReference: json['lead_reference'],
      debitDay: json['debit_day'],
      isWaitingPeriodRead: (json['is_waiting_period_read'] != null)
          ? json['is_waiting_period_read'].toString().toLowerCase() == 'true'
          : null,
      indexingStatusQueryForm: json['indexing_status_query_form'],
      indexingDateQueryForm: json['indexing_date_query_form'] == null
          ? null
          : DateTime.parse(json['indexing_date_query_form']),
      indexingByQueryForm: json['indexing_by_query_form'],
      indexingCallLogQueryForm: json['indexing_call_log_query_form'],
      indexingStatusDeclarationForm: json['indexing_status_declaration_form'],
      indexingDateDeclarationForm:
          json['indexing_date_declaration_form'] == null
              ? null
              : DateTime.parse(json['indexing_date_declaration_form']),
      indexingByDeclarationForm: json['indexing_by_declaration_form'],
      indexingCallLogDeclarationForm:
          json['indexing_call_log_declaration_form'],
      indexingStatusAcknowledgementForm:
          json['indexing_status_acknowledgement_form'],
      indexingDateAcknowledgementForm:
          json['indexing_date_acknowledgement_form'] == null
              ? null
              : DateTime.parse(json['indexing_date_acknowledgement_form']),
      indexingByAcknowledgementForm: json['indexing_by_acknowledgement_form'],
      indexingCallLogAcknowledgementForm:
          json['indexing_call_log_acknowledgement_form'],
      isUpgrade: (json['is_upgrade'] != null)
          ? json['is_upgrade'].toString().toLowerCase() == 'true'
          : null,
      upgradeReferenceNumber: json['upgrade_reference_number'],
      debitDueDateP1: (json['debit_due_date_p1'] == null)
          ? null
          : DateTime.parse(json['debit_due_date_p1']),
      debitDueDateP2: (json['debit_due_date_p2'] == null)
          ? null
          : DateTime.parse(json['debit_due_date_p2']),
      debitDueDateP3: (json['debit_due_date_p3'] == null)
          ? null
          : DateTime.parse(json['debit_due_date_p3']),
      debitDueDateSpecial: (json['debit_due_date_special'] == null)
          ? null
          : DateTime.parse(json['debit_due_date_special']),
      debitStatusP1: json['debit_status_p1'],
      debitStatusP2: json['debit_status_p2'],
      debitStatusP3: json['debit_status_p3'],
      debitStatusSpecial: json['debit_status_special'],
      rejectionStatus: json['rejection_status'],
      rejectionStatusDate: json['rejection_status_date'] == null
          ? null
          : DateTime.parse(json['rejection_status_date']),
      mipStatus: json['mip_status'],
      mipStatusDate: json['mip_status_date'] == null
          ? null
          : DateTime.parse(json['mip_status_date']),
      mipChanges: json['mip_changes'],
      maintenanceStatus: json['maintenance_status'],
      partnerWithPaidUp: json['partner_with_paid_up'],
      policyUpdates: json['policy_updates'],
      policyUpdates1: json['policy_updates1'],
      policyUpdates2: json['policy_updates2'],
      policyUpdates3: json['policy_updates3'],
      policyUpdates4: json['policy_updates4'],
      policyUpdates5: json['policy_updates5'],
      policyUpdates6: json['policy_updates6'],
      updatedBy: json['updated_by'],
      policyDocPrinted: (json['policy_doc_printed'] != null)
          ? json['policy_doc_printed'].toString().toLowerCase() == 'true'
          : null,
      policyDocPrintDate: (json['policy_doc_print_date'] == null)
          ? null
          : DateTime.parse(json['policy_doc_print_date']),
      failedAllocatedTo: json['failed_allocated_to'],
      failedAllocatedToDesc: json['failed_allocated_to_desc'],
      failedAllocatedToDoneBy: json['failed_allocated_to_done_by'],
      failedAllocatedToDate: json['failed_allocated_to_date'] == null
          ? null
          : DateTime.parse(json['failed_allocated_to_date']),
      autoNumberOld: json['auto_number_old'],
      nextCollection: json['next_collection'] == null
          ? null
          : DateTime.parse(json['next_collection']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'auto_number': autoNumber,
      'PolicyFee': policyFee,
      'VABServiceFee': vabServiceFee,
      'childrenCount': childrenCount,
      'childrenPremium': childrenPremium,
      'familyFuneralRiderPremium': familyFuneralRiderPremium,
      'inceptionDate': inceptionDate?.toIso8601String(),
      'sumAssuredFamilyCover': sumAssuredFamilyCover,
      'totalAmountPayable': totalAmountPayable,
      'totalBenefitPremium': totalBenefitPremium,
      'totalPremium': totalPremium,
      'last_update': lastUpdate,
      'timestamp': timestamp,
      'reference': reference,
      'cec_employeeid': cecEmployeeId,
      'cec_employee_name': cecEmployeeName,
      'mainIsuredCover': mainIsuredCover,
      'isMainInsured': isMainInsured,
      'mainIsuredDob': mainIsuredDob,
      'childrenSumAssured': childrenSumAssured,
      'extendedFamilysInsured': extendedFamilysInsured,
      'mainIsuredAge': mainIsuredAge,
      'mainIsuredPremium': mainIsuredPremium,
      'mainLifeInsured': mainLifeInsured,
      'parentsInsured': parentsInsured,
      'parentsextendedFamilysInsured': parentsextendedFamilysInsured,
      'partnerChildrenRider': partnerChildrenRider,
      'partnerCovered': partnerCovered,
      'ridersAdded': ridersAdded,
      'childrenFuneralPremium': childrenFuneralPremium,
      'extendedChildrenCount': extendedChildrenCount,
      'extendedChildrenPremium': extendedChildrenPremium,
      'childrenFuneralSumAssured': childrenFuneralSumAssured,
      'partnerFuneralRiderPremium': partnerFuneralRiderPremium,
      'partnerFuneralSumAssured': partnerFuneralSumAssured,
      'familyFuneralRider': familyFuneralRider,
      'partnerPremium': partnerPremium,
      'mainIsuredFuneralCover': mainIsuredFuneralCover,
      'mainIsuredFuneralPremium': mainIsuredFuneralPremium,
      'mainIsuredCoverTotal': mainIsuredCoverTotal,
      'product': product,
      'abbr': abbr,
      'cec_client_id': cecClientId,
      'onololeadid': onololeadid,
      'product_type': productType,
      'accept_policy': acceptPolicy,
      'policy_number': policyNumber,
      'status': status,
      'inforce_date': inforceDate?.toIso8601String(),
      'mip_description': mipDescription,
      'inforced_by': inforcedBy,
      'lead_reference': leadReference,
      'debit_day': debitDay,
      'is_waiting_period_read': isWaitingPeriodRead,
      'indexing_status_query_form': indexingStatusQueryForm,
      'indexing_date_query_form': indexingDateQueryForm?.toIso8601String(),
      'indexing_by_query_form': indexingByQueryForm,
      'indexing_call_log_query_form': indexingCallLogQueryForm,
      'indexing_status_declaration_form': indexingStatusDeclarationForm,
      'indexing_date_declaration_form':
          indexingDateDeclarationForm?.toIso8601String(),
      'indexing_by_declaration_form': indexingByDeclarationForm,
      'indexing_call_log_declaration_form': indexingCallLogDeclarationForm,
      'indexing_status_acknowledgement_form': indexingStatusAcknowledgementForm,
      'indexing_date_acknowledgement_form':
          indexingDateAcknowledgementForm?.toIso8601String(),
      'indexing_by_acknowledgement_form': indexingByAcknowledgementForm,
      'indexing_call_log_acknowledgement_form':
          indexingCallLogAcknowledgementForm,
      'is_upgrade': isUpgrade,
      'upgrade_reference_number': upgradeReferenceNumber,
      'debit_due_date_p1': debitDueDateP1?.toIso8601String(),
      'debit_due_date_p2': debitDueDateP2?.toIso8601String(),
      'debit_due_date_p3': debitDueDateP3?.toIso8601String(),
      'debit_due_date_special': debitDueDateSpecial?.toIso8601String(),
      'debit_status_p1': debitStatusP1,
      'debit_status_p2': debitStatusP2,
      'debit_status_p3': debitStatusP3,
      'debit_status_special': debitStatusSpecial,
      'rejection_status': rejectionStatus,
      'rejection_status_date': rejectionStatusDate?.toIso8601String(),
      'mip_status': mipStatus,
      'mip_status_date': mipStatusDate?.toIso8601String(),
      'mip_changes': mipChanges,
      'maintenance_status': maintenanceStatus,
      'partner_with_paid_up': partnerWithPaidUp,
      'policy_updates': policyUpdates,
      'policy_updates1': policyUpdates1,
      'policy_updates2': policyUpdates2,
      'policy_updates3': policyUpdates3,
      'policy_updates4': policyUpdates4,
      'policy_updates5': policyUpdates5,
      'policy_updates6': policyUpdates6,
      'updated_by': updatedBy,
      'policy_doc_printed': policyDocPrinted,
      'policy_doc_print_date': policyDocPrintDate?.toIso8601String(),
      'failed_allocated_to': failedAllocatedTo,
      'failed_allocated_to_desc': failedAllocatedToDesc,
      'failed_allocated_to_done_by': failedAllocatedToDoneBy,
      'failed_allocated_to_date': failedAllocatedToDate?.toIso8601String(),
      'auto_number_old': autoNumberOld,
      'next_collection': nextCollection?.toIso8601String(),
    };
  }
}

class Member {
  int? autoNumber;
  String? timestamp;
  String? lastUpdate;
  String? reference;
  int? additionalMemberId;
  double? premium;
  double? cover;
  String? type;
  int? percentage;
  String? coverMembersCol;
  String? benRelationship;
  String? memberStatus;
  String? terminationDate;
  int? updatedBy;
  String? memberQueryType;
  String? memberQueryTypeOldNew;
  String? memberQueryTypeOldAutoNumber;
  int? cecClientId;
  int? empId;

  Member(
    this.autoNumber,
    this.timestamp,
    this.lastUpdate,
    this.reference,
    this.additionalMemberId,
    this.premium,
    this.cover,
    this.type,
    this.percentage,
    this.coverMembersCol,
    this.benRelationship,
    this.memberStatus,
    this.terminationDate,
    this.updatedBy,
    this.memberQueryType,
    this.memberQueryTypeOldNew,
    this.memberQueryTypeOldAutoNumber,
    this.cecClientId,
    this.empId,
  );

  /// Factory method to create an empty Member.
  factory Member.empty() {
    return Member(
      0,
      // autoNumber
      "",
      // timestamp
      "",
      // lastUpdate
      "",
      // reference
      0,
      // additionalMemberId
      0.0,
      // premium
      0.0,
      // cover
      "",
      // type
      0,
      // percentage
      "",
      // coverMembersCol
      "",
      // benRelationship
      "",
      // memberStatus
      "",
      // terminationDate
      -1,
      // updatedBy
      "",
      // memberQueryType
      "",
      // memberQueryTypeOldNew
      "",
      // memberQueryTypeOldAutoNumber
      -1,
      // cecClientId
      -1, // empId
    );
  }

  /// Converts a JSON map into a Member object.
  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      json['auto_number'] ?? 0,
      json['timestamp'] ?? "",
      json['last_update'] ?? "",
      json['reference'] ?? "",
      json['additional_member_id'] ?? 0,
      json['premium'] != null ? json['premium'].toDouble() : null,
      json['cover'] != null ? json['cover'].toDouble() : null,
      json['type'] ?? "",
      json['percentage'] ?? 0,
      json['cover_memberscol'] ?? "",
      json['ben_relationship'] ?? "",
      json['member_status'] ?? "",
      json['termination_date'] ?? "",
      json['updatedBy'] ?? -1,
      json['member_query_type'] ?? "",
      json['member_query_type_old_new'] ?? "",
      json['member_query_type_old_auto_number'] ?? "",
      json['cec_client_id'] ?? -1,
      json['empid'] ?? -1,
    );
  }

  /// Converts the Member object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'auto_number': autoNumber,
      'timestamp': timestamp,
      'last_update': lastUpdate,
      'reference': reference,
      'additional_member_id': additionalMemberId,
      'premium': premium,
      'cover': cover,
      'type': type,
      'percentage': percentage,
      'cover_memberscol': coverMembersCol,
      'ben_relationship': benRelationship,
      'member_status': memberStatus,
      'termination_date': terminationDate,
      'updated_by': updatedBy,
      'member_query_type': memberQueryType,
      'member_query_type_old_new': memberQueryTypeOldNew,
      'member_query_type_old_auto_number': memberQueryTypeOldAutoNumber,
      'cec_client_id': cecClientId,
      'empid': empId,
    };
  }
}

class Performance {
  int index;
  String salesDate;
  String gender;
  int cellNumber;
  String customerName;
  String source;
  String salesType;
  String branchName;
  String status;

  Performance(
      this.index,
      this.salesDate,
      this.gender,
      this.cellNumber,
      this.customerName,
      this.source,
      this.salesType,
      this.branchName,
      this.status);
}

class LiveMonitorAgents {
  int index;
  String agentName;
  String gender;
  String email;
  String token;
  String startTime;
  String status;

  LiveMonitorAgents(this.index, this.agentName, this.gender, this.email,
      this.token, this.startTime, this.status);
}

class DailyStats {
  String date;
  var day1;
  var day2;
  var day3;
  var day4;
  var day5;
  var day6;
  var day7;
  var day8;
  var day9;
  var day10;

  var day11;
  var day12;
  var day13;
  var day14;
  var day15;
  var day16;
  var day17;
  var day18;
  var day19;
  var day20;

  var day21;
  var day22;
  var day23;
  var day24;
  var day25;
  var day26;
  var day27;
  var day28;
  var day29;
  var day30;
  var day31;

  DailyStats(
    this.date,
    this.day1,
    this.day2,
    this.day3,
    this.day4,
    this.day5,
    this.day6,
    this.day7,
    this.day8,
    this.day9,
    this.day10,
    this.day11,
    this.day12,
    this.day13,
    this.day14,
    this.day15,
    this.day16,
    this.day17,
    this.day18,
    this.day19,
    this.day20,
    this.day21,
    this.day22,
    this.day23,
    this.day24,
    this.day25,
    this.day26,
    this.day27,
    this.day28,
    this.day29,
    this.day30,
    this.day31,
  );
}

class AgentsStats {
  String agentName;
  List<Leads> daysList1;
  List<Sales> daysList2;
  List<Conversion> daysList3;
  List<DialsAttempts> daysList4;
  List<TalkTime> daysList5;
  List<ActiveTime> daysList6;

  AgentsStats(
    this.agentName,
    this.daysList1,
    this.daysList2,
    this.daysList3,
    this.daysList4,
    this.daysList5,
    this.daysList6,
  );
}

class Leads {
  String leads;
  var day1;
  var day2;
  var day3;
  var day4;
  var day5;
  var day6;
  var day7;
  var day8;
  var day9;
  var day10;
  var day11;
  var day12;
  var day13;
  var day14;
  var day15;
  var day16;

  Leads(
      this.leads,
      this.day1,
      this.day2,
      this.day3,
      this.day4,
      this.day5,
      this.day6,
      this.day7,
      this.day8,
      this.day9,
      this.day10,
      this.day11,
      this.day12,
      this.day13,
      this.day14,
      this.day15,
      this.day16);
}

class Sales {
  String sales;
  var day1;
  var day2;
  var day3;
  var day4;
  var day5;
  var day6;
  var day7;
  var day8;
  var day9;
  var day10;
  var day11;
  var day12;
  var day13;
  var day14;
  var day15;
  var day16;

  Sales(
      this.sales,
      this.day1,
      this.day2,
      this.day3,
      this.day4,
      this.day5,
      this.day6,
      this.day7,
      this.day8,
      this.day9,
      this.day10,
      this.day11,
      this.day12,
      this.day13,
      this.day14,
      this.day15,
      this.day16);
}

class Conversion {
  String conversion;
  var day1;
  var day2;
  var day3;
  var day4;
  var day5;
  var day6;
  var day7;
  var day8;
  var day9;
  var day10;
  var day11;
  var day12;
  var day13;
  var day14;
  var day15;
  var day16;

  Conversion(
      this.conversion,
      this.day1,
      this.day2,
      this.day3,
      this.day4,
      this.day5,
      this.day6,
      this.day7,
      this.day8,
      this.day9,
      this.day10,
      this.day11,
      this.day12,
      this.day13,
      this.day14,
      this.day15,
      this.day16);
}

class DialsAttempts {
  String dialsAttempts;
  var day1;
  var day2;
  var day3;
  var day4;
  var day5;
  var day6;
  var day7;
  var day8;
  var day9;
  var day10;
  var day11;
  var day12;
  var day13;
  var day14;
  var day15;
  var day16;

  DialsAttempts(
      this.dialsAttempts,
      this.day1,
      this.day2,
      this.day3,
      this.day4,
      this.day5,
      this.day6,
      this.day7,
      this.day8,
      this.day9,
      this.day10,
      this.day11,
      this.day12,
      this.day13,
      this.day14,
      this.day15,
      this.day16);
}

class TalkTime {
  String talkTime;
  var day1;
  var day2;
  var day3;
  var day4;
  var day5;
  var day6;
  var day7;
  var day8;
  var day9;
  var day10;
  var day11;
  var day12;
  var day13;
  var day14;
  var day15;
  var day16;

  TalkTime(
      this.talkTime,
      this.day1,
      this.day2,
      this.day3,
      this.day4,
      this.day5,
      this.day6,
      this.day7,
      this.day8,
      this.day9,
      this.day10,
      this.day11,
      this.day12,
      this.day13,
      this.day14,
      this.day15,
      this.day16);
}

class ActiveTime {
  String activeTime;
  var day1;
  var day2;
  var day3;
  var day4;
  var day5;
  var day6;
  var day7;
  var day8;
  var day9;
  var day10;
  var day11;
  var day12;
  var day13;
  var day14;
  var day15;
  var day16;

  ActiveTime(
      this.activeTime,
      this.day1,
      this.day2,
      this.day3,
      this.day4,
      this.day5,
      this.day6,
      this.day7,
      this.day8,
      this.day9,
      this.day10,
      this.day11,
      this.day12,
      this.day13,
      this.day14,
      this.day15,
      this.day16);
}

class OfAgents {
  int phoneNumber;
  String name;

  OfAgents(
    this.phoneNumber,
    this.name,
  );
}

class ClaimsTable5 {
  int index;
  String admin;
  double amount;

  ClaimsTable5(this.index, this.admin, this.amount);
}

class ClaimsTable6 {
  int index;
  String driver_name;
  String status;

  ClaimsTable6(this.index, this.driver_name, this.status);
}

class ClaimsTableDebit {
  int index;
  String description;
  String generatedOn;
  String service;

  ClaimsTableDebit(
      this.index, this.description, this.generatedOn, this.service);
}

class ClaimsTableDebit2 {
  int index;
  String actionDate;

  ClaimsTableDebit2(
    this.index,
    this.actionDate,
  );
}

class ClaimsTableDebit1 {
  int index;
  String clientName;
  String clientRef1;
  String clientRef2;
  String policy;
  String initiationDate;
  double amount;
  String actionDate;
  String installment;
  String bank;
  String accountType;
  String status;
  String statusDescription;

  ClaimsTableDebit1(
      this.index,
      this.clientName,
      this.clientRef1,
      this.clientRef2,
      this.policy,
      this.initiationDate,
      this.amount,
      this.actionDate,
      this.installment,
      this.bank,
      this.accountType,
      this.status,
      this.statusDescription);
}

class ClaimsTableDebit3 {
  int index;
  String policyReference;
  int policyNumber;
  String transactionDate;
  String processedBy;
  int employeeNumber;
  String paymentStatus;
  double collectedAmount;
  double policyPremium;
  String paymentMethod;
  String clientName;
  String branchName;

  ClaimsTableDebit3(
    this.index,
    this.policyReference,
    this.policyNumber,
    this.transactionDate,
    this.processedBy,
    this.employeeNumber,
    this.paymentStatus,
    this.collectedAmount,
    this.policyPremium,
    this.paymentMethod,
    this.clientName,
    this.branchName,
  );
}

class ClaimsTable4 {
  int index;
  String transdate;
  int total_member;
  double predicted_premium;
  double actual_premium;
  String variance;
  double admin_fee;
  int predicted_collections_count;
  int actual_collections_count;
  String clientName;

  ClaimsTable4(
      this.index,
      this.transdate,
      this.clientName,
      this.admin_fee,
      this.actual_premium,
      this.predicted_premium,
      this.total_member,
      this.variance,
      this.actual_collections_count,
      this.predicted_collections_count);
}

class ClaimsTable4A {
  int index;
  String reg_number;
  String make;
  String model;
  String color;
  String disc_exp_date;
  String mileage;
  String last_service_date;
  String assigned_to;
  String availability;
  String alerts;

  ClaimsTable4A(
      this.index,
      this.reg_number,
      this.make,
      this.model,
      this.color,
      this.disc_exp_date,
      this.mileage,
      this.last_service_date,
      this.assigned_to,
      this.availability,
      this.alerts);
}

class ClaimsTable4A1 {
  int index;
  String firstName;
  String email;
  String jobTitle;
  String department;

  ClaimsTable4A1(
    this.index,
    this.firstName,
    this.email,
    this.jobTitle,
    this.department,
  );
}

class ClaimsTable4B {
  int index;

  // String regN
  String assignedTime;
  int startMileage;
  String returnTime;
  int endMileage;
  String assignedTo;
  String assignedBY;
  String tripReason;

  ClaimsTable4B(
      this.index,
      this.assignedTime,
      this.startMileage,
      this.returnTime,
      this.endMileage,
      this.assignedTo,
      this.assignedBY,
      this.tripReason);
}

class ClaimsTable1 {
  int index;
  String transdate;
  String clientName;
  String policyNumber;
  double collectedAmount;
  String processedBy;
  String employeeNumber;
  String branch;
  String reason;
  String code;
  String status;

  ClaimsTable1(
      this.index,
      this.policyNumber,
      this.transdate,
      this.clientName,
      this.collectedAmount,
      this.processedBy,
      this.employeeNumber,
      this.branch,
      this.reason,
      this.code,
      this.status);
}

class ClaimsTable2 {
  int index;
  String policyNumber;
  String status;
  String massege;

  ClaimsTable2(this.index, this.policyNumber, this.massege, this.status);
}

class ClaimsTable3 {
  int index;
  String transdate;
  String collectionType;
  String policyNumber;
  double collectedPremium;
  String isDuplicate;

  ClaimsTable3(this.index, this.policyNumber, this.transdate,
      this.collectedPremium, this.collectionType, this.isDuplicate);
}

class ClaimsInvestigationTable {
  int index;
  String date;
  String customerName;
  String policyNumber;
  String synopsisStatus;
  String claimStatus;
  String branch;
  String capturedBy;

  ClaimsInvestigationTable(
      this.index,
      this.date,
      this.customerName,
      this.policyNumber,
      this.synopsisStatus,
      this.claimStatus,
      this.branch,
      this.capturedBy);
}

class LiveTable1 {
  int index;
  String doctorNurseName;
  String employeeContractorName;
  String progress;
  String timeSpent;
  String duration;
  String medicalCentre;
  String campaign;

  LiveTable1(
      this.index,
      this.doctorNurseName,
      this.employeeContractorName,
      this.progress,
      this.timeSpent,
      this.duration,
      this.medicalCentre,
      this.campaign);
}

class ClientSalesLeadsTable {
  int index;
  String date;
  String customerName;
  int cellNumber;
  String policyStatus;
  String leadStatus;
  String wrapStatus;
  String callBackTime;
  String version;
  String queryType;

  ClientSalesLeadsTable(
      this.index,
      this.date,
      this.customerName,
      this.cellNumber,
      this.policyStatus,
      this.leadStatus,
      this.wrapStatus,
      this.callBackTime,
      this.queryType,
      this.version);
}

class Claim {
  int index;
  String date;
  String customerName;
  String policyNumber;
  String synopsisStatus;
  String claimStatus;
  String referenceNumber;

  // Fields from the JSON structure with nullable types where needed
  String? collection_status;
  int claim_id;
  int? claim_onololeadid;
  int? cam_autonunber;
  double? claim_amount;
  int? claim_client_id;
  int? branch_id;
  String? claim_client_email;
  String? policy_num;
  String? policy_status;
  String? policy_reference;
  String? policy_life;
  String? claim_cell_number;
  String? claim_title;
  String? claim_first_name;
  String? claim_last_name;
  String? claim_id_num;
  String? claim_dob;
  String? death_type;
  String? claim_status;
  String? claim_status_description;
  int? claim_assigned_to;
  String? synopsis_status;
  String? policy_synopsis_res;
  String? member_synopsis;
  String? member_synopsis_reason;
  String? claim_hang_up_reason;
  String? claim_hang_up_desc1;
  String? claim_hang_up_desc2;
  String? claim_hang_up_desc3;
  String? claim_notes;
  String? branch_leader_notes;
  String? assessor_notes;
  String? risk_notes;
  int? claim_call_count;
  int? claim_call_attempt;
  int? claim_call_time_ellapsed;
  String? claim_date;
  String? claim_last_update;
  String? claim_type;
  String? claim_reference;
  int? claim_created_by;
  int? pay_or_service_rendered;
  String? paymt_or_service_Date;
  String? pay_or_service_reference;
  String? claim_complete_date;
  String? last_position;
  int? last_position_tab;
  int? is_suicide;
  int? is_underInvestigation;
  String? place_of_death;
  String? date_of_death;
  String? marital_status;
  int? waiting_period;
  int? waiting_period_type;

  Claim(
    this.index,
    this.date,
    this.customerName,
    this.policyNumber,
    this.synopsisStatus,
    this.claimStatus,
    this.referenceNumber,
    this.collection_status,
    this.claim_id,
    this.claim_onololeadid,
    this.cam_autonunber,
    this.claim_amount,
    this.claim_client_id,
    this.branch_id,
    this.claim_client_email,
    this.policy_num,
    this.policy_status,
    this.policy_reference,
    this.policy_life,
    this.claim_cell_number,
    this.claim_title,
    this.claim_first_name,
    this.claim_last_name,
    this.claim_id_num,
    this.claim_dob,
    this.death_type,
    this.claim_status,
    this.claim_status_description,
    this.claim_assigned_to,
    this.synopsis_status,
    this.policy_synopsis_res,
    this.member_synopsis,
    this.member_synopsis_reason,
    this.claim_hang_up_reason,
    this.claim_hang_up_desc1,
    this.claim_hang_up_desc2,
    this.claim_hang_up_desc3,
    this.claim_notes,
    this.branch_leader_notes,
    this.assessor_notes,
    this.risk_notes,
    this.claim_call_count,
    this.claim_call_attempt,
    this.claim_call_time_ellapsed,
    this.claim_date,
    this.claim_last_update,
    this.claim_type,
    this.claim_reference,
    this.claim_created_by,
    this.pay_or_service_rendered,
    this.paymt_or_service_Date,
    this.pay_or_service_reference,
    this.claim_complete_date,
    this.last_position,
    this.last_position_tab,
    this.is_suicide,
    this.is_underInvestigation,
    this.place_of_death,
    this.date_of_death,
    this.marital_status,
    this.waiting_period,
    this.waiting_period_type,
  );

  static Claim parseClaim(Map<String, dynamic> data) {
    // Helper function to parse integers from possibly String values
    int? parseInt(dynamic value) =>
        value is int ? value : (value is String ? int.tryParse(value) : null);

    // Helper function to parse doubles from possibly String values
    double? parseDouble(dynamic value) => value is double
        ? value
        : (value is String ? double.tryParse(value) : null);

    return Claim(
      data["index"] ?? 0,
      data["date"] ?? "-",
      data["customerName"] ?? "Unknown",
      data["policyNumber"] ?? "No policy number",
      data["synopsisStatus"] ?? "No synopsis status",
      data["claimStatus"] ?? "",
      data["referenceNumber"] ?? "",
      data["collection_status"],
      parseInt(data["claim_id"]) ?? 0,
      parseInt(data["claim_onololeadid"]),
      parseInt(data["cam_autonunber"]),
      parseDouble(data["claim_amount"]),
      parseInt(data["claim_client_id"]),
      parseInt(data["branch_id"]),
      data["claim_client_email"],
      data["policy_num"],
      data["policy_status"],
      data["policy_reference"],
      data["policy_life"],
      data["claim_cell_number"],
      data["claim_title"],
      data["claim_first_name"],
      data["claim_last_name"],
      data["claim_id_num"],
      data["claim_dob"],
      data["death_type"],
      data["claim_status"],
      data["claim_status_description"],
      parseInt(data["claim_assigned_to"]),
      data["synopsis_status"],
      data["policy_synopsis_res"],
      data["member_synopsis"],
      data["member_synopsis_reason"],
      data["claim_hang_up_reason"],
      data["claim_hang_up_desc1"],
      data["claim_hang_up_desc2"],
      data["claim_hang_up_desc3"],
      data["claim_notes"],
      data["branch_leader_notes"],
      data["assessor_notes"],
      data["risk_notes"],
      parseInt(data["claim_call_count"] ?? "0"),
      parseInt(data["claim_call_attempt"] ?? "0"),
      data["claim_call_time_ellapsed"],
      data["claim_date"],
      data["claim_last_update"],
      data["claim_type"],
      data["claim_reference"],
      parseInt(data["claim_created_by"]),
      parseInt(data["pay_or_service_rendered"]),
      data["paymt_or_service_Date"],
      data["pay_or_service_reference"],
      data["claim_complete_date"],
      data["last_position"],
      parseInt(data["last_position_tab"]),
      parseInt(data["is_suicide"]),
      parseInt(data["is_underInvestigation"]),
      data["place_of_death"],
      data["date_of_death"],
      data["marital_status"],
      data["waiting_period"],
      data["waiting_period_type"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'date': date,
      'customerName': customerName,
      'policyNumber': policyNumber,
      'synopsisStatus': synopsisStatus,
      'claimStatus': claimStatus,
      'referenceNumber': referenceNumber,
      'collection_status': collection_status,
      'claim_id': claim_id,
      'claim_onololeadid': claim_onololeadid,
      'cam_autonunber': cam_autonunber,
      'claim_amount': claim_amount,
      'claim_client_id': claim_client_id,
      'branch_id': branch_id,
      'claim_client_email': claim_client_email,
      'policy_num': policy_num,
      'policy_status': policy_status,
      'policy_reference': policy_reference,
      'policy_life': policy_life,
      'claim_cell_number': claim_cell_number,
      'claim_title': claim_title,
      'claim_first_name': claim_first_name,
      'claim_last_name': claim_last_name,
      'claim_id_num': claim_id_num,
      'claim_dob': claim_dob,
      'death_type': death_type,
      'claim_status': claim_status,
      'claim_status_description': claim_status_description,
      'claim_assigned_to': claim_assigned_to,
      'synopsis_status': synopsis_status,
      'policy_synopsis_res': policy_synopsis_res,
      'member_synopsis': member_synopsis,
      'member_synopsis_reason': member_synopsis_reason,
      'claim_hang_up_reason': claim_hang_up_reason,
      'claim_hang_up_desc1': claim_hang_up_desc1,
      'claim_hang_up_desc2': claim_hang_up_desc2,
      'claim_hang_up_desc3': claim_hang_up_desc3,
      'claim_notes': claim_notes,
      'branch_leader_notes': branch_leader_notes,
      'assessor_notes': assessor_notes,
      'risk_notes': risk_notes,
      'claim_call_count': claim_call_count,
      'claim_call_attempt': claim_call_attempt,
      'claim_call_time_ellapsed': claim_call_time_ellapsed,
      'claim_date': claim_date,
      'claim_last_update': claim_last_update,
      'claim_type': claim_type,
      'claim_reference': claim_reference,
      'claim_created_by': claim_created_by,
      'pay_or_service_rendered': pay_or_service_rendered,
      'paymt_or_service_Date': paymt_or_service_Date,
      'pay_or_service_reference': pay_or_service_reference,
      'claim_complete_date': claim_complete_date,
      'last_position': last_position,
      'last_position_tab': last_position_tab,
      'is_suicide': is_suicide,
      'is_underInvestigation': is_underInvestigation,
      'place_of_death': place_of_death,
      'date_of_death': date_of_death,
      'marital_status': marital_status,
      'waiting_period': waiting_period,
      'waiting_period_type': waiting_period_type,
    };
  }
}

class MainTable {
  int index;
  String customerName;
  String referenceNumber;

  MainTable(this.index, this.customerName, this.referenceNumber);
}

class ClaimsPeriod {
  String name;
  int period;

  ClaimsPeriod(this.name, this.period);
}

class SalesPeriod {
  String name;
  double period;

  SalesPeriod(this.name, this.period);
}

class ClaimsPeriod2 {
  String name;
  int period;

  ClaimsPeriod2(this.name, this.period);
}

class ClaimsPeriod1 {
  String name;
  int period;

  ClaimsPeriod1(
    this.name,
    this.period,
  );
}

class CircularGraphDetails {
  String description;
  Widget circularGraph;

  CircularGraphDetails(this.description, this.circularGraph);
}

/// Flutter code sample for [showTimePicker].

class ShowTimePickerApp extends StatefulWidget {
  const ShowTimePickerApp({super.key});

  @override
  State<ShowTimePickerApp> createState() => _ShowTimePickerAppState();
}

class _ShowTimePickerAppState extends State<ShowTimePickerApp> {
  ThemeMode themeMode = ThemeMode.dark;
  bool useMaterial3 = true;

  void setThemeMode(ThemeMode mode) {
    setState(() {
      themeMode = mode;
    });
  }

  void setUseMaterial3(bool? value) {
    setState(() {
      useMaterial3 = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: useMaterial3),
      darkTheme: ThemeData.dark(useMaterial3: useMaterial3),
      themeMode: themeMode,
      home: TimePickerOptions(
        themeMode: themeMode,
        useMaterial3: useMaterial3,
        setThemeMode: setThemeMode,
        setUseMaterial3: setUseMaterial3,
      ),
    );
  }
}

class TimePickerOptions extends StatefulWidget {
  const TimePickerOptions({
    super.key,
    required this.themeMode,
    required this.useMaterial3,
    required this.setThemeMode,
    required this.setUseMaterial3,
  });

  final ThemeMode themeMode;
  final bool useMaterial3;
  final ValueChanged<ThemeMode> setThemeMode;
  final ValueChanged<bool?> setUseMaterial3;

  @override
  State<TimePickerOptions> createState() => _TimePickerOptionsState();
}

class _TimePickerOptionsState extends State<TimePickerOptions> {
  TimeOfDay? selectedTime;
  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  Orientation? orientation;
  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  bool use24HourTime = false;

  void _entryModeChanged(TimePickerEntryMode? value) {
    if (value != entryMode) {
      setState(() {
        entryMode = value!;
      });
    }
  }

  void _orientationChanged(Orientation? value) {
    if (value != orientation) {
      setState(() {
        orientation = value;
      });
    }
  }

  void _textDirectionChanged(TextDirection? value) {
    if (value != textDirection) {
      setState(() {
        textDirection = value!;
      });
    }
  }

  void _tapTargetSizeChanged(MaterialTapTargetSize? value) {
    if (value != tapTargetSize) {
      setState(() {
        tapTargetSize = value!;
      });
    }
  }

  void _use24HourTimeChanged(bool? value) {
    if (value != use24HourTime) {
      setState(() {
        use24HourTime = value!;
      });
    }
  }

  void _themeModeChanged(ThemeMode? value) {
    widget.setThemeMode(value!);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Expanded(
            child: GridView(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 350,
                mainAxisSpacing: 4,
                // ignore: deprecated_member_use, https://github.com/flutter/flutter/issues/128825
                mainAxisExtent:
                    200 * MediaQuery.textScalerOf(context).textScaleFactor,
                crossAxisSpacing: 4,
              ),
              children: <Widget>[
                EnumCard<TimePickerEntryMode>(
                  choices: TimePickerEntryMode.values,
                  value: entryMode,
                  onChanged: _entryModeChanged,
                ),
                EnumCard<ThemeMode>(
                  choices: ThemeMode.values,
                  value: widget.themeMode,
                  onChanged: _themeModeChanged,
                ),
                EnumCard<TextDirection>(
                  choices: TextDirection.values,
                  value: textDirection,
                  onChanged: _textDirectionChanged,
                ),
                EnumCard<MaterialTapTargetSize>(
                  choices: MaterialTapTargetSize.values,
                  value: tapTargetSize,
                  onChanged: _tapTargetSizeChanged,
                ),
                ChoiceCard<Orientation?>(
                  choices: const <Orientation?>[...Orientation.values, null],
                  value: orientation,
                  title: '$Orientation',
                  choiceLabels: <Orientation?, String>{
                    for (final Orientation choice in Orientation.values)
                      choice: choice.name,
                    null: 'from MediaQuery',
                  },
                  onChanged: _orientationChanged,
                ),
                ChoiceCard<bool>(
                  choices: const <bool>[false, true],
                  value: use24HourTime,
                  onChanged: _use24HourTimeChanged,
                  title: 'Time Mode',
                  choiceLabels: const <bool, String>{
                    false: '12-hour am/pm time',
                    true: '24-hour time',
                  },
                ),
                ChoiceCard<bool>(
                  choices: const <bool>[false, true],
                  value: widget.useMaterial3,
                  onChanged: widget.setUseMaterial3,
                  title: 'Material Version',
                  choiceLabels: const <bool, String>{
                    false: 'Material 2',
                    true: 'Material 3',
                  },
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    child: const Text('Open time picker'),
                    onPressed: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: selectedTime ?? TimeOfDay.now(),
                        initialEntryMode: entryMode,
                        orientation: orientation,
                        builder: (BuildContext context, Widget? child) {
                          // We just wrap these environmental changes around the
                          // child in this builder so that we can apply the
                          // options selected above. In regular usage, this is
                          // rarely necessary, because the default values are
                          // usually used as-is.
                          return Theme(
                            data: Theme.of(context).copyWith(
                              materialTapTargetSize: tapTargetSize,
                            ),
                            child: Directionality(
                              textDirection: textDirection,
                              child: MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                  alwaysUse24HourFormat: use24HourTime,
                                ),
                                child: child!,
                              ),
                            ),
                          );
                        },
                      );
                      setState(() {
                        selectedTime = time;
                      });
                    },
                  ),
                ),
                if (selectedTime != null)
                  Text('Selected time: ${selectedTime!.format(context)}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// This is a simple card that presents a set of radio buttons (inside of a
// RadioSelection, defined below) for the user to select from.
class ChoiceCard<T extends Object?> extends StatelessWidget {
  const ChoiceCard({
    super.key,
    required this.value,
    required this.choices,
    required this.onChanged,
    required this.choiceLabels,
    required this.title,
  });

  final T value;
  final Iterable<T> choices;
  final Map<T, String> choiceLabels;
  final String title;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      // If the card gets too small, let it scroll both directions.
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title),
                ),
                for (final T choice in choices)
                  RadioSelection<T>(
                    value: choice,
                    groupValue: value,
                    onChanged: onChanged,
                    child: Text(choiceLabels[choice]!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// This aggregates a ChoiceCard so that it presents a set of radio buttons for
// the allowed enum values for the user to select from.
class EnumCard<T extends Enum> extends StatelessWidget {
  const EnumCard({
    super.key,
    required this.value,
    required this.choices,
    required this.onChanged,
  });

  final T value;
  final Iterable<T> choices;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return ChoiceCard<T>(
        value: value,
        choices: choices,
        onChanged: onChanged,
        choiceLabels: <T, String>{
          for (final T choice in choices) choice: choice.name,
        },
        title: value.runtimeType.toString());
  }
}

// A button that has a radio button on one side and a label child. Tapping on
// the label or the radio button selects the item.
class RadioSelection<T extends Object?> extends StatefulWidget {
  const RadioSelection({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.child,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final Widget child;

  @override
  State<RadioSelection<T>> createState() => _RadioSelectionState<T>();
}

class _RadioSelectionState<T extends Object?> extends State<RadioSelection<T>> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 8),
          child: Radio<T>(
            groupValue: widget.groupValue,
            value: widget.value,
            onChanged: widget.onChanged,
          ),
        ),
        GestureDetector(
            onTap: () => widget.onChanged(widget.value), child: widget.child),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TimeOfDay _time = const TimeOfDay(hour: 7, minute: 15);

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _selectTime,
              child: const Text('SELECT TIME'),
            ),
            const SizedBox(height: 8),
            Text(
              'Selected time: ${_time.format(context)}',
            ),
          ],
        ),
      ),
    );
  }
}

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    hintColor: shrineBrown900,
    primaryColor: shrinePink100,
    scaffoldBackgroundColor: shrineBackgroundWhite,
    cardColor: shrineBackgroundWhite,
    //textSelectionColor: shrinePink100,
    buttonTheme: const ButtonThemeData(
      colorScheme: _shrineColorScheme,
      textTheme: ButtonTextTheme.normal,
    ),
    primaryIconTheme: _customIconTheme(base.iconTheme),
    textTheme: _buildShrineTextTheme(base.textTheme),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    iconTheme: _customIconTheme(base.iconTheme),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return shrinePink400;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return shrinePink400;
        }
        return null;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return shrinePink400;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return shrinePink400;
        }
        return null;
      }),
    ),
    colorScheme: _shrineColorScheme.copyWith(error: shrineErrorRed),
  );
}

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: shrineBrown900);
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
        bodySmall: base.bodySmall?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
        labelLarge: base.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        displayColor: shrineBrown900,
        bodyColor: shrineBrown900,
      );
}

const ColorScheme _shrineColorScheme = ColorScheme(
  primary: shrinePink400,
  secondary: shrinePink50,
  surface: shrineSurfaceWhite,
  background: shrineBackgroundWhite,
  error: shrineErrorRed,
  onPrimary: shrineBrown900,
  onSecondary: shrineBrown900,
  onSurface: shrineBrown900,
  onBackground: shrineBrown900,
  onError: shrineSurfaceWhite,
  brightness: Brightness.light,
);

const Color shrinePink50 = Color(0xFFFEEAE6);
const Color shrinePink100 = Color(0xFFFEDBD0);
const Color shrinePink300 = Color(0xFFFBB8AC);
const Color shrinePink400 = Color(0xFFEAA4A4);

const Color shrineBrown900 = Color(0xFF442B2D);
const Color shrineBrown600 = Color(0xFF7D4F52);

const Color shrineErrorRed = Color(0xFFC5032B);

const Color shrineSurfaceWhite = Color(0xFFFFFBFA);
const Color shrineBackgroundWhite = Colors.white;

const defaultLetterSpacing = 0.03;

class YesOrNoDialogue {
  String stringValue;
  bool stateValue;

  YesOrNoDialogue({required this.stringValue, this.stateValue = false});
}

class Policy {
  String reference;
  List<dynamic> members; // Assuming members is a list of dynamic objects
  PremiumPayer premiumPayer;
  Quote quote;
  List<dynamic>? riders;
  dynamic addresses;
  dynamic employer;
  dynamic paymentItem;
  dynamic membersOld;
  dynamic ridersOld;
  dynamic premiumPayerOld;
  dynamic subscheme;
  dynamic policySchedule;
  dynamic policyScheduleViews;

  Policy({
    required this.reference,
    required this.members,
    required this.premiumPayer,
    required this.quote,
    this.riders,
    this.addresses,
    this.employer,
    this.paymentItem,
    this.membersOld,
    this.ridersOld,
    this.premiumPayerOld,
    this.subscheme,
    this.policySchedule,
    this.policyScheduleViews,
  });

  factory Policy.fromJson(Map<String, dynamic> json) {
    print("fgfgffg0 $json");
    return Policy(
      reference: json['reference'] ?? '',
      members: json['members'] ?? [],
      premiumPayer: PremiumPayer.fromJson(json['premiumPayer']),
      quote: Quote.fromJson(json['qoute']),
      riders: json['riders'],
      addresses: json['addresses'],
      employer: json['employer'],
      paymentItem: json['payment_item'],
      membersOld: json['members_old'],
      ridersOld: json['riders_old'],
      premiumPayerOld: json['premiumPayer_old'],
      subscheme: json['subscheme'],
      policySchedule: json['policySchedule'],
      policyScheduleViews: json['policyScheduleViews'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'members': members,
      'premiumPayer': premiumPayer.toJson(),
      'qoute': quote.toJson(),
      'riders': riders,
      'addresses': addresses,
      'employer': employer,
      'payment_item': paymentItem,
      'members_old': membersOld,
      'riders_old': ridersOld,
      'premiumPayer_old': premiumPayerOld,
      'subscheme': subscheme,
      'policySchedule': policySchedule,
      'policyScheduleViews': policyScheduleViews,
    };
  }
}

class Product {
  Product(this.product, this.productType, this.count);

  final String product;
  final String productType;
  final int count;
}

class ParlourRatesExtras {
  ParlourRatesExtras(
    this.id,
    this.product,
    this.prod_type,
    this.amount,
    this.premium,
    this.min_age,
    this.max_age,
    this.spouse,
    this.children,
    this.parents,
    this.extended,
    this.parents_and_extended,
    this.extra_members_allowed,
    this.maximum_members,
    this.timestamp,
    this.last_update,
    this.is_active,
  );

  final String id;
  final String product;
  final String prod_type;
  final double amount;
  final double premium;
  final int min_age;
  final int max_age;
  final int spouse;
  final int children;
  final int parents;
  final int extended;
  final int parents_and_extended;
  final int extra_members_allowed;
  final int maximum_members;
  final String timestamp;
  final String last_update;
  final bool is_active;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParlourRatesExtras &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class ParlourRatesExtras2 {
  ParlourRatesExtras2(
    this.product,
    this.prod_type,
  );

  final String product;
  final String prod_type;
}
