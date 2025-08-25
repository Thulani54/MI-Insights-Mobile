import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mi_insights/customwidgets/CustomCard.dart';

import '../../constants/Constants.dart';
import '../../customwidgets/custom_date_range_picker.dart';
import '../../services/inactivitylogoutmixin.dart';

double _sliderPosition = 0.0;
int _selectedButton = 1;
DateTime? startDate = DateTime.now();
DateTime? endDate = DateTime.now();
int grid_index = 0;
int grid_index_2 = 0;
double _sliderPosition4 = 0.0;
TextEditingController _searchController = TextEditingController();
String _searchQuery = '';

class UserRoles extends StatefulWidget {
  const UserRoles({super.key});

  @override
  State<UserRoles> createState() => _UserRolesState();
}

class _UserRolesState extends State<UserRoles> with InactivityLogoutMixin {
  Color _button1Color = Colors.grey.withOpacity(0.0);
  Color _button2Color = Colors.grey.withOpacity(0.0);
  Color _button3Color = Colors.grey.withOpacity(0.0);
  int currentLevel = 0;
  void _animateButton(int buttonNumber, BuildContext context) {
    restartInactivityTimer();

    setState(() {});

    _selectedButton = buttonNumber;
    if (buttonNumber == 1) {
      startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
      endDate = DateTime.now();
      _sliderPosition = 0.0;
    } else if (buttonNumber == 2) {
      _sliderPosition = (MediaQuery.of(context).size.width / 3) - 18;
      startDate = DateTime.now().subtract(Duration(days: 365));
      endDate = DateTime.now();
    } else if (buttonNumber == 3) {
      _sliderPosition = 2 * (MediaQuery.of(context).size.width / 3) - 32;
    }
    setState(() {});
    if (buttonNumber != 3) {
      setState(() {
        // Update colors
        _button1Color = buttonNumber == 1
            ? Constants.ctaColorLight
            : Colors.grey.withOpacity(0.0);
        _button2Color = buttonNumber == 2
            ? Constants.ctaColorLight
            : Colors.grey.withOpacity(0.0);
        _button3Color = buttonNumber == 3
            ? Constants.ctaColorLight
            : Colors.grey.withOpacity(0.0);

        // Update slider position based on the button tapped
      });
      DateTime now = DateTime.now();

      setState(() {});
    } else {
      showCustomDateRangePicker(
        context,
        dismissible: false,
        minimumDate: DateTime.utc(2023, 06, 01),
        maximumDate: DateTime.now(),
        /*    endDate: endDate,
        startDate: startDate,*/
        backgroundColor: Colors.white,
        primaryColor: Constants.ctaColorLight,
        onApplyClick: (start, end) {
          setState(() {
            endDate = end;
            startDate = start;
          });

          setState(() {});

          restartInactivityTimer();
        },
        onCancelClick: () {
          restartInactivityTimer();
          if (kDebugMode) {
            print("user cancelled.");
          }
          setState(() {
            _animateButton(1, context);
          });
        },
      );
    }
  }

  void _animateButton4(int buttonNumber) {
    restartInactivityTimer();

    setState(() {});

    grid_index = buttonNumber;
    if (buttonNumber == 0) {
      _sliderPosition4 = 0.0;
    } else if (buttonNumber == 1) {
      _sliderPosition4 = (MediaQuery.of(context).size.width / 3) - 18;
    } else if (buttonNumber == 2) {
      _sliderPosition4 = 2 * (MediaQuery.of(context).size.width / 3) - 32;
    }
    setState(() {});
  }

