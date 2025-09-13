import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/Constants.dart';
import '../models/Parlour.dart';

import '../models/PolicyInfoLead.dart';
import '../models/ScriptConfig.dart';
import '../models/WaitingPeriods.dart';
import '../models/map_class.dart';
import '../screens/Sales Agent/universal_premium_calculator.dart';

Future<int> updateCallCenterLeadObjectDetails(LeadObject leadObject) async {
  const String endpoint = "onoloV6/updateLeadDetails";
  final String url = Constants.insightsBackendUrl + endpoint;

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(leadObject.toJson()),
    );

    // Check response status and content
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody == 1) {
        return 1;
      } else {
        return 0;
      }
    } else {
      // Handle non-200 responses
      return 0;
    }
  } catch (e) {
    // Handle any exceptions
    print("Error updating lead details: $e");
    return 0;
  }
}

class SalesService {
  Future<bool> updateLeadDetails(BuildContext context) async {
    String baseUrl = "${Constants.insightsBackendUrl}fieldV6/updateLeadDetails";
    print("Request URL: $baseUrl");

    try {
      if (Constants.currentleadAvailable == null) {
        print("No lead available to update.");
        return false;
      }

      LeadObject currentLeadObject = Constants.currentleadAvailable!.leadObject;

      // Convert the object to JSON
      final Map<String, dynamic> jsonBody = currentLeadObject.toJson();

      // Make the POST request with the correct content type
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json", // Specify the content type
          "Accept": "application/json", // Ensure server accepts JSON
        },
        body: jsonEncode(jsonBody), // Encode the body as JSON
      );

      if (kDebugMode) {
        print(
          "Response: ${response.statusCode} | Body: ${response.body} | JSON: $jsonBody",
        );
      }

