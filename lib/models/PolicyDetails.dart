class PolicyDetails {
  String policyNumber;
  String planType;
  String status;
  String inceptionDate;
  String inforce_date;
  String customer_id_number;
  String customer_first_name;
  String customer_last_name;
  String customer_contact;

  int monthsToPayFor;
  String paymentStatus;
  int paymentsBehind;
  double monthlyPremium;
  double benefitAmount;
  bool acceptTerms;

  PolicyDetails({
    required this.policyNumber,
    required this.planType,
    required this.status,
    required this.monthsToPayFor,
    required this.paymentStatus,
    required this.paymentsBehind,
    required this.monthlyPremium,
    required this.benefitAmount,
    required this.customer_id_number,
    required this.customer_first_name,
    required this.customer_last_name,
    required this.customer_contact,
    required this.acceptTerms,
    required this.inforce_date,
    required this.inceptionDate,
  });

  toJson() {
    return {
      "policyNumber": policyNumber,
      "planType": planType,
      "status": status,
      "monthlyPremium": monthlyPremium,
      "monthsToPayFor": monthsToPayFor,
      "customer_id_number": customer_id_number,
      "customer_first_name": customer_first_name,
      "customer_last_name": customer_last_name,
      "customer_contact": customer_contact,
      "paymentStatus": paymentStatus,
      "paymentsBehind": paymentsBehind,
      "benefitAmount": benefitAmount,
      "inceptionDate": inceptionDate,
    };
  }
}

class PolicyDetails1 {
  String policyNumber;
  String planType;
  String status;
  String inceptionDate;
  String customer_id_number;
  String customer_first_name;
  String customer_last_name;
  String customer_contact;
  int monthsToPayFor;
  String paymentStatus;
  String paymentDate;
  int paymentsBehind;
  double monthlyPremium;
  double benefitAmount;
  bool acceptTerms;
  String payment_method;
  String pos_transaction_id;
  String collection_date;

  PolicyDetails1({
    required this.policyNumber,
    required this.planType,
    required this.status,
    required this.monthsToPayFor,
    required this.paymentStatus,
    required this.paymentsBehind,
    required this.monthlyPremium,
    required this.benefitAmount,
    required this.customer_id_number,
    required this.customer_first_name,
    required this.customer_last_name,
    required this.customer_contact,
    required this.acceptTerms,
    required this.inceptionDate,
    required this.paymentDate,
    required this.payment_method,
    required this.collection_date,
    required this.pos_transaction_id,
  });

  toJson() {
    return {
      "policyNumber": policyNumber,
      "planType": planType,
      "status": status,
      "monthlyPremium": monthlyPremium,
      "monthsToPayFor": monthsToPayFor,
      "customer_id_number": customer_id_number,
      "customer_first_name": customer_first_name,
      "customer_last_name": customer_last_name,
      "customer_contact": customer_contact,
      "paymentStatus": paymentStatus,
      "paymentsBehind": paymentsBehind,
      "benefitAmount": benefitAmount,
      "inceptionDate": inceptionDate,
      "paymentDate": paymentDate,
      "payment_method": payment_method,
      "collection_date": collection_date,
      "pos_transaction_id": pos_transaction_id,
    };
  }
}
