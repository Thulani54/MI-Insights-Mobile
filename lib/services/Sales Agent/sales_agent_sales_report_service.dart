import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants/Constants.dart';
import '../../models/SalesByAgent.dart';
import '../../screens/Sales Agent/SalesAgentSalesReport.dart';
import '../longPrint.dart';

Future<void> getSalesAgentSalesReport(String date_from, String date_to,
    int selectedButton1, int days_difference, BuildContext context) async {
  try {
    if (kDebugMode) {
      // print("baseUrl $baseUrl");
    }

    String baseUrl =
        "https://miinsightsapps.net/files/get_sales_data_by_agent/";
    if (selectedButton1 == 1) {
      isSalesDataLoading1a = true;
    } else if (selectedButton1 == 2) {
      isSalesDataLoading2a = true;
    } else if (selectedButton1 == 3 && days_difference <= 31) {
      isSalesDataLoading3a = true;
    } else if (selectedButton1 == 3 && days_difference > 31) {
      isSalesDataLoading3b = true;
    }
    // print("ggfgghjhj ${Constants.cec_employeeid}");

    Map<String, String>? payload = {
      "client_id": "${Constants.cec_client_id}",
      "start_date": date_from,
      "end_date": date_to,
      "cec_employee_id": "${Constants.cec_employeeid}"
    };
    await http
        .post(
            Uri.parse(
              baseUrl,
            ),
            body: payload)
        .then((value) {
      http.Response response = value;

      if (response.statusCode != 200) {
        print("fgffhhhg_sales0 ${response.body}");
        if (selectedButton1 == 1) isSalesDataLoading1a = false;
        if (selectedButton1 == 2) isSalesDataLoading2a = false;
        if (selectedButton1 == 3) isSalesDataLoading3a = false;
        if (selectedButton1 == 4) isSalesDataLoading3b = false;
        Constants.sales_sectionsList1a_sales_agent[0].amount = 0;
        Constants.sales_sectionsList1a_sales_agent[1].amount = 0;
        Constants.sales_sectionsList1a_sales_agent[2].amount = 0;
        salesValue.value++;
      } else {
        salesValue.value++;

        var jsonResponse = jsonDecode(response.body);
        if (selectedButton1 == 1) {
          Constants.sales_maxY =
              ((jsonResponse["daily_or_monthlya"] ?? 0) * 1.1).round();
          Constants.sales_bar_maxY1a =
              ((jsonResponse["branch_maxYa"] ?? 0) * 1.1).round();
          Constants.sales_bar_maxY1b =
              ((jsonResponse["branch_maxYb"] ?? 0) * 1.1).round();
          Constants.sales_bar_maxY1c =
              ((jsonResponse["branch_maxYc"] ?? 0) * 1.1).round();
          Constants.salesByAgentSales1a = [];
          Constants.salesByAgentSales1b = [];
          Constants.salesByAgentSales1c = [];
          if (jsonResponse["sales_list"] != null) {
            List all_sales = jsonResponse["sales_list"];
            Constants.sales_sectionsList1a_sales_agent[0].amount = 0;
            Constants.sales_sectionsList1a_sales_agent[1].amount = 0;
            Constants.sales_sectionsList1a_sales_agent[2].amount = 0;
            for (var element in all_sales) {
              // print(element);
              Map<String, dynamic> m1 = element as Map<String, dynamic>;
              print("dfhhghg ${element}");
              if (m1["actual_status"] == "Inforced") {
                Constants.sales_sectionsList1a_sales_agent[0].amount++;
                Constants.salesByAgentSales1a.add(SalesByAgentSale(
                  m1["policy_number"] ??
                      "", // Provide a default empty string if null
                  m1["inforce_date"] ?? "",
                  m1["sale_datetime"] ?? "",
                  m1["product"] ?? "",
                  m1["product_type"] ?? "",
                  m1["payment_type"] ?? "",
                  double.parse((m1["totalAmountPayable"] ?? 0).toString()),
                  m1["status"] ?? "",
                  m1["actual_status"] ?? "",
                  m1["description"] ?? "",
                  m1["reference"] ?? "",
                ));
              } else if (m1["actual_status"] == "Pending Inforce") {
                Constants.sales_sectionsList1a_sales_agent[1].amount++;
                Constants.salesByAgentSales1b.add(SalesByAgentSale(
                  m1["policy_number"] ?? "",
                  m1["inforce_date"] ?? "",
                  m1["sale_datetime"] ?? "",
                  m1["product"] ?? "",
                  m1["product_type"] ?? "",
                  m1["payment_type"] ?? "",
                  double.parse((m1["totalAmountPayable"] ?? 0).toString()),
                  m1["status"] ?? "",
                  m1["actual_status"] ?? "",
                  m1["description"] ?? "",
                  m1["reference"] ?? "",
                ));
              } else if (m1["actual_status"] != "Inforced") {
                print("hhgghg ${m1}");

                Constants.sales_sectionsList1a_sales_agent[2].amount++;
                if (m1["policy_number"] != null &&
                    m1["actual_status"] != null) {
                  String actul_status = "";
                  String policy_number = "";
                  if (m1["policy_number"] != null &&
                      m1["policy_number"] != "") {
                    policy_number = m1["policy_number"];
                  } else if (m1["reference"] != null && m1["reference"] != "") {
                    policy_number = m1["reference"];
                  } else {
                    policy_number = "Not assigned.";
                  }
                  if (m1["actual_status"] != null &&
                      m1["actual_status"] != "") {
                    actul_status = m1["actual_status"];
                  } else if (m1["status"] != null && m1["status"] != "") {
                    actul_status = m1["status"];
                  } else {
                    actul_status = "Rejected";
                  }
                  print(
                      "fghgvx6e ${m1["policy_number"]} ${policy_number} - ${m1["description"]} ${m1["lead_description"]}");
                  Constants.salesByAgentSales1c.add(SalesByAgentSale(
                    policy_number,
                    m1["inforce_date"] ?? "",
                    m1["sale_datetime"] ?? "",
                    m1["product"] ?? "",
                    m1["product_type"] ?? "",
                    m1["payment_type"] ?? "",
                    double.parse((m1["totalAmountPayable"] ?? 0).toString()),
                    m1["status"] ?? "",
                    actul_status,
                    m1["description"] ?? m1["lead_description"],
                    policy_number,
                  ));
                }
              }
            }
          }

          Constants.salesByAgentSales1a.toSet().toList();
          Constants.salesByAgentSales1b.toSet().toList();
          Constants.salesByAgentSales1c.toSet().toList();
          sales_jsonResponse1a =
              jsonResponse["products_group"] as Map<String, dynamic>;
          isSalesDataLoading1a = false;
          salesValue.value++;
        } else if (selectedButton1 == 2) {
          print("fggffg $jsonResponse");
          Constants.sales_sectionsList2a_sales_agent[0].amount = 0;
          Constants.sales_sectionsList2a_sales_agent[1].amount = 0;
          Constants.sales_sectionsList2a_sales_agent[2].amount = 0;

          Constants.sales_maxY =
              ((jsonResponse["daily_or_monthlya"] ?? 0) * 1.1).round();
          Constants.sales_bar_maxY2a =
              ((jsonResponse["branch_maxYa"] ?? 0) * 1.1).round();
          Constants.sales_bar_maxY2b =
              ((jsonResponse["branch_maxYb"] ?? 0) * 1.1).round();
          Constants.sales_bar_maxY2c =
              ((jsonResponse["branch_maxYc"] ?? 0) * 1.1).round();
          Constants.salesByAgentSales2a = [];
          Constants.salesByAgentSales2b = [];
          Constants.salesByAgentSales2c = [];
          if (jsonResponse["sales_list"] != null) {
            List all_sales = jsonResponse["sales_list"];
            for (var element in all_sales) {
              Constants.sales_sectionsList2a_sales_agent[0].amount++;
              if (kDebugMode) {
                print(element);
              }
              Map<String, dynamic> m1 = element as Map<String, dynamic>;
              if (m1["actual_status"] == "Inforced") {
                Constants.salesByAgentSales2a.add(SalesByAgentSale(
                  m1["policy_number"] ?? "",
                  // Provide a default empty string if null
                  m1["inception_date"] ?? "",
                  m1["sale_datetime"] ?? "",
                  m1["product"] ?? "",
                  m1["product_type"] ?? "",
                  m1["payment_type"] ?? "",
                  double.parse((m1["totalAmountPayable"] ?? 0).toString()),
                  m1["status"] ?? "",
                  m1["actual_status"] ?? m1["status"],
                  m1["description"] ?? "",
                  m1["reference"] ?? "",
                ));
              } else if (m1["actual_status"] == "Pending Inforce") {
                Constants.sales_sectionsList2a_sales_agent[1].amount++;
                Constants.salesByAgentSales2b.add(SalesByAgentSale(
                  m1["policy_number"] ?? "",
                  m1["inception_date"] ?? "",
                  m1["sale_datetime"] ?? "",
                  m1["product"] ?? "",
                  m1["product_type"] ?? "",
                  m1["payment_type"] ?? "",
                  double.parse((m1["totalAmountPayable"] ?? 0).toString()),
                  m1["status"] ?? "",
                  m1["actual_status"] ?? m1["status"],
                  m1["description"] ?? "",
                  m1["reference"] ?? "",
                ));
              } else if (m1["actual_status"] != "Inforced") {
                if (m1["policy_number"] != null &&
                    m1["actual_status"] != null) {
                  Constants.sales_sectionsList2a_sales_agent[2].amount++;
                }
                if (m1["policy_number"] != null &&
                    m1["actual_status"] != null) {
                  if (m1["policy_number"] != null &&
                      m1["actual_status"] != null) {
                    String actual_status = "";
                    String policy_number = "";
                    if (m1["policy_number"] != null &&
                        m1["policy_number"] != "") {
                      policy_number = m1["policy_number"];
                    } else if (m1["reference"] != null &&
                        m1["reference"] != "") {
                      policy_number = m1["reference"];
                    } else {
                      policy_number = "Policy Number not assigned.";
                    }
                    if (m1["actual_status"] != null &&
                        m1["actual_status"] != "") {
                      actual_status = m1["actual_status"];
                    } else if (m1["status"] != null && m1["status"] != "") {
                      actual_status = m1["status"];
                    } else {
                      actual_status = "Rejected";
                    }

                    Constants.salesByAgentSales2c.add(SalesByAgentSale(
                      m1["policy_number"] ?? "",
                      m1["inception_date"] ?? "",
                      m1["sale_datetime"] ?? "",
                      m1["product"] ?? "",
                      m1["product_type"] ?? "",
                      m1["payment_type"] ?? "",
                      double.parse((m1["totalAmountPayable"] ?? 0).toString()),
                      m1["status"] ?? "",
                      actual_status,
                      m1["description"] ?? "",
                      policy_number,
                    ));
                  }
                }
              }
            }

            Constants.salesByAgentSales2a.toSet().toList();
            Constants.salesByAgentSales2b.toSet().toList();
            Constants.salesByAgentSales2c.toSet().toList();
            sales_jsonResponse2a =
                jsonResponse["products_group"] as Map<String, dynamic>;
            isSalesDataLoading2a = false;
            Constants.sales_tree_key2a = UniqueKey();
            salesValue.value++;
          }
        } else if (selectedButton1 == 3 && days_difference <= 31) {
          print("fggffg $jsonResponse");
          Constants.sales_sectionsList3a_sales_agent[0].amount = 0;
          Constants.sales_sectionsList3a_sales_agent[1].amount = 0;
          Constants.sales_sectionsList3a_sales_agent[2].amount = 0;
          Constants.sales_maxY =
              ((jsonResponse["daily_or_monthlya"] ?? 0) * 1.1).round();
          Constants.sales_bar_maxY3a =
              ((jsonResponse["branch_maxYa"] ?? 0) * 1.1).round();
          Constants.sales_bar_maxY3b =
              ((jsonResponse["branch_maxYb"] ?? 0) * 1.1).round();
          Constants.sales_bar_maxY3c =
              ((jsonResponse["branch_maxYc"] ?? 0) * 1.1).round();
          Constants.salesByAgentSales3a = [];
          Constants.salesByAgentSales3b = [];
          Constants.salesByAgentSales3c = [];
          if (jsonResponse["sales_list"] != null) {
            List all_sales = jsonResponse["sales_list"];
            for (var element in all_sales) {
              print(element);
              Map<String, dynamic> m1 = element as Map<String, dynamic>;
              if (m1["actual_status"] == "Inforced") {
                Constants.sales_sectionsList3a_sales_agent[0].amount++;
                Constants.salesByAgentSales3a.add(SalesByAgentSale(
                  m1["policy_number"] ?? "",
                  // Provide a default empty string if null
                  m1["inception_date"] ?? "",
                  m1["sale_datetime"] ?? "",
                  m1["product"] ?? "",
                  m1["product_type"] ?? "",
                  m1["payment_type"] ?? "",
                  double.parse((m1["totalAmountPayable"] ?? "0").toString()),
                  // Assuming 0 is a reasonable default for totalAmountPayable
                  m1["status"] ?? "",
                  m1["actual_status"] ?? m1["status"],
                  m1["description"] ?? "",
                  m1["reference"] ?? "",
                ));
              } else if (m1["actual_status"] == "Pending Inforce") {
                Constants.sales_sectionsList3a_sales_agent[1].amount++;
                Constants.salesByAgentSales3b.add(SalesByAgentSale(
                  m1["policy_number"] ?? "",
                  m1["inception_date"] ?? "",
                  m1["sale_datetime"] ?? "",
                  m1["product"] ?? "",
                  m1["product_type"] ?? "",
                  m1["payment_type"] ?? "",
                  double.parse((m1["totalAmountPayable"] ?? "0")),
                  m1["actual_status"] ?? m1["status"],
                  m1["actual_status"] ?? m1["status"],
                  m1["description"] ?? "",
                  m1["reference"] ?? "",
                ));
              } else if (m1["actual_status"] != "Inforced") {
                Constants.sales_sectionsList2a_sales_agent[2].amount++;
                if (m1["policy_number"] != null &&
                    m1["actual_status"] != null) {
                  if (m1["policy_number"] != null &&
                      m1["actual_status"] != null) {
                    String actul_status = "";
                    String policy_number = "";
                    if (m1["policy_number"] != null &&
                        m1["policy_number"] != "") {
                      policy_number = m1["policy_number"];
                    } else if (m1["reference"] != null &&
                        m1["reference"] != "") {
                      policy_number = m1["reference"];
                    } else {
                      policy_number = "Policy Number not assigned.";
                    }
                    if (m1["actual_status"] != null &&
                        m1["actual_status"] != "") {
                      actul_status = m1["actual_status"];
                    } else if (m1["status"] != null && m1["status"] != "") {
                      actul_status = m1["status"];
                    } else {
                      actul_status = "Rejected";
                    }

                    Constants.sales_sectionsList3a_sales_agent[2].amount++;

                    Constants.salesByAgentSales3c.add(SalesByAgentSale(
                      m1["policy_number"] ?? "-",
                      m1["inception_date"] ?? "",
                      m1["sale_datetime"] ?? "",
                      m1["product"] ?? "",
                      m1["product_type"] ?? "",
                      m1["payment_type"] ?? "",
                      double.parse(
                          (m1["totalAmountPayable"] ?? "0").toString()),
                      m1["status"] ?? "",
                      actul_status,
                      m1["description"] ?? "",
                      policy_number,
                    ));
                  }
                  print("ghjkjkj ${m1}");
                  print("dssfdgf ${Constants.salesByAgentSales3c.length}");
                }
              }
            }

            Constants.salesByAgentSales3a.toSet().toList();
            Constants.salesByAgentSales3b.toSet().toList();
            Constants.salesByAgentSales3c.toSet().toList();
            sales_jsonResponse3a =
                jsonResponse["products_group"] as Map<String, dynamic>;
            isSalesDataLoading3a = false;
            Constants.sales_tree_key3a = UniqueKey();
            salesValue.value++;
          }
        } else {
          Constants.sales_sectionsList3a_sales_agent[0].amount = 0;
          Constants.sales_sectionsList3a_sales_agent[1].amount = 0;
          Constants.sales_sectionsList3a_sales_agent[2].amount = 0;
          print("fggffg $jsonResponse");

          Constants.sales_maxY =
              ((jsonResponse["daily_or_monthlya"] ?? 0) * 1.1).round();
          Constants.sales_bar_maxY3a =
              ((jsonResponse["branch_maxYa"] ?? 0) * 1.1).round();
          Constants.sales_bar_maxY3b =
              ((jsonResponse["branch_maxYb"] ?? 0) * 1.1).round();
          Constants.sales_bar_maxY3c =
              ((jsonResponse["branch_maxYc"] ?? 0) * 1.1).round();
          Constants.salesByAgentSales4a = [];
          Constants.salesByAgentSales4b = [];
          Constants.salesByAgentSales4c = [];
          if (jsonResponse["sales_list"] != null) {
            List all_sales = jsonResponse["sales_list"];
            for (var element in all_sales) {
              print(element);
              Map<String, dynamic> m1 = element as Map<String, dynamic>;
              if (m1["actual_status"] == "Inforced") {
                Constants.sales_sectionsList3a_sales_agent[0].amount++;
                Constants.salesByAgentSales4a.add(SalesByAgentSale(
                  m1["policy_number"] ?? "",
                  // Provide a default empty string if null
                  m1["inception_date"] ?? "",
                  m1["sale_datetime"] ?? "",
                  m1["product"] ?? "",
                  m1["product_type"] ?? "",
                  m1["payment_type"] ?? "",
                  double.parse((m1["totalAmountPayable"] ?? 0).toString()),
                  m1["status"] ?? "",
                  m1["actual_status"] ?? "",
                  m1["description"] ?? "",
                  m1["reference"] ?? "",
                ));
              }

              if (m1["actual_status"] == "Pending Inforce") {
                Constants.sales_sectionsList3a_sales_agent[1].amount++;
                Constants.salesByAgentSales4b.add(SalesByAgentSale(
                  m1["policy_number"] ?? "",
                  m1["inception_date"] ?? "",
                  m1["sale_datetime"] ?? "",
                  m1["product"] ?? "",
                  m1["product_type"] ?? "",
                  m1["payment_type"] ?? "",
                  double.parse((m1["totalAmountPayable"] ?? 0).toString()),
                  m1["status"] ?? "",
                  m1["actual_status"] ?? "",
                  m1["description"] ?? "",
                  m1["reference"] ?? "",
                ));
              }
              String policy_number = "";
              if (m1["policy_number"] != null && m1["policy_number"] != "") {
                policy_number = m1["policy_number"];
              } else if (m1["reference"] != null && m1["reference"] != "") {
                policy_number = m1["reference"];
              } else {
                policy_number = "Policy Number not assigned.";
              }
              if (m1["actual_status"] != "Inforced") {
                Constants.sales_sectionsList3a_sales_agent[1].amount++;
                Constants.salesByAgentSales4c.add(SalesByAgentSale(
                  m1["policy_number"] ?? "",
                  m1["inception_date"] ?? "",
                  m1["sale_datetime"] ?? "",
                  m1["product"] ?? "",
                  m1["product_type"] ?? "",
                  m1["payment_type"] ?? "",
                  double.parse((m1["totalAmountPayable"] ?? 0).toString()),
                  m1["status"] ?? "",
                  m1["actual_status"] ?? "",
                  m1["description"] ?? "",
                  policy_number,
                ));
              }
            }
          }

          Constants.salesByAgentSales4a.toSet().toList();
          Constants.salesByAgentSales4b.toSet().toList();
          Constants.salesByAgentSales4c.toSet().toList();
          sales_jsonResponse4a =
              jsonResponse["products_group"] as Map<String, dynamic>;
          isSalesDataLoading3b = false;
          Constants.sales_tree_key4a = UniqueKey();
          salesValue.value++;
        }
      }
    });
  } on Exception catch (_, exception) {
    //Exception exc = exception as Exception;
    // print(exception);
  }
}

