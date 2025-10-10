import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/Constants.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../customwidgets/custom_input.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPayment extends StatefulWidget {
  @override
  _RegisterPaymentState createState() => _RegisterPaymentState();
}

class _RegisterPaymentState extends State<RegisterPayment> {
  final _formKey = GlobalKey<FormState>();
  final _referenceController = TextEditingController();
  final _amountController = TextEditingController();
  final _referenceFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();

  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  File? _attachedFile;
  String? _fileName;
  String? _amountError;

  // Payover month/year dropdown
  String? _selectedPayoverMonth;
  final List<String> _payoverMonths = List.generate(12, (index) {
    DateTime date = DateTime.now().subtract(Duration(days: index * 30));
    return DateFormat("MMMM yyyy").format(date);
  }).reversed.toList();

  final ImagePicker _imagePicker = ImagePicker();

  // Payment method toggle
  int _paymentMethodIndex =
      -1; // -1 = None selected, 0 = Pay Now, 1 = Already Paid
  double _sliderPosition = 0;

  @override
  void dispose() {
    _referenceController.dispose();
    _amountController.dispose();
    _referenceFocusNode.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _animatePaymentMethodToggle(int index) {
    // Check if month is selected first
    if (_selectedPayoverMonth == null) {
      Fluttertoast.showToast(
        msg: "Please Select a Payover Month to Proceed ",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      return;
    }

    setState(() {
      _paymentMethodIndex = index;
      _sliderPosition =
          index == 0 ? 0 : (MediaQuery.of(context).size.width / 2) - 32;
    });

    if (index == 0) {
      // Show "Coming Soon" dialog for Pay Now
      _showComingSoonDialog();
    }
  }

  void _showComingSoonDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Text(
            'Coming Soon',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline,
                size: 60,
                color: Constants.ctaColorLight,
              ),
              SizedBox(height: 16),
              Text(
                'Pay Now feature will be available soon!',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Center(
              child: Container(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Reset to Already Paid
                    setState(() {
                      _paymentMethodIndex = 1;
                      _sliderPosition =
                          (MediaQuery.of(context).size.width / 2) - 32;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.ctaColorLight,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text('OK'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Constants.ctaColorLight,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _attachFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          _attachedFile = File(result.files.single.path!);
          _fileName = result.files.single.name;
        });
      }
    } catch (e) {
      print('Error picking file: $e');
      Fluttertoast.showToast(
        msg: "Error picking file: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _scanDocument() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _attachedFile = File(image.path);
          _fileName = 'scanned_${DateTime.now().millisecondsSinceEpoch}.jpg';
        });

        Fluttertoast.showToast(
          msg: "Document scanned successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Error scanning document: $e');
      Fluttertoast.showToast(
        msg: "Error scanning document: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  bool _validateForm() {
    setState(() {
      _amountError = null;
    });

    bool isValid = true;

    // Validate amount
    String amount = _amountController.text.trim();
    if (amount.isEmpty) {
      setState(() {
        _amountError = 'Please enter paid amount';
      });
      isValid = false;
    } else if (double.tryParse(amount) == null) {
      setState(() {
        _amountError = 'Please enter a valid amount';
      });
      isValid = false;
    } else if (double.parse(amount) <= 0) {
      setState(() {
        _amountError = 'Amount must be greater than 0';
      });
      isValid = false;
    }

    return isValid;
  }

  void _submitPayment() async {
    if (_validateForm()) {
      // Validate payover month is selected
      if (_selectedPayoverMonth == null) {
        Fluttertoast.showToast(
          msg: "Please select payover month",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      // Validate file is attached
      if (_attachedFile == null) {
        Fluttertoast.showToast(
          msg: "Please attach proof of payment",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Parse selected payover month
        DateTime payoverDate =
            DateFormat("MMMM yyyy").parse(_selectedPayoverMonth!);
        int payoverMonth = payoverDate.month;
        int payoverYear = payoverDate.year;

        // Create multipart request
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://uat.miinsightsapps.net/payover/PayoverPayment'),
        );

        // Add file
        request.files.add(
          await http.MultipartFile.fromPath('file', _attachedFile!.path),
        );

        // Add form fields
        request.fields['reference'] = _referenceController.text.trim();
        request.fields['payover_month'] = payoverMonth.toString();
        request.fields['payover_year'] = payoverYear.toString();
        request.fields['payment_date'] =
            DateFormat('yyyy-MM-dd').format(_selectedDate);
        request.fields['amount'] = _amountController.text.trim();
        request.fields['underwriter_id'] = '1';

        // Send request
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Show success message
          Fluttertoast.showToast(
            msg: "Payment registered successfully!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          // Navigate back
          Navigator.pop(context);
        } else {
          // Show error message
          Fluttertoast.showToast(
            msg: "Failed to register payment: ${response.statusCode}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        Fluttertoast.showToast(
          msg: "Error: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: [],
        backgroundColor: Colors.white,
        centerTitle: true,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.6),
        title: const Text(
          "Update Invoice",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 6,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),

                // Payover Month dropdown
                Text(
                  'Select Bordereaux Paid For:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.grey[500]!),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedPayoverMonth,
                        hint: Text(
                          'Select Month',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400],
                          ),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedPayoverMonth = newValue;
                          });
                        },
                        items: _payoverMonths
                            .map<DropdownMenuItem<String>>((String month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(
                              month,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Payment method toggle
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0),
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
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _animatePaymentMethodToggle(0);
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        32,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(350)),
                                    height: 35,
                                    child: Center(
                                      child: Text(
                                        'PAY NOW',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _animatePaymentMethodToggle(1);
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        32,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(350)),
                                    child: Center(
                                      child: Text(
                                        'ALREADY PAID',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_paymentMethodIndex != -1)
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            left: _sliderPosition,
                            child: Container(
                                width: (MediaQuery.of(context).size.width / 2) -
                                    32,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Constants.ctaColorLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: _paymentMethodIndex == 0
                                    ? Center(
                                        child: Text(
                                          'PAY NOW',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          'ALREADY PAID',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                // Instructions - only show when no option is selected
                if (_paymentMethodIndex == -1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                          height:
                              1.5, // This increases line spacing (1.5 = 50% more spacing)
                        ),
                        children: [
                          TextSpan(text: 'Select '),
                          TextSpan(
                            text: '"PAY NOW"',
                            style: TextStyle(
                              color: Constants.ctaColorLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: ' to process your premium payment,\n'),
                          TextSpan(text: 'or\n'),
                          TextSpan(
                            text: '"ALREADY PAID"',
                            style: TextStyle(
                              color: Constants.ctaColorLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: ' to upload proof of payment to the Insurer.',
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_paymentMethodIndex == -1) SizedBox(height: 20),

                // Show form fields only when "Already Paid" is selected
                if (_paymentMethodIndex == 1) ...[
                  // Date of payment
                  Text(
                    'Date of Payment:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.grey[500]!),
                      ),
                      child: Center(
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(_selectedDate),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Reference
                  Text(
                    'Reference Number:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  CustomInputTransparent(
                    hintText: 'Reference',
                    controller: _referenceController,
                    focusNode: _referenceFocusNode,
                    textInputAction: TextInputAction.next,
                    isPasswordField: false,
                    onChanged: (value) {},
                    onSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_amountFocusNode);
                    },
                  ),
                  SizedBox(height: 16),

                  // Paid Amount
                  Text(
                    'Paid Amount:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  CustomInputTransparent(
                    hintText: 'Paid Amount',
                    controller: _amountController,
                    focusNode: _amountFocusNode,
                    textInputAction: TextInputAction.done,
                    isPasswordField: false,
                    integersOnly: false,
                    onChanged: (value) {
                      setState(() {
                        _amountError = null;
                      });
                    },
                    onSubmitted: (value) {
                      _amountFocusNode.unfocus();
                    },
                  ),
                  if (_amountError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 8, left: 16),
                      child: Text(
                        _amountError!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  SizedBox(height: 16),

                  // File attachment section
                  Text(
                    'Attach Proof of Payment',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),

                  // Display attached file name if exists
                  if (_fileName != null)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _fileName!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, size: 18),
                            onPressed: () {
                              setState(() {
                                _attachedFile = null;
                                _fileName = null;
                              });
                            },
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ],
                      ),
                    ),

                  // Attach from files button
                  GestureDetector(
                    onTap: _attachFile,
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              'Choose from files',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.attachment,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),

                  // Scan document button
                  GestureDetector(
                    onTap: _scanDocument,
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              'Scan Document',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                SizedBox(height: 40),

                // Submit Button - only show when "Already Paid" is selected
                if (_paymentMethodIndex == 1)
                  Container(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.ctaColorLight,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                if (_paymentMethodIndex == 1) SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
