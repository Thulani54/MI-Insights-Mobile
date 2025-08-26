class CustomerProfile {
  final int totalMembers;
  final int onMainMemberPolicies;
  final int onInforcedPolicies;
  final int onNotInforcedPolicies;
  final Map<String, MemberAgeGroup> mainMemberAges;
  final GenderDistribution genderDistribution;
  final MembersCountsData membersCountsData;
  final ClaimsData claimsData;
  final Map<String, double> claimsRatioDict;
  final List<int> deceasedAgesList;
  final AgeDistributionLists ageDistributionLists;

  CustomerProfile({
    required this.totalMembers,
    required this.onMainMemberPolicies,
    required this.onInforcedPolicies,
    required this.onNotInforcedPolicies,
    required this.mainMemberAges,
    required this.genderDistribution,
    required this.membersCountsData,
    required this.claimsData,
    required this.claimsRatioDict,
    required this.deceasedAgesList,
    required this.ageDistributionLists,
  });

  // Empty/default constructor
  factory CustomerProfile.empty() {
    return CustomerProfile(
      totalMembers: 0,
      onMainMemberPolicies: 0,
      onInforcedPolicies: 0,
      onNotInforcedPolicies: 0,
      mainMemberAges: {},
      genderDistribution: GenderDistribution.empty(),
      membersCountsData: MembersCountsData.empty(),
      claimsData: ClaimsData.empty(),
      claimsRatioDict: {},
      deceasedAgesList: [],
      ageDistributionLists: AgeDistributionLists.empty(),
    );
  }

  // Create new instance with updated fields
  CustomerProfile copyWith({
    int? totalMembers,
    int? onMainMemberPolicies,
    int? onInforcedPolicies,
    int? onNotInforcedPolicies,
    Map<String, MemberAgeGroup>? mainMemberAges,
    GenderDistribution? genderDistribution,
    MembersCountsData? membersCountsData,
    ClaimsData? claimsData,
    Map<String, double>? claimsRatioDict,
    List<int>? deceasedAgesList,
    AgeDistributionLists? ageDistributionLists,
  }) {
    return CustomerProfile(
      totalMembers: totalMembers ?? this.totalMembers,
      onMainMemberPolicies: onMainMemberPolicies ?? this.onMainMemberPolicies,
      onInforcedPolicies: onInforcedPolicies ?? this.onInforcedPolicies,
      onNotInforcedPolicies:
          onNotInforcedPolicies ?? this.onNotInforcedPolicies,
      mainMemberAges: mainMemberAges ?? this.mainMemberAges,
      genderDistribution: genderDistribution ?? this.genderDistribution,
      membersCountsData: membersCountsData ?? this.membersCountsData,
      claimsData: claimsData ?? this.claimsData,
      claimsRatioDict: claimsRatioDict ?? this.claimsRatioDict,
      deceasedAgesList: deceasedAgesList ?? this.deceasedAgesList,
      ageDistributionLists: ageDistributionLists ?? this.ageDistributionLists,
    );
  }

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      totalMembers: json['total_members'] ?? 0,
      onMainMemberPolicies: json['on_main_member_policies'] ?? 0,
      onInforcedPolicies: json['on_inforced_policies'] ?? 0,
      onNotInforcedPolicies: json['on_not_inforced_policies'] ?? 0,
      mainMemberAges: _parseMainMemberAges(json['main_member_ages'] ?? {}),
      genderDistribution:
          GenderDistribution.fromJson(json['gender_distribution_by_age'] ?? {}),
      membersCountsData:
          MembersCountsData.fromJson(json['members_counts'] ?? {}),
      claimsData: ClaimsData.fromJson(json),
      claimsRatioDict: Map<String, double>.from(
          (json['claims_ratio_dict'] ?? {})
              .map((k, v) => MapEntry(k, v.toDouble()))),
      deceasedAgesList: List<int>.from(json['deceased_ages_list'] ?? []),
      ageDistributionLists: AgeDistributionLists.fromJson(json),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'total_members': totalMembers,
      'on_main_member_policies': onMainMemberPolicies,
      'on_inforced_policies': onInforcedPolicies,
      'on_not_inforced_policies': onNotInforcedPolicies,
      'main_member_ages':
          mainMemberAges.map((key, value) => MapEntry(key, value.toJson())),
      'gender_distribution_by_age': genderDistribution.toJson(),
      'members_counts': membersCountsData.toJson(),
      'claims_ratio_dict': claimsRatioDict,
      'deceased_ages_list': deceasedAgesList,
      // ClaimsData fields are included in the main JSON structure
      'claims_total_members': claimsData.totalMembers,
      'claims_on_main_member_policies': claimsData.onMainMemberPolicies,
      'claims_on_inforced_policies': claimsData.onInforcedPolicies,
      'claims_on_not_inforced_policies': claimsData.onNotInforcedPolicies,
      'claims_gender_distribution_by_age':
          claimsData.genderDistribution.toJson(),
      'claims_members_counts': claimsData.membersCountsData.toJson(),
    };
  }

  static Map<String, MemberAgeGroup> _parseMainMemberAges(
      Map<String, dynamic> ages) {
    return ages
        .map((key, value) => MapEntry(key, MemberAgeGroup.fromJson(value)));
  }

  // Utility getters
  bool get isEmpty => totalMembers == 0;
  bool get hasData => totalMembers > 0;

  double get enforcementRate =>
      totalMembers > 0 ? onInforcedPolicies / totalMembers : 0.0;
  double get claimsRate =>
      totalMembers > 0 ? claimsData.totalMembers / totalMembers : 0.0;

  // Gender totals for easy access
  GenderTotals get customerGenderTotals => genderDistribution.totals;
  GenderTotals get claimsGenderTotals => claimsData.genderTotals;

  @override
  String toString() {
    return 'CustomerProfile(totalMembers: $totalMembers, onInforcedPolicies: $onInforcedPolicies, claimsTotal: ${claimsData.totalMembers})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomerProfile &&
        other.totalMembers == totalMembers &&
        other.onMainMemberPolicies == onMainMemberPolicies &&
        other.onInforcedPolicies == onInforcedPolicies &&
        other.onNotInforcedPolicies == onNotInforcedPolicies;
  }

  @override
  int get hashCode {
    return totalMembers.hashCode ^
        onMainMemberPolicies.hashCode ^
        onInforcedPolicies.hashCode ^
        onNotInforcedPolicies.hashCode;
  }
}

