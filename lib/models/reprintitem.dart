class ReprintItem {
  final int id;
  final String policy_number;
  final int authorizer_emp_id;
  final String transaction_date;
  final String client_name;
  final String collected_amount;
  final String processed_by;
  final String employee_number;
  final String employee_name;
  final String branch;
  final bool is_printed;
  final String print_code;
  final String reason_for_request;
  final String? decline_reason; // Nullable field
  final String status;
  final String timestamp;
  final String transaction_id;
  final int cec_client_id;
  final int emp_id;

  ReprintItem({
    required this.id,
    required this.policy_number,
    required this.authorizer_emp_id,
    required this.transaction_date,
    required this.client_name,
    required this.collected_amount,
    required this.processed_by,
    required this.employee_number,
    required this.employee_name,
    required this.branch,
    required this.is_printed,
    required this.print_code,
    required this.reason_for_request,
    this.decline_reason, // Nullable field
    required this.status,
    required this.timestamp,
    required this.transaction_id,
    required this.cec_client_id,
    required this.emp_id,
  });

  // Factory constructor to create a ReprintItem from a JSON map
  factory ReprintItem.fromJson(Map<String, dynamic> json) {
    return ReprintItem(
      id: json['id'],
      policy_number: json['policy_number'],
      authorizer_emp_id: json['authorizer_emp_id'],
      transaction_date: json['transaction_date'],
      client_name: json['client_name'],
      collected_amount: json['collected_amount'].toString(),
      processed_by: json['processed_by'],
      employee_number: json['employee_number'] ?? '',
      employee_name: json['employee_name'] ?? '',
      branch: json['branch'] ?? '',
      is_printed: json['is_printed'],
      print_code: json['print_code'] ?? '',
      reason_for_request: json['reason_for_request'] ?? '',
      decline_reason: json['decline_reason'], // Nullable field
      status: json['status'],
      timestamp: json['timestamp'],
      transaction_id: json['transaction_id'],
      cec_client_id: json['cec_client_id'],
      emp_id: json['emp_id'],
    );
  }

  // Convert ReprintItem to a JSON map
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "policy_number": policy_number,
      "authorizer_emp_id": authorizer_emp_id,
      "transaction_date": transaction_date,
      "client_name": client_name,
      "collected_amount": collected_amount,
      "processed_by": processed_by,
      "employee_number": employee_number,
      "employee_name": employee_name,
      "branch": branch,
      "is_printed": is_printed,
      "print_code": print_code,
      "reason_for_request": reason_for_request,
      "decline_reason": decline_reason, // Nullable field
      "status": status,
      "timestamp": timestamp,
      "transaction_id": transaction_id,
      "cec_client_id": cec_client_id,
      "emp_id": emp_id,
    };
  }

  @override
  String toString() {
    return 'ReprintItem(id: $id, policy_number: $policy_number, authorizer_emp_id: $authorizer_emp_id, transaction_date: $transaction_date, client_name: $client_name, collected_amount: $collected_amount, processed_by: $processed_by, employee_number: $employee_number, employee_name: $employee_name, branch: $branch, is_printed: $is_printed, print_code: $print_code, reason_for_request: $reason_for_request, decline_reason: $decline_reason, status: $status, timestamp: $timestamp, transaction_id: $transaction_id, cec_client_id: $cec_client_id, emp_id: $emp_id)';
  }
}