  List<dynamic> userRoles = [];
  List<Map<String, dynamic>> filteredUsers = [];
  List<dynamic> activeUserRoles = [];
  List<dynamic> inactiveUserRoles = [];
  List<dynamic> allRoles = [];
  List<dynamic> allPermissions = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    endDate = DateTime.now();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchUserRoles();
    await fetchAllRoles();
    await fetchAllPermissions();
    _searchController.addListener(_filterUsers);
  }

  void _filterUsers() {
    setState(() {
      filteredUsers = List<Map<String, dynamic>>.from(userRoles).where((user) {
        final query = _searchController.text.toLowerCase();
        print(user);
        return user['name'].toLowerCase().contains(query);
      }).toList();
      print(filteredUsers);
    });
  }

  Future<void> fetchUserRoles() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate!);
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate!);

    try {
      String baseUrl =
          '${Constants.InsightsReportsbaseUrl}/api/rights_and_roles/get_users_by_client_id/?client_id=${Constants.cec_client_id}&start_date=${formattedStartDate}&end_date=${formattedEndDate}';

      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final roles = data['users'] as List<dynamic>;

        final activeRoles =
            roles.where((e) => e["employee_status"] == "active").toList();
        final inactiveRoles =
            roles.where((e) => e["employee_status"] != "active").toList();

        print("Active Roles: $activeRoles");

        setState(() {
          userRoles = roles;
          activeUserRoles = activeRoles;
          inactiveUserRoles = inactiveRoles;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load user roles');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  Future<void> fetchAllRoles() async {
    try {
      String baseUrl =
          '${Constants.InsightsReportsbaseUrl}/api/rights_and_roles/get_all_roles/';

      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          allRoles = data['roles'];
          print(allRoles);
        });
      } else {
        throw Exception('Failed to load roles');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    }
  }

  Future<void> fetchAllPermissions() async {
    try {
      String baseUrl =
          '${Constants.InsightsReportsbaseUrl}/api/rights_and_roles/get_all_permissions/';

      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          allPermissions = data['permissions'];
          print(allPermissions);
        });
      } else {
        throw Exception('Failed to load permissions');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    }
  }

  Future<void> updateUserRole(String email, String roleId) async {
    setState(() {
      isLoading = true;
    });

    try {
      String url =
          '${Constants.InsightsReportsbaseUrl}/api/rights_and_roles/update_user_role/';

      final response = await http.post(
        Uri.parse(url),
        body: json.encode({'email': email, 'role_id': roleId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        fetchUserRoles(); // Refresh the user roles
      } else {
        throw Exception('Failed to update user role');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  Future<void> modifyUserPermissions(
      String email, List<String> permissions, String action) async {
    setState(() {
      isLoading = true;
    });

    try {
      String url =
          '${Constants.InsightsReportsbaseUrl}/api/rights_and_roles/modify_user_permissions/';

      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
            {'email': email, 'permissions': permissions, 'action': action}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        fetchUserRoles(); // Refresh the user roles
      } else {
        throw Exception('Failed to modify user permissions');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  Map<String, Map<String, List<Map<String, String>>>> rolesHierarchy = {
    'executive_group': {
      'job_functions': [
        {'value': 'ceo', 'label': 'Chief Executive Officer (CEO)'},
        {'value': 'md', 'label': 'Managing Director (MD)'},
        {'value': 'gm', 'label': 'General Manager (GM)'},
      ],
      'departments': [
        {'value': 'operations_management', 'label': 'Operations Management'},
        {'value': 'finance_management', 'label': 'Finance Management'},
        {'value': 'hr_management', 'label': 'HR Management'},
      ],
    },
    'executive_divisional': {
      'job_functions': [
        {'value': 'rm', 'label': 'Regional Manager (RM)'},
        {'value': 'bm', 'label': 'Branch Manager (BM)'},
        {'value': 'sm', 'label': 'Senior Manager (SM)'},
      ],
      'departments': [
        {'value': 'sales_management', 'label': 'Sales Management'},
        {'value': 'marketing_management', 'label': 'Marketing Management'},
        {'value': 'product_development', 'label': 'Product Development'},
      ],
    },
    'senior_management': {
      'job_functions': [
        {'value': 'sm', 'label': 'Senior Manager (SM)'},
        {'value': 'm', 'label': 'Manager (M)'},
        {'value': 'tl', 'label': 'Team Leader (TL)'},
      ],
      'departments': [
        {'value': 'policy_administration', 'label': 'Policy Administration'},
        {'value': 'claims_management', 'label': 'Claims Management'},
        {
          'value': 'client_retentions_management',
          'label': 'Client Retentions Management'
        },
      ],
    },
    'middle_management': {
      'job_functions': [
        {'value': 'm', 'label': 'Manager (M)'},
        {'value': 'tl', 'label': 'Team Leader (TL)'},
        {'value': 'c_s_a', 'label': 'Consultant / Specialist / Agent (C/S/A)'},
      ],
      'departments': [
        {
          'value': 'customer_service_management',
          'label': 'Customer Service Management'
        },
        {'value': 'quality_assurance', 'label': 'Quality Assurance'},
        {'value': 'compliance_management', 'label': 'Compliance Management'},
      ],
    },
    'lower_management': {
      'job_functions': [
        {'value': 'fa', 'label': 'Field Agent (FA)'},
        {'value': 'bc', 'label': 'Branch Consultant (BC)'},
        {'value': 'cca', 'label': 'Call Centre Agent (CCA)'},
      ],
      'departments': [
        {'value': 'inventory_management', 'label': 'Inventory Management'},
        {
          'value': 'buying_purchasing_logistics',
          'label': 'Buying / Purchasing & Logistics'
        },
        {'value': 'others', 'label': 'Others'},
      ],
    },
    'specialist': {
      'job_functions': [
        {'value': 'ca', 'label': 'Adjudicator / Agent (CA)'},
        {'value': 'assessor', 'label': 'Assessor / Agent (CA)'},
        {'value': 'sales_management', 'label': 'Sales Management'},
      ],
      'departments': [
        {'value': 'legal_compliance', 'label': 'Legal & Compliance'},
        {'value': 'it', 'label': 'IT'},
        {'value': 'quality_assurance', 'label': 'Quality Assurance'},
      ],
    },
  };
  List<Map<String, String>> moduleChoices = [
    {'value': 'sales', 'label': 'Sales'},
    {'value': 'collections', 'label': 'Collections'},
    {'value': 'claims', 'label': 'Claims'},
    {'value': 'customer_profile', 'label': 'Cust. Profile'},
    {'value': 'fulfillment', 'label': 'Fulfillment'},
    {'value': 'commission', 'label': 'Commission'},
    {'value': 'maintenance', 'label': 'Maintenance'},
    {'value': 'attendance', 'label': 'Attendance'},
    {'value': 'policy_search', 'label': 'Pol. Search'},
    {'value': 'reprints', 'label': 'Reprints'},
    {'value': 'morale_index', 'label': 'Morale Index'},
    {'value': 'retentions', 'label': 'Retentions'},
    {'value': 'marketing', 'label': 'Marketing'},
  ];

  List<Map<String, String>> permissionChoices = [
    {'value': 'view only', 'label': 'View Only'},
    {'value': 'create', 'label': 'Create'},
    {'value': 'edit', 'label': 'Edit'},
    {'value': 'delete', 'label': 'Delete'},
    {'value': 'manage', 'label': 'Manage'},
    {'value': 'admin', 'label': 'Admin'},
    {'value': 'custom', 'label': 'Custom'},
  ];

  void _showEditUserRolesDialog(Map<String, dynamic> user) {
    //print("dfdf ");
    String email = user['email'];
    String? selectedCompanyType;
    String? selectedRoleLevel;
    String? selectedJobFunction;
    String? selectedDepartment;
    String currentRole = "";
    List<Map<String, dynamic>> selectedModulePermissionPairs = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            List<dynamic> userRoles1 = user["roles"] ?? [];
            List<dynamic> userPermissions1 = user["permissions"] ?? [];
            //print(user);
            //print(userRoles1);

            try {
              if (userRoles1.isNotEmpty) {
                setState(() {
                  //print(userRoles1);

                  selectedCompanyType = userRoles1[0]['company_type'] ?? "";
                  selectedRoleLevel = userRoles1[0]['role_level'] ?? "";
                  selectedJobFunction =
                      userRoles1[0]['role_job_function'] ?? "";
                  selectedDepartment =
                      userRoles1[0]['function_department'] ?? "";
                  currentRole =
                      "$selectedCompanyType - $selectedRoleLevel - $selectedJobFunction - $selectedDepartment";
                });

                if (userPermissions1.isNotEmpty) {
                  selectedModulePermissionPairs =
                      List<Map<String, dynamic>>.from(
                    userPermissions1.map((perm) => {
                          'module': perm['module'],
                          'permissions': [perm['type']]
                        }),
                  );
                }
              }
            } catch (e) {
              print("Error setting state: $e");
            }
            void _onCompanyTypeChanged(String? value) {
              setState(() {
                selectedCompanyType = value;
                selectedRoleLevel = null;
                selectedJobFunction = null;
                selectedDepartment = null;
                selectedModulePermissionPairs.clear();
              });
            }

            void _onRoleLevelChanged(String? value) {
              setState(() {
                selectedRoleLevel = value;
                selectedJobFunction = null;
                selectedDepartment = null;
                selectedModulePermissionPairs.clear();
              });
            }

            void _onJobFunctionChanged(String? value) {
              setState(() {
                selectedJobFunction = value;
                selectedDepartment = null;
                selectedModulePermissionPairs.clear();
              });
            }

            void _addModulePermissionPair() {
              // print("gfhg");
              setState(() {
                selectedModulePermissionPairs.add({
                  'module': null,
                  'permissions': [],
                });
              });
            }

            void _removeModulePermissionPair(int index) {
              setState(() {
                selectedModulePermissionPairs.removeAt(index);
              });
            }

            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              buttonPadding: EdgeInsets.only(top: 0.0, left: 0, right: 0),
              insetPadding: EdgeInsets.only(left: 8.0, right: 8),
              titlePadding: EdgeInsets.only(right: 0),
              surfaceTintColor: Colors.white,
              contentPadding: const EdgeInsets.only(left: 0.0),
              title: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 12, top: 24),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      currentRole.isEmpty
                          ? Text(
                              'Add User Roles',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            )
                          : Text(
                              'Edit User Roles',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              content: Form(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (currentRole.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Current role : ${formatRoleName(currentRole)}",
                              style: TextStyle(
                                  color: Constants.ctaColorLight,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),

                        // Company Type Dropdown

                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 16, top: 16, bottom: 8),
                                child: Row(
                                  children: [
                                    Text(
                                      "Company Type:",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 8.0, left: 8),
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0.0, top: 0),
                                  child: DropdownButton2<String>(
                                    isExpanded: true,
                                    hint: Text("Company Type"),
                                    value: selectedCompanyType,
                                    onChanged: _onCompanyTypeChanged,
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Colors.white,
                                      ),
                                    ),
                                    items: [
                                      {'value': 'parlour', 'label': 'Parlour'},
                                      {'value': 'broker', 'label': 'Broker'},
                                      {
                                        'value': 'intermediary',
                                        'label': 'Intermediary'
                                      },
                                      {
                                        'value': 'underwriter',
                                        'label': 'Underwriter'
                                      },
                                      {
                                        'value': 'super_user',
                                        'label': 'Super User'
                                      },
                                      {
                                        'value': 'administrator',
                                        'label': 'Administrator'
                                      },
                                      {
                                        'value': 'super_admin',
                                        'label': 'Super Admin'
                                      },
                                    ].map<DropdownMenuItem<String>>(
                                        (Map<String, String> item) {
                                      return DropdownMenuItem<String>(
                                        value: item['value'],
                                        child: Text(
                                          item['label']!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    underline: Container(),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Role Level Dropdown

                        if (selectedCompanyType != null) ...[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 16, top: 16, bottom: 8),
                            child: Row(
                              children: [
                                Text(
                                  "Role Level:",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0, left: 8),
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, top: 0),
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      hint: Text("Role Level"),
                                      value: selectedRoleLevel,
                                      onChanged: _onRoleLevelChanged,
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          color: Colors.white,
                                        ),
                                      ),
                                      items: [
                                        {
                                          'value': 'executive_group',
                                          'label': 'Executive - Group'
                                        },
                                        {
                                          'value': 'executive_divisional',
                                          'label': 'Executive - Divisional'
                                        },
                                        {
                                          'value': 'senior_management',
                                          'label': 'Senior Management'
                                        },
                                        {
                                          'value': 'middle_management',
                                          'label': 'Middle Management'
                                        },
                                        {
                                          'value': 'lower_management',
                                          'label': 'Lower Management'
                                        },
                                        {
                                          'value': 'specialist',
                                          'label': 'Specialist'
                                        },
                                      ].map<DropdownMenuItem<String>>(
                                          (Map<String, String> item) {
                                        return DropdownMenuItem<String>(
                                          value: item['value'],
                                          child: Text(
                                            item['label']!,
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      underline: Container(),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        // Role Job Function Dropdown

                        if (selectedRoleLevel != null) ...[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, top: 16, bottom: 8),
                            child: Row(
                              children: [
                                Text(
                                  "Role Job Function:",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0, left: 8),
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, top: 0),
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      hint: Text("Job Functions"),
                                      value: selectedJobFunction,
                                      onChanged: _onJobFunctionChanged,
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          color: Colors.white,
                                        ),
                                      ),
                                      items: rolesHierarchy[selectedRoleLevel]![
                                              'job_functions']!
                                          .map<DropdownMenuItem<String>>(
                                              (Map<String, String> item) {
                                        return DropdownMenuItem<String>(
                                          value: item['value'],
                                          child: Text(
                                            item['label']!,
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      underline: Container(),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        // Function Department Dropdown

                        if (selectedJobFunction != null) ...[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, top: 16, bottom: 8),
                            child: Row(
                              children: [
                                Text(
                                  "Function Department:",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0, left: 8),
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, top: 0),
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      hint: Text("Department"),
                                      value: selectedDepartment,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedDepartment = value;
                                        });
                                      },
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          color: Colors.white,
                                        ),
                                      ),
                                      items: rolesHierarchy[selectedRoleLevel]![
                                              'departments']!
                                          .map<DropdownMenuItem<String>>(
                                              (Map<String, String> item) {
                                        return DropdownMenuItem<String>(
                                          value: item['value'],
                                          child: Text(
                                            item['label']!,
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      underline: Container(),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        // Module and Permission Pairs
                        // if (selectedDepartment != null)
                        ...[
                          Column(
                            children: List.generate(
                              selectedModulePermissionPairs.length,
                              (index) => Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0, right: 6.0, top: 8.0),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0.0, top: 0),
                                              child: DropdownButton2<String>(
                                                isExpanded: true,
                                                hint: Text("Module"),
                                                value:
                                                    selectedModulePermissionPairs[
                                                        index]['module'],
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedModulePermissionPairs[
                                                            index]['module'] =
                                                        value;
                                                  });
                                                },
                                                dropdownStyleData:
                                                    DropdownStyleData(
                                                  maxHeight: 200,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                items: moduleChoices.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (Map<String, String> item) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: item['value'],
                                                    child: Text(
                                                      item['label']!,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                underline: Container(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6.0, right: 12.0, top: 8.0),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0.0, top: 0),
                                              child: DropdownButton2<String>(
                                                isExpanded: true,
                                                hint: Text("Permissions"),
                                                value: selectedModulePermissionPairs[
                                                                index]
                                                            ['permissions']
                                                        .isNotEmpty
                                                    ? selectedModulePermissionPairs[
                                                                index]
                                                            ['permissions']
                                                        .first
                                                    : null,
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (!selectedModulePermissionPairs[
                                                                index]
                                                            ['permissions']
                                                        .contains(value)) {
                                                      selectedModulePermissionPairs[
                                                                  index]
                                                              ['permissions']
                                                          .add(value!);
                                                    }
                                                  });
                                                },
                                                dropdownStyleData:
                                                    DropdownStyleData(
                                                  maxHeight: 200,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                items: permissionChoices.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (Map<String, String> item) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: item['value'],
                                                    child: Text(
                                                      item['label']!,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                underline: Container(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.remove_circle),
                                    color: Colors.red,
                                    onPressed: () =>
                                        _removeModulePermissionPair(index),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          /*  Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12.0, top: 8.0),
                            child: ElevatedButton.icon(
                              onPressed: _addModulePermissionPair,
                              icon: Icon(
                                Icons.add,
                                color: Constants.ctaColorLight,
                              ),
                              label: Text(
                                'Add Module',
                                style: TextStyle(
                                  color: Constants.ctaColorLight,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, // Button color
                                elevation: 0, // Removes the elevation (shadow)
                                side: BorderSide(
                                    color: Colors.grey), // Adds a grey border
                              ),
                            ),
                          ),*/
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    int? roleId;
                    try {
                      roleId = allRoles.firstWhere(
                        (role) =>
                            role["company_type"] == selectedCompanyType &&
                            role["role_level"] == selectedRoleLevel &&
                            role["role_job_function"] == selectedJobFunction &&
                            role["function_department"] == selectedDepartment,
                      )["role_id"];
                      updateUserRole(email, roleId.toString());
                    } catch (e) {
                      roleId = null;
                    }
                    if (selectedModulePermissionPairs.isNotEmpty) {
                      print(permissionChoices);
                      int? permissionId;
                      print(
                          "Selected Modules and Permissions: $selectedModulePermissionPairs");

                      List<String> usersPermissions = [];
                      List<String> newUsersPermissions = [];
                      List<String> removedUsersPermissions = [];

                      // Assuming user["permissions"] contains a list of permission IDs
                      if (user["permissions"] != null) {
                        usersPermissions =
                            List<String>.from(user["permissions"]);
                      }

                      for (var permission in selectedModulePermissionPairs) {
                        var permissionMatch = allPermissions.firstWhere(
                          (perm) =>
                              permission["module"] == perm["module"] &&
                              permission["permissions"][0] == perm["type"],
                          orElse: () =>
                              null, // Return null if no match is found
                        );

                        if (permissionMatch != null) {
                          permissionId = permissionMatch["permission_id"];
                          print("Permission ID: $permissionId");

                          if (usersPermissions.contains(permissionId)) {
                            print("User already has permission $permissionId");
                          } else {
                            print("Adding new permission $permissionId");
                            newUsersPermissions.add(permissionId.toString());
                          }
                        } else {
                          print(
                              "No matching permission found for module: ${permission["module"]} with type: ${permission["permissions"][0]}");
                        }
                      }

                      // Assuming you also want to remove permissions that are no longer selected
                      for (var userPermission in usersPermissions) {
                        var isStillSelected =
                            selectedModulePermissionPairs.any((permission) {
                          var permissionMatch = allPermissions.firstWhere(
                            (perm) =>
                                permission["module"] == perm["module"] &&
                                permission["permissions"][0] == perm["type"],
                            orElse: () => null,
                          );
                          return permissionMatch != null &&
                              permissionMatch["permission_id"] ==
                                  userPermission;
                        });

                        if (!isStillSelected) {
                          print("Removing permission $userPermission");
                          removedUsersPermissions.add(userPermission);
                        }
                      }

                      if (newUsersPermissions.isNotEmpty) {
                        modifyUserPermissions(
                            email, newUsersPermissions, "add");
                      }

                      if (removedUsersPermissions.isNotEmpty) {
                        modifyUserPermissions(
                            email, removedUsersPermissions, "remove");
                      }
                    }

// Proceed with further logic, like closing the dialog
                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                  /* Container(
                      width: 125,
                      height: 38,
                      decoration: BoxDecoration(
                          color: Constants.ctaColorLight,
                          borderRadius: BorderRadius.circular(360)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 14.0, right: 14, top: 5, bottom: 5),
                        child: Center(
                          child: const Text(
                            'Continue',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),*/
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditAdditionalPermissionsDialog(Map<String, dynamic> user) {
    String email = user['email'];
    List<Map<String, dynamic>> selectedModulePermissionPairs = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Initialize selected permissions from existing additional permissions
            if (selectedModulePermissionPairs.isEmpty &&
                user["additional_permissions"] != null) {
              selectedModulePermissionPairs = List<Map<String, dynamic>>.from(
                user["additional_permissions"].map((perm) {
                  String permissionName = perm['permission_name'];
                  String moduleName = permissionName.split(" ")[0];
                  String permissionType = permissionName.substring(
                      permissionName.indexOf("(") + 1,
                      permissionName.indexOf(")"));

                  return {
                    'module': moduleName.toLowerCase(),
                    'permissions': [permissionType.toLowerCase()],
                  };
                }),
              );
            }

            void _addModulePermissionPair() {
              setState(() {
                // Force refresh by assigning a new list
                selectedModulePermissionPairs = [
                  ...selectedModulePermissionPairs,
                  {'module': null, 'permissions': []}
                ];
              });
            }

            void _removeModulePermissionPair(int index) {
              setState(() {
                selectedModulePermissionPairs =
                    List.from(selectedModulePermissionPairs)..removeAt(index);
              });
            }

            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              buttonPadding: EdgeInsets.only(top: 0.0, left: 0, right: 0),
              insetPadding: EdgeInsets.only(left: 8.0, right: 8),
              titlePadding: EdgeInsets.only(right: 0),
              surfaceTintColor: Colors.white,
              contentPadding: const EdgeInsets.only(left: 0.0),
              title: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 12, top: 24),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Edit Additional Permissions',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              content: Form(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Module and Permission Pairs
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, top: 16, bottom: 8),
                          child: Row(
                            children: [
                              Text(
                                "Modules and Permissions:",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: List.generate(
                            selectedModulePermissionPairs.length,
                            (index) => Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, right: 6.0, top: 8.0),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0, top: 0),
                                            child: DropdownButton2<String>(
                                              isExpanded: true,
                                              hint: Text("Module"),
                                              value:
                                                  selectedModulePermissionPairs[
                                                      index]['module'],
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedModulePermissionPairs[
                                                      index]['module'] = value;
                                                });
                                              },
                                              dropdownStyleData:
                                                  DropdownStyleData(
                                                maxHeight: 200,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  color: Colors.white,
                                                ),
                                              ),
                                              items: moduleChoices.map<
                                                      DropdownMenuItem<String>>(
                                                  (Map<String, String> item) {
                                                return DropdownMenuItem<String>(
                                                  value: item['value'],
                                                  child: Text(
                                                    item['label']!,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              underline: Container(),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6.0, right: 12.0, top: 8.0),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0, top: 0),
                                            child: DropdownButton2<String>(
                                              isExpanded: true,
                                              hint: Text("Permissions"),
                                              value: selectedModulePermissionPairs[
                                                          index]['permissions']
                                                      .isNotEmpty
                                                  ? selectedModulePermissionPairs[
                                                          index]['permissions']
                                                      .first
                                                  : null,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedModulePermissionPairs[
                                                          index]['permissions']
                                                      .clear();
                                                  selectedModulePermissionPairs[
                                                          index]['permissions']
                                                      .add(value!);
                                                });
                                              },
                                              dropdownStyleData:
                                                  DropdownStyleData(
                                                maxHeight: 200,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  color: Colors.white,
                                                ),
                                              ),
                                              items: permissionChoices.map<
                                                      DropdownMenuItem<String>>(
                                                  (Map<String, String> item) {
                                                return DropdownMenuItem<String>(
                                                  value: item['value'],
                                                  child: Text(
                                                    item['label']!,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              underline: Container(),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  color: Colors.red,
                                  onPressed: () =>
                                      _removeModulePermissionPair(index),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12.0, right: 12.0, top: 8.0),
                          child: ElevatedButton.icon(
                            onPressed: _addModulePermissionPair,
                            icon: Icon(
                              Icons.add,
                              color: Constants.ctaColorLight,
                            ),
                            label: Text(
                              'Add a Module and Permission',
                              style: TextStyle(
                                color: Constants.ctaColorLight,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // Button color
                              elevation: 0, // Removes the elevation (shadow)
                              side: BorderSide(
                                  color: Colors.grey), // Adds a grey border
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedModulePermissionPairs.isNotEmpty) {
                      print(
                          "Selected Modules and Permissions: $selectedModulePermissionPairs");

                      List<String> newPermissions = [];
                      for (var permission in selectedModulePermissionPairs) {
                        var permissionMatch = allPermissions.firstWhere(
                          (perm) =>
                              permission["module"] == perm["module"] &&
                              permission["permissions"][0] == perm["type"],
                          orElse: () => null,
                        );

                        if (permissionMatch != null) {
                          newPermissions
                              .add(permissionMatch["permission_id"].toString());
                        }
                      }

                      if (newPermissions.isNotEmpty) {
                        modifyUserPermissions(email, newPermissions, "add");
                      }
                    }

                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          shadowColor: Colors.grey.withOpacity(0.45),
          elevation: 6,
          backgroundColor: Colors.white,
          title: const Text(
            "User Roles",
            style: TextStyle(color: Colors.black),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              CupertinoIcons.back,
              color: Colors.black,
              size: 24,
            ),
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Failed to load user roles',
                            style: TextStyle(color: Colors.red)),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: fetchData,
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(12)),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Center(
                                  child: Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _animateButton(1, context);
                                        },
                                        child: Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3) -
                                              12,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(360)),
                                          height: 35,
                                          child: Center(
                                            child: Text(
                                              '1 Mth View',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _animateButton(2, context);
                                        },
                                        child: Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3) -
                                              12,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(360)),
                                          child: Center(
                                            child: Text(
                                              '12 Mths View',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _animateButton(3, context);
                                        },
                                        child: Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3) -
                                              12,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(360)),
                                          child: Center(
                                            child: Text(
                                              'Select Dates',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              AnimatedPositioned(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                left: _sliderPosition,
                                child: InkWell(
                                  onTap: () {
                                    _animateButton(3, context);
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Constants
                                          .ctaColorLight, // Color of the slider
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: _selectedButton == 1
                                        ? Center(
                                            child: Text(
                                              '1 Mth View',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : _selectedButton == 2
                                            ? Center(
                                                child: Text(
                                                  '12 Mths View',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            : Center(
                                                child: Text(
                                                  'Select Dates',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 12),
                        child: Container(
                          height: 1,
                          color: Colors.grey.withOpacity(0.35),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 8),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(12)),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Center(
                                  child: Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _animateButton4(0);
                                        },
                                        child: Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3) -
                                              12,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(360)),
                                          height: 35,
                                          child: Center(
                                            child: Text(
                                              'All',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _animateButton4(1);
                                        },
                                        child: Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3) -
                                              12,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(360)),
                                          child: Center(
                                            child: Text(
                                              'Active',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _animateButton4(2);
                                        },
                                        child: Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3) -
                                              12,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(360)),
                                          child: Center(
                                            child: Text(
                                              'Inactive',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              AnimatedPositioned(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                left: _sliderPosition4,
                                child: InkWell(
                                  onTap: () {
                                    _animateButton4(2);
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Constants
                                          .ctaColorLight, // Color of the slider
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: grid_index == 0
                                        ? Center(
                                            child: Text(
                                              'All',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : grid_index == 1
                                            ? Center(
                                                child: Text(
                                                  'Active',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            : Center(
                                                child: Text(
                                                  'Inactive',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 8.0, right: 8, top: 12, bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 8, right: 8, top: 4, bottom: 4),
                                child: Container(
                                  height: 40,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Material(
                                      elevation: 10,
                                      surfaceTintColor: Colors.white,
                                      color: Colors.white,
                                      child: TextFormField(
                                        autofocus: false,
                                        decoration: InputDecoration(
                                          suffixIcon: InkWell(
                                            onTap: () {},
                                            child: Container(
                                              height: 35,
                                              width: 70,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0.0,
                                                    bottom: 0.0,
                                                    right: 0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Constants
                                                          .ctaColorLight,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Center(
                                                    child: Text(
                                                      "Search",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          hintText: 'Search a user',
                                          hintStyle: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          filled: true,
                                          fillColor:
                                              Colors.grey.withOpacity(0.09),
                                          contentPadding:
                                              EdgeInsets.only(left: 24),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.0)),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.0)),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        controller: _searchController,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (filteredUsers.isNotEmpty &&
                          _searchController.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12.0, right: 12, bottom: 12),
                          child: CustomCard(
                            elevation: 6,
                            color: Colors.white,
                            child: ListView.builder(
                              itemCount: filteredUsers.length == 0
                                  ? 0
                                  : filteredUsers.length < 4
                                      ? filteredUsers.length
                                      : 4,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final user = filteredUsers[index];
                                return ListTile(
                                  title: Text(user['name']),
                                  subtitle: Text(user['email']),
                                  onTap: () {
                                    _searchController.text = "";
                                    _showUserDialog(user);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: grid_index == 0
                                ? userRoles.length
                                : grid_index == 1
                                    ? activeUserRoles.length
                                    : inactiveUserRoles.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> user = {
                                "user_id": "",
                                "email": "",
                                "employee_status": "",
                                "name": "",
                                "roles": [],
                                "additional_permissions": []
                              };
                              if (grid_index == 0) {
                                user = userRoles[index];
                              } else if (grid_index == 1) {
                                user = activeUserRoles[index];
                              } else {
                                user = inactiveUserRoles[index];
                              }

                              // Extract and format roles
                              final roles = (user['roles'] as List)
                                  .map<String>((role) =>
                                      "${formatRoleName(role['role_job_function'])} ${formatRoleName(role['company_type'])}")
                                  .toList();

                              // Extract and format permissions
                              final userRolesList = user['roles'] as List;
                              List<String> permissions = [];
                              for (var role in userRolesList) {
                                if (role['permissions'] != null &&
                                    role['permissions'].isNotEmpty) {
                                  permissions.addAll((role['permissions']
                                          as List)
                                      .map<String>((permission) =>
                                          "${formatRoleName(permission['module_name'])} - ${formatRoleName(permission['permission_name'])}")
                                      .toList());
                                }
                              }

                              // Extract and format additional permissions
                              final additionalPermissions = (user[
                                      'additional_permissions'] as List)
                                  .map<String>((permission) =>
                                      "${formatRoleName(permission['module_name'])} - ${formatRoleName(permission['permission_name'])}")
                                  .toList();

                              // Build the list item
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomCard(
                                  surfaceTintColor: Colors.white,
                                  color: Colors.white,
                                  elevation: 6,
                                  child: ListTile(
                                    title: Text(
                                      "${index + 1}) Name: ${user['name']}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (grid_index == 0)
                                            Text(
                                                formatRoleName(
                                                    user["employee_status"]),
                                                style: TextStyle(fontSize: 12)),
                                          if (roles.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0),
                                              child: Text(
                                                "Role: ${roles.join(', ')}",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          if (roles.isNotEmpty)
                                            Divider(
                                                color: Colors.grey
                                                    .withOpacity(0.55)),
                                          if (permissions.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0),
                                              child: Text(
                                                "Standard Permissions:",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          if (permissions.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4.0),
                                              child: Text(
                                                permissions.join(', '),
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          if (additionalPermissions.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0),
                                              child: Text(
                                                "Additional Permissions:",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          if (additionalPermissions.isNotEmpty)
                                            Divider(
                                                color: Colors.grey
                                                    .withOpacity(0.55)),
                                          if (additionalPermissions.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0),
                                              child: Text(
                                                additionalPermissions
                                                    .join(', '),
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, bottom: 4),
                                            child: Row(
                                              children: [
                                                roles.isEmpty
                                                    ? Expanded(
                                                        child: Text(
                                                        "Edit Role",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.grey,
                                                            fontSize: 13),
                                                      ))
                                                    : Expanded(
                                                        child: InkWell(
                                                        onTap: () {
                                                          _showEditUserRolesDialog(
                                                              user);
                                                        },
                                                        child: Text(
                                                          "Edit Role",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Constants
                                                                  .ctaColorLight,
                                                              fontSize: 13),
                                                        ),
                                                      )),
                                                roles.isEmpty
                                                    ? Expanded(
                                                        child: Text(
                                                        "Manage Permissions",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.grey,
                                                            fontSize: 13),
                                                      ))
                                                    : Expanded(
                                                        child: InkWell(
                                                        onTap: () {
                                                          _showEditAdditionalPermissionsDialog(
                                                              user);
                                                        },
                                                        child: Text(
                                                          "Manage Permissions",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Constants
                                                                  .ctaColorLight,
                                                              fontSize: 13),
                                                        ),
                                                      ))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    trailing: roles.isNotEmpty ||
                                            user["employee_status"] != "active"
                                        ? null
                                        : IconButton(
                                            icon: Icon(
                                              CupertinoIcons.add_circled,
                                              color: Constants.ctaColorLight,
                                            ),
                                            onPressed: () =>
                                                _showEditUserRolesDialog(user),
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  void _showViewUserPermissions(
      BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          buttonPadding: EdgeInsets.only(top: 0.0, left: 0, right: 0),
          insetPadding: EdgeInsets.only(left: 16.0, right: 16),
          titlePadding: EdgeInsets.only(right: 0),
          surfaceTintColor: Colors.white,
          contentPadding: const EdgeInsets.only(left: 0.0),
          title: Padding(
            padding: const EdgeInsets.only(top: 16, left: 8.0),
            child: Text(
              'User Roles and Permissions',
              style: TextStyle(fontSize: 16),
            ),
          ),
          content: Container(
            width: double.maxFinite,
            color: Colors.grey.withOpacity(0.65),
            child: UserRolesPermissions(userEmail: user['email']),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showUserDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final roles = (user['roles'] as List)
            .map<String>((role) =>
                "${formatRoleName(role['role_job_function'])} ${formatRoleName(role['company_type'])}")
            .toList();

        // Extract and format permissions
        final userRolesList = user['roles'] as List;
        List<String> permissions = [];
        for (var role in userRolesList) {
          if (role['permissions'] != null && role['permissions'].isNotEmpty) {
            permissions.addAll((role['permissions'] as List)
                .map<String>((permission) =>
                    "${formatRoleName(permission['module_name'])} - ${formatRoleName(permission['permission_name'])}")
                .toList());
          }
        }

        // Extract and format additional permissions
        final additionalPermissions = (user['additional_permissions'] as List)
            .map<String>((permission) =>
                "${formatRoleName(permission['module_name'])} - ${formatRoleName(permission['permission_name'])}")
            .toList();
        return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            buttonPadding: EdgeInsets.only(top: 0.0, left: 0, right: 0),
            insetPadding: EdgeInsets.only(left: 8.0, right: 8),
            titlePadding: EdgeInsets.only(right: 0),
            surfaceTintColor: Colors.white,
            contentPadding: const EdgeInsets.only(left: 0.0),
            content: CustomCard(
              surfaceTintColor: Colors.white,
              color: Colors.white,
              elevation: 6,
              child: ListTile(
                title: Text(
                  "Name: ${user['name']}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (grid_index == 0)
                        Text(formatRoleName(user["employee_status"]),
                            style: TextStyle(fontSize: 12)),
                      if (roles.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            "Role: ${roles.join(', ')}",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      if (roles.isNotEmpty)
                        Divider(color: Colors.grey.withOpacity(0.55)),
                      if (permissions.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            "Standard Permissions:",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ),
                      if (permissions.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            permissions.join(', '),
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      if (additionalPermissions.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            "Additional Permissions:",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ),
                      if (additionalPermissions.isNotEmpty)
                        Divider(color: Colors.grey.withOpacity(0.55)),
                      if (additionalPermissions.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            additionalPermissions.join(', '),
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 4),
                        child: Row(
                          children: [
                            roles.isEmpty
                                ? Expanded(
                                    child: Text(
                                    "Edit Role",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        fontSize: 13),
                                  ))
                                : Expanded(
                                    child: InkWell(
                                    onTap: () {
                                      _showEditUserRolesDialog(user);
                                    },
                                    child: Text(
                                      "Edit Role",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Constants.ctaColorLight,
                                          fontSize: 13),
                                    ),
                                  )),
                            roles.isEmpty
                                ? Expanded(
                                    child: Text(
                                    "Manage Permissions",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        fontSize: 13),
                                  ))
                                : Expanded(
                                    child: InkWell(
                                    onTap: () {
                                      _showEditAdditionalPermissionsDialog(
                                          user);
                                    },
                                    child: Text(
                                      "Manage Permissions",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Constants.ctaColorLight,
                                          fontSize: 13),
                                    ),
                                  ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                trailing:
                    roles.isNotEmpty || user["employee_status"] != "active"
                        ? null
                        : IconButton(
                            icon: Icon(
                              CupertinoIcons.add_circled,
                              color: Constants.ctaColorLight,
                            ),
                            onPressed: () => _showEditUserRolesDialog(user),
                          ),
              ),
            ));
      },
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<dynamic> permissionsList;
  final Function(List<dynamic>) onSelectionChanged;

  MultiSelectChip(this.permissionsList, {required this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<dynamic> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];

    widget.permissionsList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          color: WidgetStateProperty.all<Color>(Colors.white),
          disabledColor: Colors.white,
          selectedColor: Constants.ctaColorLight,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          label: Text(item['name']),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}

class GroupedMultiSelectChip extends StatefulWidget {
  final List<dynamic> permissionsList;
  final Function(List<dynamic>) onSelectionChanged;

  GroupedMultiSelectChip(this.permissionsList,
      {required this.onSelectionChanged});

  @override
  _GroupedMultiSelectChipState createState() => _GroupedMultiSelectChipState();
}

class _GroupedMultiSelectChipState extends State<GroupedMultiSelectChip> {
  List<dynamic> selectedChoices = [];

  _buildChoiceList(String module, List<dynamic> permissions) {
    List<Widget> choices = [];
    //print(permissions);

    permissions.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          color: WidgetStateProperty.all<Color>(Colors.white),
          disabledColor: Colors.white,
          selectedColor: Constants.ctaColorLight,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          label: Text(item['type']),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<dynamic>> groupedPermissions = {};

    // Group permissions by module
    widget.permissionsList.forEach((permission) {
      if (!groupedPermissions.containsKey(permission['module'])) {
        groupedPermissions[permission['module']] = [];
      }
      groupedPermissions[permission['module']]!.add(permission);
    });

    List<Widget> modules = [];
    groupedPermissions.forEach((module, permissions) {
      modules.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                formatRoleName(module),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Wrap(
              children: _buildChoiceList(module, permissions),
            ),
          ],
        ),
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: modules,
    );
  }
}

class UserRolesPermissions extends StatefulWidget {
  final String userEmail;

  UserRolesPermissions({required this.userEmail});

  @override
  _UserRolesPermissionsState createState() => _UserRolesPermissionsState();
}

class _UserRolesPermissionsState extends State<UserRolesPermissions> {
  bool isLoading = true;
  String? errorMessage;
  List<dynamic> userRoles = [];
  List<dynamic> userPermissions = [];

  @override
  void initState() {
    super.initState();

    fetchUserRolesPermissions();
  }

  Future<void> fetchUserRolesPermissions() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      String baseUrl =
          '${Constants.InsightsReportsbaseUrl}/api/authentication/get_user_roles_permissions/?email=${widget.userEmail}';

      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userRoles = data['roles'];
          userPermissions = data['permissions'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load user roles and permissions');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Failed to load user roles and permissions',
                        style: TextStyle(color: Colors.red)),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: fetchUserRolesPermissions,
                      child: Text('Retry'),
                    ),
                  ],
                ),
              )
            : ListView(
                children: [
                  ListTile(
                    title: Text('Roles'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: userRoles
                          .map<Widget>((role) => Text(
                              '${role['company_type']} (${role['role_job_function']})'))
                          .toList(),
                    ),
                  ),
                  ListTile(
                    title: Text('Permissions'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: userPermissions
                          .map<Widget>((permission) => Text(
                              '${permission['module_name']}: ${permission['permission_name']}'))
                          .toList(),
                    ),
                  ),
                ],
              );
  }
}

String formatRoleName(String roleName) {
  // Replace underscores with spaces
  String modifiedRoleName = roleName.replaceAll('_', ' ');

  // Split the string into words
  List<String> words = modifiedRoleName.split(' ');

  // Capitalize the first letter of each word
  List<String> capitalizedWords = words.map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).toList();

  // Join the words back into a single string
  String formattedRoleName = capitalizedWords.join(' ');

  // Return the formatted string as Text(role['name'])
  return formattedRoleName;
}
