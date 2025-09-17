import 'package:flutter/material.dart';
import 'package:styled_text/widgets/styled_text.dart';

import '../constants/Constants.dart';

class CustomScriptText extends StatefulWidget {
  final String text;

  const CustomScriptText({super.key, required this.text});

  @override
  State<CustomScriptText> createState() => _CustomScriptTextState();
}

class _CustomScriptTextState extends State<CustomScriptText> {
  bool _isHovering = false;
  String actual_text = "";

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border: _isHovering
              ? Border.all(
                  color: Constants.ctaColorLight.withOpacity(0.3),
                  width: 2,
                )
              : null,
          borderRadius: BorderRadius.circular(4),
          boxShadow: _isHovering
              ? [
                  BoxShadow(
                    color: Colors.white,
                    //   color: Constants.ctaColorLight.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: StyledText(
          text: actual_text,
          tags: Constants.scriptTextTags,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
            // Add text shadow when hovering
            shadows: _isHovering
                ? [
                    Shadow(
                      color: Constants.ftaColorLight.withOpacity(0.1),
                      blurRadius: 4,
                    )
                  ]
                : null,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    actual_text = widget.text;
    actual_text = replaceTemplates(widget.text);
  }

  String replaceTemplates(String inputText) {
    // If there is no current lead, just return the original text.
    if (Constants.currentleadAvailable == null) {
      return inputText;
    }

    String output = inputText;
    final lead = Constants.currentleadAvailable!;
    final leadObject = lead.leadObject;

    // Replace placeholders with appropriate values.
    output = output.replaceAll("#Greeting", getTimeBasedGreeting());

    if (lead.policies.isNotEmpty) {
      output = output.replaceAll(
        "@PolicyNumber",
        lead.policies.first.reference ?? "",
      );
    }

    output = output.replaceAll("@CompanyName", Constants.business_name ?? "");
    output = output.replaceAll("@Underwriter", Constants.business_name ?? "");
    output = output.replaceAll("@ClientName", leadObject.firstName ?? "");
    output = output.replaceAll("@ClientTitle", leadObject.title ?? "");
    output = output.replaceAll("@ClientSurname", leadObject.lastName ?? "");

    if (lead.policies.isNotEmpty) {
      output = output.replaceAll(
        "@PremiumAmount",
        lead.policies.first.quote.totalAmountPayable?.toString() ?? "",
      );
      output = output.replaceAll(
        "@CoverAmount",
        lead.policies.first.quote.sumAssuredFamilyCover?.toString() ?? "",
      );
    }

    output = output.replaceAll(
      "@EasypayReferenceNumber",
      leadObject.easyPayReference ?? "",
    );

    if (lead.policies.isNotEmpty) {
      output = output.replaceAll(
        "@CollectionDate",
        lead.policies.first.quote.debitDay.toString(),
      );
      output = output.replaceAll(
        "@TotalQuotedPremium",
        lead.policies.first.quote.totalAmountPayable?.toString() ?? "",
      );
      output = output.replaceAll(
        "@TotalQuotedRiskCover",
        lead.policies.first.quote.sumAssuredFamilyCover?.toString() ?? "",
      );
    }

    output = output.replaceAll(
      "@CurrentSalesAgentName",
      Constants.myDisplayname.toString(),
    );
    output = output.replaceAll(
      "@CurrentBusinessName",
      Constants.business_name.toString(),
    );

    // Debug output if needed.
    print("Final text: $output");

    return output;
  }

  String getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String getTimeBasedGreeting2() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}
