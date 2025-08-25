class Sale {
  final dynamic extPolicyNumber;
  final String saleDatetime;
  final String saleTime;
  final int branchId;
  final int onololeadId;
  final String title;
  final String firstName;
  final String lastName;
  final String leadStatus;
  final int assignedTo;
  final String customerIdNumber;
  final String hangUpReason;
  final dynamic callBackDate;
  final dynamic callBackTime;
  final String saleDate;
  final String timestamp;
  final String cellNumber;
  final String reference;
  final double totalAmountPayable;
  final String prodDescription;
  final String productType;
  final String policyNumber;
  final String quoteStatus;
  final String inforceDate;
  final int inforcedBy;
  final String acceptPolicy;
  final String lastUpdate;
  final String mipDescription;
  final String cecEmployeeName;
  final dynamic qaDoneBy;
  final dynamic qaStatus;
  final dynamic qaScore;
  final dynamic qaStartDate;
  final dynamic qaEndDate;
  final dynamic verificationDoneBy;
  final dynamic verificationScore;
  final dynamic verificationStatus;
  final dynamic verificationStartDate;
  final dynamic verificationEndDate;
  final dynamic verificationHangUpReason;
  final dynamic verificationDataError;

  Sale({
    required this.extPolicyNumber,
    required this.saleDatetime,
    required this.saleTime,
    required this.branchId,
    required this.onololeadId,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.leadStatus,
    required this.assignedTo,
    required this.customerIdNumber,
    required this.hangUpReason,
    required this.callBackDate,
    required this.callBackTime,
    required this.saleDate,
    required this.timestamp,
    required this.cellNumber,
    required this.reference,
    required this.totalAmountPayable,
    required this.prodDescription,
    required this.productType,
    required this.policyNumber,
    required this.quoteStatus,
    required this.inforceDate,
    required this.inforcedBy,
    required this.acceptPolicy,
    required this.lastUpdate,
    required this.mipDescription,
    required this.cecEmployeeName,
    required this.qaDoneBy,
    required this.qaStatus,
    required this.qaScore,
    required this.qaStartDate,
    required this.qaEndDate,
    required this.verificationDoneBy,
    required this.verificationScore,
    required this.verificationStatus,
    required this.verificationStartDate,
    required this.verificationEndDate,
    required this.verificationHangUpReason,
    required this.verificationDataError,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      extPolicyNumber: json['ext_policy_number'],
      saleDatetime: json['sale_datetime'],
      saleTime: json['sale_time'],
      branchId: json['branch_id'],
      onololeadId: json['onololeadid'],
      title: json['title'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      leadStatus: json['lead_status'],
      assignedTo: json['assigned_to'],
      customerIdNumber: json['customer_id_number'],
      hangUpReason: json['hang_up_reason'],
      callBackDate: json['call_back_date'],
      callBackTime: json['call_back_time'],
      saleDate: json['sale_date'],
      timestamp: json['timestamp'],
      cellNumber: json['cell_number'],
      reference: json['reference'],
      totalAmountPayable: json['totalAmountPayable'],
      prodDescription: json['prod_description'],
      productType: json['product_type'],
      policyNumber: json['policy_number'],
      quoteStatus: json['quote_status'],
      inforceDate: json['inforce_date'],
      inforcedBy: json['inforced_by'],
      acceptPolicy: json['accept_policy'],
      lastUpdate: json['last_update'],
      mipDescription: json['mip_description'],
      cecEmployeeName: json['cec_employee_name'],
      qaDoneBy: json['qa_done_by'],
      qaStatus: json['qa_status'],
      qaScore: json['qa_score'],
      qaStartDate: json['qa_start_date'],
      qaEndDate: json['qa_end_date'],
      verificationDoneBy: json['verification_done_by'],
      verificationScore: json['verification_score'],
      verificationStatus: json['verification_status'],
      verificationStartDate: json['verification_start_date'],
      verificationEndDate: json['verification_end_date'],
      verificationHangUpReason: json['verification_hang_up_reason'],
      verificationDataError: json['verification_data_error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ext_policy_number': extPolicyNumber,
      'sale_datetime': saleDatetime,
      'sale_time': saleTime,
      'branch_id': branchId,
      'onololeadid': onololeadId,
      'title': title,
      'first_name': firstName,
      'last_name': lastName,
      'lead_status': leadStatus,
      'assigned_to': assignedTo,
      'customer_id_number': customerIdNumber,
      'hang_up_reason': hangUpReason,
      'call_back_date': callBackDate,
      'call_back_time': callBackTime,
      'sale_date': saleDate,
      'timestamp': timestamp,
      'cell_number': cellNumber,
      'reference': reference,
      'totalAmountPayable': totalAmountPayable,
      'prod_description': prodDescription,
      'product_type': productType,
      'policy_number': policyNumber,
      'quote_status': quoteStatus,
      'inforce_date': inforceDate,
      'inforced_by': inforcedBy,
      'accept_policy': acceptPolicy,
      'last_update': lastUpdate,
      'mip_description': mipDescription,
      'cec_employee_name': cecEmployeeName,
      'qa_done_by': qaDoneBy,
      'qa_status': qaStatus,
      'qa_score': qaScore,
      'qa_start_date': qaStartDate,
      'qa_end_date': qaEndDate,
      'verification_done_by': verificationDoneBy,
      'verification_score': verificationScore,
      'verification_status': verificationStatus,
      'verification_start_date': verificationStartDate,
      'verification_end_date': verificationEndDate,
      'verification_hang_up_reason': verificationHangUpReason,
      'verification_data_error': verificationDataError,
    };
  }
}
