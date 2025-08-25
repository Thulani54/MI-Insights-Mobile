import 'package:flutter/material.dart';

import '../../models/PolicyDetails.dart';

class CashPaymentDialog extends StatelessWidget {
  final VoidCallback onVerified;
  final Color backgroundColor;
  final Color titleColor;
  final Color contentColor;
  final Color buttonColor;
  final String title;
  final String message;
  final String verifyButtonText;
  final String cancelButtonText;
  final String secondaryText;
  final double borderRadius;
  final double buttonHeight;
  final double buttonFontSize;
  final List<PolicyDetails> selectedPolicydetails;

  CashPaymentDialog({
    required this.onVerified,
    this.backgroundColor = Colors.white,
    this.titleColor = Colors.black,
    this.contentColor = Colors.black,
    this.buttonColor = Colors.white,
    this.title = 'Verification',
    this.message = 'Please select an option',
    this.verifyButtonText = 'Verify',
    this.cancelButtonText = 'Cancel',
    this.secondaryText = 'Policy Summary',
    this.borderRadius = 360.0,
    this.buttonHeight = 40.0,
    this.buttonFontSize = 16.0,
    required this.selectedPolicydetails,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        color: backgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: titleColor,
              ),
            ),
            if (selectedPolicydetails.isNotEmpty)
              SizedBox(
                height: 6,
              ),
            if (selectedPolicydetails.isNotEmpty) Text(secondaryText),
            if (selectedPolicydetails.isNotEmpty)
              SizedBox(
                height: 6,
              ),
            if (selectedPolicydetails.isNotEmpty)
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16,
                    ),
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(color: Colors.grey),
                    ),
                  )),
                ],
              ),
            if (selectedPolicydetails.isNotEmpty)
              SizedBox(
                height: 6,
              ),
            if (selectedPolicydetails.isNotEmpty)
              ...selectedPolicydetails
                  .map((element) => Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, bottom: 12),
                        child: Row(
                          children: [
                            Text(
                              element.policyNumber,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Spacer(),
                            Text(":"),
                            Spacer(),
                            Text(
                              "R" +
                                  (element.monthsToPayFor *
                                          element.monthlyPremium)
                                      .toStringAsFixed(2),
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            if (selectedPolicydetails.isNotEmpty)
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16,
                    ),
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(color: Colors.grey),
                    ),
                  )),
                ],
              ),
            SizedBox(height: 16.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    cancelButtonText,
                    style: TextStyle(fontSize: buttonFontSize),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    backgroundColor: buttonColor,
                    surfaceTintColor: Colors.white,
                    minimumSize: Size(120.0, buttonHeight),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onVerified();
                  },
                  child: Text(
                    verifyButtonText,
                    style: TextStyle(fontSize: buttonFontSize),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    backgroundColor: buttonColor,
                    surfaceTintColor: Colors.white,
                    minimumSize: Size(120.0, buttonHeight),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