class MemberAgeGroup {
  final int beneficiary;
  final int child;
  final int mainMember;
  final int partner;

  MemberAgeGroup({
    required this.beneficiary,
    required this.child,
    required this.mainMember,
    required this.partner,
  });

  factory MemberAgeGroup.empty() {
    return MemberAgeGroup(
      beneficiary: 0,
      child: 0,
      mainMember: 0,
      partner: 0,
    );
  }

  factory MemberAgeGroup.fromJson(Map<String, dynamic> json) {
    return MemberAgeGroup(
      beneficiary: json['beneficiary'] ?? 0,
      child: json['child'] ?? 0,
      mainMember: json['main_member'] ?? 0,
      partner: json['partner'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'beneficiary': beneficiary,
      'child': child,
      'main_member': mainMember,
      'partner': partner,
    };
  }

  int get total => beneficiary + child + mainMember + partner;
}

class GenderDistribution {
  final Map<String, AgeGenderData> ageGroups;

  GenderDistribution({required this.ageGroups});

  factory GenderDistribution.empty() {
    return GenderDistribution(ageGroups: {});
  }

  factory GenderDistribution.fromJson(Map<String, dynamic> json) {
    return GenderDistribution(
      ageGroups: json
          .map((key, value) => MapEntry(key, AgeGenderData.fromJson(value))),
    );
  }

  Map<String, dynamic> toJson() {
    return ageGroups.map((key, value) => MapEntry(key, value.toJson()));
  }

  // Calculate total counts by gender
  GenderTotals get totals {
    int totalMale = 0;
    int totalFemale = 0;

    for (var ageGroup in ageGroups.values) {
      totalMale += ageGroup.male;
      totalFemale += ageGroup.female;
    }

    int total = totalMale + totalFemale;
    double malePercentage = total > 0 ? totalMale / total : 0.0;
    double femalePercentage = total > 0 ? totalFemale / total : 0.0;

    return GenderTotals(
      totalMale: totalMale,
      totalFemale: totalFemale,
      total: total,
      malePercentage: malePercentage,
      femalePercentage: femalePercentage,
    );
  }
}

class AgeGenderData {
  final int female;
  final int male;

  AgeGenderData({required this.female, required this.male});

  factory AgeGenderData.empty() {
    return AgeGenderData(female: 0, male: 0);
  }

  factory AgeGenderData.fromJson(Map<String, dynamic> json) {
    return AgeGenderData(
      female: json['female'] ?? 0,
      male: json['male'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'female': female,
      'male': male,
    };
  }

  int get total => female + male;
}

class GenderTotals {
  final int totalMale;
  final int totalFemale;
  final int total;
  final double malePercentage;
  final double femalePercentage;

