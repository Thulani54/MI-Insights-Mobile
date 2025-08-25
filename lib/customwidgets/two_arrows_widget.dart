import 'package:flutter/material.dart';

class ArrowPainter extends CustomPainter {
  final Paint arrowPaint;
  final bool isUpArrow;

  ArrowPainter({required this.isUpArrow}) : arrowPaint = Paint() {
    arrowPaint.color = isUpArrow ? Colors.green : Colors.blue;
    arrowPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var arrowWidth = size.width / 2;
    var arrowHeight = size.height * 0.5; // Half the height for the arrowhead
    var tailWidth = size.width * 0.45;
    var tailHeight = size.height * 0.5; // Half the height for the tail
    final double radius = 10;

    // Draw the arrow with head and tail having the same height
    Path path = Path();

    if (isUpArrow) {
      // Arrow pointing up
      // Move to the start of the arrowhead (center top)
      path.moveTo(size.width / 2, 0);

      // Draw right edge to arrowhead tip
      path.lineTo(size.width - radius, arrowHeight - radius);
      path.quadraticBezierTo(
          size.width, arrowHeight, size.width - radius, arrowHeight);

      // Draw right side of the tail
      path.lineTo((size.width + tailWidth) / 2, arrowHeight);
      path.lineTo((size.width + tailWidth) / 2, size.height - radius);
      path.quadraticBezierTo((size.width + tailWidth) / 2, size.height,
          (size.width + tailWidth) / 2 - radius, size.height);

      // Draw bottom of the tail
      path.lineTo((size.width - tailWidth) / 2 + radius, size.height);
      path.quadraticBezierTo((size.width - tailWidth) / 2, size.height,
          (size.width - tailWidth) / 2, size.height - radius);

      // Draw left side of the tail
      path.lineTo((size.width - tailWidth) / 2, arrowHeight);

      // Close the path with a curve to create a pointed and circular tip
      path.lineTo(radius, arrowHeight);
      path.quadraticBezierTo(0, arrowHeight, 0, arrowHeight - radius);
      path.lineTo(size.width / 2, 0);
    } else {
      // Mirror the logic for a downward arrow, adjusting for a bottom-pointing tip
      path.moveTo(size.width / 2, size.height);
      path.lineTo(size.width - radius, size.height - arrowHeight + radius);
      path.quadraticBezierTo(size.width, size.height - arrowHeight,
          size.width - radius, size.height - arrowHeight);
      path.lineTo((size.width + tailWidth) / 2, size.height - arrowHeight);
      path.lineTo((size.width + tailWidth) / 2, radius);
      path.quadraticBezierTo((size.width + tailWidth) / 2, 0,
          (size.width + tailWidth) / 2 - radius, 0);
      path.lineTo((size.width - tailWidth) / 2 + radius, 0);
      path.quadraticBezierTo((size.width - tailWidth) / 2, 0,
          (size.width - tailWidth) / 2, radius);
      path.lineTo((size.width - tailWidth) / 2, size.height - arrowHeight);
      path.lineTo(radius, size.height - arrowHeight);
      path.quadraticBezierTo(
          0, size.height - arrowHeight, 0, size.height - arrowHeight + radius);
      path.lineTo(size.width / 2, size.height);
    }
    path.close();
    canvas.drawPath(path, arrowPaint);
    final Paint circlePaint = Paint();
    var circleRadius = size.width * 0.15; // adjust the radius as needed

    // Calculate the center point of the circle for up and down arrows
    Offset circleCenter = isUpArrow
        ? Offset((size.width / 2) - 2, circleRadius + 40)
        : Offset((size.width / 2) - 2,
            size.height - arrowHeight - circleRadius + 85);
    circlePaint.color = Colors.white;
    circlePaint.style = PaintingStyle.fill;
    // Draw the circle on top of the arrow
    canvas.drawCircle(circleCenter, circleRadius, circlePaint);

    final Paint borderPaint = Paint();

    borderPaint.color = Colors.grey.withOpacity(0.65);
    borderPaint.style = PaintingStyle.stroke;
    borderPaint.strokeWidth = 4;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ArrowWithText extends StatelessWidget {
  final String text; // Text for the arrow
  final String secondary_text; // Text for the arrow
  final String circleText; // Text for the circle
  final bool isUpArrow;
  final double circleVerticalOffset;

  ArrowWithText({
    required this.text,
    required this.secondary_text,
    required this.circleText,
    this.isUpArrow = true,
    this.circleVerticalOffset = 20.0, // Default offset
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.black;
    return CustomPaint(
      painter: ArrowPainter(
        isUpArrow: isUpArrow,
      ),
      child: Container(
        width: 200,
        height: 260,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Position the circle text
            Positioned(
              top: isUpArrow
                  ? circleVerticalOffset + 3
                  : null, // adjust positioning as needed
              bottom: isUpArrow
                  ? null
                  : circleVerticalOffset - 11, // adjust positioning as needed
              child: Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: Text(
                  circleText,
                  style: TextStyle(
                    color: textColor, // Use textColor for the circle text
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Adjust font size as needed for the circle
                  ),
                ),
              ),
            ),
            Positioned(
              top: isUpArrow ? 100 : 125, // adjust positioning as needed
              bottom: isUpArrow ? null : 0 - 10, // adjust positioning as needed
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white, // Use textColor for the circle text
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // Adjust font size as needed for the circle
                ),
              ),
            ),
            Positioned(
              top: isUpArrow ? 130 : 5, // adjust positioning as needed
              bottom: isUpArrow ? null : 0 - 16, // adjust positioning as needed
              child: Container(
                width: MediaQuery.of(context).size.width * 0.48 / 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    secondary_text,
                    style: TextStyle(
                      color: Colors.white, // Use textColor for the circle text
                      fontWeight: FontWeight.bold,
                      fontSize: 11, // Adjust font size as needed for the circle
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