      // Check response status and body
      if (response.statusCode == 200) {
        final responseBody =
            response.body.trim(); // Trim any surrounding whitespace or quotes

        if (responseBody == "1" || responseBody == '"1"') {
          // Success case
          if (kDebugMode) {
            print("Update successful: ${responseBody}");
          }
          return true;
        } else {
          // Handle unexpected response body
          print("Unexpected response body ghgg: ${responseBody}");
          return false;
        }
      } else {
        // Error case
        print("Error: ${response.reasonPhrase}");
        return false;
      }
    } catch (exception) {
      // Handle exception
      print("Exception occurred: ${exception.toString()}");
      return false;
    }
  }

  Future<List<ProductWaitingPeriod>> fetchGroupedProducts() async {
    final response = await http.get(
      Uri.parse(
        '${Constants.insightsBackendBaseUrl}parlour/getProductWaitingPeriods?client_name=${Constants.business_name}',
      ),
    );
    print(
      '${Constants.insightsBackendBaseUrl}parlour/getProductWaitingPeriods?client_name=${Constants.business_name}',
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<ProductWaitingPeriod> products =
          data.map((item) => ProductWaitingPeriod.fromJson(item)).toList();
      List<String> products_list = [];
      for (var policy in Constants.currentleadAvailable!.policies) {
        products_list.add(policy.quote.product);
      }

      // Group by productFamily and productName
      Map<String, ProductWaitingPeriod> grouped = {};

      for (var product in products) {
        final key = '${product.productFamily}-${product.productName}';
        if (grouped.containsKey(key)) {
          // Merge IDs and Types
          grouped[key] = ProductWaitingPeriod(
            id: '${grouped[key]!.id}, ${product.id}',
            productFamily: product.productFamily,
            productName: product.productName,
            waitingPeriod: product.waitingPeriod,
            type: '${grouped[key]!.type}, ${product.type}',
            companyName: product.companyName,
            deathType: product.deathType,
          );
        } else {
          grouped[key] = ProductWaitingPeriod(
            id: product.id.toString(),
            // Convert id to String for merging
            productFamily: product.productFamily,
            productName: product.productName,
            waitingPeriod: product.waitingPeriod,
            type: product.type,
            companyName: product.companyName,
            deathType: product.deathType,
          );
        }
      }

      return grouped.values.toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<ProductWaitingPeriod>> fetchGroupedAllProducts() async {
    final response = await http.get(
      Uri.parse(
        '${Constants.insightsBackendBaseUrl}parlour/getProductWaitingPeriods?client_name=${Constants.business_name}',
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<ProductWaitingPeriod> products =
          data.map((item) => ProductWaitingPeriod.fromJson(item)).toList();

      // Group by productFamily and productName
      Map<String, ProductWaitingPeriod> grouped = {};

      for (var product in products) {
        final key = '${product.productFamily}-${product.productName}';
        if (grouped.containsKey(key)) {
          // Merge IDs and Types
          grouped[key] = ProductWaitingPeriod(
            id: '${grouped[key]!.id}, ${product.id}',
            productFamily: product.productFamily,
            productName: product.productName,
            waitingPeriod: product.waitingPeriod,
            type: '${grouped[key]!.type},${product.type}',
            companyName: product.companyName,
            deathType: product.deathType,
          );
        } else {
          grouped[key] = ProductWaitingPeriod(
            id: product.id.toString(),
            // Convert id to String for merging
            productFamily: product.productFamily,
            productName: product.productName,
            waitingPeriod: product.waitingPeriod,
            type: product.type,
            companyName: product.companyName,
            deathType: product.deathType,
          );
        }
      }

      return grouped.values.toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<ScriptConfig> fetchScriptConfig() async {
    print("dfgfghfhg ${Constants.business_name}");
    final url =
        '${Constants.parlourConfigBaseUrl}parlour-config/client_script/?parlour=${Constants.business_name}&module=Sales&language=${Constants.currentUserLanguage}&username=test&password=12345';
    if (kDebugMode) {
      print(url);
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ScriptConfig.fromJson(data);
    } else {
      throw Exception('Failed to load script config');
    }
  }

  Future<ParlourConfig?> fetchParlourConfig(int clientId) async {
    //print("fdfggf $clientId");
    //clientId = 212;
    final url = Uri.parse(
        '${Constants.parlourConfigBaseUrl}parlour-config/get-parlour-rates-extras/?client_id=$clientId');

    final request = http.Request('GET', url);

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final jsonString = await response.stream.bytesToString();
        final parsedJson = json.decode(jsonString);
        final parlourConfig = ParlourConfig.fromJson(parsedJson);
        return parlourConfig;
      } else {
        print('Error: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }

  Future<SuccessResponse> endLeadCall({
    required LeadObject lead,
    required int empId,
  }) async {
    final headers = {'Content-Type': 'application/json'};

    final body = json.encode({"lead": lead.toJson(), "empId": empId});

    String baseUrlField = "${Constants.insightsBackendUrl}fieldV6/endCall";
    String baseUrl = "${Constants.insightsBackendUrl}onolo/endCall";
    debugPrint("Response statusCode: ${lead.toJson()}");

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: body,
    );

    debugPrint("Response statusCode: ${response.statusCode}");
    debugPrint("Response body: ${response.body}");

    if (response.statusCode == 200) {
      // Trim whitespace just to be safe
      final rawBody = response.body.trim();

      // If server literally returns "0" or "0" in quotes:
      if (rawBody == "0" || rawBody == '"0"') {
        // Option A: Return a basic, hardcoded success if "0" is your success condition
        return SuccessResponse(
          success: true,
          message: "Call ended successfully",
        );

        // Option B: If you really need to parse it with fromJson,
        // implement fromJson in a way that handles "0".
        // e.g. return SuccessResponse.fromJson(rawBody);
      } else {
        throw Exception("Unexpected response body: $rawBody");
      }
    } else {
      throw Exception("Request failed: ${response.reasonPhrase}");
    }
  }

  Future<bool> updateAvailability(
    BuildContext context,
    String status,
    String breakType,
  ) async {
    final url = Uri.parse(
      "${Constants.InsightsAdminbaseUrl}/onolo/updateAvailability",
    );

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "cec_employeeid": Constants.cec_employeeid,
          "status": status,
          "cec_client_id": Constants.cec_client_id,
          "status_start_time": "",
          "customer_number": "",
          "break_type": breakType,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (kDebugMode) {
          // print("fgfgfgh $responseData");
          // print(responseData.runtimeType.toString());
        }

        if (responseData is String && responseData == "1") {
          return true;
        }
      }

      return false;
    } catch (e) {
      print("Error updating availability: $e");
      return false;
    }
  }

  Future<bool> updatePolicyMaint(
      PolicyInfoLead lead, BuildContext context) async {
    final String url = "${Constants.insightsBackendUrl}parlour/updatePolicy";
    Future.delayed(Duration(seconds: 2), () {});
    try {
      Map<String, dynamic> formData = {
        "policy": lead.policies.map((policy) => policy.toJson()).toList(),
        "updated_by": Constants.cec_employeeid.toString(),
        "query_type": "New Business",
        "isMaintenance": true,
      };

      if (kDebugMode) {
        //print("Sending JSON payload: ${jsonEncode(formData)}");
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json", // Use JSON content type
          "Accept": "application/json",
        },
        body: jsonEncode(formData),
      );

      if (kDebugMode) {
        print("Response code wwwq : ${response.statusCode}");
        print("Response body wq212: ${response.body}");
      }

      if (response.statusCode == 200) {
        /*  MotionToast.success(
            height: 45,
            width: 280,
            onClose: () {},
            description: Text(
              response.body.toString().replaceAll("-", ""),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontFamily: 'YuGothic',
              ),
            ),
          ).show(context);*/
        /*final bodyTrimmed = response.body.trim();
          if (bodyTrimmed == "1" || bodyTrimmed == "\"1\"") {
            return true;
          } else {
            print("Server response not recognized: $bodyTrimmed");
            return true;
          }*/
        return true;
      } else {
        print("Error from server: ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }

  Future<bool> updatePolicy(Lead lead, BuildContext context) async {
    final String url = "${Constants.insightsBackendUrl}parlour/updatePolicy";
    Future.delayed(Duration(seconds: 2), () {});
    try {
      Map<String, dynamic> formData = {
        "policy": lead.policies.map((policy) => policy.toJson()).toList(),
        "updated_by": Constants.cec_employeeid.toString(),
        "query_type": "New Business",
        "isMaintenance": false,
      };

      if (kDebugMode) {
        //print("Sending JSON payload: ${jsonEncode(formData)}");
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json", // Use JSON content type
          "Accept": "application/json",
        },
        body: jsonEncode(formData),
      );

      if (kDebugMode) {
        print("Response code wwwq : ${response.statusCode}");
        print("Response body wq213: ${response.body}");
      }

      if (response.statusCode == 200) {
        /*  MotionToast.success(
          height: 45,
          width: 280,
          onClose: () {},
          description: Text(
            response.body.toString().replaceAll("-", ""),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontFamily: 'YuGothic',
            ),
          ),
        ).show(context);*/
        /*final bodyTrimmed = response.body.trim();
        if (bodyTrimmed == "1" || bodyTrimmed == "\"1\"") {
          return true;
        } else {
          print("Server response not recognized: $bodyTrimmed");
          return true;
        }*/
        return true;
      } else {
        print("Error from server: ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }

  Future<bool> updatePolicyMaintanance(
      PolicyInfoLead lead, BuildContext context) async {
    final String url = "${Constants.insightsBackendUrl}parlour/updatePolicy";
    Future.delayed(Duration(seconds: 2), () {});
    try {
      Map<String, dynamic> formData = {
        "policy": lead.policies.map((policy) => policy.toJson()).toList(),
        "updated_by": Constants.cec_employeeid.toString(),
        "query_type": "New Business",
        "isMaintenance": true,
      };

      if (kDebugMode) {
        //print("Sending JSON payload: ${jsonEncode(formData)}");
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json", // Use JSON content type
          "Accept": "application/json",
        },
        body: jsonEncode(formData),
      );

      if (kDebugMode) {
        print("Response code wwwq : ${response.statusCode}");
        print("Response body wq212: ${response.body}");
      }

      if (response.statusCode == 200) {
        /*  MotionToast.success(
            height: 45,
            width: 280,
            onClose: () {},
            description: Text(
              response.body.toString().replaceAll("-", ""),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontFamily: 'YuGothic',
              ),
            ),
          ).show(context);*/
        /*final bodyTrimmed = response.body.trim();
          if (bodyTrimmed == "1" || bodyTrimmed == "\"1\"") {
            return true;
          } else {
            print("Server response not recognized: $bodyTrimmed");
            return true;
          }*/
        return true;
      } else {
        print("Error from server: ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }

  Future<void> fetchAndStoreParlourRates() async {
    final url = Uri.parse(
      "${Constants.parlourConfigBaseUrl}/parlour-config/get-parlour-rates-extras/?client_id=${Constants.cec_client_id}",
    );

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        Constants.currentParlourConfig = ParlourConfig.fromJson(jsonResponse);

        if (Constants.currentParlourConfig != null &&
            Constants.currentParlourConfig!.mainRates.isNotEmpty) {
          print(
            "First Product: ${Constants.currentParlourConfig!.mainRates.first.product}",
          );
          print(
            "First ProdType: ${Constants.currentParlourConfig!.mainRates.first.prodType}",
          );
        } else {
          print("No main rates found.");
        }
      } else {
        print("Failed to fetch data: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<bool> createNewPolicy({
    required int leadId,
    required int additionalMemberId,
    required String productType,
    required String reference,
    required String productFamily,
    required int clientId,
  }) async {
    final String url =
        "${Constants.insightsBackendUrl}parlour/newPolicy?leadid=${leadId}&additional_member_id=${additionalMemberId}&product_type=${productType}&reference=${reference}&productFamily=${productFamily}&client_id=${clientId}";

    try {
      // Construct the request body
      final Map<String, dynamic> requestBody = {
        "leadid": leadId,
        "additional_member_id": additionalMemberId,
        "product_type": productType,
        "reference": reference,
        "productFamily": productFamily,
        "client_id": clientId,
      };

      // Debugging
      print("Request URL: $url");
      print("Request Body: ${jsonEncode(requestBody)}");

      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      // Debugging
      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // Check response
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody is Map && responseBody["reference"] != null) {
          print(
            "New Policy created successfully: ${responseBody["reference"]}",
          );
          Policy newPolicy = Policy.fromJson(
            Map<String, dynamic>.from(responseBody),
          );

          if (Constants.currentleadAvailable != null) {
            //Constants.currentleadAvailable!.policies.add(newPolicy);
            // mySalesPremiumCalculatorValue.value++;
          }

          return true;
        } else {
          print("Unexpected response: $responseBody");
          return false;
        }
      } else {
        print("Failed to create policy: ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }

  void updateLeadPoliciesWithPremiumResponse(
    Lead lead,
    List<CalculatePolicyPremiumResponse> responses,
    List<InsurancePlan> insurancePlan,
    bool showPopup,
    BuildContext context,
  ) {
    // Loop over the policies. (Use the minimum length in case they don't match exactly.)
    int count = lead.policies.length;
    int responseCount = responses.length;
    int planCount = insurancePlan.length;

    print(
        "Policy counts - Lead: $count, Responses: $responseCount, Plans: $planCount");

    // Use the minimum count to avoid index out of bounds
    int minCount =
        [count, responseCount, planCount].reduce((a, b) => a < b ? a : b);

    for (int i = 0; i < minCount; i++) {
      final premiumResponse = responses[i];

      // Only update if the calculated total premium is non-null and greater than zero.
      if (premiumResponse.totalPremium != null &&
          premiumResponse.totalPremium! > 0) {
        Policy policy = lead.policies[i];

        // Calculate total premium for all selected riders
        double selectedRidersTotal = 0.0;

        // Check if riders exist and are not null
        if (Constants.currentleadAvailable?.policies != null &&
            i < Constants.currentleadAvailable!.policies.length &&
            Constants.currentleadAvailable!.policies[i].riders != null) {
          for (var rider
              in Constants.currentleadAvailable!.policies[i].riders!) {
            var riderPremium = rider["premium"];
            if (riderPremium != null) {
              // Convert riderPremium to double if necessary.
              double premiumValue;
              if (riderPremium is num) {
                premiumValue = riderPremium.toDouble();
              } else {
                premiumValue = double.tryParse(riderPremium.toString()) ?? 0.0;
              }
              // Add to total instead of replacing
              selectedRidersTotal += premiumValue;
            }
          }
        }

        print(
            "Policy $i - Base Premium: ${premiumResponse.totalPremium}, Riders Total: $selectedRidersTotal");

        // Update the quote with calculated values
        if (Constants.currentleadAvailable?.policies != null &&
            i < Constants.currentleadAvailable!.policies.length) {
          // Set the base premium from API response
          Constants.currentleadAvailable!.policies[i].quote.totalPremium =
              premiumResponse.totalPremium;

          // Set the riders total
          Constants.currentleadAvailable!.policies[i].quote
              .totalBenefitPremium = selectedRidersTotal;

          // Calculate total amount payable (base premium + riders)
          double totalAmountPayable =
              (premiumResponse.totalPremium ?? 0.0) + selectedRidersTotal;
          Constants.currentleadAvailable!.policies[i].quote.totalAmountPayable =
              totalAmountPayable + (premiumResponse.joiningFee ?? 0.0);

          print("Policy $i - Total Amount Payable: $totalAmountPayable");
        }

        // Update the main sum assured and product type on the local policy object
        if (i < insurancePlan.length) {
          policy.quote.sumAssuredFamilyCover = insurancePlan[i].coverAmount;
          policy.quote.productType = insurancePlan[i].prodType!;
          policy.quote.product = insurancePlan[i].product!;
        }
      } else {
        print(
            "Policy $i - Skipped: Invalid premium response (${premiumResponse.totalPremium})");
      }
    }

    updatePolicy(lead, context);
  }

  void updateLeadMaintPoliciesWithPremiumResponse(
    PolicyInfoLead lead,
    List<CalculatePolicyPremiumResponse> responses,
    List<InsurancePlan> insurancePlan,
    bool showPopup,
    BuildContext context,
  ) {
    // Loop over the policies. (Use the minimum length in case they don't match exactly.)
    int count = lead.policies.length;
    int responseCount = responses.length;
    int planCount = insurancePlan.length;

    print(
        "Policy counts - Lead: $count, Responses: $responseCount, Plans: $planCount");

    // Use the minimum count to avoid index out of bounds
    int minCount =
        [count, responseCount, planCount].reduce((a, b) => a < b ? a : b);

    for (int i = 0; i < minCount; i++) {
      final premiumResponse = responses[i];

      // Only update if the calculated total premium is non-null and greater than zero.
      if (premiumResponse.totalPremium != null &&
          premiumResponse.totalPremium! > 0) {
        Policy policy = lead.policies[i];

        // Calculate total premium for all selected riders
        double selectedRidersTotal = 0.0;

        // Check if riders exist and are not null
        if (Constants.currentPolicyInfoleadAvailable?.policies != null &&
            i < Constants.currentPolicyInfoleadAvailable!.policies.length &&
            Constants.currentPolicyInfoleadAvailable!.policies[i].riders !=
                null) {
          for (var rider in Constants
              .currentPolicyInfoleadAvailable!.policies[i].riders!) {
            var riderPremium = rider["premium"];
            if (riderPremium != null) {
              // Convert riderPremium to double if necessary.
              double premiumValue;
              if (riderPremium is num) {
                premiumValue = riderPremium.toDouble();
              } else {
                premiumValue = double.tryParse(riderPremium.toString()) ?? 0.0;
              }
              // Add to total instead of replacing
              selectedRidersTotal += premiumValue;
            }
          }
        }

        print(
            "Policy $i - Base Premium: ${premiumResponse.totalPremium}, Riders Total: $selectedRidersTotal");

        // Update the quote with calculated values
        if (Constants.currentPolicyInfoleadAvailable?.policies != null &&
            i < Constants.currentPolicyInfoleadAvailable!.policies.length) {
          // Set the base premium from API response
          Constants.currentPolicyInfoleadAvailable!.policies[i].quote
              .totalPremium = premiumResponse.totalPremium;

          // Set the riders total
          Constants.currentPolicyInfoleadAvailable!.policies[i].quote
              .totalBenefitPremium = selectedRidersTotal;

          // Calculate total amount payable (base premium + riders)
          double totalAmountPayable =
              (premiumResponse.totalPremium ?? 0.0) + selectedRidersTotal;
          Constants.currentPolicyInfoleadAvailable!.policies[i].quote
                  .totalAmountPayable =
              totalAmountPayable + (premiumResponse.joiningFee ?? 0.0);

          print("Policy $i - Total Amount Payable: $totalAmountPayable");
        }

        // Update the main sum assured and product type on the local policy object
        if (i < insurancePlan.length) {
          policy.quote.sumAssuredFamilyCover = insurancePlan[i].coverAmount;
          policy.quote.productType = insurancePlan[i].prodType!;
          policy.quote.product = insurancePlan[i].product!;
        }
      } else {
        print(
            "Policy $i - Skipped: Invalid premium response (${premiumResponse.totalPremium})");
      }
    }

    updatePolicyMaint(lead, context);
  }

  Future<Lead?> getPolicyInfo(String reference) async {
    //Obtain lead information by policy reference
    final String fetchUrl =
        "${Constants.insightsBackendUrl}onoloV6/getPolicyInfo?reff=$reference&cec_client_id=${Constants.cec_client_id}";
    if (kDebugMode) {
      print("dffgfg $fetchUrl");
    }

    try {
      final response = await http.get(Uri.parse(fetchUrl));
      print("gfgggh1 ${response.body}");
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Pass the entire responseData to PolicyInfoLead.fromJson()
        // This allows access to root-level fields like msgReinstate, msgRestart, etc.
        Constants.currentPolicyInfoleadAvailable =
            PolicyInfoLead.fromJson(responseData);

        policyPremiums = [];

        // Still return the Lead from the nested structure
        if (responseData["Lead"] != null &&
            responseData["Lead"] is List &&
            (responseData["Lead"] as List).isNotEmpty) {
          return Lead.fromJson(responseData["Lead"][0]);
        }
      } else {
        print("Failed to fetch lead by ID: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching lead by ID: $error");
    }
    return null;
  }

  Future<Lead?> getLeadById(String leadId) async {
    final String fetchUrl =
        "${Constants.insightsBackendUrl}parlour/getLeadById?onololeadid=$leadId&cec_client_id=${Constants.cec_client_id}";
    if (kDebugMode) {
      print("dffgfg $fetchUrl");
    }

    try {
      final response = await http.get(Uri.parse(fetchUrl));
      print("gfgggh1 ${response.body}");
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Constants.currentleadAvailable = Lead.fromJson(responseData[0]);

        Constants.currentleadAvailable = Lead.fromJson(responseData[0]);

        policyPremiums = [];

        //print("got lead 2yuyf ${responseData}");
        return Lead.fromJson(responseData[0]);
      } else {
        print("Failed to fetch lead by ID: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching lead by ID: $error");
    }
    return null;
  }

  Future<void> updateMember2(
    BuildContext context,
    Map<String, dynamic> member,
  ) async {
    String baseUrl =
        "${Constants.insightsBackendBaseUrl}parlour/editBeneficiary";

    int onoloadId = Constants.currentleadAvailable!.leadObject.onololeadid;

    // print("Base URL: $baseUrl");
    // print("onoloadId: $onoloadId");
    // print("AutoNumber to update: $autoNumber");

    try {
      // Prepare headers
      var headers = {'Content-Type': 'application/json'};

      // Prepare the payload
      Map<String, dynamic> payload = member;

      print("Payload for updatehhj: $payload");

      var request = http.Request('POST', Uri.parse(baseUrl));
      request.body = json.encode(payload);
      request.headers.addAll(headers);

      // Send the update request
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      print("Response body8hgghf: $responseBody");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(responseBody);
        if (responseData.toString() == "1") {
          print(
            "Member updated successfully. AutoNumber: ${member['autoNumber']}",
          );
        } else {}
      } else {
        print("Failed to update member: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error occurred while updating member: $e");
    }
  }

  Future<bool> addMemberToPolicy(
    Map<String, dynamic> payload,
    BuildContext context,
  ) async {
    // Replace with your actual endpoint URL.
    final String url =
        "${Constants.InsightsAdminbaseUrl}parlour/addBeneficiary";

    print("Add Beneficiary Payload: $payload");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );
      int onoloadId = Constants.currentleadAvailable!.leadObject.onololeadid;
      print("Beneficiary response body ${response.body} ${onoloadId}");

      if (response.statusCode == 200) {
        // Optionally decode response or create a Member from jsonResponse.
        // final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print("Beneficiary added successfully.");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Sends a request to remove a beneficiary by posting the member's JSON.
  /// Returns true if removal was successful, false otherwise.
  Future<bool> removeMemberToPolicy(
    Member member,
    String currentReference,
    BuildContext context,
  ) async {
    final String url =
        "${Constants.InsightsAdminbaseUrl}parlour/removeBeneficiary";

    print("Remove Beneficiary Payload: ${member.toJson()}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(member.toJson()),
      );
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        String result = response.body;
        print("Remove beneficiary Response: $result");

        // If the delete command returns "0", no rows were deleted.
        if (result == "0") {
          print("Beneficiary removal failed: no record found.");
          return false;
        }

        print("Beneficiary removed successfully.");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

class SuccessResponse {
  final bool success;
  final String message;

  SuccessResponse({required this.success, required this.message});

  // Example of a custom parser:
  factory SuccessResponse.fromJson(String rawBody) {
    // If the server only returns a "0" string, treat that as success
    if (rawBody.trim() == "0" || rawBody.trim() == '"0"') {
      return SuccessResponse(success: true, message: "Call ended successfully");
    }

    throw Exception("Unexpected response body: $rawBody");
  }
}

/// Updates each policy’s quote on the [lead] using the corresponding premium response.
/// For each policy, if the calculated total premium is not 0, it:
///   - Updates the quote’s totalPremium,
///   - (Optionally) updates the product (if new product info is available),
///   - Updates the main sum assured (here assumed to be sumAssuredFamilyCover).
