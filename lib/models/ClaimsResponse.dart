import 'dart:convert';

class ClaimsResponse {
  final ClaimsByCategory claimsByCategory;
  final Map<String, double> claimsSumByCategory;
  final ClaimsByType claimsByType;
  final Map<String, dynamic> claimsDaily;
  final Map<String, int> claimsMonthly;
  final Map<String, int> groupedClaims;
  final Map<String, int> totalClaimsByBranchId;
  final Map<String, int> categorizedByEmployee;
  final Map<String, ClaimPercentageCategory> claimsPercentages;
  final Map<String, dynamic> claimsAmounts;
  final double sumOutstanding;
  final Map<String, double> claimsRatioDict;
  final Map<String, double> monthlyPremiumsDict;
  final Map<String, double> monthlyClaimsPremiumsDict;
  final double sumPaid;
  final double sumDeclined;
  final int countDeclined;
  final int countOutstanding;
  final int countPaid;
  final List<int> deceasedAgesList;
  final List<ClaimItem> claimsList;
  final bool success;

  ClaimsResponse({
    required this.claimsByCategory,
    required this.claimsSumByCategory,
    required this.claimsByType,
    required this.claimsDaily,
    required this.claimsMonthly,
    required this.groupedClaims,
    required this.totalClaimsByBranchId,
    required this.categorizedByEmployee,
    required this.claimsPercentages,
    required this.claimsAmounts,
    required this.sumOutstanding,
    required this.claimsRatioDict,
    required this.monthlyPremiumsDict,
    required this.monthlyClaimsPremiumsDict,
    required this.sumPaid,
    required this.sumDeclined,
    required this.countDeclined,
    required this.countOutstanding,
    required this.countPaid,
    required this.deceasedAgesList,
    required this.claimsList,
    required this.success,
  });

