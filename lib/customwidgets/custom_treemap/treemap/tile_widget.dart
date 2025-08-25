import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mi_insights/customwidgets/custom_treemap/treemap/tile_details.dart';

class TileWidget extends StatelessWidget {
  const TileWidget({Key? key, required this.details}) : super(key: key);

  final TileDetails details;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        width: details.size?.width,
        height: details.size?.height,
        left: details.offset!.dx,
        top: details.offset!.dy,
        child: GestureDetector(
            onTap: () => details.onTap!(details.title),
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: details.borderColor),
                  color: details.color,
                ),
                child: Center(
                    child: ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                            details.title +
                                "\n ${formatLargeNumber4(details.value.round().toString())}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: details.textColor, fontSize: 11)),
                      ),
                    ],
                  ),
                )))));
  }
}

String formatLargeNumber4(String valueStr) {
  const List<String> suffixes = [
    "",
    "k",
    "m",
    "b",
    "t"
  ]; // Add more suffixes as needed

  double value;
  try {
    value = double.parse(valueStr);
  } catch (e) {
    return 'Invalid Number';
  }

  bool isNegative = value < 0; // Check if the number is negative
  value = value.abs(); // Work with the absolute value

  // If the value is less than a million, return it with commas
  if (value < 1000000) {
    return isNegative
        ? "-${formatWithCommas3(value)}"
        : formatWithCommas3(value);
  }

  int index = 0;
  double newValue = value;

  while (newValue >= 1000 && index < suffixes.length - 1) {
    newValue /= 1000;
    index++;
  }

  // Force decimal places for large numbers with suffixes
  return isNegative
      ? "-${formatWithCommas3(newValue, true)}${suffixes[index]}"
      : "${formatWithCommas3(newValue, true)}${suffixes[index]}";
}

String formatWithCommas3(double value, [bool forceDecimal = false]) {
  bool isNegative = value < 0;
  double absValue = value.abs();

  final format = absValue < 1000000 && !forceDecimal
      ? NumberFormat("#,##0", "en_US")
      : NumberFormat("#,##0.00", "en_US");

  // Format the number and add back the negative sign if necessary
  return isNegative ? "-${format.format(absValue)}" : format.format(absValue);
}
