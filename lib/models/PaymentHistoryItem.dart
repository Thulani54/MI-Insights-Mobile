class PaymentHistoryItem {
  final String payment_date;
  final String collection_date;
  final String amount;
  final String status;
  final String policy_number;
  final double collected_premium;
  final String pos_transaction_id;
  final bool acceptTerms;
  final int emp_id;
  final String employee_name;
  final String employee_surname;
  final String employee_number;
  PaymentHistoryItem({
    required this.payment_date,
    required this.amount,
    required this.status,
    required this.collection_date,
    required this.policy_number,
    required this.pos_transaction_id,
    required this.collected_premium,
    required this.acceptTerms,
    required this.emp_id,
    required this.employee_name,
    required this.employee_surname,
    required this.employee_number,
  });
  toJson() {
    return {
      "payment_date": payment_date,
      "amount": amount,
      "status": status,
      "collection_date": collection_date,
      "collected_premium": collected_premium,
      "policy_number": policy_number,
      "pos_transaction_id": pos_transaction_id,
      "policy_number": policy_number,
      "emp_id": emp_id,
      "employee_name": employee_name,
      "employee_surname": employee_surname,
      "employee_number": employee_number,
    };
  }
}

class ReprintHistoryItem {
  final String payment_date;
  final String collection_date;
  final String amount;
  final String status;
  final bool is_printed;
  final String policy_number;
  final String pos_transaction_id;
  final bool acceptTerms;
  ReprintHistoryItem({
    required this.payment_date,
    required this.amount,
    required this.is_printed,
    required this.status,
    required this.collection_date,
    required this.policy_number,
    required this.pos_transaction_id,
    required this.acceptTerms,
  });
  toJson() {
    return {
      "payment_date": payment_date,
      "amount": amount,
      "status": status,
      "collection_date": collection_date,
      "policy_number": policy_number,
      "pos_transaction_id": pos_transaction_id,
      "policy_number": policy_number,
    };
  }
}