  factory ClaimsResponse.fromJson(Map<String, dynamic> json) => ClaimsResponse(
        claimsByCategory:
            ClaimsByCategory.fromJson(json["claims_by_category"] ?? {}),
        claimsSumByCategory: Map.from(json["claims_sum_by_category"] ?? {}).map(
            (k, v) =>
                MapEntry<String, double>(k.toString(), (v ?? 0).toDouble())),
        claimsByType: ClaimsByType.fromJson(json["claims_by_type"] ?? {}),
        claimsDaily: Map.from(json["claims_daily"] ?? {}),
        claimsMonthly: Map.from(json["claims_monthly"] ?? {})
            .map((k, v) => MapEntry<String, int>(k.toString(), v ?? 0)),
        groupedClaims: Map.from(json["grouped_claims"] ?? {})
            .map((k, v) => MapEntry<String, int>(k.toString(), v ?? 0)),
        totalClaimsByBranchId: Map.from(json["total_claims_by_branch_id"] ?? {})
            .map((k, v) => MapEntry<String, int>(k.toString(), v ?? 0)),
        categorizedByEmployee: Map.from(json["categorized_by_employee"] ?? {})
            .map((k, v) => MapEntry<String, int>(k.toString(), v ?? 0)),
        claimsPercentages: Map.from(json["claims_percentages"] ?? {}).map(
            (k, v) => MapEntry<String, ClaimPercentageCategory>(
                k.toString(), ClaimPercentageCategory.fromJson(v ?? {}))),
        claimsAmounts: Map.from(json["claims_amounts"] ?? {}),
        sumOutstanding: (json["sum_outstanding"] ?? 0).toDouble(),
        claimsRatioDict: Map.from(json["claims_ratio_dict"] ?? {}).map((k, v) =>
            MapEntry<String, double>(k.toString(), (v ?? 0).toDouble())),
        monthlyPremiumsDict: Map.from(json["monthly_premiums_dict"] ?? {}).map(
            (k, v) =>
                MapEntry<String, double>(k.toString(), (v ?? 0).toDouble())),
        monthlyClaimsPremiumsDict:
            Map.from(json["monthly_claims_premiums_dict"] ?? {}).map((k, v) =>
                MapEntry<String, double>(k.toString(), (v ?? 0).toDouble())),
        sumPaid: (json["sum_paid"] ?? 0).toDouble(),
        sumDeclined: (json["sum_declined"] ?? 0).toDouble(),
        countDeclined: json["count_declined"] ?? 0,
        countOutstanding: json["count_outstanding"] ?? 0,
        countPaid: json["count_paid"] ?? 0,
        deceasedAgesList:
            List<int>.from((json["deceased_ages_list"] ?? []).map((x) => x)),
        claimsList: List<ClaimItem>.from(
            (json["claims_list"] ?? []).map((x) => ClaimItem.fromJson(x))),
        success: json["success"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "claims_by_category": claimsByCategory.toJson(),
        "claims_sum_by_category": Map.from(claimsSumByCategory)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "claims_by_type": claimsByType.toJson(),
        "claims_daily": claimsDaily,
        "claims_monthly": Map.from(claimsMonthly)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "grouped_claims": Map.from(groupedClaims)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "total_claims_by_branch_id": Map.from(totalClaimsByBranchId)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "categorized_by_employee": Map.from(categorizedByEmployee)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "claims_percentages": Map.from(claimsPercentages)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "claims_amounts": claimsAmounts,
        "sum_outstanding": sumOutstanding,
        "claims_ratio_dict": Map.from(claimsRatioDict)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "monthly_premiums_dict": Map.from(monthlyPremiumsDict)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "monthly_claims_premiums_dict": Map.from(monthlyClaimsPremiumsDict)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "sum_paid": sumPaid,
        "sum_declined": sumDeclined,
        "count_declined": countDeclined,
        "count_outstanding": countOutstanding,
        "count_paid": countPaid,
        "deceased_ages_list":
            List<dynamic>.from(deceasedAgesList.map((x) => x)),
        "claims_list": List<dynamic>.from(claimsList.map((x) => x.toJson())),
        "success": success,
      };

  factory ClaimsResponse.empty() => ClaimsResponse(
        claimsByCategory: ClaimsByCategory.empty(),
        claimsSumByCategory: {},
        claimsByType: ClaimsByType.empty(),
        claimsDaily: {},
        claimsMonthly: {},
        groupedClaims: {},
        totalClaimsByBranchId: {},
        categorizedByEmployee: {},
        claimsPercentages: {},
        claimsAmounts: {},
        sumOutstanding: 0.0,
        claimsRatioDict: {},
        monthlyPremiumsDict: {},
        monthlyClaimsPremiumsDict: {},
        sumPaid: 0.0,
        sumDeclined: 0.0,
        countDeclined: 0,
        countOutstanding: 0,
        countPaid: 0,
        deceasedAgesList: [],
        claimsList: [],
        success: false,
      );

  ClaimsResponse copyWith({
    ClaimsByCategory? claimsByCategory,
    Map<String, double>? claimsSumByCategory,
    ClaimsByType? claimsByType,
    Map<String, dynamic>? claimsDaily,
    Map<String, int>? claimsMonthly,
    Map<String, int>? groupedClaims,
    Map<String, int>? totalClaimsByBranchId,
    Map<String, int>? categorizedByEmployee,
    Map<String, ClaimPercentageCategory>? claimsPercentages,
    Map<String, dynamic>? claimsAmounts,
    double? sumOutstanding,
    Map<String, double>? claimsRatioDict,
    Map<String, double>? monthlyPremiumsDict,
    Map<String, double>? monthlyClaimsPremiumsDict,
    double? sumPaid,
    double? sumDeclined,
    int? countDeclined,
    int? countOutstanding,
    int? countPaid,
    List<int>? deceasedAgesList,
    List<ClaimItem>? claimsList,
    bool? success,
  }) {
    return ClaimsResponse(
      claimsByCategory: claimsByCategory ?? this.claimsByCategory,
      claimsSumByCategory: claimsSumByCategory ?? this.claimsSumByCategory,
      claimsByType: claimsByType ?? this.claimsByType,
      claimsDaily: claimsDaily ?? this.claimsDaily,
      claimsMonthly: claimsMonthly ?? this.claimsMonthly,
      groupedClaims: groupedClaims ?? this.groupedClaims,
      totalClaimsByBranchId:
          totalClaimsByBranchId ?? this.totalClaimsByBranchId,
      categorizedByEmployee:
          categorizedByEmployee ?? this.categorizedByEmployee,
      claimsPercentages: claimsPercentages ?? this.claimsPercentages,
      claimsAmounts: claimsAmounts ?? this.claimsAmounts,
      sumOutstanding: sumOutstanding ?? this.sumOutstanding,
      claimsRatioDict: claimsRatioDict ?? this.claimsRatioDict,
      monthlyPremiumsDict: monthlyPremiumsDict ?? this.monthlyPremiumsDict,
      monthlyClaimsPremiumsDict:
          monthlyClaimsPremiumsDict ?? this.monthlyClaimsPremiumsDict,
      sumPaid: sumPaid ?? this.sumPaid,
      sumDeclined: sumDeclined ?? this.sumDeclined,
      countDeclined: countDeclined ?? this.countDeclined,
      countOutstanding: countOutstanding ?? this.countOutstanding,
      countPaid: countPaid ?? this.countPaid,
      deceasedAgesList: deceasedAgesList ?? this.deceasedAgesList,
      claimsList: claimsList ?? this.claimsList,
      success: success ?? this.success,
    );
  }
}

class ClaimItem {
  final int claimId;
  final int claimClientId;
  final String claimCellNumber;
  final String claimTitle;
  final String claimFirstName;
  final String claimLastName;
  final String claimStatus;
  final dynamic claimAssignedTo;
  final dynamic claimClientEmail;
  final dynamic claimHangUpDesc2;
  final dynamic claimHangUpDesc3;
  final dynamic claimNotes;
  final dynamic claimCallCount;
  final dynamic claimCallAttempt;
  final dynamic claimCallTimeEllapsed;
  final String claimDate;
  final String claimLastUpdate;
  final int claimOnololeadid;
  final String claimReference;
  final int claimCreatedBy;
  final String claimCompleteDate;
  final dynamic claimHangUpDesc1;
  final dynamic claimHangUpReason;
  final dynamic claimType;
  final double claimAmount;
  final int camAutonunber;
  final int branchId;
  final String policyNum;
  final String policyStatus;
  final String policyReference;
  final String policyLife;
  final String claimIdNum;
  final List<String> claimDob;
  final String deathType;
  final String claimStatusDescription;
  final String synopsisStatus;
  final String policySynopsisRes;
  final String memberSynopsis;
  final String memberSynopsisReason;
  final String branchLeaderNotes;
  final String? assessorNotes;
  final dynamic riskNotes;
  final String? payOrServiceRendered;
  final String paymtOrServiceDate;
  final String? payOrServiceReference;
  final String lastPosition;
  final int lastPositionTab;
  final int isSuicide;
  final int isUnderInvestigation;
  final String placeOfDeath;
  final String dateOfDeath;
  final String maritalStatus;
  final int waitingPeriod;
  final String waitingPeriodType;
  final dynamic deathCertificateNo;
  final int cecUserHistoryid;
  final int cecEmployeeid;
  final String action;
  final String object;
  final String extra1;
  final String extra2;
  final String extra3;
  final dynamic extra4;
  final dynamic extra5;
  final int cecClientId;
  final String timestamp;
  final String result;
  final String description;
  final int year;
  final String month;
  final int day;
  final String mainCat;
  final String date;
  final double timeDiffDays;
  final double timeDiffHours;

