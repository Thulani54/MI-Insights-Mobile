import 'map_class.dart';

class PolicyInfoLead {
  final LeadObject leadObject;
  final List<AdditionalMember> additionalMembers;
  Employer? employer;
  Employer? employerOld;
  final Replacement? replacement;
  final MipLogin? login;
  Addresses? addresses;
  BeneficiaryAddress? beneficiaryAddress;
  Addresses? addressesOld;
  final List<Policy> policies;
  final List<dynamic> history;
  final String? documentPath;
  final dynamic accessedBy;

  PolicyInfoLead({
    required this.leadObject,
    required this.additionalMembers,
    this.employer,
    this.employerOld,
    this.replacement,
    this.login,
    this.addresses,
    this.beneficiaryAddress,
    this.addressesOld,
    required this.policies,
    required this.history,
    this.documentPath,
    this.accessedBy,
  });

  // fromJson method
  factory PolicyInfoLead.fromJson(Map<String, dynamic> json) {
    return PolicyInfoLead(
      leadObject: LeadObject.fromJson(json['lead']),
      additionalMembers: (json['additional_members'] as List<dynamic>?)
              ?.map((item) => AdditionalMember.fromJson(item))
              .toList() ??
          [],
      employer:
          json['employer'] != null ? Employer.fromJson(json['employer']) : null,
      employerOld: json['employer_old'] != null
          ? Employer.fromJson(json['employer_old'])
          : null,
      replacement: json['replacement'] != null
          ? Replacement.fromJson(json['replacement'])
          : null,
      login: json['login'] != null ? MipLogin.fromJson(json['login']) : null,
      addresses: json['addresses'] != null
          ? Addresses.fromJson(json['addresses'])
          : null,
      beneficiaryAddress: json['beneficiary_Address'] != null
          ? BeneficiaryAddress.fromJson(json['beneficiary_Address'])
          : null,
      addressesOld: json['addresses_old'] != null
          ? Addresses.fromJson(json['addresses_old'])
          : null,
      policies: (json['policy'] as List<dynamic>?)
              ?.map((item) => Policy.fromJson(item))
              .toList() ??
          [],
      history: (json['history'] as List<dynamic>?) ?? [],
      documentPath: json['DocumentPath'] as String?,
      accessedBy: json['accessed_by'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'lead': leadObject.toJson(),
      'additional_members':
          additionalMembers.map((member) => member.toJson()).toList(),
      'employer': employer?.toJson(),
      'employer_old': employerOld?.toJson(),
      'replacement': replacement?.toJson(),
      'login': login?.toJson(),
      'addresses': addresses?.toJson(),
      'beneficiary_Address': beneficiaryAddress?.toJson(),
      'addresses_old': addressesOld?.toJson(),
      'policy': policies.map((policy) => policy.toJson()).toList(),
      'history': history,
      'DocumentPath': documentPath,
      'accessed_by': accessedBy,
    };
  }

  Map<String, String> toPolicyForm() {
    final Map<String, String> formFields = {};

    // Loop through each policy
    for (int i = 0; i < policies.length; i++) {
      final Policy policy = policies[i];

      // Policy reference: policy[i][reference]
      formFields["policy[$i][reference]"] = policy.reference ?? "";

      // ---------- MEMBERS ----------
      for (int j = 0; j < policy.members.length; j++) {
        final Member mem = policy.members[j];

        formFields["policy[$i][members][$j][auto_number]"] =
            (mem.autoNumber ?? "").toString();
        formFields["policy[$i][members][$j][timestamp]"] = mem.timestamp ?? "";
        formFields["policy[$i][members][$j][last_update]"] =
            mem.lastUpdate ?? "";
        formFields["policy[$i][members][$j][reference]"] = mem.reference ?? "";
        formFields["policy[$i][members][$j][additional_member_id]"] =
            mem.additionalMemberId?.toString() ?? "";
        formFields["policy[$i][members][$j][premium]"] =
            mem.premium?.toString() ?? "";
        formFields["policy[$i][members][$j][cover]"] =
            mem.cover?.toString() ?? "10001.00";
        formFields["policy[$i][members][$j][type]"] = mem.type ?? "main_member";
        formFields["policy[$i][members][$j][percentage]"] =
            mem.percentage?.toString() ?? "";
        formFields["policy[$i][members][$j][ben_relationship]"] =
            mem.benRelationship ?? "";
        formFields["policy[$i][members][$j][member_status]"] =
            mem.memberStatus ?? "";
        formFields["policy[$i][members][$j][termination_date]"] =
            mem.terminationDate ?? "";
        formFields["policy[$i][members][$j][updated_by]"] =
            mem.updatedBy?.toString() ?? "";
        formFields["policy[$i][members][$j][member_query_type]"] =
            mem.memberQueryType ?? "";
        formFields["policy[$i][members][$j][member_query_type_old_new]"] =
            mem.memberQueryTypeOldNew ?? "";
        formFields["policy[$i][members][$j][empid]"] =
            mem.empId?.toString() ?? "";
        formFields["policy[$i][members][$j][cec_client_id]"] =
            mem.cecClientId?.toString() ?? "";
      }

      // ---------- PREMIUM PAYER ----------
      if (policy.premiumPayer != null) {
        final PremiumPayer payer = policy.premiumPayer!;
        formFields["policy[$i][premiumPayer][auto_number]"] =
            (payer.autoNumber ?? "").toString();
        formFields["policy[$i][premiumPayer][bankname]"] = payer.bankname ?? "";
        formFields["policy[$i][premiumPayer][branchname]"] =
            payer.branchname ?? "";
        formFields["policy[$i][premiumPayer][branchcode]"] =
            payer.branchcode ?? "";
        formFields["policy[$i][premiumPayer][accno]"] = payer.accno ?? "";
        formFields["policy[$i][premiumPayer][accounttype]"] =
            payer.accounttype ?? "";
        formFields["policy[$i][premiumPayer][salarydate]"] =
            payer.salarydate ?? "";
        formFields["policy[$i][premiumPayer][collectionday]"] =
            payer.collectionday ?? "";
        formFields["policy[$i][premiumPayer][timestamp]"] =
            payer.timestamp ?? "";
        formFields["policy[$i][premiumPayer][reference]"] =
            payer.reference ?? "";
        formFields["policy[$i][premiumPayer][onololeadid]"] =
            payer.onololeadid?.toString() ?? "";
        formFields["policy[$i][premiumPayer][acount_holder]"] =
            payer.acountHolder ?? "";
        formFields["policy[$i][premiumPayer][combine_premium]"] =
            payer.combinePremium ?? "";
        formFields["policy[$i][premiumPayer][updated_by]"] =
            payer.updatedBy?.toString() ?? "";
      }

      // ---------- QUOTE ----------
      if (policy.quote != null) {
        Quote q = policy.quote!;
        formFields["policy[$i][quote][auto_number]"] =
            (q.autoNumber ?? "").toString();
        formFields["policy[$i][quote][inceptionDate]"] =
            (q.inceptionDate ?? "").toString();
        formFields["policy[$i][quote][reference]"] = q.reference ?? "";
        formFields["policy[$i][quote][product]"] = q.product ?? "Funeral Plans";
        formFields["policy[$i][quote][product_type]"] = q.productType ?? "";
        formFields["policy[$i][quote][abbr]"] = q.abbr ?? "";
        formFields["policy[$i][quote][policy_number]"] = q.policyNumber ?? "";
        formFields["policy[$i][quote][status]"] = q.status ?? "";
        formFields["policy[$i][quote][inforce_date]"] =
            (q.inforceDate ?? "").toString();
        formFields["policy[$i][quote][updated_by]"] =
            q.updatedBy?.toString() ?? "0";
        formFields["policy[$i][quote][totalAmountPayable]"] =
            q.totalAmountPayable?.toString() ?? "";
        formFields["policy[$i][quote][sumAssuredFamilyCover]"] =
            q.sumAssuredFamilyCover?.toString() ?? "";
        formFields["policy[$i][quote][accept_policy]"] = q.acceptPolicy ?? "";
        formFields["policy[$i][quote][onololeadid]"] =
            q.onololeadid?.toString() ?? "";
        formFields["policy[$i][quote][inforced_by]"] =
            q.inforcedBy?.toString() ?? "";
      }
    }

    return formFields;
  }

  Map<String, String> toPolicyFormForIndex(int index) {
    final Map<String, String> formFields = {};

    // Check that index is within bounds.
    if (index < 0 || index >= policies.length) {
      return formFields;
    }

    final Policy policy = policies[index];

    // POLICY REFERENCE
    formFields["policy[$index][reference]"] = policy.reference ?? "";

    // ---------- MEMBERS ----------
    for (int j = 0; j < policy.members.length; j++) {
      final Member mem = policy.members[j];

      formFields["policy[$index][members][$j][auto_number]"] =
          (mem.autoNumber ?? "").toString();
      formFields["policy[$index][members][$j][timestamp]"] =
          mem.timestamp ?? "";
      formFields["policy[$index][members][$j][last_update]"] =
          mem.lastUpdate ?? "";
      formFields["policy[$index][members][$j][reference]"] =
          mem.reference ?? "";
      formFields["policy[$index][members][$j][additional_member_id]"] =
          mem.additionalMemberId?.toString() ?? "";
      formFields["policy[$index][members][$j][premium]"] =
          mem.premium?.toString() ?? "";
      formFields["policy[$index][members][$j][cover]"] =
          mem.cover?.toString() ?? "10001.00";
      formFields["policy[$index][members][$j][type]"] =
          mem.type ?? "main_member";
      formFields["policy[$index][members][$j][percentage]"] =
          mem.percentage?.toString() ?? "";
      formFields["policy[$index][members][$j][ben_relationship]"] =
          mem.benRelationship ?? "";
      formFields["policy[$index][members][$j][member_status]"] =
          mem.memberStatus ?? "";
      formFields["policy[$index][members][$j][termination_date]"] =
          mem.terminationDate ?? "";
      formFields["policy[$index][members][$j][updated_by]"] =
          mem.updatedBy?.toString() ?? "";
      formFields["policy[$index][members][$j][member_query_type]"] =
          mem.memberQueryType ?? "";
      formFields["policy[$index][members][$j][member_query_type_old_new]"] =
          mem.memberQueryTypeOldNew ?? "";
      formFields["policy[$index][members][$j][empid]"] =
          mem.empId?.toString() ?? "";
      formFields["policy[$index][members][$j][cec_client_id]"] =
          mem.cecClientId?.toString() ?? "";
    }

    // ---------- PREMIUM PAYER ----------
    if (policy.premiumPayer != null) {
      final PremiumPayer payer = policy.premiumPayer!;
      formFields["policy[$index][premiumPayer][auto_number]"] =
          (payer.autoNumber ?? "").toString();
      formFields["policy[$index][premiumPayer][bankname]"] =
          payer.bankname ?? "";
      formFields["policy[$index][premiumPayer][branchname]"] =
          payer.branchname ?? "";
      formFields["policy[$index][premiumPayer][branchcode]"] =
          payer.branchcode ?? "";
      formFields["policy[$index][premiumPayer][accno]"] = payer.accno ?? "";
      formFields["policy[$index][premiumPayer][accounttype]"] =
          payer.accounttype ?? "";
      formFields["policy[$index][premiumPayer][salarydate]"] =
          payer.salarydate ?? "";
      formFields["policy[$index][premiumPayer][collectionday]"] =
          payer.collectionday ?? "";
      formFields["policy[$index][premiumPayer][timestamp]"] =
          payer.timestamp ?? "";
      formFields["policy[$index][premiumPayer][reference]"] =
          payer.reference ?? "";
      formFields["policy[$index][premiumPayer][onololeadid]"] =
          payer.onololeadid?.toString() ?? "";
      formFields["policy[$index][premiumPayer][acount_holder]"] =
          payer.acountHolder ?? "";
      formFields["policy[$index][premiumPayer][combine_premium]"] =
          payer.combinePremium ?? "";
      formFields["policy[$index][premiumPayer][updated_by]"] =
          payer.updatedBy?.toString() ?? "";
    }

    // ---------- QUOTE ----------
    if (policy.quote != null) {
      Quote q = policy.quote!;
      formFields["policy[$index][quote][auto_number]"] =
          (q.autoNumber ?? "").toString();
      formFields["policy[$index][quote][inceptionDate]"] =
          (q.inceptionDate ?? "").toString();
      formFields["policy[$index][quote][reference]"] = q.reference ?? "";
      formFields["policy[$index][quote][product]"] =
          q.product ?? "Funeral Plans";
      formFields["policy[$index][quote][product_type]"] = q.productType ?? "";
      formFields["policy[$index][quote][abbr]"] = q.abbr ?? "";
      formFields["policy[$index][quote][policy_number]"] = q.policyNumber ?? "";
      formFields["policy[$index][quote][status]"] = q.status ?? "";
      formFields["policy[$index][quote][inforce_date]"] =
          (q.inforceDate ?? "").toString();
      formFields["policy[$index][quote][updated_by]"] =
          q.updatedBy?.toString() ?? "0";
      formFields["policy[$index][quote][totalAmountPayable]"] =
          q.totalAmountPayable?.toString() ?? "";
      formFields["policy[$index][quote][sumAssuredFamilyCover]"] =
          q.sumAssuredFamilyCover?.toString() ?? "";
      formFields["policy[$index][quote][accept_policy]"] = q.acceptPolicy ?? "";
      formFields["policy[$index][quote][onololeadid]"] =
          q.onololeadid?.toString() ?? "";
      formFields["policy[$index][quote][inforced_by]"] =
          q.inforcedBy?.toString() ?? "";
    }

    return formFields;
  }
}
