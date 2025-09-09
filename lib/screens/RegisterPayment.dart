import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/Constants.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../customwidgets/custom_input.dart';

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

  @override
  void dispose() {
    _referenceController.dispose();
    _amountController.dispose();
    _referenceFocusNode.dispose();
    _amountFocusNode.dispose();
    super.dispose();
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
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invoice updated successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Navigate back
      Navigator.pop(context);
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
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),

              // Date of payment
              Text(
                'Date of payment',
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
                'Reference',
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
                'Paid Amount',
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

              // Attach Proof of Payment
              Text(
                'Attach Proof of Payment',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
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
                          _fileName ?? 'No Document',
                          style: TextStyle(
                            fontSize: 16,
                            color: _fileName != null
                                ? Colors.black87
                                : Colors.grey[400],
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

              Spacer(),

              // Submit Button
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
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