  GenderTotals({
    required this.totalMale,
    required this.totalFemale,
    required this.total,
    required this.malePercentage,
    required this.femalePercentage,
  });
}

class MembersCountsData {
  final MemberTypeCount mainMember;
  final MemberTypeCount child;
  final MemberTypeCount beneficiary;
  final MemberTypeCount adultChild;
  final MemberTypeCount partner;
  final MemberTypeCount extendedFamily;

  MembersCountsData({
    required this.mainMember,
    required this.child,
    required this.beneficiary,
    required this.adultChild,
    required this.partner,
    required this.extendedFamily,
  });

  factory MembersCountsData.empty() {
    return MembersCountsData(
      mainMember: MemberTypeCount.empty(),
      child: MemberTypeCount.empty(),
      beneficiary: MemberTypeCount.empty(),
      adultChild: MemberTypeCount.empty(),
      partner: MemberTypeCount.empty(),
      extendedFamily: MemberTypeCount.empty(),
    );
  }

  factory MembersCountsData.fromJson(Map<String, dynamic> json) {
    return MembersCountsData(
      mainMember: MemberTypeCount.fromJson(json['main_member'] ?? {}),
      child: MemberTypeCount.fromJson(json['child'] ?? {}),
      beneficiary: MemberTypeCount.fromJson(json['beneficiary'] ?? {}),
      adultChild: MemberTypeCount.fromJson(json['adult_child'] ?? {}),
      partner: MemberTypeCount.fromJson(json['partner'] ?? {}),
      extendedFamily: MemberTypeCount.fromJson(json['extended_family'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'main_member': mainMember.toJson(),
      'child': child.toJson(),
      'beneficiary': beneficiary.toJson(),
      'adult_child': adultChild.toJson(),
      'partner': partner.toJson(),
      'extended_family': extendedFamily.toJson(),
    };
  }
}

class MemberTypeCount {
  final int total;
  final int enforced;
  final int notEnforced;
  final double enforcedPercentage;
  final double notEnforcedPercentage;
  final GenderCounts genders;

  MemberTypeCount({
    required this.total,
    required this.enforced,
    required this.notEnforced,
    required this.enforcedPercentage,
    required this.notEnforcedPercentage,
    required this.genders,
  });

  factory MemberTypeCount.empty() {
    return MemberTypeCount(
      total: 0,
      enforced: 0,
      notEnforced: 0,
      enforcedPercentage: 0.0,
      notEnforcedPercentage: 0.0,
      genders: GenderCounts.empty(),
    );
  }

  factory MemberTypeCount.fromJson(Map<String, dynamic> json) {
    return MemberTypeCount(
      total: json['total'] ?? 0,
      enforced: json['enforced'] ?? 0,
      notEnforced: json['not_enforced'] ?? 0,
      enforcedPercentage: (json['enforced_percentage'] ?? 0.0).toDouble(),
      notEnforcedPercentage:
          (json['not_enforced_percentage'] ?? 0.0).toDouble(),
      genders: GenderCounts.fromJson(json['genders'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'enforced': enforced,
      'not_enforced': notEnforced,
      'enforced_percentage': enforcedPercentage,
      'not_enforced_percentage': notEnforcedPercentage,
      'genders': genders.toJson(),
    };
  }
}

class GenderCounts {
  final GenderCount male;
  final GenderCount female;

  GenderCounts({required this.male, required this.female});

  factory GenderCounts.empty() {
    return GenderCounts(
      male: GenderCount.empty(),
      female: GenderCount.empty(),
    );
  }

  factory GenderCounts.fromJson(Map<String, dynamic> json) {
    return GenderCounts(
      male: GenderCount.fromJson(json['male'] ?? {}),
      female: GenderCount.fromJson(json['female'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'male': male.toJson(),
      'female': female.toJson(),
    };
  }
}

class GenderCount {
  final int total;
  final int enforced;
  final int notEnforced;
  final double enforcedPercentage;
  final double notEnforcedPercentage;

  GenderCount({
    required this.total,
    required this.enforced,
    required this.notEnforced,
    required this.enforcedPercentage,
    required this.notEnforcedPercentage,
  });

  factory GenderCount.empty() {
    return GenderCount(
      total: 0,
      enforced: 0,
      notEnforced: 0,
      enforcedPercentage: 0.0,
      notEnforcedPercentage: 0.0,
    );
  }

  factory GenderCount.fromJson(Map<String, dynamic> json) {
    return GenderCount(
      total: json['total'] ?? 0,
      enforced: json['enforced'] ?? 0,
      notEnforced: json['not_enforced'] ?? 0,
      enforcedPercentage: (json['enforced_percentage'] ?? 0.0).toDouble(),
      notEnforcedPercentage:
          (json['not_enforced_percentage'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'enforced': enforced,
      'not_enforced': notEnforced,
      'enforced_percentage': enforcedPercentage,
      'not_enforced_percentage': notEnforcedPercentage,
    };
  }
}

class ClaimsData {
  final int totalMembers;
  final int onMainMemberPolicies;
  final int onInforcedPolicies;
  final int onNotInforcedPolicies;
  final GenderDistribution genderDistribution;
  final MembersCountsData membersCountsData;
  final AgeDistributionLists ageDistributionLists;

  ClaimsData({
    required this.totalMembers,
    required this.onMainMemberPolicies,
    required this.onInforcedPolicies,
    required this.onNotInforcedPolicies,
    required this.genderDistribution,
    required this.membersCountsData,
    required this.ageDistributionLists,
  });

  factory ClaimsData.empty() {
    return ClaimsData(
      totalMembers: 0,
      onMainMemberPolicies: 0,
      onInforcedPolicies: 0,
      onNotInforcedPolicies: 0,
      genderDistribution: GenderDistribution.empty(),
      membersCountsData: MembersCountsData.empty(),
      ageDistributionLists: AgeDistributionLists.empty(),
    );
  }

  factory ClaimsData.fromJson(Map<String, dynamic> json) {
    return ClaimsData(
      totalMembers: json['claims_total_members'] ?? 0,
      onMainMemberPolicies: json['claims_on_main_member_policies'] ?? 0,
      onInforcedPolicies: json['claims_on_inforced_policies'] ?? 0,
      onNotInforcedPolicies: json['claims_on_not_inforced_policies'] ?? 0,
      genderDistribution: GenderDistribution.fromJson(
          json['claims_gender_distribution_by_age'] ?? {}),
      membersCountsData:
          MembersCountsData.fromJson(json['claims_members_counts'] ?? {}),
      ageDistributionLists: AgeDistributionLists.fromClaimsJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'claims_total_members': totalMembers,
      'claims_on_main_member_policies': onMainMemberPolicies,
      'claims_on_inforced_policies': onInforcedPolicies,
      'claims_on_not_inforced_policies': onNotInforcedPolicies,
      'claims_gender_distribution_by_age': genderDistribution.toJson(),
      'claims_members_counts': membersCountsData.toJson(),
    };
  }

  // Calculate total gender distribution for claims
  GenderTotals get genderTotals => genderDistribution.totals;
}

class AgeDistributionLists {
  final List<double> mainMember;
  final List<double> partner;
  final List<double> child;
  final List<double> extendedFamily;

  AgeDistributionLists({
    required this.mainMember,
    required this.partner,
    required this.child,
    required this.extendedFamily,
  });

  factory AgeDistributionLists.empty() {
    return AgeDistributionLists(
      mainMember: [],
      partner: [],
      child: [],
      extendedFamily: [],
    );
  }

  factory AgeDistributionLists.fromJson(Map<String, dynamic> json) {
    final ageDistLists = json['age_distribution_lists'] ?? {};
    return AgeDistributionLists(
      mainMember: List<double>.from((ageDistLists['main_member'] ?? []).map((x) => x.toDouble())),
      partner: List<double>.from((ageDistLists['partner'] ?? []).map((x) => x.toDouble())),
      child: List<double>.from((ageDistLists['child'] ?? []).map((x) => x.toDouble())),
      extendedFamily: List<double>.from((ageDistLists['extended_family'] ?? []).map((x) => x.toDouble())),
    );
  }

  factory AgeDistributionLists.fromClaimsJson(Map<String, dynamic> json) {
    final claimsAgeDistLists = json['claims_age_distribution_lists'] ?? {};
    return AgeDistributionLists(
      mainMember: List<double>.from((claimsAgeDistLists['main_member'] ?? []).map((x) => x.toDouble())),
      partner: List<double>.from((claimsAgeDistLists['partner'] ?? []).map((x) => x.toDouble())),
      child: List<double>.from((claimsAgeDistLists['child'] ?? []).map((x) => x.toDouble())),
      extendedFamily: List<double>.from((claimsAgeDistLists['extended_family'] ?? []).map((x) => x.toDouble())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'main_member': mainMember,
      'partner': partner,
      'child': child,
      'extended_family': extendedFamily,
    };
  }
}