  ClaimItem({
    required this.claimId,
    required this.claimClientId,
    required this.claimCellNumber,
    required this.claimTitle,
    required this.claimFirstName,
    required this.claimLastName,
    required this.claimStatus,
    this.claimAssignedTo,
    this.claimClientEmail,
    this.claimHangUpDesc2,
    this.claimHangUpDesc3,
    this.claimNotes,
    this.claimCallCount,
    this.claimCallAttempt,
    this.claimCallTimeEllapsed,
    required this.claimDate,
    required this.claimLastUpdate,
    required this.claimOnololeadid,
    required this.claimReference,
    required this.claimCreatedBy,
    required this.claimCompleteDate,
    this.claimHangUpDesc1,
    this.claimHangUpReason,
    this.claimType,
    required this.claimAmount,
    required this.camAutonunber,
    required this.branchId,
    required this.policyNum,
    required this.policyStatus,
    required this.policyReference,
    required this.policyLife,
    required this.claimIdNum,
    required this.claimDob,
    required this.deathType,
    required this.claimStatusDescription,
    required this.synopsisStatus,
    required this.policySynopsisRes,
    required this.memberSynopsis,
    required this.memberSynopsisReason,
    required this.branchLeaderNotes,
    this.assessorNotes,
    this.riskNotes,
    this.payOrServiceRendered,
    required this.paymtOrServiceDate,
    this.payOrServiceReference,
    required this.lastPosition,
    required this.lastPositionTab,
    required this.isSuicide,
    required this.isUnderInvestigation,
    required this.placeOfDeath,
    required this.dateOfDeath,
    required this.maritalStatus,
    required this.waitingPeriod,
    required this.waitingPeriodType,
    this.deathCertificateNo,
    required this.cecUserHistoryid,
    required this.cecEmployeeid,
    required this.action,
    required this.object,
    required this.extra1,
    required this.extra2,
    required this.extra3,
    this.extra4,
    this.extra5,
    required this.cecClientId,
    required this.timestamp,
    required this.result,
    required this.description,
    required this.year,
    required this.month,
    required this.day,
    required this.mainCat,
    required this.date,
    required this.timeDiffDays,
    required this.timeDiffHours,
  });

