// Main Model
import 'package:flutter/material.dart';

import '../Constants/constants.dart';
import '../customwidgets/CustomCard.dart';
import '../screens/Sales Agent/field_premium_calculator.dart';

class ParlourConfig {
  final List<ExtendedMemberRate> extendedMemberRates;
  final List<JoiningFee> joiningFee;
  final List<MainRate> mainRates;
  final Map<String, ProductPitch> productPitch;

  ParlourConfig({
    required this.extendedMemberRates,
    required this.joiningFee,
    required this.mainRates,
    required this.productPitch,
  });

  factory ParlourConfig.fromJson(Map<String, dynamic> json) {
    return ParlourConfig(
      extendedMemberRates: json['extended_member_rates'] != null
          ? (json['extended_member_rates'] as List)
              .map(
                  (e) => ExtendedMemberRate.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      joiningFee: json['joining_fee'] != null
          ? (json['joining_fee'] as List)
              .map((e) => JoiningFee.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      mainRates: json['main_rates'] != null
          ? (json['main_rates'] as List)
              .map((e) => MainRate.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      productPitch: json['product_pitch'] != null
          ? (json['product_pitch'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                  key, ProductPitch.fromJson(value as Map<String, dynamic>)),
            )
          : {},
    );
  }
}

// Extended Member Rate (Empty in this case)
class ExtendedMemberRate {
  final int fullproduct;
  final String product;
  final String prodType;
  final double rate;
  final String relationship;
  final int minAge;
  final int maxAge;
  final double amount;
  final String client;
  final int clientId;
  final DateTime timestamp;
  final DateTime dateTimestamp;
  final DateTime lastUpdate;
  final DateTime dateLastUpdate;

  ExtendedMemberRate({
    required this.fullproduct,
    required this.product,
    required this.prodType,
    required this.rate,
    required this.relationship,
    required this.minAge,
    required this.maxAge,
    required this.amount,
    required this.client,
    required this.clientId,
    required this.timestamp,
    required this.dateTimestamp,
    required this.lastUpdate,
    required this.dateLastUpdate,
  });

  factory ExtendedMemberRate.fromJson(Map<String, dynamic> json) {
    return ExtendedMemberRate(
      fullproduct: json['fullproduct'] is int
          ? json['fullproduct']
          : int.tryParse(json['fullproduct'].toString()) ?? 0,
      product: json['product'] as String? ?? "",
      prodType: json['prod_type'] as String? ?? "",
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      relationship: json['relationship'] as String? ?? "",
      minAge: json['min_age'] is int
          ? json['min_age']
          : int.tryParse(json['min_age'].toString()) ?? 0,
      maxAge: json['max_age'] is int
          ? json['max_age']
          : int.tryParse(json['max_age'].toString()) ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      client: json['client'] as String? ?? "",
      clientId: json['client_id'] is int
          ? json['client_id']
          : int.tryParse(json['client_id'].toString()) ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'].toString())
          : DateTime.now(),
      dateTimestamp: json['date_timestamp'] != null
          ? DateTime.parse(json['date_timestamp'].toString())
          : DateTime.now(),
      lastUpdate: json['last_update'] != null
          ? DateTime.parse(json['last_update'].toString())
          : DateTime.now(),
      dateLastUpdate: json['date_last_update'] != null
          ? DateTime.parse(json['date_last_update'].toString())
          : DateTime.now(),
    );
  }
}

// Joining Fee
class JoiningFee {
  final int id;
  final String product;
  final String prodType;
  final double fee;
  final int clientId;
  final DateTime timestamp;
  final String dateTimestamp;
  final DateTime lastUpdate;
  final String dateLastUpdate;

  JoiningFee({
    required this.id,
    required this.product,
    required this.prodType,
    required this.fee,
    required this.clientId,
    required this.timestamp,
    required this.dateTimestamp,
    required this.lastUpdate,
    required this.dateLastUpdate,
  });

  factory JoiningFee.fromJson(Map<String, dynamic> json) {
    return JoiningFee(
      id: json['id'],
      product: json['product'],
      prodType: json['prod_type'],
      fee: json['fee'].toDouble(),
      clientId: json['client_id'],
      timestamp: DateTime.parse(json['timestamp']),
      dateTimestamp: json['date_timestamp'],
      lastUpdate: DateTime.parse(json['last_update']),
      dateLastUpdate: json['date_last_update'],
    );
  }
}

// Main Rate
class MainRate {
  final int id;
  final String product;
  final String prodType;
  final String relationship;
  final double amount;
  final double premium;
  final int minAge;
  final int maxAge;
  final int clientId;
  final int spouse;
  final int children;
  final int parents;
  final int extended;
  final int parentsAndExtended;
  final int extraMembersAllowed;
  final int maximumMembers;
  final bool isActive;

  MainRate({
    required this.id,
    required this.product,
    required this.prodType,
    required this.relationship,
    required this.amount,
    required this.premium,
    required this.minAge,
    required this.maxAge,
    required this.clientId,
    required this.spouse,
    required this.children,
    required this.parents,
    required this.extended,
    required this.parentsAndExtended,
    required this.extraMembersAllowed,
    required this.maximumMembers,
    required this.isActive,
  });

  factory MainRate.fromJson(Map<String, dynamic> json) {
    return MainRate(
      id: json['id'],
      product: json['product'],
      prodType: json['prod_type'],
      relationship: json['relationship'] ?? "",
      amount: json['amount'].toDouble(),
      premium: json['premium'].toDouble(),
      minAge: json['min_age'],
      maxAge: json['max_age'],
      clientId: json['client_id'],
      spouse: json['spouse'],
      children: json['children'],
      parents: json['parents'],
      extended: json['extended'],
      parentsAndExtended: json['parents_and_extended'],
      extraMembersAllowed: json['extra_members_allowed'],
      maximumMembers: json['maximum_members'],
      isActive: json['is_active'],
    );
  }
}

// Product Pitch
class ProductPitch {
  final Map<String, PlanDetails> plans;

  ProductPitch({required this.plans});

  factory ProductPitch.fromJson(Map<String, dynamic> json) {
    return ProductPitch(
      plans: json.map(
        (key, value) => MapEntry(key, PlanDetails.fromJson(value)),
      ),
    );
  }
}

// Plan Details
class PlanDetails {
  final String cover;
  final List<String> services;
  final List<String> coverAmounts;
  final List<MemberLimit> maxMembers;

  PlanDetails({
    required this.cover,
    required this.services,
    required this.coverAmounts,
    required this.maxMembers,
  });

  factory PlanDetails.fromJson(Map<String, dynamic> json) {
    return PlanDetails(
      cover: json['cover'],
      services: List<String>.from(json['services']),
      coverAmounts: List<String>.from(json['cover_amounts']),
      maxMembers: (json['max_members'] as List<dynamic>)
          .map((e) => MemberLimit.fromJson(e))
          .toList(),
    );
  }
}

// Member Limit
class MemberLimit {
  final String amount;
  final int memberLimit;
  final int extraMembersAllowed;
  final bool extendedCover;

  MemberLimit({
    required this.amount,
    required this.memberLimit,
    required this.extraMembersAllowed,
    required this.extendedCover,
  });

  factory MemberLimit.fromJson(Map<String, dynamic> json) {
    return MemberLimit(
      amount: json['amount'],
      memberLimit: json['member_limit'],
      extraMembersAllowed: json['extra_members_allowed'],
      extendedCover: json['extended_cover'],
    );
  }
}

class CalculatePolicyPremiumResponse {
  final int cecClientId;
  final String? reference;
  final String? mainInsuredDob;
  final List<String> partnersDobs; // Updated from singular partnerDob to a list
  final List<String> childrensDobs;
  final List<String> extendedMembersDobs;
  final int? fullProductId;
  List<MemberPremium> memberPremiums;
  double? totalPremium;
  double? joiningFee;
  final List<dynamic> selectedRidersIds;
  double? selectedRidersTotal;
  final List<dynamic> selectedRidersDetail;
  final double? totalDue;
  final List<Rider> allRiders;
  final List<QuoteRates> allMainRates;
  final List<dynamic> applicableMainRates;
  final List<Rider> applicableMRiders;
  final String? error; // New field for error message
  final List<String> errors; // New field for validation details

  CalculatePolicyPremiumResponse({
    required this.cecClientId,
    required this.reference,
    required this.mainInsuredDob,
    required this.partnersDobs,
    required this.childrensDobs,
    required this.extendedMembersDobs,
    this.fullProductId,
    required this.memberPremiums,
    this.totalPremium,
    this.joiningFee,
    required this.selectedRidersIds,
    this.selectedRidersTotal,
    required this.selectedRidersDetail,
    this.totalDue,
    required this.allRiders,
    required this.allMainRates,
    required this.applicableMainRates,
    required this.applicableMRiders,
    this.error,
    required this.errors,
  });

  factory CalculatePolicyPremiumResponse.fromJson(Map<String, dynamic> json) {
    final premiumsList = (json['member_premiums'] as List<dynamic>?)
            ?.map((e) => MemberPremium.fromJson(e))
            .toList() ??
        [];

    return CalculatePolicyPremiumResponse(
      cecClientId: int.tryParse(json['cec_client_id'].toString()) ?? 0,
      // handling string/number
      reference: json['reference'] ?? "",
      mainInsuredDob: json['main_insured_dob'],
      partnersDobs: (json['partners_dobs'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      childrensDobs: (json['childrens_dobs'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      extendedMembersDobs: (json['extended_members_dobs'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      fullProductId: json['full_product_id'],
      memberPremiums: premiumsList,
      totalPremium: (json['total_premium'] != null)
          ? (json['total_premium'] as num).toDouble()
          : null,
      joiningFee: (json['joining_fee'] != null)
          ? (json['joining_fee'] as num).toDouble()
          : null,
      selectedRidersIds: json['selected_riders_ids'] ?? [],
      selectedRidersTotal: (json['selected_riders_total'] != null)
          ? (json['selected_riders_total'] as num).toDouble()
          : null,
      selectedRidersDetail: json['selected_riders_detail'] ?? [],
      totalDue: (json['total_due'] != null)
          ? (json['total_due'] as num).toDouble()
          : null,
      allRiders: ((json['all_riders'] ?? []) as List<dynamic>?)
              ?.map((e) => Rider.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      allMainRates: ((json['all_main_rates'] ?? []) as List<dynamic>?)
              ?.map((e) => QuoteRates.fromJson(e))
              .toList() ??
          [],
      applicableMRiders: ((json['applicable_riders'] ?? []) as List<dynamic>?)
              ?.map((e) => Rider.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      applicableMainRates: json['applicable_main_rates'] ?? [],
      error: json['error'],
      errors: List<String>.from(json['details'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "cec_client_id": cecClientId,
      "reference": reference,
      "main_insured_dob": mainInsuredDob,
      "partners_dobs": partnersDobs,
      "childrens_dobs": childrensDobs,
      "extended_members_dobs": extendedMembersDobs,
      "full_product_id": fullProductId,
      "member_premiums": memberPremiums.map((mp) => mp.toJson()).toList(),
      "total_premium": totalPremium,
      "joining_fee": joiningFee,
      "selected_riders_ids": selectedRidersIds,
      "selected_riders_total": selectedRidersTotal,
      "selected_riders_detail": selectedRidersDetail,
      "total_due": totalDue,
      "all_riders": allRiders.map((r) => r.toJson()).toList(),
      "all_main_rates": allMainRates.map((r) => r.toJson()).toList(),
      "applicable_riders": applicableMRiders.map((r) => r.toJson()).toList(),
      "applicable_main_rates": applicableMainRates,
      "error": error,
      "details": errors,
    };
  }
}

class Rider {
  final int id;
  final int clientId;
  final String clientName;
  final String linkedProduct;
  final String riderName;
  final String relationship;
  final bool isIndividual;
  final double value;
  final int minAge;
  final int maxAge;
  final double price;
  final double percentage;
  final bool isPercentage;
  final String summary;
  final String timestamp;
  final String lastUpdate;

  Rider({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.linkedProduct,
    required this.riderName,
    required this.relationship,
    required this.isIndividual,
    required this.value,
    required this.minAge,
    required this.maxAge,
    required this.price,
    required this.percentage,
    required this.isPercentage,
    required this.summary,
    required this.timestamp,
    required this.lastUpdate,
  });

  /// Factory constructor to create a Rider object from JSON
  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
      id: json['id'] as int,
      clientId: json['client_id'] as int,
      clientName: json['client_name'] as String? ?? '',
      linkedProduct: json['linked_product'] as String? ?? '',
      riderName: json['rider_name'] as String? ?? '',
      relationship: json['relationship'] as String? ?? '',
      isIndividual: json['is_individual'] as bool,
      value: (json['value'] as num).toDouble(),
      minAge: json['min_age'] as int,
      maxAge: json['max_age'] as int,
      price: (json['price'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      isPercentage: json['is_percentage'] as bool,
      summary: json['summary'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      lastUpdate: json['last_update'] as String? ?? '',
    );
  }

  /// Method to convert a Rider object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'client_name': clientName,
      'linked_product': linkedProduct,
      'rider_name': riderName,
      'relationship': relationship,
      'is_individual': isIndividual,
      'value': value,
      'min_age': minAge,
      'max_age': maxAge,
      'price': price,
      'percentage': percentage,
      'is_percentage': isPercentage,
      'summary': summary,
      'timestamp': timestamp,
      'last_update': lastUpdate,
    };
  }
}

class QuoteRates {
  final int id;
  final int fullProductId;
  final String product;
  final String prodType;
  final double amount;
  final double premium;
  final int minAge;
  final int maxAge;
  final int clientId;
  final int spouse;
  final int children;
  final int parents;
  final int extended;
  final int parentsAndExtended;
  final int extraMembersAllowed;
  final int maximumMembers;
  final String uwRatesRef;
  final DateTime timestamp;
  final int createdBy;
  final DateTime lastUpdate;
  final int updatedBy;
  final bool isActive;

  QuoteRates({
    required this.id,
    required this.fullProductId,
    required this.product,
    required this.prodType,
    required this.amount,
    required this.premium,
    required this.minAge,
    required this.maxAge,
    required this.clientId,
    required this.spouse,
    required this.children,
    required this.parents,
    required this.extended,
    required this.parentsAndExtended,
    required this.extraMembersAllowed,
    required this.maximumMembers,
    required this.uwRatesRef,
    required this.timestamp,
    required this.createdBy,
    required this.lastUpdate,
    required this.updatedBy,
    required this.isActive,
  });

  /// Factory constructor to create a MainRate object from JSON
  factory QuoteRates.fromJson(Map<String, dynamic> json) {
    return QuoteRates(
      id: json['id'] ?? 0,
      fullProductId: json['fullproduct_id'] ?? 0,
      product: json['product'],
      prodType: json['prod_type'],
      amount: (json['amount'] as num).toDouble(),
      premium: (json['premium'] as num).toDouble(),
      minAge: json['min_age'],
      maxAge: json['max_age'],
      clientId: json['client_id'],
      spouse: json['spouse'],
      children: json['children'],
      parents: json['parents'],
      extended: json['extended'],
      parentsAndExtended: json['parents_and_extended'],
      extraMembersAllowed: json['extra_members_allowed'],
      maximumMembers: json['maximum_members'],
      uwRatesRef: json['uw_rates_ref'] ?? "",
      timestamp: DateTime.parse(json['timestamp']),
      createdBy: json['created_by'],
      lastUpdate: DateTime.parse(json['last_update']),
      updatedBy: json['updated_by'],
      isActive: json['is_active'],
    );
  }

  /// Convert the MainRate object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullproduct_id': fullProductId,
      'product': product,
      'prod_type': prodType,
      'amount': amount,
      'premium': premium,
      'min_age': minAge,
      'max_age': maxAge,
      'client_id': clientId,
      'spouse': spouse,
      'children': children,
      'parents': parents,
      'extended': extended,
      'parents_and_extended': parentsAndExtended,
      'extra_members_allowed': extraMembersAllowed,
      'maximum_members': maximumMembers,
      'uw_rates_ref': uwRatesRef,
      'timestamp': timestamp.toIso8601String(),
      'created_by': createdBy,
      'last_update': lastUpdate.toIso8601String(),
      'updated_by': updatedBy,
      'is_active': isActive,
    };
  }
}

class InsurancePlan {
  int? cecClientId;
  String? mainInsuredDob;
  String? reference;
  List<String>? partnersDobs; // maps to "partner_dob"
  List<double>? partnersCoverAmounts; // maps to "partners_cover_amount"
  List<String>? childrensDobs;
  List<double>? childrensCoverAmounts; // maps to "childrens_cover_amounts"
  List<String>? extendedMembersDobs;
  List<double>?
      extendedMembersCoverAmounts; // maps to "extended_members_cover_amounts"
  List<int>? selectedRiders;
  String? product;
  String? prodType;
  String? fullProductId;
  double? coverAmount;

  InsurancePlan({
    this.cecClientId,
    this.reference,
    this.mainInsuredDob,
    this.partnersDobs,
    this.partnersCoverAmounts,
    this.childrensDobs,
    this.childrensCoverAmounts,
    this.extendedMembersDobs,
    this.extendedMembersCoverAmounts,
    this.selectedRiders,
    this.product,
    this.prodType,
    this.fullProductId,
    this.coverAmount,
  });

  /// Factory method to create an InsurancePlan object from JSON
  factory InsurancePlan.fromJson(Map<String, dynamic> json) {
    return InsurancePlan(
      cecClientId: json['cec_client_id'] is int
          ? json['cec_client_id']
          : int.tryParse(json['cec_client_id'].toString()),
      reference: json['reference'],
      mainInsuredDob: json['main_insured_dob'],
      partnersDobs: json['partner_dob'] != null
          ? List<String>.from(json['partner_dob'])
          : null,
      partnersCoverAmounts: json['partners_cover_amount'] != null
          ? (json['partners_cover_amount'] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList()
          : null,
      childrensDobs: json['childrens_dobs'] != null
          ? List<String>.from(json['childrens_dobs'])
          : null,
      childrensCoverAmounts: json['childrens_cover_amounts'] != null
          ? (json['childrens_cover_amounts'] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList()
          : null,
      extendedMembersDobs: json['extended_members_dobs'] != null
          ? List<String>.from(json['extended_members_dobs'])
          : null,
      extendedMembersCoverAmounts:
          json['extended_members_cover_amounts'] != null
              ? (json['extended_members_cover_amounts'] as List<dynamic>)
                  .map((e) => (e as num).toDouble())
                  .toList()
              : null,
      selectedRiders: json['selected_riders'] != null
          ? List<int>.from(json['selected_riders'])
          : null,
      product: json['product'],
      prodType: json['prod_type'],
      fullProductId: json['full_product_id'],
      coverAmount: json['cover_amount'] != null
          ? (json['cover_amount'] as num).toDouble()
          : null,
    );
  }

  /// Method to convert InsurancePlan object to JSON
  Map<String, dynamic> toJson() {
    return {
      'cec_client_id': cecClientId,
      'reference': reference,
      'main_insured_dob': mainInsuredDob,
      'partner_dob': partnersDobs,
      'partners_cover_amount': partnersCoverAmounts,
      'childrens_dobs': childrensDobs ?? [],
      'childrens_cover_amounts': childrensCoverAmounts,
      'extended_members_dobs': extendedMembersDobs ?? [],
      'extended_members_cover_amounts': extendedMembersCoverAmounts,
      'selected_riders': selectedRiders ?? [],
      'product': product,
      'prod_type': prodType,
      'full_product_id': fullProductId,
      'cover_amount': coverAmount,
    };
  }
}

class RiderCard extends StatefulWidget {
  final Rider rider;
  final bool isSelected;
  final VoidCallback? onCheck;
  final VoidCallback? onAddBenefit;

  const RiderCard({
    Key? key,
    required this.rider,
    required this.isSelected,
    this.onCheck,
    this.onAddBenefit,
  }) : super(key: key);

  @override
  State<RiderCard> createState() => _RiderCardState();
}

class _RiderCardState extends State<RiderCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onCheck, // Single tap => "check" or select
        child: AnimatedScale(
          scale: isHovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: CustomCard(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: widget.isSelected
                    ? Constants.ftaColorLight.withOpacity(0.7)
                    : Colors.transparent,
                width: 2,
              ),
            ),
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Circle avatar or icon for the rider
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: widget.isSelected
                        ? Constants.ftaColorLight
                        : Colors.grey.shade300,
                    child: const Icon(
                      Icons.health_and_safety,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Rider details in a column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.rider.riderName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Linked Product: ${widget.rider.linkedProduct}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Price: R${widget.rider.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          'Age Range: ${widget.rider.minAge} - ${widget.rider.maxAge}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // "Add Benefit" button on the far right

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.isSelected == true)
                        Text(
                          "Benefit added",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'YuGothic',
                              color: Colors.black),
                        ),
                      if (widget.isSelected == false)
                        Container(
                          child: TextButton.icon(
                            onPressed: widget.onAddBenefit,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Add Benefit',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'YuGothic',
                                  color: Colors.white),
                            ),
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.teal,
                                backgroundColor: Constants.ftaColorLight),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RiderCard2 extends StatefulWidget {
  final Rider rider;
  final bool isSelected;
  final VoidCallback? onCheck;
  final VoidCallback? onAddBenefit;

  const RiderCard2({
    Key? key,
    required this.rider,
    required this.isSelected,
    this.onCheck,
    this.onAddBenefit,
  }) : super(key: key);

  @override
  State<RiderCard2> createState() => _RiderCard2State();
}

class _RiderCard2State extends State<RiderCard2> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onCheck, // Single tap => "check" or select
        child: AnimatedScale(
          scale: isHovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: CustomCard(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: widget.isSelected
                    ? Constants.ftaColorLight.withOpacity(0.7)
                    : Colors.transparent,
                width: 2,
              ),
            ),
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Circle avatar or icon for the rider

                  // Rider details in a column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Constants.ftaColorLight,
                            child: const Icon(
                              Icons.health_and_safety,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            widget.rider.riderName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            '${widget.rider.linkedProduct}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            'Price: R${widget.rider.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            'Age Range: ${widget.rider.minAge} - ${widget.rider.maxAge}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                  // "Add Benefit" button on the far right

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.isSelected == true)
                        Text(
                          "Benefit added",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'YuGothic',
                              color: Colors.black),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper function to parse a list of MainRates from JSON
List<QuoteRates> parseMainRates(List<dynamic> jsonList) {
  return jsonList.map((json) => QuoteRates.fromJson(json)).toList();
}

/// Helper function to convert a list of MainRates to JSON
List<Map<String, dynamic>> mainRatesToJson(List<QuoteRates> rates) {
  return rates.map((rate) => rate.toJson()).toList();
}
