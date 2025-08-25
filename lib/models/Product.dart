class Product {
  Product(this.product, this.productType, this.count);

  final String product;
  final String productType;
  final int count;
}

class ParlourRatesExtras3 {
  ParlourRatesExtras3(
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
      other is ParlourRatesExtras3 &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class ParlourRatesExtras2a {
  ParlourRatesExtras2a(
    this.product,
    this.prod_type,
  );
  final String product;
  final String prod_type;
}