  factory ClaimItem.fromJson(Map<String, dynamic> json) => ClaimItem(
        claimId: json["claim_id"] ?? 0,
        claimClientId: json["claim_client_id"] ?? 0,
        claimCellNumber: json["claim_cell_number"]?.toString() ?? '',
        claimTitle: json["claim_title"]?.toString() ?? '',
        claimFirstName: json["claim_first_name"]?.toString() ?? '',
        claimLastName: json["claim_last_name"]?.toString() ?? '',
        claimStatus: json["claim_status"]?.toString() ?? '',
        claimAssignedTo: json["claim_assigned_to"],
        claimClientEmail: json["claim_client_email"],
        claimHangUpDesc2: json["claim_hang_up_desc2"],
        claimHangUpDesc3: json["claim_hang_up_desc3"],
        claimNotes: json["claim_notes"],
        claimCallCount: json["claim_call_count"],
        claimCallAttempt: json["claim_call_attempt"],
        claimCallTimeEllapsed: json["claim_call_time_ellapsed"],
        claimDate: json["claim_date"]?.toString() ?? '',
        claimLastUpdate: json["claim_last_update"]?.toString() ?? '',
        claimOnololeadid: json["claim_onololeadid"] ?? 0,
        claimReference: json["claim_reference"]?.toString() ?? '',
        claimCreatedBy: json["claim_created_by"] ?? 0,
        claimCompleteDate: json["claim_complete_date"]?.toString() ?? '',
        claimHangUpDesc1: json["claim_hang_up_desc1"],
        claimHangUpReason: json["claim_hang_up_reason"],
        claimType: json["claim_type"],
        claimAmount: (json["claim_amount"] ?? 0).toDouble(),
        camAutonunber: json["cam_autonunber"] ?? 0,
        branchId: json["branch_id"] ?? 0,
        policyNum: json["policy_num"]?.toString() ?? '',
        policyStatus: json["policy_status"]?.toString() ?? '',
        policyReference: json["policy_reference"]?.toString() ?? '',
        policyLife: json["policy_life"]?.toString() ?? '',
        claimIdNum: json["claim_id_num"]?.toString() ?? '',
        claimDob: List<String>.from(
            (json["claim_dob"] ?? []).map((x) => x.toString())),
        deathType: json["death_type"]?.toString() ?? '',
        claimStatusDescription:
            json["claim_status_description"]?.toString() ?? '',
        synopsisStatus: json["synopsis_status"]?.toString() ?? '',
        policySynopsisRes: json["policy_synopsis_res"]?.toString() ?? '',
        memberSynopsis: json["member_synopsis"]?.toString() ?? '',
        memberSynopsisReason: json["member_synopsis_reason"]?.toString() ?? '',
        branchLeaderNotes: json["branch_leader_notes"]?.toString() ?? '',
        assessorNotes: json["assessor_notes"]?.toString(),
        riskNotes: json["risk_notes"],
        payOrServiceRendered: json["pay_or_service_rendered"]?.toString(),
        paymtOrServiceDate: json["paymt_or_service_Date"]?.toString() ?? '',
        payOrServiceReference: json["pay_or_service_reference"]?.toString(),
        lastPosition: json["last_position"]?.toString() ?? '',
        lastPositionTab: json["last_position_tab"] ?? 0,
        isSuicide: json["is_suicide"] ?? 0,
        isUnderInvestigation: json["is_underInvestigation"] ?? 0,
        placeOfDeath: json["place_of_death"]?.toString() ?? '',
        dateOfDeath: json["date_of_death"]?.toString() ?? '',
        maritalStatus: json["marital_status"]?.toString() ?? '',
        waitingPeriod: json["waiting_period"] ?? 0,
        waitingPeriodType: json["waiting_period_type"]?.toString() ?? '',
        deathCertificateNo: json["death_certificate_no"],
        cecUserHistoryid: json["cec_user_historyid"] ?? 0,
        cecEmployeeid: json["cec_employeeid"] ?? 0,
        action: json["action"]?.toString() ?? '',
        object: json["object"]?.toString() ?? '',
        extra1: json["extra1"]?.toString() ?? '',
        extra2: json["extra2"]?.toString() ?? '',
        extra3: json["extra3"]?.toString() ?? '',
        extra4: json["extra4"],
        extra5: json["extra5"],
        cecClientId: json["cec_client_id"] ?? 0,
        timestamp: json["timestamp"]?.toString() ?? '',
        result: json["result"]?.toString() ?? '',
        description: json["description"]?.toString() ?? '',
        year: json["year"] ?? 0,
        month: json["month"]?.toString() ?? '',
        day: json["day"] ?? 0,
        mainCat: json["Main Cat"]?.toString() ?? '',
        date: json["date"]?.toString() ?? '',
        timeDiffDays: (json["time_diff_days"] ?? 0).toDouble(),
        timeDiffHours: (json["time_diff_hours"] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "claim_id": claimId,
        "claim_client_id": claimClientId,
        "claim_cell_number": claimCellNumber,
        "claim_title": claimTitle,
        "claim_first_name": claimFirstName,
        "claim_last_name": claimLastName,
        "claim_status": claimStatus,
        "claim_assigned_to": claimAssignedTo,
        "claim_client_email": claimClientEmail,
        "claim_hang_up_desc2": claimHangUpDesc2,
        "claim_hang_up_desc3": claimHangUpDesc3,
        "claim_notes": claimNotes,
        "claim_call_count": claimCallCount,
        "claim_call_attempt": claimCallAttempt,
        "claim_call_time_ellapsed": claimCallTimeEllapsed,
        "claim_date": claimDate,
        "claim_last_update": claimLastUpdate,
        "claim_onololeadid": claimOnololeadid,
        "claim_reference": claimReference,
        "claim_created_by": claimCreatedBy,
        "claim_complete_date": claimCompleteDate,
        "claim_hang_up_desc1": claimHangUpDesc1,
        "claim_hang_up_reason": claimHangUpReason,
        "claim_type": claimType,
        "claim_amount": claimAmount,
        "cam_autonunber": camAutonunber,
        "branch_id": branchId,
        "policy_num": policyNum,
        "policy_status": policyStatus,
        "policy_reference": policyReference,
        "policy_life": policyLife,
        "claim_id_num": claimIdNum,
        "claim_dob": List<dynamic>.from(claimDob.map((x) => x)),
        "death_type": deathType,
        "claim_status_description": claimStatusDescription,
        "synopsis_status": synopsisStatus,
        "policy_synopsis_res": policySynopsisRes,
        "member_synopsis": memberSynopsis,
        "member_synopsis_reason": memberSynopsisReason,
        "branch_leader_notes": branchLeaderNotes,
        "assessor_notes": assessorNotes,
        "risk_notes": riskNotes,
        "pay_or_service_rendered": payOrServiceRendered,
        "paymt_or_service_Date": paymtOrServiceDate,
        "pay_or_service_reference": payOrServiceReference,
        "last_position": lastPosition,
        "last_position_tab": lastPositionTab,
        "is_suicide": isSuicide,
        "is_underInvestigation": isUnderInvestigation,
        "place_of_death": placeOfDeath,
        "date_of_death": dateOfDeath,
        "marital_status": maritalStatus,
        "waiting_period": waitingPeriod,
        "waiting_period_type": waitingPeriodType,
        "death_certificate_no": deathCertificateNo,
        "cec_user_historyid": cecUserHistoryid,
        "cec_employeeid": cecEmployeeid,
        "action": action,
        "object": object,
        "extra1": extra1,
        "extra2": extra2,
        "extra3": extra3,
        "extra4": extra4,
        "extra5": extra5,
        "cec_client_id": cecClientId,
        "timestamp": timestamp,
        "result": result,
        "description": description,
        "year": year,
        "month": month,
        "day": day,
        "Main Cat": mainCat,
        "date": date,
        "time_diff_days": timeDiffDays,
        "time_diff_hours": timeDiffHours,
      };

  factory ClaimItem.empty() => ClaimItem(
        claimId: 0,
        claimClientId: 0,
        claimCellNumber: '',
        claimTitle: '',
        claimFirstName: '',
        claimLastName: '',
        claimStatus: '',
        claimDate: '',
        claimLastUpdate: '',
        claimOnololeadid: 0,
        claimReference: '',
        claimCreatedBy: 0,
        claimCompleteDate: '',
        claimAmount: 0.0,
        camAutonunber: 0,
        branchId: 0,
        policyNum: '',
        policyStatus: '',
        policyReference: '',
        policyLife: '',
        claimIdNum: '',
        claimDob: [],
        deathType: '',
        claimStatusDescription: '',
        synopsisStatus: '',
        policySynopsisRes: '',
        memberSynopsis: '',
        memberSynopsisReason: '',
        branchLeaderNotes: '',
        paymtOrServiceDate: '',
        lastPosition: '',
        lastPositionTab: 0,
        isSuicide: 0,
        isUnderInvestigation: 0,
        placeOfDeath: '',
        dateOfDeath: '',
        maritalStatus: '',
        waitingPeriod: 0,
        waitingPeriodType: '',
        cecUserHistoryid: 0,
        cecEmployeeid: 0,
        action: '',
        object: '',
        extra1: '',
        extra2: '',
        extra3: '',
        cecClientId: 0,
        timestamp: '',
        result: '',
        description: '',
        year: 0,
        month: '',
        day: 0,
        mainCat: '',
        date: '',
        timeDiffDays: 0.0,
        timeDiffHours: 0.0,
      );

  ClaimItem copyWith({
    int? claimId,
    int? claimClientId,
    String? claimCellNumber,
    String? claimTitle,
    String? claimFirstName,
    String? claimLastName,
    String? claimStatus,
    dynamic claimAssignedTo,
    dynamic claimClientEmail,
    dynamic claimHangUpDesc2,
    dynamic claimHangUpDesc3,
    dynamic claimNotes,
    dynamic claimCallCount,
    dynamic claimCallAttempt,
    dynamic claimCallTimeEllapsed,
    String? claimDate,
    String? claimLastUpdate,
    int? claimOnololeadid,
    String? claimReference,
    int? claimCreatedBy,
    String? claimCompleteDate,
    dynamic claimHangUpDesc1,
    dynamic claimHangUpReason,
    dynamic claimType,
    double? claimAmount,
    int? camAutonunber,
    int? branchId,
    String? policyNum,
    String? policyStatus,
    String? policyReference,
    String? policyLife,
    String? claimIdNum,
    List<String>? claimDob,
    String? deathType,
    String? claimStatusDescription,
    String? synopsisStatus,
    String? policySynopsisRes,
    String? memberSynopsis,
    String? memberSynopsisReason,
    String? branchLeaderNotes,
    String? assessorNotes,
    dynamic riskNotes,
    String? payOrServiceRendered,
    String? paymtOrServiceDate,
    String? payOrServiceReference,
    String? lastPosition,
    int? lastPositionTab,
    int? isSuicide,
    int? isUnderInvestigation,
    String? placeOfDeath,
    String? dateOfDeath,
    String? maritalStatus,
    int? waitingPeriod,
    String? waitingPeriodType,
    dynamic deathCertificateNo,
    int? cecUserHistoryid,
    int? cecEmployeeid,
    String? action,
    String? object,
    String? extra1,
    String? extra2,
    String? extra3,
    dynamic extra4,
    dynamic extra5,
    int? cecClientId,
    String? timestamp,
    String? result,
    String? description,
    int? year,
    String? month,
    int? day,
    String? mainCat,
    String? date,
    double? timeDiffDays,
    double? timeDiffHours,
  }) {
    return ClaimItem(
      claimId: claimId ?? this.claimId,
      claimClientId: claimClientId ?? this.claimClientId,
      claimCellNumber: claimCellNumber ?? this.claimCellNumber,
      claimTitle: claimTitle ?? this.claimTitle,
      claimFirstName: claimFirstName ?? this.claimFirstName,
      claimLastName: claimLastName ?? this.claimLastName,
      claimStatus: claimStatus ?? this.claimStatus,
      claimAssignedTo: claimAssignedTo ?? this.claimAssignedTo,
      claimClientEmail: claimClientEmail ?? this.claimClientEmail,
      claimHangUpDesc2: claimHangUpDesc2 ?? this.claimHangUpDesc2,
      claimHangUpDesc3: claimHangUpDesc3 ?? this.claimHangUpDesc3,
      claimNotes: claimNotes ?? this.claimNotes,
      claimCallCount: claimCallCount ?? this.claimCallCount,
      claimCallAttempt: claimCallAttempt ?? this.claimCallAttempt,
      claimCallTimeEllapsed:
          claimCallTimeEllapsed ?? this.claimCallTimeEllapsed,
      claimDate: claimDate ?? this.claimDate,
      claimLastUpdate: claimLastUpdate ?? this.claimLastUpdate,
      claimOnololeadid: claimOnololeadid ?? this.claimOnololeadid,
      claimReference: claimReference ?? this.claimReference,
      claimCreatedBy: claimCreatedBy ?? this.claimCreatedBy,
      claimCompleteDate: claimCompleteDate ?? this.claimCompleteDate,
      claimHangUpDesc1: claimHangUpDesc1 ?? this.claimHangUpDesc1,
      claimHangUpReason: claimHangUpReason ?? this.claimHangUpReason,
      claimType: claimType ?? this.claimType,
      claimAmount: claimAmount ?? this.claimAmount,
      camAutonunber: camAutonunber ?? this.camAutonunber,
      branchId: branchId ?? this.branchId,
      policyNum: policyNum ?? this.policyNum,
      policyStatus: policyStatus ?? this.policyStatus,
      policyReference: policyReference ?? this.policyReference,
      policyLife: policyLife ?? this.policyLife,
      claimIdNum: claimIdNum ?? this.claimIdNum,
      claimDob: claimDob ?? this.claimDob,
      deathType: deathType ?? this.deathType,
      claimStatusDescription:
          claimStatusDescription ?? this.claimStatusDescription,
      synopsisStatus: synopsisStatus ?? this.synopsisStatus,
      policySynopsisRes: policySynopsisRes ?? this.policySynopsisRes,
      memberSynopsis: memberSynopsis ?? this.memberSynopsis,
      memberSynopsisReason: memberSynopsisReason ?? this.memberSynopsisReason,
      branchLeaderNotes: branchLeaderNotes ?? this.branchLeaderNotes,
      assessorNotes: assessorNotes ?? this.assessorNotes,
      riskNotes: riskNotes ?? this.riskNotes,
      payOrServiceRendered: payOrServiceRendered ?? this.payOrServiceRendered,
      paymtOrServiceDate: paymtOrServiceDate ?? this.paymtOrServiceDate,
      payOrServiceReference:
          payOrServiceReference ?? this.payOrServiceReference,
      lastPosition: lastPosition ?? this.lastPosition,
      lastPositionTab: lastPositionTab ?? this.lastPositionTab,
      isSuicide: isSuicide ?? this.isSuicide,
      isUnderInvestigation: isUnderInvestigation ?? this.isUnderInvestigation,
      placeOfDeath: placeOfDeath ?? this.placeOfDeath,
      dateOfDeath: dateOfDeath ?? this.dateOfDeath,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      waitingPeriod: waitingPeriod ?? this.waitingPeriod,
      waitingPeriodType: waitingPeriodType ?? this.waitingPeriodType,
      deathCertificateNo: deathCertificateNo ?? this.deathCertificateNo,
      cecUserHistoryid: cecUserHistoryid ?? this.cecUserHistoryid,
      cecEmployeeid: cecEmployeeid ?? this.cecEmployeeid,
      action: action ?? this.action,
      object: object ?? this.object,
      extra1: extra1 ?? this.extra1,
      extra2: extra2 ?? this.extra2,
      extra3: extra3 ?? this.extra3,
      extra4: extra4 ?? this.extra4,
      extra5: extra5 ?? this.extra5,
      cecClientId: cecClientId ?? this.cecClientId,
      timestamp: timestamp ?? this.timestamp,
      result: result ?? this.result,
      description: description ?? this.description,
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      mainCat: mainCat ?? this.mainCat,
      date: date ?? this.date,
      timeDiffDays: timeDiffDays ?? this.timeDiffDays,
      timeDiffHours: timeDiffHours ?? this.timeDiffHours,
    );
  }
}

class ClaimsByCategory {
  final int lodging;
  final int processing;
  final int closed;
  final int declinedAndRepudiated;
  final int inProgress;
  final int paid;

