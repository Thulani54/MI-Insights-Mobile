import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants/Constants.dart';
import '../models/PolicyDetails.dart';

List<PolicyDetails> policydetails = [];
void loginservice(String phoneNumber, String searchVal, String token) async {
  Constants.selectedPolicydetails = [];
  String urlPath = "/parlour/getpolicyinfo//";
  String apiUrl = Constants.insightsbaseUrl + urlPath;

  Map<String, dynamic> requestBody = {
    "empNum": phoneNumber,
    "searchVal": searchVal,
    "token": token,
  };

  try {
    var response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode(requestBody),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("data $data");
      print("data ${data["success"].runtimeType}");
      if (data["success"] == false) {
      } else {
        List dataList = data["message"];
        dataList.forEach((element) {
          String paymentStatus = element["paymentStatus"];
          print("paymentStatus $paymentStatus");
          Constants.cec_empid = element["querying_emp_id"];
          Constants.user_reference =
              element["Lead"][0]["policy"][0]["reference"].toString();
          print("user_reference1 ${Constants.user_reference}");
          Constants.cec_client_id = element["Lead"][0]["lead"]["cec_client_id"];
          Constants.customer_id_number =
              element["Lead"][0]["lead"]["customer_id_number"];
          Constants.customer_first_name =
              element["Lead"][0]["lead"]["first_name"];
          Constants.customer_last_name =
              element["Lead"][0]["lead"]["last_name"];
          Constants.cell_number = element["Lead"][0]["lead"]["cell_number"];
          List<dynamic> lst2 = element["Lead"];
          lst2.forEach((element) {
            Map mxcf = element as Map;
            String plantype = mxcf["policy"][0]["qoute"]["product_type"];
            String policynumber = mxcf["policy"][0]["qoute"]["policy_number"];
            String status = mxcf["policy"][0]["qoute"]["status"];
            double totalAmountPayable =
                mxcf["policy"][0]["qoute"]["totalAmountPayable"];
            String inceptionDate = mxcf["policy"][0]["qoute"]["inceptionDate"];
            String inforce_date = mxcf["policy"][0]["qoute"]["inforce_date"];
            double sumAssuredFamilyCover =
                mxcf["policy"][0]["qoute"]["sumAssuredFamilyCover"];
            Constants.cec_empname = data["message"][0]["querying_emp_name"];
            Constants.cec_logo = data["message"][0]["logo"];
            if (kDebugMode) {
              print(paymentStatus);

              print("plantype $plantype");
              print("cec_client_id ${Constants.cec_client_id}");
              print("cell_number ${Constants.cell_number}");
              print("customer_id_number ${Constants.customer_id_number}");
              print(
                  "cec_empid ${data["message"][0]["querying_emp_id"].runtimeType} ${data["message"][0]["querying_emp_id"]}");

              print(
                  "cec_emp_name ${data["message"][0]["querying_emp_name"].runtimeType} ${data["message"][0]["querying_emp_name"]}");
              print(
                  "cec_logo ${data["message"][0]["logo"].runtimeType} ${data["message"][0]["logo"]}");
              print("policynumber $policynumber");
              print("status $status");
              print("totalAmountPayable $totalAmountPayable");
              print("inceptionDate $inceptionDate");
              print("inforce_date $inforce_date");
              print("sumAssuredFamilyCover $sumAssuredFamilyCover");
              print(data);
              print(data["message"][0]["Lead"][0]["policy"][0]["qoute"]);
            }
            policydetails.add(PolicyDetails(
                policyNumber: policynumber,
                planType: plantype,
                status: status,
                monthsToPayFor: 1,
                paymentStatus: paymentStatus,
                paymentsBehind: 2,
                inforce_date: inforce_date,
                monthlyPremium: totalAmountPayable,
                benefitAmount: sumAssuredFamilyCover,
                inceptionDate: inceptionDate,
                acceptTerms: false,
                customer_id_number: '',
                customer_first_name: '',
                customer_last_name: '',
                customer_contact: ''));
            /* policydetails.add(PolicyDetails(
                policyNumber: policynumber,
                planType: plantype,
                status: status,
                monthsToPayFor: 1,
                paymentStatus: paymentStatus,
                paymentsBehind: 2,
                monthlyPremium: totalAmountPayable,
                benefitAmount: sumAssuredFamilyCover,
                acceptTerms: false));*/
          });
        });
      }
      //Constants.client_previous_transactions = data;
      String paymentStatus = data["message"][0]["paymentStatus"];
      Constants.cec_empid = data["message"][0]["querying_emp_id"];
      Constants.user_reference =
          data["message"][0]["Lead"][0]["policy"][0]["reference"].toString();
      print("user_reference ${Constants.user_reference}");
      Constants.cec_client_id =
          data["message"][0]["Lead"][0]["lead"]["cec_client_id"];

      print("Request failed with status: ${response.statusCode}");
    }
  } catch (error) {
    print("Error: $error");
  }
}
