import 'dart:math' as math;
import "dart:ui" as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

double maxValue1 = 0.0;
double targetValue1 = 0.0;

class CustomGaugeWithLabel extends StatelessWidget {
  final double targetValue;
  final double actualValue;
  final double? height; // Added height parameter

  final double minValue; // Added
  final double maxValue; // Added

  const CustomGaugeWithLabel({
    Key? key,
    required this.targetValue,
    required this.actualValue,
    this.height, // Optional height parameter
    this.minValue = 0.0, // Default value for minValue
    this.maxValue = 2000.0, // Default value for maxValue
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print("fhhtj $actualValue $maxValue $minValue");
    maxValue1 = maxValue;
    if (actualValue > maxValue) {
      maxValue1 = actualValue;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Use provided height or fall back to constraints
        double widgetHeight = height ?? constraints.maxHeight;
        double widgetWidth = constraints.maxWidth;

        return Container(
          width: widgetWidth,
          height: widgetHeight,
          child: Column(
            children: [
              Expanded(
                child: CustomPaint(
                  size: Size(widgetWidth, widgetHeight),
                  painter: GaugeCustomPainter(
                    targetValue: targetValue,
                    needleValue: actualValue,
                    minValue: minValue,
                    maxValue: 1200,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

/*  Offset calculateLabelPosition(Size size, double value, double offsetFromGauge,
      double gaugeWidth, double minValue, double maxValue) {
    double radius = size.width / 2 - gaugeWidth;
    double angle = math.pi * (1 - ((value - minValue) / (maxValue - minValue)));

    double x = (size.width / 2) + (radius + offsetFromGauge) * math.cos(angle);
    double y = size.height - (radius + offsetFromGauge) * math.sin(angle);

    y -= 20; // Adjust label position

    return Offset(x, y);
  }*/
}

class GaugeCustomPainter extends CustomPainter {
  final double targetValue;
  final double needleValue;
  final double minValue;
  final double maxValue;

  GaugeCustomPainter({
    required this.targetValue,
    required this.needleValue,
    this.minValue = 0.0,
    this.maxValue = 100.0,
  });

  void drawMultilineText(Canvas canvas, List<String> lines, Offset position,
      TextStyle style, Size canvasSize) {
    for (var i = 0; i < lines.length; i++) {
      final textSpan = TextSpan(text: lines[i], style: style);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: ui.TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout(minWidth: 0, maxWidth: canvasSize.width * 0.9);

      double textY =
          position.dy - (lines.length / 2.0 - i) * (textPainter.height + 5);
      // Ensure text doesn't go beyond container bounds
      textY = textY.clamp(
          textPainter.height / 2, canvasSize.height - textPainter.height / 2);

      final offset = Offset(position.dx - textPainter.width / 2, textY);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Scale gauge width based on container size
    double gaugeWidth = (size.width * 0.08).clamp(8.0, 30.0);

    // Base gauge arc
    Paint gaugePaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = gaugeWidth
      ..strokeCap = StrokeCap.round;

    // Progress arc
    Paint progressPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = gaugeWidth
      ..strokeCap = StrokeCap.round;

    // Calculate progress as a percentage of the target value (capped between 0 and 1)
    double actualPercentage = (needleValue / targetValue) * 100;
    double progressPercent = (needleValue / targetValue).clamp(0.0, 1.0);
    double progressRadians = math.pi * progressPercent;

    // Scale center position based on size - ensure it fits within container
    double centerY =
        (size.height * 0.75).clamp(gaugeWidth, size.height - gaugeWidth);
    Offset center = Offset(size.width / 2, centerY);
    double maxRadius =
        math.min(size.width / 2 - gaugeWidth / 2, size.height * 0.6);
    double radius = math.max(20.0, maxRadius);

    // Draw the background gauge arc (full arc)
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi,
        math.pi, false, gaugePaint);

    // Draw the progress arc (based on actual value)
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi,
        progressRadians, false, progressPaint);

    // Needle logic - scale with size
    final needleRadians = math.pi * progressPercent;
    final needleLength =
        radius * 0.85; // Scale needle length relative to radius
    final needleWidth =
        (size.width * 0.04).clamp(4.0, 12.5); // Scale needle width

    // Calculate end point of the needle
    Offset needleEnd = Offset(
      center.dx + needleLength * math.cos(math.pi + needleRadians),
      center.dy + needleLength * math.sin(math.pi + needleRadians),
    );

    // Calculate base points of the needle triangle
    Offset baseLeft = Offset(
      center.dx + (needleWidth / 2) * math.sin(math.pi + needleRadians),
      center.dy - (needleWidth / 2) * math.cos(math.pi + needleRadians),
    );
    Offset baseRight = Offset(
      center.dx - (needleWidth / 2) * math.sin(math.pi + needleRadians),
      center.dy + (needleWidth / 2) * math.cos(math.pi + needleRadians),
    );

    // Create a path for the needle
    Path needlePath = Path()
      ..moveTo(baseLeft.dx, baseLeft.dy) // Move to base left
      ..lineTo(needleEnd.dx, needleEnd.dy) // Line to needle end (sharp point)
      ..lineTo(baseRight.dx, baseRight.dy) // Line to base right
      ..close(); // Close path to form a triangle

    // Draw the needle
    canvas.drawPath(
        needlePath,
        Paint()
          ..color = (needleValue - targetValue) < 0 ? Colors.red : Colors.green
          ..style = PaintingStyle.fill);

    // Draw the center dot - scale with size
    Paint centerDotPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;
    double centerDotRadius = (size.width * 0.02).clamp(3.0, 10.0);
    canvas.drawCircle(center, centerDotRadius, centerDotPaint);

    // Text styles for the gauge labels - scale with size
    double fontSize = (size.width * 0.035).clamp(8.0, 13.5);
    double fontSize1 = (size.width * 0.045).clamp(10.0, 17.0);

    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
    );
    TextStyle textStyle1 = TextStyle(
      color: progressPercent < 1.0 ? Colors.red : Colors.green,
      fontSize: fontSize1,
      fontWeight: FontWeight.bold,
    );

    // Sales difference text
    int salesDiff = (needleValue - targetValue).toInt();
    String percentageText = '${(progressPercent * 100).round().toString()}%';
    String salesText = salesDiff > 0
        ? '+\nAhead Of Month To Date Target of ${targetValue.round()}'
        : salesDiff == 0
            ? "On Target"
            : '\nBehind Month To Date Target of ${targetValue.round()}';

    // Positioning text on the gauge - place text above the center dot
    double textY1 = (center.dy - radius * 0.3).clamp(10, center.dy - 50);
    double textY2 =
        (center.dy - radius * 0.15).clamp(textY1 + 15, center.dy - 30);

    Offset textPosition1 = Offset(size.width / 2, textY1);
    Offset textPosition = Offset(size.width / 2, textY2);

    drawMultilineText(canvas, [actualPercentage.toStringAsFixed(0) + "%"],
        textPosition1, textStyle1, size);
    drawMultilineText(canvas, [salesText], textPosition, textStyle, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GaugeWidget extends StatelessWidget {
  final double targetValue;
  final double actualValue;

  GaugeWidget({required this.targetValue, required this.actualValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: CustomPaint(
        painter: GaugeCustomPainter(
          targetValue: targetValue,
          needleValue: actualValue,
        ),
      ),
    );
  }
}

class CustomGaugeWithLabel2 extends StatelessWidget {
  final double targetValue;
  double actualValue;
  final double? height; // Added height parameter

  final double minValue; // Added
  final double maxValue; // Added

  CustomGaugeWithLabel2({
    Key? key,
    required this.targetValue,
    required this.actualValue,
    this.height, // Optional height parameter
    this.minValue = 0.0, // Default value for minValue
    this.maxValue = 1600.0, // Default value for maxValue
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use provided height or fall back to constraints
        double widgetHeight = height ?? constraints.maxHeight;
        double widgetWidth = constraints.maxWidth;

        return Container(
          width: widgetWidth,
          height: widgetHeight,
          child: Column(
            children: [
              Expanded(
                child: CustomPaint(
                  size: Size(widgetWidth, widgetHeight),
                  painter: GaugeCustomPainter2(
                    targetValue: targetValue,
                    needleValue: actualValue,
                    minValue: minValue,
                    maxValue: maxValue,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

/*  Offset calculateLabelPosition(Size size, double value, double offsetFromGauge,
      double gaugeWidth, double minValue, double maxValue) {
    double radius = size.width / 2 - gaugeWidth;
    double angle = math.pi * (1 - ((value - minValue) / (maxValue - minValue)));

    double x = (size.width / 2) + (radius + offsetFromGauge) * math.cos(angle);
    double y = size.height - (radius + offsetFromGauge) * math.sin(angle);

    y -= 20; // Adjust label position

    return Offset(x, y);
  }*/
}

class GaugeCustomPainter2 extends CustomPainter {
  final double targetValue;
  double needleValue;
  final double minValue;
  final double maxValue;

  GaugeCustomPainter2({
    required this.targetValue,
    required this.needleValue,
    this.minValue = 0.0,
    this.maxValue = 100.0,
  });

  void drawMultilineText(Canvas canvas, List<String> lines, Offset position,
      TextStyle style, Size canvasSize) {
    for (var i = 0; i < lines.length; i++) {
      final textSpan = TextSpan(text: lines[i], style: style);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: ui.TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout(minWidth: 0, maxWidth: canvasSize.width * 0.9);

      double textY =
          position.dy - (lines.length / 2.0 - i) * (textPainter.height + 5);
      // Ensure text doesn't go beyond container bounds
      textY = textY.clamp(
          textPainter.height / 2, canvasSize.height - textPainter.height / 2);

      final offset = Offset(position.dx - textPainter.width / 2, textY);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Scale gauge width based on container size
    double gaugeWidth = (size.width * 0.08).clamp(8.0, 30.0);

    Paint gaugePaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = gaugeWidth
      ..strokeCap = StrokeCap.round;

    Paint progressPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = gaugeWidth
      ..strokeCap = StrokeCap.round;

    // Scale center position based on size - ensure it fits within container
    double centerY =
        (size.height * 0.75).clamp(gaugeWidth, size.height - gaugeWidth);
    Offset center = Offset(size.width / 2, centerY);
    double maxRadius = math.min(size.width / 2 - gaugeWidth / 2, size.height * 0.6);
    double radius = math.max(20.0, maxRadius);

    // Draw the base gauge arc (background)
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi,
        math.pi, false, gaugePaint);

    // Cap the needle value at 100% for the gauge
    double cappedPercentage = (needleValue / targetValue).clamp(0.0, 1.0);
    double progressRadians = math.pi * cappedPercentage;

    // Draw the progress arc (capped at 100% visually)
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi,
        progressRadians, false, progressPaint);

    // Needle logic - scale with size
    final needleRadians = math.pi * cappedPercentage;
    final needleLength =
        radius * 0.85; // Scale needle length relative to radius
    final needleWidth =
        (size.width * 0.04).clamp(4.0, 12.5); // Scale needle width

    // Calculate end point of the needle
    Offset needleEnd = Offset(
      center.dx + needleLength * math.cos(math.pi + needleRadians),
      center.dy + needleLength * math.sin(math.pi + needleRadians),
    );

    // Calculate base points of the needle triangle
    Offset baseLeft = Offset(
      center.dx + (needleWidth / 2) * math.sin(math.pi + needleRadians),
      center.dy - (needleWidth / 2) * math.cos(math.pi + needleRadians),
    );
    Offset baseRight = Offset(
      center.dx - (needleWidth / 2) * math.sin(math.pi + needleRadians),
      center.dy + (needleWidth / 2) * math.cos(math.pi + needleRadians),
    );

    Path needlePath = Path()
      ..moveTo(baseLeft.dx, baseLeft.dy)
      ..lineTo(needleEnd.dx, needleEnd.dy)
      ..lineTo(baseRight.dx, baseRight.dy)
      ..close();

    // Draw the needle
    canvas.drawPath(
        needlePath,
        Paint()
          ..color = (needleValue - targetValue) < 0 ? Colors.red : Colors.green
          ..style = PaintingStyle.fill);

    // Draw the center dot - scale with size
    Paint centerDotPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;
    double centerDotRadius = (size.width * 0.02).clamp(3.0, 10.0);
    canvas.drawCircle(center, centerDotRadius, centerDotPaint);

    // Text styles for the gauge labels - scale with size
    double fontSize = (size.width * 0.035).clamp(8.0, 13.5);
    double fontSize1 = (size.width * 0.045).clamp(10.0, 17.0);
    
    // Calculate the actual percentage difference for the text (without capping)
    double actualPercentage = (needleValue / targetValue) * 100;
    
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
    );
    TextStyle textStyle1 = TextStyle(
      color: actualPercentage < 100 ? Colors.red : Colors.green,
      fontSize: fontSize1,
      fontWeight: FontWeight.bold,
    );

    String percentageText = '${actualPercentage.round().toStringAsFixed(0)}%';

    // Calculate sales difference and display appropriate text
    int salesDiff = (needleValue - targetValue).toInt();
    String salesText = salesDiff > 0
        ? "\nAhead of Full Month's Target of ${formatLargeNumber(targetValue.round().toString())}"
        : salesDiff == 0
            ? "On Target"
            : "\nTowards Full Month's Target of ${formatLargeNumber(targetValue.round().toString())}";

    // Positioning text on the gauge - place text above the center dot
    double textY1 = (center.dy - radius * 0.3).clamp(10, center.dy - 40);
    double textY2 = (center.dy - radius * 0.15).clamp(textY1 + 15, center.dy - 20);

    Offset textPosition1 = Offset(size.width / 2, textY1);
    Offset textPosition = Offset(size.width / 2, textY2);

    // Draw the text on the gauge
    drawMultilineText(canvas, [percentageText], textPosition1, textStyle1, size);
    drawMultilineText(canvas, [salesText], textPosition, textStyle, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CustomGaugeWithLabel4 extends StatelessWidget {
  final double targetValue;
  final double actualValue;
  final double? height; // Added height parameter

  final double minValue; // Added
  final double maxValue; // Added

  const CustomGaugeWithLabel4({
    Key? key,
    required this.targetValue,
    required this.actualValue,
    this.height, // Optional height parameter
    this.minValue = 0.0, // Default value for minValue
    this.maxValue = 2000.0, // Default value for maxValue
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use provided height or fall back to constraints
        double widgetHeight = height ?? constraints.maxHeight;
        double widgetWidth = constraints.maxWidth;

        return Container(
          width: widgetWidth,
          height: widgetHeight,
          child: Column(
            children: [
              targetValue == 0
                  ? Expanded(
                      child: CustomPaint(
                        size: Size(widgetWidth, widgetHeight),
                        painter: GaugeCustomPainter4(
                          targetValue: 1200,
                          needleValue: 1200,
                          minValue: minValue,
                          maxValue: 1200,
                        ),
                      ),
                    )
                  : Expanded(
                      child: CustomPaint(
                        size: Size(widgetWidth, widgetHeight),
                        painter: GaugeCustomPainter4(
                          targetValue: targetValue,
                          needleValue: actualValue,
                          minValue: minValue,
                          maxValue: maxValue,
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

/*  Offset calculateLabelPosition(Size size, double value, double offsetFromGauge,
      double gaugeWidth, double minValue, double maxValue) {
    double radius = size.width / 2 - gaugeWidth;
    double angle = math.pi * (1 - ((value - minValue) / (maxValue - minValue)));

    double x = (size.width / 2) + (radius + offsetFromGauge) * math.cos(angle);
    double y = size.height - (radius + offsetFromGauge) * math.sin(angle);

    y -= 20; // Adjust label position

    return Offset(x, y);
  }*/
}

class GaugeCustomPainter4 extends CustomPainter {
  final double targetValue;
  final double needleValue;
  final double minValue;
  final double maxValue;

  GaugeCustomPainter4({
    required this.targetValue,
    required this.needleValue,
    this.minValue = 0.0,
    this.maxValue = 100.0,
  });

  void drawMultilineText(
      Canvas canvas, List<String> lines, Offset position, TextStyle style) {
    for (var i = 0; i < lines.length; i++) {
      final textSpan = TextSpan(text: lines[i], style: style);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: ui.TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout(minWidth: 0, maxWidth: double.infinity);
      final offset = Offset(
          position.dx - textPainter.width / 2,
          position.dy -
              (lines.length / 2.0 - i) *
                  (textPainter.height + 5) // Vertically space the lines
          );
      textPainter.paint(canvas, offset);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    double gaugeWidth = 30.0;
    Paint gaugePaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = gaugeWidth
      ..strokeCap = StrokeCap.round;

    Paint progressPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = gaugeWidth
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height - 25);
    double radius = size.width / 2 - gaugeWidth;

    // Draw the gauge background arc
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi,
        math.pi, false, gaugePaint);

    // Normalize the needle value within the range [0, 1]
    double normalizedNeedleValue =
        (needleValue - minValue) / (maxValue - minValue);

    // Ensure the needle does not exceed 100% (1.0) after applying the offset
    normalizedNeedleValue = normalizedNeedleValue.clamp(0.0, 1.0);

    // Calculate radians for the needle value
    double needleRadians = math.pi * normalizedNeedleValue + 0.05;
    double needleRadians2 = math.pi * normalizedNeedleValue;

    // Draw the progress arc up to the needle value
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi,
        needleRadians2, false, progressPaint);

    double needleLength =
        radius - 20; // Adjusted to keep the needle inside the gauge
    double needleWidth = 10.0; // Width of the needle base

    // Calculate end point of the needle
    Offset needleEnd = Offset(
      center.dx + needleLength * math.cos(math.pi + needleRadians),
      center.dy + needleLength * math.sin(math.pi + needleRadians),
    );

    // Calculate base points of the needle triangle
    Offset baseLeft = Offset(
      center.dx + (needleWidth / 2) * math.sin(math.pi + needleRadians),
      center.dy - (needleWidth / 2) * math.cos(math.pi + needleRadians),
    );
    Offset baseRight = Offset(
      center.dx - (needleWidth / 2) * math.sin(math.pi + needleRadians),
      center.dy + (needleWidth / 2) * math.cos(math.pi + needleRadians),
    );

    Path needlePath = Path()
      ..moveTo(baseLeft.dx, baseLeft.dy)
      ..lineTo(needleEnd.dx, needleEnd.dy)
      ..lineTo(baseRight.dx, baseRight.dy)
      ..close();

    // Draw the needle
    canvas.drawPath(
        needlePath,
        Paint()
          ..color = (needleValue - targetValue) < 0 ? Colors.red : Colors.green
          ..style = PaintingStyle.fill);

    // Draw center dot
    Paint centerDotPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 20 / 2, centerDotPaint);

    // Text styles
    TextStyle textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 13.5,
      fontWeight: FontWeight.w500,
    );

    // Calculate the percentage difference and sales needed/passed
    double percentageDiff =
        (100 - (((targetValue - needleValue) / targetValue) * 100)).abs();
    TextStyle textStyle1 = TextStyle(
      color: percentageDiff < 100 ? Colors.red : Colors.green,
      fontSize: 17,
      fontWeight: FontWeight.bold,
    );
    int salesDiff = (needleValue - targetValue).toInt();

    String percentageText = ' ${percentageDiff.round().toStringAsFixed(0)}%';

    String salesText = salesDiff > 0
        ? "\nAhead of Selected Range Target of ${formatLargeNumber(targetValue.round().toString())}"
        : salesDiff == 0
            ? "On Target"
            : "\nTowards Selected Range Target of ${formatLargeNumber(targetValue.round().toString())}";

    Offset textPosition = Offset(
        size.width / 2 - 0, size.height * 0.635); // Adjusted for visual fit
    Offset textPosition1 =
        Offset(size.width / 2 - 0, size.height * (0.63 - 0.1));
    drawMultilineText(canvas, [percentageText], textPosition1, textStyle1);
    drawMultilineText(canvas, [salesText], textPosition, textStyle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CustomGaugeWithLabel3 extends StatelessWidget {
  final double targetValue;
  final double actualValue;
  final double? height; // Added height parameter

  final double minValue; // Added
  final double maxValue; // Added

  const CustomGaugeWithLabel3({
    Key? key,
    required this.targetValue,
    required this.actualValue,
    this.height, // Optional height parameter
    this.minValue = 0.0, // Default value for minValue
    this.maxValue = 100.0, // Default value for maxValue
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use provided height or fall back to constraints
        double widgetHeight = height ?? constraints.maxHeight;
        double widgetWidth = constraints.maxWidth;

        return Container(
          width: widgetWidth,
          height: widgetHeight,
          child: Column(
            children: [
              Expanded(
                child: CustomPaint(
                  size: Size(widgetWidth, widgetHeight),
                  painter: GaugeCustomPainter3(
                    targetValue: targetValue,
                    needleValue: actualValue,
                    minValue: minValue,
                    maxValue: maxValue,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

/*  Offset calculateLabelPosition(Size size, double value, double offsetFromGauge,
      double gaugeWidth, double minValue, double maxValue) {
    double radius = size.width / 2 - gaugeWidth;
    double angle = math.pi * (1 - ((value - minValue) / (maxValue - minValue)));

    double x = (size.width / 2) + (radius + offsetFromGauge) * math.cos(angle);
    double y = size.height - (radius + offsetFromGauge) * math.sin(angle);

    y -= 20; // Adjust label position

    return Offset(x, y);
  }*/
}

class GaugeCustomPainter3 extends CustomPainter {
  final double targetValue;
  final double needleValue;
  final double minValue;
  final double maxValue;

  GaugeCustomPainter3({
    required this.targetValue,
    required this.needleValue,
    this.minValue = 0.0,
    this.maxValue = 100.0,
  });

  void drawMultilineText(
      Canvas canvas, List<String> lines, Offset position, TextStyle style) {
    for (var i = 0; i < lines.length; i++) {
      final textSpan = TextSpan(text: lines[i], style: style);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: ui.TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout(minWidth: 0, maxWidth: double.infinity);
      final offset = Offset(
          position.dx - textPainter.width / 2,
          position.dy -
              (lines.length / 2.0 - i) *
                  (textPainter.height + 5) // Vertically space the lines
          );
      textPainter.paint(canvas, offset);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    double gaugeWidth = 30.0;
    Paint gaugePaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = gaugeWidth
      ..strokeCap = StrokeCap.round;

    Paint progressPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = gaugeWidth
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height - 25);
    double radius = size.width / 2 - gaugeWidth;

    // Draw the gauge background arc
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi,
        math.pi, false, gaugePaint);

    // Normalize the needle value within the range [0, 1]
    double normalizedNeedleValue =
        (needleValue - minValue) / (maxValue - minValue);

    // Ensure the needle does not exceed 100% (1.0) after applying the offset
    normalizedNeedleValue = normalizedNeedleValue.clamp(0.0, 1.0);

    // Calculate radians for the needle value
    double needleRadians = math.pi * normalizedNeedleValue + 0.05;
    double needleRadians2 = math.pi * normalizedNeedleValue;

    // Draw the progress arc up to the needle value
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi,
        needleRadians2, false, progressPaint);

    double needleLength =
        radius - 20; // Adjusted to keep the needle inside the gauge
    double needleWidth = 10.0; // Width of the needle base

    // Calculate end point of the needle
    Offset needleEnd = Offset(
      center.dx + needleLength * math.cos(math.pi + needleRadians),
      center.dy + needleLength * math.sin(math.pi + needleRadians),
    );

    // Calculate base points of the needle triangle
    Offset baseLeft = Offset(
      center.dx + (needleWidth / 2) * math.sin(math.pi + needleRadians),
      center.dy - (needleWidth / 2) * math.cos(math.pi + needleRadians),
    );
    Offset baseRight = Offset(
      center.dx - (needleWidth / 2) * math.sin(math.pi + needleRadians),
      center.dy + (needleWidth / 2) * math.cos(math.pi + needleRadians),
    );

    Path needlePath = Path()
      ..moveTo(baseLeft.dx, baseLeft.dy)
      ..lineTo(needleEnd.dx, needleEnd.dy)
      ..lineTo(baseRight.dx, baseRight.dy)
      ..close();

    // Draw the needle
    canvas.drawPath(
        needlePath,
        Paint()
          ..color = (needleValue - targetValue) < 0 ? Colors.red : Colors.green
          ..style = PaintingStyle.fill);

    // Draw center dot
    Paint centerDotPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 20 / 2, centerDotPaint);

    // Text styles
    TextStyle textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    // Calculate the percentage difference and sales needed/passed
    double percentageDiff =
        (100 - (((targetValue - needleValue) / targetValue) * 100)).abs();

    String salesText = "${targetValue.toStringAsFixed(1)}% \nClaims Ratio";

    Offset textPosition = Offset(
        size.width / 2 - 0, size.height * 0.6); // Adjusted for visual fit
    drawMultilineText(canvas, [salesText], textPosition, textStyle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

String formatWithCommas(double value) {
  final format = NumberFormat("#,##0", "en_US");
  return format.format(value);
}

String formatLargeNumber(String valueStr) {
  const List<String> suffixes = [
    "",
    "k",
    "m",
    "b",
    "t"
  ]; // Add more suffixes as needed

  // Convert string to double and handle invalid inputs
  double value;
  try {
    value = double.parse(valueStr);
  } catch (e) {
    return 'Invalid Number';
  }

  // If the value is less than 1000, return it as a string with commas
  if (value < 1000000) {
    return formatWithCommas(value);
  }

  int index = 0;
  double newValue = value;

  while (newValue >= 1000 && index < suffixes.length - 1) {
    newValue /= 1000;
    index++;
  }

  return '${formatWithCommas(newValue)}${suffixes[index]}';
}

String formatLargeNumber2(String valueStr) {
  const List<String> suffixes = [
    "",
    "k",
    "m",
    "b",
    "t"
  ]; // Add more suffixes as needed

  // Convert string to double and handle invalid inputs
  double value;
  try {
    value = double.parse(valueStr);
  } catch (e) {
    return 'Invalid Number';
  }

  // If the value is less than 100 000, return it as a string with commas
  if (value < 100000) {
    return formatWithCommas(value);
  }

  int index = 0;
  double newValue = value;

  while (newValue >= 1000 && index < suffixes.length - 1) {
    newValue /= 1000;
    index++;
  }

  return '${formatWithCommas(newValue)}${suffixes[index]}';
}

String formatLargeNumber3(String valueStr) {
  const List<String> suffixes = [
    "",
    "k",
    "m",
    "b",
    "t"
  ]; // Add more suffixes as needed

  // Convert string to double and handle invalid inputs
  double value;
  try {
    value = double.parse(valueStr);
  } catch (e) {
    return 'Invalid Number';
  }

  int index = 0;
  double newValue = value;

  while (newValue >= 1000 && index < suffixes.length - 1) {
    newValue /= 1000;
    index++;
  }

  if (value > 999) {
    return '${((newValue)).toStringAsFixed(1)}${suffixes[index]}';
  } else
    return value.toStringAsFixed(0);
}

String getMonthAbbreviation(int monthNumber) {
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  // Check if the month number is valid
  if (monthNumber < 1 || monthNumber > 12) {
    return "-";
  }

  return months[monthNumber - 1];
}