  ClaimsByCategory({
    required this.lodging,
    required this.processing,
    required this.closed,
    required this.declinedAndRepudiated,
    required this.inProgress,
    required this.paid,
  });

  factory ClaimsByCategory.fromJson(Map<String, dynamic> json) =>
      ClaimsByCategory(
        lodging: json["Lodging"] ?? 0,
        processing: json["Processing"] ?? 0,
        closed: json["Closed"] ?? 0,
        declinedAndRepudiated: json["Declined And Repudiated"] ?? 0,
        inProgress: json["In Progress"] ?? 0,
        paid: json["Paid"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "Lodging": lodging,
        "Processing": processing,
        "Closed": closed,
        "Declined And Repudiated": declinedAndRepudiated,
        "In Progress": inProgress,
        "Paid": paid,
      };

  factory ClaimsByCategory.empty() => ClaimsByCategory(
        lodging: 0,
        processing: 0,
        closed: 0,
        declinedAndRepudiated: 0,
        inProgress: 0,
        paid: 0,
      );

  ClaimsByCategory copyWith({
    int? lodging,
    int? processing,
    int? closed,
    int? declinedAndRepudiated,
    int? inProgress,
    int? paid,
  }) {
    return ClaimsByCategory(
      lodging: lodging ?? this.lodging,
      processing: processing ?? this.processing,
      closed: closed ?? this.closed,
      declinedAndRepudiated:
          declinedAndRepudiated ?? this.declinedAndRepudiated,
      inProgress: inProgress ?? this.inProgress,
      paid: paid ?? this.paid,
    );
  }
}

class ClaimsByType {
  final int assessing;
  final int complete;
  final int intimation;

