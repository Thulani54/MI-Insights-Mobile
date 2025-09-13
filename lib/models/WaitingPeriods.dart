class ProductWaitingPeriod {
  final String id;
  final String productFamily;
  final String productName;
  final int waitingPeriod;
  final String type;
  final String companyName;
  final String deathType;

  ProductWaitingPeriod({
    required this.id,
    required this.productFamily,
    required this.productName,
    required this.waitingPeriod,
    required this.type,
    required this.companyName,
    required this.deathType,
  });

  factory ProductWaitingPeriod.fromJson(Map<String, dynamic> json) {
    return ProductWaitingPeriod(
      id: (json['id']).toString(),
      productFamily: json['product_family'],
      productName: json['product_name'],
      waitingPeriod: json['waiting_period'],
      type: json['type'],
      companyName: json['company_name'],
      deathType: ((json['death_type'] ?? 0).toString()) == "1"
          ? 'Natural'
          : ((json['death_type'] ?? 0).toString()) == "2"
              ? 'Accidental'
              : ((json['death_type'] ?? 0).toString()) == "3"
                  ? 'Suicide'
                  : ((json['death_type'] ?? 0).toString()) == "4"
                      ? 'Unnatural'
                      : ((json['death_type'] ?? 0).toString()) == "1"
                          ? 'Natural'
                          : "Natural",
    );
  }
}
