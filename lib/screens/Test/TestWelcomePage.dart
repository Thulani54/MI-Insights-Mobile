import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../HomePage.dart';
import '../../constants/Constants.dart';

class LeadInformationPage extends StatefulWidget {
  const LeadInformationPage({Key? key}) : super(key: key);

  @override
  _LeadInformationPageState createState() => _LeadInformationPageState();
}

class _LeadInformationPageState extends State<LeadInformationPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Controllers for form fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyController = TextEditingController();
  final _designationController = TextEditingController();
  final _notesController = TextEditingController();

  // Dropdown values
  String? _selectedCompanySize;
  String? _selectedBusinessType;

  static final String SUBMIT_LEAD_ENDPOINT =
      '${Constants.blackBrokerUrl}api/leads/submit';

  List<String> _selectedChallenges = [];
  bool _consentToContact = false;
  bool _subscribeToNewsletter = false;
  bool _isSubmitting = false;

  final List<String> _companySizes = [
    '1-10 employees',
    '11-50 employees',
    '51-200 employees',
    '201-500 employees',
    '501-1000 employees',
    '1000+ employees'
  ];

  final List<String> _businessTypes = [
    'Insurer / Product Provider',
    'Administrator',
    'Small Intermediary / Broker',
    'Intermediate Intermediary / Broker',
    'Large Intermediary / Broker',
    'Just exploring / Other'
  ];

  final Map<String, List<String>> _challengesByBusinessType = {
    'Insurer / Product Provider': [
      'Need real-time compliance visibility across your distribution channels?',
      'Worried about audit trails and exposure to regulatory penalties?',
      'Struggling to monitor and manage intermediary risk in real time?',
      'Require centralized oversight of financial product distribution partners?',
      'Seeking better control over product rollout and channel performance?'
    ],
    'Administrator': [
      'Unable to track premium flows across your schemes in real time?',
      'Need smarter reconciliation and financial reporting tools?',
      'Experiencing revenue leakage across your distribution pipeline?',
      'Managing multiple payment providers without unified oversight?',
      'Want better visibility in operations and client servicing efficiency?'
    ],
    'Small Intermediary / Broker': [
      'Still using manual tools to manage client journeys and collections?',
      'Losing clients due to poor follow-ups or missed renewals?',
      'Need simple digital tools to grow your financial product portfolio?',
      'Struggling to meet compliance and reporting standards?',
      'Want to differentiate with value-added offerings beyond insurance?'
    ],
    'Intermediate Intermediary / Broker': [
      'Finding it hard to manage performance across teams or product lines?',
      'Losing oversight of distributed client touchpoints?',
      'Need scalable digital onboarding with built-in regulatory alignment?',
      'Looking for better visibility into key performance drivers?',
      'Want to grow your footprint without adding back-office burden?'
    ],
    'Large Intermediary / Broker': [
      'Managing fragmented systems for onboarding, compliance, and finance?',
      'Need real-time insight into multi-channel distribution performance?',
      'Concerned about compliance obligations across your broker network?',
      'Want to enable and support smaller brokers / Juristic Reps under your license?',
      'Looking to unify your entire distribution value chain digitally?'
    ],
  };

  @override
  void initState() {
    super.initState();
    _checkIfCompleted();
  }

  Future<void> _checkIfCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isCompleted = prefs.getBool('lead_form_completed') ?? false;

    if (isCompleted) {
      // If already completed, navigate to HomePage
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      });
    }
  }

  Future<void> _markAsCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('lead_form_completed', true);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _designationController.dispose();
    _notesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: InkWell(
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Welcome',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: Constants.ctaColorLight,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          "assets/logos/MI AnalytiX 2 Tone.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'Welcome to MI Analytix',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please provide us with your details below to obtain access to our MI AnalytiX Demo.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Personal Information Section
              _buildSectionCard(
                title: 'Personal Information',
                icon: Icons.person,
                children: [
                  _buildTextFormField(
                    controller: _firstNameController,
                    label: 'First Name',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'First name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _lastNameController,
                    label: 'Last Name',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Last name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _emailController,
                    label: 'Email Address',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value!)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Company Information Section
              _buildSectionCard(
                title: 'Company Information',
                icon: Icons.business,
                children: [
                  _buildTextFormField(
                    controller: _companyController,
                    label: 'Company Name',
                    icon: Icons.business_outlined,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Company name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _designationController,
                    label: 'Job Title/Designation',
                    icon: Icons.work_outline,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Designation is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    value: _selectedCompanySize,
                    label: 'Company Size',
                    icon: Icons.groups_outlined,
                    items: _companySizes,
                    onChanged: (value) {
                      setState(() {
                        _selectedCompanySize = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Company size is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Business Type Section
              _buildSectionCard(
                title: 'Insurance Value Chain',
                icon: Icons.account_tree,
                children: [
                  Text(
                    'What best describes your Organisation in the typical insurance value chain?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    value: _selectedBusinessType,
                    label: 'Business Type',
                    icon: Icons.business_center_outlined,
                    items: _businessTypes,
                    onChanged: (value) {
                      setState(() {
                        _selectedBusinessType = value;
                        _selectedChallenges
                            .clear(); // Clear previous selections
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Business type is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              // Challenges Section (appears after business type selection)
              if (_selectedBusinessType != null &&
                  _selectedBusinessType != 'Just exploring / Other' &&
                  _challengesByBusinessType
                      .containsKey(_selectedBusinessType)) ...[
                const SizedBox(height: 20),
                _buildSectionCard(
                  title: 'Key Challenges',
                  icon: Icons.check_box_outlined,
                  children: [
                    Text(
                      'Thank you for your feedback, ${_getBusinessTypeLabel(_selectedBusinessType!)} we work with often face a few key challenges. Could you let me know which of these apply to you?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._buildChallengeCheckboxes(),
                  ],
                ),
              ],

              const SizedBox(height: 20),

              // Additional Notes Section
              _buildSectionCard(
                title: 'Additional Information',
                icon: Icons.note_outlined,
                children: [
                  _buildTextFormField(
                    controller: _notesController,
                    label: 'Additional Notes (Optional)',
                    icon: Icons.note_outlined,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Consent Section
              _buildSectionCard(
                title: 'Consent & Preferences',
                icon: Icons.privacy_tip,
                children: [
                  CheckboxListTile(
                    value: _consentToContact,
                    onChanged: (value) {
                      setState(() {
                        _consentToContact = value ?? false;
                      });
                    },
                    title: const Text(
                        'I consent to being contacted for business purposes'),
                    subtitle: const Text('Required for lead processing'),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Constants.ctaColorLight,
                  ),
                  CheckboxListTile(
                    value: _subscribeToNewsletter,
                    onChanged: (value) {
                      setState(() {
                        _subscribeToNewsletter = value ?? false;
                      });
                    },
                    title: const Text('Subscribe to newsletter and updates'),
                    subtitle: const Text(
                        'Optional - receive industry insights and product updates'),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Constants.ctaColorLight,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isSubmitting ? Colors.grey : Constants.ctaColorLight,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: _isSubmitting
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Submitting...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue with Demo',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _getBusinessTypeLabel(String businessType) {
    switch (businessType) {
      case 'Insurer / Product Provider':
        return 'Insurers';
      case 'Administrator':
        return 'Administrators';
      case 'Small Intermediary / Broker':
        return 'small to medium sized Intermediaries';
      case 'Intermediate Intermediary / Broker':
        return 'Intermediate brokers';
      case 'Large Intermediary / Broker':
        return 'large intermediaries';
      default:
        return 'organizations';
    }
  }

  List<Widget> _buildChallengeCheckboxes() {
    final challenges = _challengesByBusinessType[_selectedBusinessType] ?? [];
    return challenges.map((challenge) {
      return CheckboxListTile(
        value: _selectedChallenges.contains(challenge),
        onChanged: (value) {
          setState(() {
            if (value == true) {
              _selectedChallenges.add(challenge);
            } else {
              _selectedChallenges.remove(challenge);
            }
          });
        },
        title: Text(
          challenge,
          style: const TextStyle(fontSize: 14),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Constants.ctaColorLight,
      );
    }).toList();
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Constants.ctaColorLight,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Constants.ctaColorLight),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: Constants.ctaColorLight!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Constants.ctaColorLight),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: Constants.ctaColorLight!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
    );
  }

  // API Configuration

  Future<bool> _submitToAPI(Map<String, dynamic> leadData) async {
    try {
      final response = await http.post(
        Uri.parse('$SUBMIT_LEAD_ENDPOINT'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Add any authentication headers if needed
          // 'Authorization': 'Bearer your-auth-token',
        },
        body: json.encode(leadData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success response
        final responseData = json.decode(response.body);
        print('API Response: $responseData');
        return true;
      } else {
        // Error response
        print('API Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      // Network or other error
      print('Network Error: $e');
      return false;
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_consentToContact) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Consent to contact is required to submit the form'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      // Create lead data object
      final leadData = {
        'personal_info': {
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'email': _emailController.text.trim().toLowerCase(),
          'phone': _phoneController.text.trim(),
        },
        'company_info': {
          'company_name': _companyController.text.trim(),
          'designation': _designationController.text.trim(),
          'company_size': _selectedCompanySize,
        },
        'business_details': {
          'business_type': _selectedBusinessType,
          'challenges': _selectedChallenges,
          'notes': _notesController.text.trim(),
        },
        'consent': {
          'contact_consent': _consentToContact,
          'newsletter_subscription': _subscribeToNewsletter,
        },
        'metadata': {
          'created_at': DateTime.now().toIso8601String(),
          'source': 'mobile_app',
          'version': '1.0',
        },
      };

      // Submit to API
      bool success = await _submitToAPI(leadData);

      setState(() {
        _isSubmitting = false;
      });

      // Mark as completed regardless of success or failure
      await _markAsCompleted();

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Lead information submitted successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      } else {
        // Show error message but still proceed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.info, color: Colors.white),
                SizedBox(width: 8),
                Text('Proceeding to demo. We\'ll follow up later.'),
              ],
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }

      // Navigate to HomePage after a short delay to show the message
      await Future.delayed(Duration(seconds: 2));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _companyController.clear();
    _designationController.clear();
    _notesController.clear();

    setState(() {
      _selectedCompanySize = null;
      _selectedBusinessType = null;
      _selectedChallenges.clear();
      _consentToContact = false;
      _subscribeToNewsletter = false;
    });
  }
}