  ClaimsByType({
    required this.assessing,
    required this.complete,
    required this.intimation,
  });

  factory ClaimsByType.fromJson(Map<String, dynamic> json) => ClaimsByType(
        assessing: json["assessing"] ?? 0,
        complete: json["complete"] ?? 0,
        intimation: json["intimation"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "assessing": assessing,
        "complete": complete,
        "intimation": intimation,
      };

  factory ClaimsByType.empty() => ClaimsByType(
        assessing: 0,
        complete: 0,
        intimation: 0,
      );

  ClaimsByType copyWith({
    int? assessing,
    int? complete,
    int? intimation,
  }) {
    return ClaimsByType(
      assessing: assessing ?? this.assessing,
      complete: complete ?? this.complete,
      intimation: intimation ?? this.intimation,
    );
  }
}

class ClaimPercentageCategory {
  final TimeFrameDetails percentages;
  final TimeFrameDetails counts;
  final TimeFrameDetails amounts;

  ClaimPercentageCategory({
    required this.percentages,
    required this.counts,
    required this.amounts,
  });

  factory ClaimPercentageCategory.fromJson(Map<String, dynamic> json) =>
      ClaimPercentageCategory(
        percentages: TimeFrameDetails.fromJson(json["percentages"] ?? {}),
        counts: TimeFrameDetails.fromJson(json["counts"] ?? {}),
        amounts: TimeFrameDetails.fromJson(json["amounts"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "percentages": percentages.toJson(),
        "counts": counts.toJson(),
        "amounts": amounts.toJson(),
      };

  factory ClaimPercentageCategory.empty() => ClaimPercentageCategory(
        percentages: TimeFrameDetails.empty(),
        counts: TimeFrameDetails.empty(),
        amounts: TimeFrameDetails.empty(),
      );

  ClaimPercentageCategory copyWith({
    TimeFrameDetails? percentages,
    TimeFrameDetails? counts,
    TimeFrameDetails? amounts,
  }) {
    return ClaimPercentageCategory(
      percentages: percentages ?? this.percentages,
      counts: counts ?? this.counts,
      amounts: amounts ?? this.amounts,
    );
  }
}

class TimeFrameDetails {
  final dynamic within5Hours;
  final dynamic within12Hours;
  final dynamic within24Hours;
  final dynamic within48Hours;
  final dynamic after48Hours;
  final dynamic after5Days;

  TimeFrameDetails({
    required this.within5Hours,
    required this.within12Hours,
    required this.within24Hours,
    required this.within48Hours,
    required this.after48Hours,
    required this.after5Days,
  });

  factory TimeFrameDetails.fromJson(Map<String, dynamic> json) =>
      TimeFrameDetails(
        within5Hours: json["Within 5 Hours"],
        within12Hours: json["Within 12 Hours"],
        within24Hours: json["Within 24 Hours"],
        within48Hours: json["Within 48 Hours"],
        after48Hours: json["After 48 Hours"],
        after5Days: json["After 5 Days"],
      );

  Map<String, dynamic> toJson() => {
        "Within 5 Hours": within5Hours,
        "Within 12 Hours": within12Hours,
        "Within 24 Hours": within24Hours,
        "Within 48 Hours": within48Hours,
        "After 48 Hours": after48Hours,
        "After 5 Days": after5Days,
      };

  factory TimeFrameDetails.empty() => TimeFrameDetails(
        within5Hours: 0,
        within12Hours: 0,
        within24Hours: 0,
        within48Hours: 0,
        after48Hours: 0,
        after5Days: 0,
      );

  TimeFrameDetails copyWith({
    dynamic within5Hours,
    dynamic within12Hours,
    dynamic within24Hours,
    dynamic within48Hours,
    dynamic after48Hours,
    dynamic after5Days,
  }) {
    return TimeFrameDetails(
      within5Hours: within5Hours ?? this.within5Hours,
      within12Hours: within12Hours ?? this.within12Hours,
      within24Hours: within24Hours ?? this.within24Hours,
      within48Hours: within48Hours ?? this.within48Hours,
      after48Hours: after48Hours ?? this.after48Hours,
      after5Days: after5Days ?? this.after5Days,
    );
  }
}
