class POSPaymentSlipReprintRequest {
  final int id;
  final String policyNumber;
  final int authorizerEmpId;
  final DateTime transactionDate;
  final String clientName;
  final double collectedAmount;
  final String processedBy;
  final String employeeNumber;
  final String employeeName;
  final String branch;
  final bool isPrinted;
  final String printCode;
  final String reasonForRequest;
  final String? declineReason;
  final String status;
  final int cecClientId;
  final DateTime timestamp;
  final String transactionId;
  final int empId;

  POSPaymentSlipReprintRequest({
    required this.id,
    required this.policyNumber,
    required this.authorizerEmpId,
    required this.transactionDate,
    required this.clientName,
    required this.collectedAmount,
    required this.processedBy,
    required this.employeeNumber,
    required this.employeeName,
    required this.branch,
    required this.isPrinted,
    required this.printCode,
    required this.reasonForRequest,
    this.declineReason,
    required this.status,
    required this.cecClientId,
    required this.timestamp,
    required this.transactionId,
    required this.empId,
  });

  // Factory method to create an instance of the class from JSON
  factory POSPaymentSlipReprintRequest.fromJson(Map<String, dynamic> json) {
    return POSPaymentSlipReprintRequest(
      id: json['id'],
      policyNumber: json['policy_number'],
      authorizerEmpId: json['authorizer_emp_id'],
      transactionDate: DateTime.parse(json['transaction_date']),
      clientName: json['client_name'],
      collectedAmount: double.parse(json['collected_amount']),
      processedBy: json['processed_by'],
      employeeNumber: json['employee_number'],
      employeeName: json['employee_name'],
      branch: json['branch'],
      isPrinted: json['is_printed'],
      printCode: json['print_code'],
      reasonForRequest: json['reason_for_request'],
      declineReason: json['decline_reason'] ?? "",
      status: json['status'],
      cecClientId: json['cec_client_id'],
      timestamp: DateTime.parse(json['timestamp']),
      transactionId: json['transaction_id'],
      empId: json['emp_id'],
    );
  }

  // Method to convert the class instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'policy_number': policyNumber,
      'authorizer_emp_id': authorizerEmpId,
      'transaction_date': transactionDate.toIso8601String(),
      'client_name': clientName,
      'collected_amount': collectedAmount.toString(),
      'processed_by': processedBy,
      'employee_number': employeeNumber,
      'employee_name': employeeName,
      'branch': branch,
      'is_printed': isPrinted,
      'print_code': printCode,
      'reason_for_request': reasonForRequest,
      'decline_reason': declineReason,
      'status': status,
      'cec_client_id': cecClientId,
      'timestamp': timestamp.toIso8601String(),
      'transaction_id': transactionId,
      'emp_id': empId,
    };
  }
}
