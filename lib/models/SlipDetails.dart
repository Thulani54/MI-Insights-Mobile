class SlipDetails {
  String policyNumber;
  String planType;
  String status;
  int monthsToPayFor;
  String paymentStatus;
  int paymentsBehind;
  double monthlyPremium;
  double benefitAmount;

  SlipDetails({
    required this.policyNumber,
    required this.planType,
    required this.status,
    required this.monthsToPayFor,
    required this.paymentStatus,
    required this.paymentsBehind,
    required this.monthlyPremium,
    required this.benefitAmount,
  });
}
