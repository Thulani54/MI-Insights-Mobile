import 'package:flutter/material.dart';

import '../../constants/Constants.dart';
import 'FieldSalesAffinity.dart';

class FieldSaleBasicInformation extends StatefulWidget {
  @override
  _FieldSaleBasicInformationState createState() =>
      _FieldSaleBasicInformationState();
}

class _FieldSaleBasicInformationState extends State<FieldSaleBasicInformation> {
  // Tips for each sale type
  final Map<String, List<String>> saleTips = {
    "Field Sale": [
      "Ensure your device is fully charged or has sufficient battery. for the sale",
      "Confirm an active internet connection.",
      "Verify the customer's identification.",
      "Take clear pictures or documents"
          "Explain the product details clearly.",
      "Collect accurate data for processing.",
    ],
    "Paperless Sale": [
      "Ensure your device is fully charged or has sufficient battery. for the sale",
      "Confirm an active internet connection.",
      "Ensure all forms are signed electronically.",
      "Upload necessary documents immediately.",
      "Verify customer details in the portal."
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sale Type Selection
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Radio<String>(
                  value: "Field Sale",
                  groupValue: Constants.fieldSaleType,
                  activeColor: Constants.ctaColorLight,
                  onChanged: (value) {
                    setState(() {
                      Constants.fieldSaleType = value!;
                      salesFieldAffinityValue.value++;
                    });
                  },
                ),
                const Text(
                  "Field Sale",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Row(
              children: [
                Radio<String>(
                  value: "Paperless Sale",
                  groupValue: Constants.fieldSaleType,
                  activeColor: Constants.ctaColorLight,
                  onChanged: (value) {
                    setState(() {
                      Constants.fieldSaleType = value!;
                      salesFieldAffinityValue.value++;
                    });
                  },
                ),
                const Text(
                  "Paperless Sale",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Tips Heading
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Text(
            "Tips for ${Constants.fieldSaleType}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        // Tips List
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: saleTips[Constants.fieldSaleType]?.length ?? 0,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(
                  Icons.check_circle,
                  color: Constants.ctaColorLight,
                ),
                title: Text(
                  saleTips[Constants.fieldSaleType]![index],
                  style: const TextStyle(fontSize: 14),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