Future<void> getSalesAgentLeadsReportOld(String date_from, String date_to,
    int selectedButton2, int days_difference, BuildContext context) async {
  String baseUrl =
      "https://miinsightsapps.net/fieldV6/getLeadss?empId=${Constants.cec_employeeid}&searchKey=&status=my&cec_client_id=${Constants.cec_client_id}&type=field&startDate=${date_from}date%20range&endDate=${date_to}";
  print("dshdsgds5 ${baseUrl}");

  try {
    if (kDebugMode) {
      //print("baseUrl $baseUrl");
    }

    await http.get(
        Uri.parse(
          baseUrl,
        ),
        headers: {
          "Cookie":
              "userid=expiry=2021-04-25&client_modules=1001#1002#1003#1004#1005#1006#1007#1008#1009#1010#1011#1012#1013#1014#1015#1017#1018#1020#1021#1022#1024#1025#1026#1027#1028#1029#1030#1031#1032#1033#1034#1035&clientid=&empid=3&empfirstname=Mncedisi&emplastname=Khumalo&email=mncedisi@athandwe.co.za&username=mncedisi@athandwe.co.za&dob=8/28/1985 12:00:00 AM&fullname=Mncedisi Khumalo&userRole=5&userImage=mncedisi@athandwe.co.za.jpg&employedAt=branch&role=leader&branchid=6&branchname=Boulders&jobtitle=Administrative Assistant&dialing_strategy=Campaign Manager&clientname=Test 1 Funeral Parlour&foldername=maafrica&client_abbr=AS&pbx_account=pbx1051ef0a&soft_phone_ip=&agent_type=branch&mip_username=mnces@mip.co.za&agent_email=Mr Mncedisi Khumalo&ViciDial_phone_login=&ViciDial_phone_password=&ViciDial_agent_user=99&ViciDial_agent_password=&device_id=dC7JwXFwwdI:APA91bF0gTbuXlfT6wIcGMLY57Xo7VxUMrMH-MuFYL5PnjUVI0G5X1d3d90FNRb8-XmcjI40L1XqDH-KAc1KWnPpxNg8Z8SK4Ty0xonbz4L3sbKz3Rlr4hyBqePWx9ZfEp53vWwkZ3tx&servername=http://localhost:55661"
        }).then((value) async {
      http.Response response = value;
      if (kDebugMode) {
        print("fghghjjh0f " + response.body);
        //print(response.statusCode);
      }
      List<Map> jsonResponse = List<Map>.from(jsonDecode(response.body));
      if (selectedButton2 == 1) {
        Constants.leads_sectionsList1a[0].amount = 0;
        Constants.leads_sectionsList1a[1].amount = 0;
        Constants.leads_sectionsList1a[2].amount = 0;
        Constants.leadsByAgentSales1a = [];
        Constants.leadsByAgentSales1b = [];
        Constants.leadsByAgentSales1c = [];
        for (var element in jsonResponse) {
          Map<String, dynamic> m1 = element as Map<String, dynamic>;
          print(m1);
          logLongString(
              "fdfggff  ${m1["onololeadid"]} ${m1["first_name"]} ${m1["last_name"]} ${m1["lead_status"]} -----y ${m1["hang_up_reason"]} ${m1["hang_up_desc2"]} ${m1["hang_up_desc3"]} ");

          if (((m1["hang_up_reason"] == "Incomplete" &&
                  m1["hang_up_desc2"] == null) ||
              (m1["hang_up_desc2"] == null && m1["hang_up_reason"] == null))) {
            Constants.leads_sectionsList1a[0].amount++;
            Constants.leadsByAgentSales1a.add(SalesByAgentLead(
              m1["onololeadid"] ?? "",
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          } else if ((m1["hang_up_reason"] == "No Documents" ||
              m1["hang_up_reason"] == "Rejected by server" ||
              (m1["hang_up_reason"] == "Incomplete" &&
                  m1["hang_up_desc2"] != null))) {
            // print("tfgghgdfhg");
            Constants.leads_sectionsList1a[2].amount++;
            Constants.leadsByAgentSales1c.add(SalesByAgentLead(
              m1["onololeadid"] ?? "", // Provide a default empty string if null
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          } else if (m1["hang_up_reason"] == "Transfer" ||
              m1["hang_up_reason"] == "Call Back" ||
              (m1["hang_up_reason"] == "No Contact" ||
                  m1["hang_up_desc2"] == "Voice Mail") ||
              (m1["hang_up_reason"] == "No Contact" ||
                  m1["hang_up_desc2"] == "No Answer")) {
            Constants.leads_sectionsList1a[1].amount++;
            Constants.leadsByAgentSales1b.add(SalesByAgentLead(
              m1["onololeadid"] ?? "", // Provide a default empty string if null
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          } else if ((m1["hang_up_reason"] == "Incomplete" &&
                  m1["hang_up_reason"] != null) ||
              m1["hang_up_reason"] == "Does not qualify" ||
              m1["hang_up_reason"] == "Prank Call" ||
              m1["hang_up_reason"] == "Duplicate Lead" ||
              m1["hang_up_reason"] == "Mystery Shopper" ||
              m1["hang_up_reason"] == "Not Interested" ||
              (m1["hang_up_reason"] == "No Contact" ||
                  m1["hang_up_desc2"] == "Number Does Not Exist")) {
            print("tfgghgdfhg");
            Constants.leads_sectionsList1a[2].amount++;
            Constants.leadsByAgentSales1c.add(SalesByAgentLead(
              m1["onololeadid"] ?? "", // Provide a default empty string if null
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          }
        }
        if (kDebugMode) {
          print(
              "fghgjh $selectedButton2 ${Constants.leadsByAgentSales1a.length} ${jsonResponse.length}");
        }
      }
      if (selectedButton2 == 2) {
        Constants.leads_sectionsList2a[0].amount = 0;
        Constants.leads_sectionsList2a[1].amount = 0;
        Constants.leads_sectionsList2a[2].amount = 0;
        Constants.leadsByAgentSales2a = [];
        Constants.leadsByAgentSales2b = [];
        Constants.leadsByAgentSales2c = [];
        for (var element in jsonResponse) {
          Map<String, dynamic> m1 = element as Map<String, dynamic>;
          print(m1);
          logLongString(
              "fdfggff2  ${m1["onololeadid"]} ${m1["first_name"]} ${m1["last_name"]} ${m1["lead_status"]} -----y ${m1["hang_up_reason"]} ${m1["hang_up_desc2"]} ${m1["hang_up_desc3"]} ");

          if (((m1["hang_up_reason"] == "Incomplete" &&
                  m1["hang_up_desc2"] == null) ||
              (m1["hang_up_desc2"] == null && m1["hang_up_reason"] == null))) {
            Constants.leads_sectionsList2a[0].amount++;
            Constants.leadsByAgentSales2a.add(SalesByAgentLead(
              m1["onololeadid"] ?? "",
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          } else if ((m1["hang_up_reason"] == "No Documents" ||
              m1["hang_up_reason"] == "Rejected by server" ||
              (m1["hang_up_reason"] == "Incomplete" &&
                  m1["hang_up_desc2"] != null))) {
            // print("tfgghgdfhg");
            Constants.leads_sectionsList2a[2].amount++;
            Constants.leadsByAgentSales2c.add(SalesByAgentLead(
              m1["onololeadid"] ?? "", // Provide a default empty string if null
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          } else if (m1["hang_up_reason"] == "Transfer" ||
              m1["hang_up_reason"] == "Call Back" ||
              (m1["hang_up_reason"] == "No Contact" ||
                  m1["hang_up_desc2"] == "Voice Mail") ||
              (m1["hang_up_reason"] == "No Contact" ||
                  m1["hang_up_desc2"] == "No Answer")) {
            Constants.leads_sectionsList2a[1].amount++;
            Constants.leadsByAgentSales2b.add(SalesByAgentLead(
              m1["onololeadid"] ?? "", // Provide a default empty string if null
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          } else if ((m1["hang_up_reason"] == "Incomplete" &&
                  m1["hang_up_reason"] != null) ||
              m1["hang_up_reason"] == "Does not qualify" ||
              m1["hang_up_reason"] == "Prank Call" ||
              m1["hang_up_reason"] == "Duplicate Lead" ||
              m1["hang_up_reason"] == "Mystery Shopper" ||
              m1["hang_up_reason"] == "Not Interested" ||
              (m1["hang_up_reason"] == "No Contact" ||
                  m1["hang_up_desc2"] == "Number Does Not Exist")) {
            print("tfgghgdfhg");
            Constants.leads_sectionsList2a[2].amount++;
            Constants.leadsByAgentSales2c.add(SalesByAgentLead(
              m1["onololeadid"] ?? "", // Provide a default empty string if null
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          }
        }
        if (kDebugMode) {
          print(
              "fghgjh2 $selectedButton2 ${Constants.leadsByAgentSales2a.length} ${date_from} ${date_to} ${jsonResponse.length}");
        }
      }
      if (selectedButton2 == 3) {
        Constants.leads_sectionsList3a[0].amount = 0;
        Constants.leads_sectionsList3a[1].amount = 0;
        Constants.leads_sectionsList3a[2].amount = 0;
        Constants.leadsByAgentSales3a = [];
        Constants.leadsByAgentSales3b = [];
        Constants.leadsByAgentSales3c = [];
        for (var element in jsonResponse) {
          Map<String, dynamic> m1 = element as Map<String, dynamic>;
          print(m1);
          logLongString(
              "fdfggff  ${m1["onololeadid"]} ${m1["first_name"]} ${m1["last_name"]} ${m1["lead_status"]} -----y ${m1["hang_up_reason"]} ${m1["hang_up_desc2"]} ${m1["hang_up_desc3"]} ");

          if (((m1["hang_up_reason"] == "Incomplete" &&
                  m1["hang_up_desc2"] == null) ||
              (m1["hang_up_desc2"] == null && m1["hang_up_reason"] == null))) {
            Constants.leads_sectionsList3a[0].amount++;
            Constants.leadsByAgentSales3a.add(SalesByAgentLead(
              m1["onololeadid"] ?? "",
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          } else if ((m1["hang_up_reason"] == "No Documents" ||
              m1["hang_up_reason"] == "Rejected by server" ||
              (m1["hang_up_reason"] == "Incomplete" &&
                  m1["hang_up_desc2"] != null))) {
            // print("tfgghgdfhg");
            Constants.leads_sectionsList3a[2].amount++;
            Constants.leadsByAgentSales3c.add(SalesByAgentLead(
              m1["onololeadid"] ?? "", // Provide a default empty string if null
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          } else if (m1["hang_up_reason"] == "Transfer" ||
              m1["hang_up_reason"] == "Call Back" ||
              (m1["hang_up_reason"] == "No Contact" ||
                  m1["hang_up_desc2"] == "Voice Mail") ||
              (m1["hang_up_reason"] == "No Contact" ||
                  m1["hang_up_desc2"] == "No Answer")) {
            Constants.leads_sectionsList3a[1].amount++;
            Constants.leadsByAgentSales3b.add(SalesByAgentLead(
              m1["onololeadid"] ?? "", // Provide a default empty string if null
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          } else if ((m1["hang_up_reason"] == "Incomplete" &&
                  m1["hang_up_reason"] != null) ||
              m1["hang_up_reason"] == "Does not qualify" ||
              m1["hang_up_reason"] == "Prank Call" ||
              m1["hang_up_reason"] == "Duplicate Lead" ||
              m1["hang_up_reason"] == "Mystery Shopper" ||
              m1["hang_up_reason"] == "Not Interested" ||
              (m1["hang_up_reason"] == "No Contact" ||
                  m1["hang_up_desc2"] == "Number Does Not Exist")) {
            print("tfgghgdfhg");
            Constants.leads_sectionsList3a[2].amount++;
            Constants.leadsByAgentSales3c.add(SalesByAgentLead(
              m1["onololeadid"] ?? "", // Provide a default empty string if null
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          }
        }
        if (kDebugMode) {
          print(
              "fghgjh3 $selectedButton2 ${Constants.leadsByAgentSales1a.length} ${jsonResponse.length}");
        }
      }
    });
  } catch (exception) {
    //Exception exc = exception as Exception;
    if (kDebugMode) {
      print(exception.toString());
    }
  }
}

Future<void> getSalesAgentLeadsReport(String date_from, String date_to,
    int selectedButton2, int days_difference, BuildContext context) async {
  /*String baseUrl =
      "https://miinsightsapps.net/fieldV6/getLeadss?empId=${Constants.cec_employeeid}&searchKey=&status=my&cec_client_id=${Constants.cec_client_id}&type=field&startDate=${date_from}date%20range&endDate=${date_to}"
      ""
      "";*/
  String baseUrl = "https://miinsightsapps.net/files/get_leads_data_by_agent/";
  print("dshdsgds5 ${baseUrl}");

  try {
    if (kDebugMode) {
      //print("baseUrl $baseUrl");
    }
    Map<String, String>? payload = {
      "client_id": "${Constants.cec_client_id}",
      "start_date": date_from,
      "end_date": date_to,
      "cec_employee_id": "${Constants.cec_empid}"
    };
    // print(payload);

    await http.post(
        Uri.parse(
          baseUrl,
        ),
        body: payload,
        headers: {
          "Cookie":
              "userid=expiry=2021-04-25&client_modules=1001#1002#1003#1004#1005#1006#1007#1008#1009#1010#1011#1012#1013#1014#1015#1017#1018#1020#1021#1022#1024#1025#1026#1027#1028#1029#1030#1031#1032#1033#1034#1035&clientid=&empid=3&empfirstname=Mncedisi&emplastname=Khumalo&email=mncedisi@athandwe.co.za&username=mncedisi@athandwe.co.za&dob=8/28/1985 12:00:00 AM&fullname=Mncedisi Khumalo&userRole=5&userImage=mncedisi@athandwe.co.za.jpg&employedAt=branch&role=leader&branchid=6&branchname=Boulders&jobtitle=Administrative Assistant&dialing_strategy=Campaign Manager&clientname=Test 1 Funeral Parlour&foldername=maafrica&client_abbr=AS&pbx_account=pbx1051ef0a&soft_phone_ip=&agent_type=branch&mip_username=mnces@mip.co.za&agent_email=Mr Mncedisi Khumalo&ViciDial_phone_login=&ViciDial_phone_password=&ViciDial_agent_user=99&ViciDial_agent_password=&device_id=dC7JwXFwwdI:APA91bF0gTbuXlfT6wIcGMLY57Xo7VxUMrMH-MuFYL5PnjUVI0G5X1d3d90FNRb8-XmcjI40L1XqDH-KAc1KWnPpxNg8Z8SK4Ty0xonbz4L3sbKz3Rlr4hyBqePWx9ZfEp53vWwkZ3tx&servername=http://localhost:55661"
        }).then((value) async {
      http.Response response = value;
      if (kDebugMode) {
        // print("fghghjjh5 " + response.body);
        //print(response.statusCode);
      }
      List<Map> jsonResponse =
          List<Map>.from(jsonDecode(response.body)["all_leads_list"]);
      if (selectedButton2 == 1) {
        Constants.leads_sectionsList1a[0].amount = 0;
        Constants.leads_sectionsList1a[1].amount = 0;
        Constants.leads_sectionsList1a[2].amount = 0;
        Constants.leadsByAgentSales1a = [];
        Constants.leadsByAgentSales1b = [];
        Constants.leadsByAgentSales1c = [];
        for (var element in jsonResponse) {
          Map<String, dynamic> m1 = element as Map<String, dynamic>;
          print(m1);
          //939012
          /*logLongString(
              "fdfggff  ${m1["onololeadid"]} ${m1["first_name"]} ${m1["last_name"]} ${m1["lead_status"]} -----y ${m1["hang_up_reason"]} ${m1["hang_up_desc2"]} ${m1["hang_up_desc3"]} ");
*/
          if (m1["hang_up_reason"] == "" && m1["status"] == "") {
            Constants.leads_sectionsList1a[0].amount++;
            Constants.leadsByAgentSales1a.add(SalesByAgentLead(
              m1["onololeadid"] ?? "",
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          }
          if (((m1["hang_up_reason"] == "Incomplete" &&
                  m1["hang_up_desc2"] == null) ||
              (m1["hang_up_desc2"] == null && m1["hang_up_reason"] == null))) {
            Constants.leads_sectionsList1a[0].amount++;
            Constants.leadsByAgentSales1a.add(SalesByAgentLead(
              m1["onololeadid"] ?? "",
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          } else if ((m1["hang_up_reason"] == "No Documents" ||
              m1["hang_up_reason"] == "Rejected by server" ||
              (m1["hang_up_reason"] == "Incomplete" &&
                  m1["hang_up_desc2"] != null))) {
            // print("tfgghgdfhg");
            Constants.leads_sectionsList1a[2].amount++;
            Constants.leadsByAgentSales1c.add(SalesByAgentLead(
              m1["onololeadid"] ?? "", // Provide a default empty string if null
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          } else if (m1["hang_up_reason"] == "Transfer" ||
              m1["hang_up_reason"] == "Call Back" ||
              (m1["hang_up_reason"] == "No Contact" ||
                  m1["hang_up_desc2"] == "Voice Mail") ||
              (m1["hang_up_reason"] == "No Contact" ||
                  m1["hang_up_desc2"] == "No Answer")) {
            Constants.leads_sectionsList1a[1].amount++;
            Constants.leadsByAgentSales1b.add(SalesByAgentLead(
              m1["onololeadid"] ?? "", // Provide a default empty string if null
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          } else if ((m1["hang_up_reason"] == "Incomplete" &&
                  m1["hang_up_reason"] != null) ||
              m1["hang_up_reason"] == "Does not qualify" ||
              m1["hang_up_reason"] == "Prank Call" ||
              m1["hang_up_reason"] == "Duplicate Lead" ||
              m1["hang_up_reason"] == "Mystery Shopper" ||
              m1["hang_up_reason"] == "Not Interested" ||
              (m1["hang_up_reason"] == "No Contact" ||
                  m1["hang_up_desc2"] == "Number Does Not Exist")) {
            print("tfgghgdfhg");
            Constants.leads_sectionsList1a[2].amount++;
            Constants.leadsByAgentSales1c.add(SalesByAgentLead(
              m1["onololeadid"] ?? "", // Provide a default empty string if null
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          }
        }
        if (kDebugMode) {
          print(
              "fghgjh $selectedButton2 ${Constants.leadsByAgentSales1a.length} ${jsonResponse.length}");
        }
      }
      if (selectedButton2 == 2) {
        Constants.leads_sectionsList2a[0].amount = 0;
        Constants.leads_sectionsList2a[1].amount = 0;
        Constants.leads_sectionsList2a[2].amount = 0;
        Constants.leadsByAgentSales2a = [];
        Constants.leadsByAgentSales2b = [];
        Constants.leadsByAgentSales2c = [];
        for (var element in jsonResponse) {
          Map<String, dynamic> m1 = element as Map<String, dynamic>;
          print(m1);
          logLongString(
              "fdfggff2  ${m1["onololeadid"]} ${m1["first_name"]} ${m1["last_name"]} ${m1["lead_status"]} -----y ${m1["hang_up_reason"]} ${m1["hang_up_desc2"]} ${m1["hang_up_desc3"]} ");

          if (((m1["hang_up_reason"] == "Incomplete" &&
                  m1["hang_up_desc2"] == null) ||
              (m1["hang_up_desc2"] == null && m1["hang_up_reason"] == null))) {
            Constants.leads_sectionsList2a[0].amount++;
            Constants.leadsByAgentSales2a.add(SalesByAgentLead(
              m1["onololeadid"] ?? "",
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          } else if ((m1["hang_up_reason"] == "No Documents" ||
              m1["hang_up_reason"] == "Rejected by server" ||
              (m1["hang_up_reason"] == "Incomplete" &&
                  m1["hang_up_desc2"] != null))) {
            // print("tfgghgdfhg");
            Constants.leads_sectionsList2a[2].amount++;
            Constants.leadsByAgentSales2c.add(SalesByAgentLead(
              m1["onololeadid"] ?? "", // Provide a default empty string if null
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          } else if (m1["hang_up_reason"] == "Transfer" ||
              m1["hang_up_reason"] == "Call Back" ||
              (m1["hang_up_reason"] == "No Contact" ||
                  m1["hang_up_desc2"] == "Voice Mail") ||
              (m1["hang_up_reason"] == "No Contact" ||
                  m1["hang_up_desc2"] == "No Answer")) {
            Constants.leads_sectionsList2a[1].amount++;
            Constants.leadsByAgentSales2b.add(SalesByAgentLead(
              m1["onololeadid"] ?? "", // Provide a default empty string if null
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          } else if ((m1["hang_up_reason"] == "Incomplete" &&
                  m1["hang_up_reason"] != null) ||
              m1["hang_up_reason"] == "Does not qualify" ||
              m1["hang_up_reason"] == "Prank Call" ||
              m1["hang_up_reason"] == "Duplicate Lead" ||
              m1["hang_up_reason"] == "Mystery Shopper" ||
              m1["hang_up_reason"] == "Not Interested" ||
              (m1["hang_up_reason"] == "No Contact" ||
                  m1["hang_up_desc2"] == "Number Does Not Exist")) {
            print("tfgghgdfhg");
            Constants.leads_sectionsList2a[2].amount++;
            Constants.leadsByAgentSales2c.add(SalesByAgentLead(
              m1["onololeadid"] ?? "", // Provide a default empty string if null
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          }
        }
        if (kDebugMode) {
          print(
              "fghgjh2 $selectedButton2 ${Constants.leadsByAgentSales2a.length} ${date_from} ${date_to} ${jsonResponse.length}");
        }
      }
      if (selectedButton2 == 3) {
        Constants.leads_sectionsList3a[0].amount = 0;
        Constants.leads_sectionsList3a[1].amount = 0;
        Constants.leads_sectionsList3a[2].amount = 0;
        Constants.leadsByAgentSales3a = [];
        Constants.leadsByAgentSales3b = [];
        Constants.leadsByAgentSales3c = [];
        for (var element in jsonResponse) {
          Map<String, dynamic> m1 = element as Map<String, dynamic>;
          print(m1);
          logLongString(
              "fdfggff  ${m1["onololeadid"]} ${m1["first_name"]} ${m1["last_name"]} ${m1["lead_status"]} -----y ${m1["hang_up_reason"]} ${m1["hang_up_desc2"]} ${m1["hang_up_desc3"]} ");

          if (((m1["hang_up_reason"] == "Incomplete" &&
                  m1["hang_up_desc2"] == null) ||
              (m1["hang_up_desc2"] == null && m1["hang_up_reason"] == null))) {
            Constants.leads_sectionsList3a[0].amount++;
            Constants.leadsByAgentSales3a.add(SalesByAgentLead(
              m1["onololeadid"] ?? "",
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          } else if ((m1["hang_up_reason"] == "No Documents" ||
              m1["hang_up_reason"] == "Rejected by server" ||
              (m1["hang_up_reason"] == "Incomplete" &&
                  m1["hang_up_desc2"] != null))) {
            // print("tfgghgdfhg");
            Constants.leads_sectionsList3a[2].amount++;
            Constants.leadsByAgentSales3c.add(SalesByAgentLead(
              m1["onololeadid"] ?? "", // Provide a default empty string if null
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          } else if (m1["hang_up_reason"] == "Transfer" ||
              m1["hang_up_reason"] == "Call Back" ||
              (m1["hang_up_reason"] == "No Contact" ||
                  m1["hang_up_desc2"] == "Voice Mail") ||
              (m1["hang_up_reason"] == "No Contact" ||
                  m1["hang_up_desc2"] == "No Answer")) {
            Constants.leads_sectionsList3a[1].amount++;
            Constants.leadsByAgentSales3b.add(SalesByAgentLead(
              m1["onololeadid"] ?? "", // Provide a default empty string if null
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          } else if ((m1["hang_up_reason"] == "Incomplete" &&
                  m1["hang_up_reason"] != null) ||
              m1["hang_up_reason"] == "Does not qualify" ||
              m1["hang_up_reason"] == "Prank Call" ||
              m1["hang_up_reason"] == "Duplicate Lead" ||
              m1["hang_up_reason"] == "Mystery Shopper" ||
              m1["hang_up_reason"] == "Not Interested" ||
              (m1["hang_up_reason"] == "No Contact" ||
                  m1["hang_up_desc2"] == "Number Does Not Exist")) {
            print("tfgghgdfhg");
            Constants.leads_sectionsList3a[2].amount++;
            Constants.leadsByAgentSales3c.add(SalesByAgentLead(
              m1["onololeadid"] ?? "", // Provide a default empty string if null
              m1["title"] ?? "",
              m1["first_name"] ?? "",
              m1["last_name"] ?? "",
              m1["product"] ?? "",
              m1["lead_status"] ?? "",
              m1["assigned_to"] ?? 0,
              m1["customer_id_number"] ?? "",
              m1["timestamp"] ?? "",
              m1["cell_number"] ?? "",
              m1["reference"] ?? "",
              m1["product_type"] ?? "",
              m1["lead_status"] ?? "",
              m1["hang_up_reason"] ?? "",
              m1["hang_up_desc2"] ?? "",
              m1["hang_up_desc3"] ?? "",
            ));
          }
        }
        if (kDebugMode) {
          print(
              "fghgjh3 $selectedButton2 ${Constants.leadsByAgentSales1a.length} ${jsonResponse.length}");
        }
      }
    });
  } catch (exception) {
    //Exception exc = exception as Exception;
    if (kDebugMode) {
      print(exception.toString());
    }
  }
}

/*
Future<void> getSalesAgentLeads(String date_from, String date_to,
    int selectedButton1, int days_difference, BuildContext context) async {
  try {
    if (kDebugMode) {
      // print("baseUrl $baseUrl");
    }

    String baseUrl =
        "https://miinsightsapps.net/files/get_leads_data_by_agent/";
    if (selectedButton1 == 1) {
      isSalesDataLoading1a = true;
    } else if (selectedButton1 == 2) {
      isSalesDataLoading2a = true;
    } else if (selectedButton1 == 3 && days_difference <= 31) {
      isSalesDataLoading3a = true;
    } else if (selectedButton1 == 3 && days_difference > 31) {
      isSalesDataLoading3b = true;
    }
    //print("ggfgghjhj ${Constants.cec_employeeid}");

    Map<String, String>? payload = {
      "client_id": "${Constants.cec_client_id}",
      "start_date": date_from,
      "end_date": date_to,
      "cec_employee_id": "${Constants.cec_employeeid}"
    };
    await http
        .post(
            Uri.parse(
              baseUrl,
            ),
            body: payload)
        .then((value) {
      http.Response response = value;
      print("dfhhghg6 ${response.body}");

      if (response.statusCode != 200) {
        //print("fgffhhhg_sales0 ${response.body}");
        if (selectedButton1 == 1) isSalesDataLoading1a = false;
        if (selectedButton1 == 2) isSalesDataLoading2a = false;
        if (selectedButton1 == 3) isSalesDataLoading3a = false;
        if (selectedButton1 == 4) isSalesDataLoading3b = false;

        salesValue.value++;
      } else {
        var jsonResponse = jsonDecode(response.body);
        if (selectedButton1 == 1) {
          Constants.leadsByAgentSales1a = [];
          Constants.leadsByAgentSales1b = [];
          Constants.leadsByAgentSales1c = [];
          if (jsonResponse["all_leads_list"] != null) {
            List all_sales = jsonResponse["all_leads_list"];

            for (var element in all_sales) {
              // print(element);
              Map<String, dynamic> m1 = element as Map<String, dynamic>;
              Constants.leadsByAgentSales1a.add(SalesByAgentSale(
                  m1["policy_number"] ?? "",
                  m1["inceptionDate"] ?? "",
                  m1["sale_datetime"] ?? "",
                  m1["product"] ?? "",
                  m1["product_type"] ?? "",
                  m1["payment_type"] ?? "",
                  double.parse((m1["totalAmountPayable"] ?? 0).toString()),
                  m1["status"] ?? ""));
            }
          }
          if (jsonResponse["incomplete_leads_list"] != null) {
            List incomplete_leads = jsonResponse["incomplete_leads_list"];
            //print("dfhhghg ${all_sales}");
            for (var element in incomplete_leads) {
              // print(element);
              Map<String, dynamic> m1 = element as Map<String, dynamic>;
              Constants.leadsByAgentSales1b.add(SalesByAgentSale(
                  m1["policy_number"] ?? "",
                  m1["inceptionDate"] ?? "",
                  m1["sale_datetime"] ?? "",
                  m1["product"] ?? "",
                  m1["product_type"] ?? "",
                  m1["payment_type"] ?? "",
                  double.parse((m1["totalAmountPayable"] ?? 0).toString()),
                  m1["status"] ?? ""));
            }
          }
          if (jsonResponse["not_accepted_leads_list"] != null) {
            List not_accepted_leads = jsonResponse["not_accepted_leads_list"];
            //print("dfhhghg ${all_sales}");
            for (var element in not_accepted_leads) {
              // print(element);
              Map<String, dynamic> m1 = element as Map<String, dynamic>;
              Constants.leadsByAgentSales1c.add(SalesByAgentSale(
                  m1["policy_number"] ?? "",
                  m1["inceptionDate"] ?? "",
                  m1["sale_datetime"] ?? "",
                  m1["product"] ?? "",
                  m1["product_type"] ?? "",
                  m1["payment_type"] ?? "",
                  double.parse((m1["totalAmountPayable"] ?? 0).toString()),
                  m1["status"] ?? ""));
            }
          }

          Constants.leadsByAgentSales1a.toSet().toList();
          Constants.leadsByAgentSales1b.toSet().toList();
          Constants.leadsByAgentSales1c.toSet().toList();
          leads_jsonResponse1a =
              jsonResponse["products_group"] as Map<String, dynamic>;
          isSalesDataLoading1a = false;
          salesValue.value++;
        } else if (selectedButton1 == 2) {
          print("fggffg $jsonResponse");
          Constants.leads_sectionsList2a[0].amount =
              jsonResponse["total_sale_counts"];
          Constants.leads_sectionsList2a[1].amount =
              jsonResponse["total_inforced_counts"];
          Constants.leads_sectionsList2a[2].amount =
              jsonResponse["total_not_inforced_counts"];

          Constants.leadsByAgentSales2a = [];
          Constants.leadsByAgentSales2b = [];
          Constants.leadsByAgentSales2c = [];
          if (jsonResponse["sales_list"] != null) {
            List all_sales = jsonResponse["sales_list"];
            for (var element in all_sales) {
              print(element);
              Map<String, dynamic> m1 = element as Map<String, dynamic>;
              Constants.salesByAgentSales2a.add(SalesByAgentSale(
                  m1["policy_number"] ??
                      "", // Provide a default empty string if null
                  m1["inception_date"] ?? "",
                  m1["sale_datetime"] ?? "",
                  m1["product"] ?? "",
                  m1["product_type"] ?? "",
                  m1["payment_type"] ?? "",
                  m1["totalAmountPayable"] ??
                      0, // Assuming 0 is a reasonable default for totalAmountPayable
                  m1["status"] ?? ""));

              if (m1["status"] == "Inforced")
                Constants.salesByAgentSales2b.add(SalesByAgentSale(
                    m1["policy_number"] ?? "",
                    m1["inception_date"] ?? "",
                    m1["sale_datetime"] ?? "",
                    m1["product"] ?? "",
                    m1["product_type"] ?? "",
                    m1["payment_type"] ?? "",
                    m1["totalAmountPayable"] ?? 0,
                    m1["status"] ?? ""));
              if (m1["status"] != "Inforced")
                Constants.salesByAgentSales2c.add(SalesByAgentSale(
                    m1["policy_number"] ?? "",
                    m1["inception_date"] ?? "",
                    m1["sale_datetime"] ?? "",
                    m1["product"] ?? "",
                    m1["product_type"] ?? "",
                    m1["payment_type"] ?? "",
                    m1["totalAmountPayable"] ?? 0,
                    m1["status"] ?? ""));
            }
          }

          Constants.salesByAgentSales2a.toSet().toList();
          Constants.salesByAgentSales2b.toSet().toList();
          Constants.salesByAgentSales2c.toSet().toList();
          sales_jsonResponse2a =
              jsonResponse["products_group"] as Map<String, dynamic>;
          isSalesDataLoading2a = false;
          Constants.sales_tree_key2a = UniqueKey();
          salesValue.value++;
        } else if (selectedButton1 == 3 && days_difference <= 31) {
          print("fggffg $jsonResponse");
          Constants.sales_sectionsList3a[0].amount =
              jsonResponse["total_sale_counts"];
          Constants.sales_sectionsList3a[1].amount =
              jsonResponse["total_inforced_counts"];
          Constants.sales_sectionsList3a[2].amount =
              jsonResponse["total_not_inforced_counts"];
          Constants.sales_maxY =
              ((jsonResponse["daily_or_monthlya"] ?? 0) * 1.1).round();
          Constants.sales_bar_maxY3a =
              ((jsonResponse["branch_maxYa"] ?? 0) * 1.1).round();
          Constants.sales_bar_maxY3b =
              ((jsonResponse["branch_maxYb"] ?? 0) * 1.1).round();
          Constants.sales_bar_maxY3c =
              ((jsonResponse["branch_maxYc"] ?? 0) * 1.1).round();
          Constants.salesByAgentSales3a = [];
          Constants.salesByAgentSales3b = [];
          Constants.salesByAgentSales3c = [];
          if (jsonResponse["sales_list"] != null) {
            List all_sales = jsonResponse["sales_list"];
            for (var element in all_sales) {
              print(element);
              Map<String, dynamic> m1 = element as Map<String, dynamic>;
              Constants.salesByAgentSales3a.add(SalesByAgentSale(
                  m1["policy_number"] ??
                      "", // Provide a default empty string if null
                  m1["inception_date"] ?? "",
                  m1["sale_datetime"] ?? "",
                  m1["product"] ?? "",
                  m1["product_type"] ?? "",
                  m1["payment_type"] ?? "",
                  m1["totalAmountPayable"] ??
                      0, // Assuming 0 is a reasonable default for totalAmountPayable
                  m1["status"] ?? ""));

              if (m1["status"] == "Inforced")
                Constants.salesByAgentSales3b.add(SalesByAgentSale(
                    m1["policy_number"] ?? "",
                    m1["inception_date"] ?? "",
                    m1["sale_datetime"] ?? "",
                    m1["product"] ?? "",
                    m1["product_type"] ?? "",
                    m1["payment_type"] ?? "",
                    m1["totalAmountPayable"] ?? 0,
                    m1["status"] ?? ""));
              if (m1["status"] != "Inforced")
                Constants.salesByAgentSales3c.add(SalesByAgentSale(
                    m1["policy_number"] ?? "",
                    m1["inception_date"] ?? "",
                    m1["sale_datetime"] ?? "",
                    m1["product"] ?? "",
                    m1["product_type"] ?? "",
                    m1["payment_type"] ?? "",
                    m1["totalAmountPayable"] ?? 0,
                    m1["status"] ?? ""));
            }
          }

          Constants.salesByAgentSales3a.toSet().toList();
          Constants.salesByAgentSales3b.toSet().toList();
          Constants.salesByAgentSales3c.toSet().toList();
          sales_jsonResponse3a =
              jsonResponse["products_group"] as Map<String, dynamic>;
          isSalesDataLoading3a = false;
          Constants.sales_tree_key3a = UniqueKey();
          salesValue.value++;
        } else {
          print("fggffg $jsonResponse");
          Constants.sales_sectionsList3b[0].amount =
              jsonResponse["total_sale_counts"];
          Constants.sales_sectionsList3b[1].amount =
              jsonResponse["total_inforced_counts"];
          Constants.sales_sectionsList3b[2].amount =
              jsonResponse["total_not_inforced_counts"];
          Constants.sales_maxY =
              ((jsonResponse["daily_or_monthlya"] ?? 0) * 1.1).round();
          Constants.sales_bar_maxY3a =
              ((jsonResponse["branch_maxYa"] ?? 0) * 1.1).round();
          Constants.sales_bar_maxY3b =
              ((jsonResponse["branch_maxYb"] ?? 0) * 1.1).round();
          Constants.sales_bar_maxY3c =
              ((jsonResponse["branch_maxYc"] ?? 0) * 1.1).round();
          Constants.salesByAgentSales4a = [];
          Constants.salesByAgentSales3b = [];
          Constants.salesByAgentSales3c = [];
          if (jsonResponse["sales_list"] != null) {
            List all_sales = jsonResponse["sales_list"];
            for (var element in all_sales) {
              print(element);
              Map<String, dynamic> m1 = element as Map<String, dynamic>;
              Constants.salesByAgentSales4a.add(SalesByAgentSale(
                  m1["policy_number"] ??
                      "", // Provide a default empty string if null
                  m1["inception_date"] ?? "",
                  m1["sale_datetime"] ?? "",
                  m1["product"] ?? "",
                  m1["product_type"] ?? "",
                  m1["payment_type"] ?? "",
                  m1["totalAmountPayable"] ??
                      0, // Assuming 0 is a reasonable default for totalAmountPayable
                  m1["status"] ?? ""));

              if (m1["status"] == "Inforced")
                Constants.salesByAgentSales4b.add(SalesByAgentSale(
                    m1["policy_number"] ?? "",
                    m1["inception_date"] ?? "",
                    m1["sale_datetime"] ?? "",
                    m1["product"] ?? "",
                    m1["product_type"] ?? "",
                    m1["payment_type"] ?? "",
                    m1["totalAmountPayable"] ?? 0,
                    m1["status"] ?? ""));
              if (m1["status"] != "Inforced")
                Constants.salesByAgentSales4c.add(SalesByAgentSale(
                    m1["policy_number"] ?? "",
                    m1["inception_date"] ?? "",
                    m1["sale_datetime"] ?? "",
                    m1["product"] ?? "",
                    m1["product_type"] ?? "",
                    m1["payment_type"] ?? "",
                    m1["totalAmountPayable"] ?? 0,
                    m1["status"] ?? ""));
            }
          }

          Constants.salesByAgentSales4a.toSet().toList();
          Constants.salesByAgentSales4b.toSet().toList();
          Constants.salesByAgentSales4c.toSet().toList();
          sales_jsonResponse4a =
              jsonResponse["products_group"] as Map<String, dynamic>;
          isSalesDataLoading3b = false;
          Constants.sales_tree_key4a = UniqueKey();
          salesValue.value++;
        }
      }
    });
  } on Exception catch (_, exception) {
    //Exception exc = exception as Exception;
    // print(exception);
  }
}
*/

Map<String, Color> typeToColor = {
  'Cash Payment': Colors.blue,
  'Debit Order': Colors.purple,
  'persal': Colors.green,
  'Salary Deduction': Colors.yellow,
  'Other': Colors.grey,
};

Map<Color, int> colorOrder = {
  Colors.blue: 1,
  Colors.purple: 2,
  Colors.green: 3,
  Colors.yellow: 4,
  Colors.grey: 5,
};
Color _getStatusColor(String status) {
  Color color;
  switch (status) {
    case 'Cash Payment':
      color = Colors.blue;
      break;
    case 'EFT':
      color = Colors.purple;
      break;
    case 'Debit Order':
      color = Colors.orange;
      break;
    case 'persal':
      color = Colors.green;
      break;
    case 'Easypay':
      color = Colors.indigo;
      break;
    case 'Salary Deduction':
      color = Colors.yellow;
      break;
    default:
      print("fgghgh " + status);
      color = Colors.grey;
  }
  return color;
}

List<BarChartGroupData> processDataForSalesDaily1(List<dynamic> jsonData) {
  bool containsData = false;

  DateTime now = DateTime.now();
  int currentMonth = now.month;
  int currentYear = now.year;
  int daysInCurrentMonth = DateTime(currentYear, currentMonth + 1, 0).day;

  Map<int, Map<String, double>> dailyAttendance = {
    for (var day = 1; day <= daysInCurrentMonth; day++) day: {}
  };

  for (var item in jsonData) {
    if (item is Map<String, dynamic>) {
      DateTime date = DateTime.parse(item['date_or_month']);
      if (date.month == currentMonth && date.year == currentYear) {
        int dayOfMonth = date.day;
        String status = item["type"] ?? "";
        double count = (item["average_premium"] as num)
            .toDouble(); // Cast to num first to avoid errors
        dailyAttendance[dayOfMonth]
            ?.update(status, (value) => value + count, ifAbsent: () => count);
        if (count > 0) containsData = true;
      }
    }
  }

  List<BarChartGroupData> barChartData = [];
  dailyAttendance.forEach((dayOfMonth, statusData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    // Create a sorted list of MapEntry from statusData
    var sortedEntries = statusData.entries
        .map((e) => MapEntry(_getStatusColor(e.key), e.value))
        .toList()
      ..sort(
          (a, b) => (colorOrder[a.key] ?? 0).compareTo(colorOrder[b.key] ?? 0));

    for (var entry in sortedEntries) {
      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + entry.value, entry.key));
      cumulativeAmount += entry.value;
    }

    barChartData.add(BarChartGroupData(
      x: dayOfMonth,
      barRods: [
        BarChartRodData(
          toY: cumulativeAmount,
          rodStackItems: rodStackItems.isEmpty
              ? [BarChartRodStackItem(0, 0, Colors.transparent)]
              : rodStackItems,
          borderRadius: BorderRadius.zero,
          width: 8,
        ),
      ],
      barsSpace: 4,
    ));
  });

  return containsData ? barChartData : [];
}

List<BarChartGroupData> processDataForSalesDaily3(
    List<dynamic> jsonData, DateTime startDate) {
  bool containsData = false;
  DateTime endDate =
      startDate.add(Duration(days: 30)); // 31 days including the start date

  // Initialize dailyAttendance with empty maps for each day in the range
  Map<int, Map<String, double>> dailyAttendance = {};

  // Pre-initialize all days in the range to ensure every day is accounted for
  for (int i = 0; i <= 30; i++) {
    // Loop through 31 days, including the start date
    dailyAttendance[i] = {}; // Initialize each day with an empty map
  }

  // Process jsonData to populate dailyAttendance
  for (var item in jsonData) {
    if (item is Map<String, dynamic>) {
      DateTime date = DateTime.parse(item['date_or_month']);
      if (date.isBefore(startDate) || date.isAfter(endDate))
        continue; // Skip dates outside the range

      String status = item["type"] ?? "";
      double count = (item["average_premium"] as num).toDouble();
      int dayDifference = date.difference(startDate).inDays;

      if (dayDifference >= 0 && dayDifference <= 30) {
        // Ensure within the 31-day range
        dailyAttendance[dayDifference]
            ?.update(status, (value) => value + count, ifAbsent: () => count);
        if (count > 0) containsData = true;
      }
    }
  }

  List<BarChartGroupData> barChartData = [];
  dailyAttendance.forEach((dayDifference, statusData) {
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    statusData.forEach((status, value) {
      Color color = _getStatusColor(
          status); // Ensure this function exists and returns a Color
      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + value, color));
      cumulativeAmount += value;
    });

    if (cumulativeAmount > 0 || dayDifference <= dailyAttendance.keys.length) {
      // Include all days in range
      barChartData.add(BarChartGroupData(
        x: dayDifference,
        barRods: [
          BarChartRodData(
            toY: cumulativeAmount,
            rodStackItems: rodStackItems.isEmpty
                ? [BarChartRodStackItem(0, 0, Colors.transparent)]
                : rodStackItems,
            borderRadius: BorderRadius.zero,
            width: 8,
          ),
        ],
        barsSpace: 4,
      ));
    }
  });

  return containsData ? barChartData : [];
}

List<BarChartGroupData> processDataForCommissionCountMonthly2(
  List<dynamic> jsonData,
  BuildContext context,
) {
  bool containsData = false;

  Map<String, Map<String, double>> monthlySales = {};

  for (var item in jsonData) {
    if (item is Map<String, dynamic>) {
      //print("datehhghg $item ");
      DateTime date = DateTime.parse(item['date_or_month'] + "-01");

      String monthKey = "${date.year}-${date.month.toString().padLeft(2, '0')}";
      String type = item["type"] ?? "";
      double count = (item["average_premium"] as num).toDouble();

      monthlySales.putIfAbsent(monthKey, () => {});
      //print("ghggh $monthKey $count");
      monthlySales[monthKey]
          ?.update(type, (value) => value + count, ifAbsent: () => count);
      containsData = true;
    }
  }

  var sortedMonths = monthlySales.keys.toList()..sort();

  List<BarChartGroupData> barChartData = [];
  for (var monthKey in sortedMonths) {
    var statusData = monthlySales[monthKey];
    double cumulativeAmount = 0.0;
    List<BarChartRodStackItem> rodStackItems = [];

    // Assuming sortReprintCancellationsData and colorOrder are defined elsewhere
    var sortedEntries = sortReprintCancellationsData(statusData!);
    sortedEntries.forEach((entry) {
      Color color = _getStatusColor(entry.key);
      rodStackItems.add(BarChartRodStackItem(
          cumulativeAmount, cumulativeAmount + entry.value, color));
      cumulativeAmount += entry.value;
    });

    barChartData.add(BarChartGroupData(
      x: DateTime.parse(monthKey + "-01").month,
      barRods: [
        BarChartRodData(
          toY: cumulativeAmount,
          rodStackItems: rodStackItems.isEmpty
              ? [BarChartRodStackItem(0, 0, Colors.transparent)]
              : rodStackItems,
          borderRadius: BorderRadius.zero,
          width: (Constants.screenWidth / 12) - 8,
        ),
      ],
    ));
  }

  return containsData ? barChartData : [];
}

List<MapEntry<String, double>> sortReprintCancellationsData(
    Map<String, double> salesData) {
  Map<String, Color> typeToColor = {
    'Cash Payment': Colors.blue,
    'Debit Order': Colors.purple,
    'persal': Colors.green,
    'Salary Deduction': Colors.yellow,
    'Other': Colors.grey,
  };

  Map<Color, int> colorOrder = {
    Colors.blue: 1,
    Colors.purple: 2,
    Colors.green: 3,
    Colors.yellow: 4,
    Colors.grey: 5,
  };

  var entries = salesData.entries.toList();

  entries.sort((a, b) {
    Color colorA =
        typeToColor[a.key] ?? Colors.grey; // Default to grey if not found
    Color colorB =
        typeToColor[b.key] ?? Colors.grey; // Default to grey if not found
    return colorOrder[colorA]!.compareTo(colorOrder[colorB]!);
  });

  return entries;
}
