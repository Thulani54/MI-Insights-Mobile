import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';

import 'package:motion_toast/motion_toast.dart';

import '../../constants/Constants.dart';
import '../../customwidgets/custom_input.dart';
import '../../models/SalesAgentModel.dart';
import '../../models/map_class.dart';
import '../../services/MyNoyifier.dart';

MyNotifier? myNotifier;

Future<void> createCallCenterNewLead({
  required BuildContext context,
  required String leadGuid,
  required String cellphone,
  required String title,
  required String name,
  required String surname,
  required String campaign,
  required int branchId,
  required String product,
  required String productType,
}) async {
  // Prepare the data payload
  final Map<String, dynamic> data = {
    "LeadGuid": leadGuid,
    "cec_client_id": Constants.cec_client_id,
    "empId": Constants.cec_empid,
    "cellphone": cellphone,
    "title": title,
    "name": name,
    "surname": surname,
    "campaign": campaign,
    "branch_id": branchId,
    "product": product,
    "product_type": productType,
  };

  String createUrl = "${Constants.insightsBackendBaseUrl}parlour/newLead";

  try {
    // Send POST request
    final response = await http.post(
      Uri.parse(createUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final leadId = jsonDecode(response.body);
      print("Lead created successfully: $leadId");

      // Fetch the lead details using the lead ID
      final lead = await fetchLeadById(leadId);

      if (lead != null) {
        Navigator.of(context).pop(); // Close the current dialog

        // Open a new dialog with lead details
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text("Lead Details"),
              content: Text(
                  "Lead successfully created:\n\nName: ${lead.title} ${lead.firstName} ${lead.lastName}\nLead ID: ${lead.onololeadid}"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the new dialog
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(
            context, "Failed to fetch lead details. Please try again.");
      }
    } else {
      print("Failed to create lead: ${response.body}");
      showErrorDialog(context, "Failed to create lead. Please try again.");
    }
  } catch (error) {
    print("Error creating lead: $error");
    showErrorDialog(context, "An error occurred. Please try again later.");
  }
}

Future<LeadObject?> fetchLeadById(String leadId) async {
  final String fetchUrl =
      "${Constants.insightsBackendBaseUrl}parlour/getLeadById?onololeadid=$leadId&cec_client_id=${Constants.cec_empid}";
  print("dffgfg sd ds $fetchUrl");

  try {
    final response = await http.get(Uri.parse(fetchUrl));
    print("gfgggh1 ${response.body}");
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      Constants.currentleadAvailable = Lead.fromJson(responseData[0]);

      print("gfgggh2 ${Constants.currentleadAvailable}");
      return LeadObject.fromJson(responseData[0]);
    } else {
      print("Failed to fetch lead by ID: ${response.statusCode}");
    }
  } catch (error) {
    print("Error fetching lead by ID: $error");
  }
  return null;
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the error dialog
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}

class FieldSaleManualDial extends StatefulWidget {
  const FieldSaleManualDial({super.key});

  @override
  State<FieldSaleManualDial> createState() => _FieldSaleManualDialState();
}

class _FieldSaleManualDialState extends State<FieldSaleManualDial> {
  final _CADPhoneController = TextEditingController();
  final _CADFirstnameController = TextEditingController();
  final _CADLastnameController = TextEditingController();
  String? _selectedValue1;
  String? _selectedValue2;
  String? _selectedProduct;
  String? _selectedProductType;
  int show_index1 = 0;
  List<Map<String, String>> salesDropdownItems = [];
  List<Map<String, String>> salesDropdownList2 = [
    {'value': 'Mr', 'label': 'Mr'},
    {'value': 'Ms', 'label': 'Ms'},
    {'value': 'Mrs', 'label': 'Mrs'},
    {'value': 'Miss', 'label': 'Miss'},
  ];
  List<Map<String, String>> productDropdownItems = [
    {'value': 'Athandwe', 'label': 'Athandwe'},
    {'value': 'Masibambane', 'label': 'Masibambane'},
    {'value': 'Siyazisizana', 'label': 'Siyazisizana'},
    {'value': 'Phakamani', 'label': 'Phakamani'},
  ];
  List<Map<String, String>> productTypeDropdownItems = [
    {'value': 'Athandwe', 'label': 'Athandwe'},
    {'value': 'Standard', 'label': 'Standard'},
    {'value': 'Premium', 'label': 'Premium'},
    {'value': 'Elite', 'label': 'Elite'},
  ];
  List<ParlourRatesExtras2> displayed_parlour_rates = [
    ParlourRatesExtras2(
      "Select Product",
      "",
    )
  ];
  SalesAgentModel? selected_agent;
  List<SalesAgentModel> all_sales_agents = [];
  List<SalesAgentModel> filteredSalesAgents = [];
  String title = "Mr";
  List<String> titles = ["Mr", "Ms", "Mrs", "Miss"];

  TextEditingController phone_number_controller = TextEditingController();
  TextEditingController name_controller = TextEditingController();
  TextEditingController surname_controller = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController _salesAgentController = TextEditingController();
  String agent_sale_date = "Select Date";
  SalesAgentModel? selectedSalesAgent;
  FocusNode phone_number_focus_node = FocusNode();
  FocusNode name_focus_node = FocusNode();
  FocusNode surname_focus_node = FocusNode();
  FocusNode sales_agent_focus_node = FocusNode();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCampaigns(); // Fetch campaigns on initialization
  }

  Future<void> fetchCampaigns() async {
    // String url ="${Constants.insightsBackendUrl}parlour/getCampaigns?cec_client_id=1";
    String url =
        "${Constants.insightsBackendBaseUrl}parlour/getCampaigns?cec_client_id=1";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          salesDropdownItems = [
            {'value': '--Select Campaign--', 'label': '--Select Campaign--'},
            ...data
                .map((campaign) => {
                      'value': campaign['campaign_name'] as String,
                      'label': campaign['campaign_name'] as String,
                    })
                .toList(),
          ];
        });
      } else {
        print("Failed to fetch campaigns: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching campaigns: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Manual Dial',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'YuGothic',
                            color: Colors.black,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Iconsax.close_square,
                            size: 28,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey.withOpacity(0.55)),
                    const SizedBox(height: 16),
                    buildInputField(
                      label: "Phone Number",
                      child: CustomInputTransparent1(
                        controller: _CADPhoneController,
                        hintText: '+27 67 345 6789',
                        onChanged: (value) {},
                        onSubmitted: (value) {},
                        focusNode: FocusNode(),
                        //suffix: Icon(CupertinoIcons.person_fill, size: 22, color: Color(0xFFEF601B).withOpacity(0.45),),
                        textInputAction: TextInputAction.next,
                        isPasswordField: false,
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildDropdownField(
                      label: "Campaign",
                      dropdownValue: _selectedValue1,
                      items: salesDropdownItems,
                      onChanged: (value) => setState(() {
                        _selectedValue1 = value;
                      }),
                    ),
                    const SizedBox(height: 16),
                    buildDropdownField(
                      label: "Product",
                      dropdownValue: _selectedProduct,
                      items: productDropdownItems,
                      onChanged: (value) => setState(() {
                        _selectedProduct = value;
                      }),
                    ),
                    const SizedBox(height: 16),
                    buildDropdownField(
                      label: "Product Type",
                      dropdownValue: _selectedProductType,
                      items: productTypeDropdownItems,
                      onChanged: (value) => setState(() {
                        _selectedProductType = value;
                      }),
                    ),
                    const SizedBox(height: 16),
                    buildExpandableSection(setState),
                    const SizedBox(height: 16),
                    Divider(color: Colors.grey.withOpacity(0.55)),
                    const SizedBox(height: 16),
                    buildActionButtons(setState),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildInputField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'YuGothic',
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget buildDropdownField({
    required String label,
    required String? dropdownValue,
    required List<Map<String, String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'YuGothic',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: const Text(
                '--Select--',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'YuGothic',
                ),
              ),
              value: dropdownValue,
              onChanged: onChanged,
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                ),
              ),
              items: items.map<DropdownMenuItem<String>>(
                (Map<String, String> item) {
                  return DropdownMenuItem<String>(
                    value: item['value'],
                    child: Text(
                      item['label']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildExpandableSection(void Function(void Function()) setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Additional Lead Details',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'YuGothic',
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  show_index1 = show_index1 == 0 ? 1 : 0;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Constants.ctaColorLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(5),
                child: Icon(
                  show_index1 == 0 ? Icons.add : Icons.remove,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        if (show_index1 == 1)
          Column(
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: buildDropdownField(
                      label: "Title",
                      dropdownValue: _selectedValue2,
                      items: salesDropdownList2,
                      onChanged: (value) => setState(() {
                        _selectedValue2 = value;
                      }),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildInputField(
                      label: "Name",
                      child: CustomInputTransparent1(
                        controller: _CADFirstnameController,
                        hintText: 'First Name',

                        onChanged: (value) {},
                        onSubmitted: (value) {},
                        focusNode: FocusNode(),
                        //suffix: Icon(CupertinoIcons.person_fill, size: 22, color: Color(0xFFEF601B).withOpacity(0.45),),
                        textInputAction: TextInputAction.next,
                        isPasswordField: false,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildInputField(
                      label: "Last Name",
                      child: CustomInputTransparent1(
                        controller: _CADLastnameController,
                        hintText: 'Last Name',
                        onChanged: (value) {},
                        onSubmitted: (value) {},
                        focusNode: FocusNode(),
                        //suffix: Icon(CupertinoIcons.person_fill, size: 22, color: Color(0xFFEF601B).withOpacity(0.45),),
                        textInputAction: TextInputAction.next,
                        isPasswordField: false,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Widget buildActionButtons(void Function(void Function()) setState) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ElevatedButton.icon(
              icon: Icon(
                Icons.save,
                size: 16,
                color: Colors.white,
              ),
              label: Text(
                "Submit",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'YuGothic',
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12),
                backgroundColor: Constants.ctaColorLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(360),
                ),
              ),
              onPressed: () => _handleCreateLead("Submit", setState),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ElevatedButton.icon(
              icon: Icon(
                Icons.save_as,
                size: 16,
                color: Colors.white,
              ),
              label: Text(
                "Save and Continue",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'YuGothic',
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(360),
                ),
              ),
              onPressed: () => _handleCreateLead("Save and Continue", setState),
            ),
          ),
        ),
      ],
    );
  }

  void _handleCreateLead(String buttonType, void Function(void Function()) setState) {
    // Validate required fields
    if (_CADPhoneController.text.isEmpty) {
      MotionToast.error(
        height: 45,
        onClose: () {},
        description: const Text(
          "Cellphone cannot be empty",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'YuGothic',
          ),
        ),
      ).show(context);
      return;
    }
    
    if (_selectedValue1 == null || _selectedValue1 == '--Select Campaign--') {
      MotionToast.error(
        height: 45,
        onClose: () {},
        description: const Text(
          "Please select a campaign",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'YuGothic',
          ),
        ),
      ).show(context);
      return;
    }
    
    if (_selectedProduct == null) {
      MotionToast.error(
        height: 45,
        onClose: () {},
        description: const Text(
          "Please select a product",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'YuGothic',
          ),
        ),
      ).show(context);
      return;
    }
    
    if (_selectedProductType == null) {
      MotionToast.error(
        height: 45,
        onClose: () {},
        description: const Text(
          "Please select a product type",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'YuGothic',
          ),
        ),
      ).show(context);
      return;
    }

    // If additional details are expanded, validate them
    if (show_index1 == 1) {
      if (_selectedValue2 == null) {
        MotionToast.error(
          height: 45,
          onClose: () {},
          description: const Text(
            "Title cannot be empty",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontFamily: 'YuGothic',
            ),
          ),
        ).show(context);
        return;
      }
      
      if (_CADFirstnameController.text.isEmpty) {
        MotionToast.error(
          height: 45,
          onClose: () {},
          description: const Text(
            "First Name cannot be empty",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontFamily: 'YuGothic',
            ),
          ),
        ).show(context);
        return;
      }
      
      if (_CADLastnameController.text.isEmpty) {
        MotionToast.error(
          height: 45,
          onClose: () {},
          description: const Text(
            "Last Name cannot be empty",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontFamily: 'YuGothic',
            ),
          ),
        ).show(context);
        return;
      }
    }

    // Create the lead for both Submit and Save and Continue
    createCallCenterNewLead(
      context: context,
      leadGuid: "${buttonType}_ManualDial_Lead",
      cellphone: _CADPhoneController.text,
      title: show_index1 == 1 ? _selectedValue2.toString() : "Mr", // Default title if not specified
      name: show_index1 == 1 ? _CADFirstnameController.text : "Not Specified",
      surname: show_index1 == 1 ? _CADLastnameController.text : "Not Specified",
      campaign: _selectedValue1.toString(),
      branchId: 6,
      product: _selectedProduct.toString(),
      productType: _selectedProductType.toString(),
    );

    // For "Save and Continue", you might want to clear the form or perform additional actions
    if (buttonType == "Save and Continue") {
      // Clear the form for the next lead
      setState(() {
        _CADPhoneController.clear();
        _CADFirstnameController.clear();
        _CADLastnameController.clear();
        _selectedValue1 = null;
        _selectedValue2 = null;
        _selectedProduct = null;
        _selectedProductType = null;
        show_index1 = 0;
      });
    }
  }

  Widget buildButton(String label, IconData icon, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: ElevatedButton.icon(
          icon: Icon(
            icon,
            size: 16,
            color: Colors.white,
          ),
          label: Text(label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                fontFamily: 'YuGothic',
                color: Colors.white,
              )),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(12),
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(360),
            ),
          ),
          onPressed: () {
            if (_CADPhoneController.text.isEmpty) {
              MotionToast.error(
                height: 40,
                onClose: () {},
                description: Text(
                  "Cellphone cannot be empty",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'YuGothic',
                  ),
                ),
              ).show(context);
            }
            if (_CADFirstnameController.text.isEmpty) {
              MotionToast.error(
                height: 40,
                onClose: () {},
                description: Text(
                  "First Name cannot be empty",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'YuGothic',
                  ),
                ),
              ).show(context);
            }
            if (_CADLastnameController.text.isEmpty) {
              MotionToast.error(
                height: 40,
                onClose: () {},
                description: Text(
                  "Last Name cannot be empty",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'YuGothic',
                  ),
                ),
              ).show(context);
            }
            if (_selectedValue2 == null) {
              MotionToast.error(
                height: 40,
                onClose: () {},
                description: Text(
                  "Title cannot be empty",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'YuGothic',
                  ),
                ),
              ).show(context);
            }
            if (label == "Save & Call") {
              // Validate product and productType
              if (_selectedProduct == null || _selectedProductType == null) {
                MotionToast.error(
                  height: 45,
                  onClose: () {},
                  description: const Text(
                    "Please select product and product type",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'YuGothic',
                    ),
                  ),
                ).show(context);
                return;
              }
              
              createCallCenterNewLead(
                  context: context,
                  leadGuid: "ManualDial_Lead",
                  cellphone: _CADPhoneController.text,
                  title: _selectedValue2.toString(),
                  name: _CADFirstnameController.text,
                  surname: _CADLastnameController.text,
                  campaign: _selectedValue1.toString(),
                  branchId: 6,
                  product: _selectedProduct.toString(),
                  productType: _selectedProductType.toString());
            }
          },
        ),
      ),
    );
  }
}
