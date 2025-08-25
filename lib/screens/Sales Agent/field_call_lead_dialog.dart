import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/Constants.dart';
import '../../../models/map_class.dart';
import '../../customwidgets/moving_circle.dart';
import '../../services/callCenterService.dart';
import 'FieldSalesAffinity.dart';
import 'endcalldialog2.dart';

// CustomPainter that draws the moving line along the border
class MovingLineBorderPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  MovingLineBorderPainter({
    required this.animation,
    required this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final borderRadius = BorderRadius.circular(36);
    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect);
    final path = Path()..addRRect(rrect);

    final pathMetrics = path.computeMetrics().toList();
    final totalLength = pathMetrics.fold(
      0.0,
      (double prev, ui.PathMetric metric) => prev + metric.length,
    );

    final lineLength = 60.0;

    final currentPosition = (animation.value * totalLength) % totalLength;
    final endPosition = currentPosition + lineLength;

    final movingLinePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    if (endPosition <= totalLength) {
      // The line is within the total length
      _drawPathSegment(
        canvas,
        pathMetrics,
        currentPosition,
        endPosition,
        movingLinePaint,
      );
    } else {
      // The line wraps around the path
      _drawPathSegment(
        canvas,
        pathMetrics,
        currentPosition,
        totalLength,
        movingLinePaint,
      );
      _drawPathSegment(
        canvas,
        pathMetrics,
        0.0,
        endPosition - totalLength,
        movingLinePaint,
      );
    }
  }

  void _drawPathSegment(
    Canvas canvas,
    List<ui.PathMetric> pathMetrics,
    double start,
    double end,
    Paint paint,
  ) {
    double accumulatedLength = 0.0;
    for (ui.PathMetric metric in pathMetrics) {
      final metricLength = metric.length;
      if (accumulatedLength + metricLength < start) {
        accumulatedLength += metricLength;
        continue;
      }
      final localStart = (start - accumulatedLength).clamp(0.0, metricLength);
      final localEnd = (end - accumulatedLength).clamp(0.0, metricLength);
      if (localStart < localEnd) {
        final extractPath = metric.extractPath(localStart, localEnd);
        canvas.drawPath(extractPath, paint);
      }
      accumulatedLength += metricLength;
      if (accumulatedLength >= end) {
        break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant MovingLineBorderPainter oldDelegate) {
    return oldDelegate.animation.value != animation.value ||
        oldDelegate.color != color;
  }
}

// Stateful widget that manages the animation and uses the custom painter
class MovingLineDialog extends StatefulWidget {
  final Widget child;

  const MovingLineDialog({Key? key, required this.child}) : super(key: key);

  @override
  _MovingLineDialogState createState() => _MovingLineDialogState();
}

class _MovingLineDialogState extends State<MovingLineDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4), // Adjust as needed for speed
    )..repeat();
    _animation = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MovingLineBorderPainter(
        animation: _animation,
        color: Constants.ctaColorLight,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: widget.child,
      ),
    );
  }
}

// Now modify your CallLeadDialog to use MovingLineDialog

class CallLeadDialog extends StatefulWidget {
  final Lead leadAvailable;
  final String type;

  const CallLeadDialog({
    Key? key,
    required this.leadAvailable,
    required this.type,
  }) : super(key: key);

  @override
  State<CallLeadDialog> createState() => _CallLeadDialogState();
}

class _CallLeadDialogState extends State<CallLeadDialog> {
  int changeColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // Set to transparent
      elevation: 0.0,
      child: MovingLineDialog(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: 500, maxHeight: 600),
          decoration: BoxDecoration(
            color: Colors.white, // Set the background color here
            borderRadius: BorderRadius.circular(36),
          ),
          child: StatefulBuilder(
            builder: (context, setState) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 32),
                Center(
                  child: Text(
                    "Lead Available",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Constants.ctaColorLight,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Center(
                  child: Text(
                    "A lead is available for you to action.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'YuGothic',
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  "First Name and Last Name",
                  style: TextStyle(
                    fontFamily: 'YuGothic',
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(360)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "${widget.leadAvailable.leadObject.firstName} ${widget.leadAvailable.leadObject.lastName}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic',
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  "Cellphone",
                  style: TextStyle(
                    fontFamily: 'YuGothic',
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(360)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "${widget.leadAvailable.leadObject.cellNumber}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic',
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  "Campaign",
                  style: TextStyle(
                    fontFamily: 'YuGothic',
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(360)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "${widget.leadAvailable.leadObject.campaignName}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic',
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.phone,
                        size: 42, color: Color(0XFF00a65a)),
                    SizedBox(width: 12),
                    Text(
                      Constants.fieldSalesPhone,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 32,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w900,
                          color: Color(0XFF00a65a),
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Container(
                        height: 40,
                        width: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(250),
                          border: Border.all(
                            width: changeColorIndex == 1 ? 0.0 : 1.0,
                            color: Constants.ctaColorLight,
                          ),
                          color: changeColorIndex == 1
                              ? Constants.ctaColorLight
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            "Decline Lead",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 14,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic',
                                color: changeColorIndex == 1
                                    ? Colors.white
                                    : Constants.ctaColorLight,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          changeColorIndex = 1;
                        });
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(360),
                            ),
                            elevation: 0.0,
                            backgroundColor: Colors.transparent,
                            child: Container(
                              constraints:
                                  const BoxConstraints(minHeight: 250.0),
                              child:
                                  EndCallDialog2(), // Replace with your actual widget
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 12),
                    InkWell(
                      child: Container(
                        height: 40,
                        width: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(360),
                          border: Border.all(
                            width: changeColorIndex == 2 ? 0.0 : 1.0,
                            color: Constants.ctaColorLight,
                          ),
                          color: Constants.ctaColorLight,
                        ),
                        child: Center(
                          child: Text(
                            widget.type == "Call Center"
                                ? "Dial"
                                : "Accept Lead",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 14,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          changeColorIndex = 2;
                        });
                        if (widget.type == "Field") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Fieldsalesaffinity(), // Replace with your actual widget
                            ),
                          );
                        } else if (widget.type == "Call Center") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Fieldsalesaffinity(), // Replace with your actual widget
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WhatsappLeadDialog extends StatefulWidget {
  final String username;
  final String cellphone;
  final String initial_message;
  final String type;

  const WhatsappLeadDialog({
    Key? key,
    required this.username,
    required this.cellphone,
    required this.initial_message,
    required this.type,
  }) : super(key: key);

  @override
  State<WhatsappLeadDialog> createState() => _WhatsappLeadDialogState();
}

class _WhatsappLeadDialogState extends State<WhatsappLeadDialog> {
  int changeColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    //Constants.onololeadid = widget.leadAvailable.leadObject.onololeadid;

    return Dialog(
      backgroundColor: Colors.transparent, // Set to transparent
      elevation: 0.0,
      child: MovingLineDialog(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: 500, maxHeight: 630),
          decoration: BoxDecoration(
            color: Colors.white, // Set the background color here
            borderRadius: BorderRadius.circular(36),
          ),
          child: StatefulBuilder(
            builder: (context, setState) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 32),
                Center(
                  child: Text(
                    "Lead Available",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Constants.ctaColorLight,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Center(
                  child: Text(
                    "A lead is available for you to action.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'YuGothic',
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  "First Name and Last Name",
                  style: TextStyle(
                    fontFamily: 'YuGothic',
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(360)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "${widget.username}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic',
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  "Cellphone",
                  style: TextStyle(
                    fontFamily: 'YuGothic',
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(360)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "${widget.cellphone}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic',
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  "Channel",
                  style: TextStyle(
                    fontFamily: 'YuGothic',
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(360)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Whatsapp",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic',
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  "Initial Message",
                  style: TextStyle(
                    fontFamily: 'YuGothic',
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(360)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            widget.initial_message,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic',
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.phone,
                        size: 42, color: Color(0XFF00a65a)),
                    SizedBox(width: 12),
                    Text(
                      Constants.fieldSalesPhone,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 32,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w900,
                          color: Color(0XFF00a65a),
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Container(
                        height: 40,
                        width: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(250),
                          border: Border.all(
                            width: changeColorIndex == 1 ? 0.0 : 1.0,
                            color: Constants.ctaColorLight,
                          ),
                          color: changeColorIndex == 1
                              ? Constants.ctaColorLight
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            "Decline the Chat",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 14,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic',
                                color: changeColorIndex == 1
                                    ? Colors.white
                                    : Constants.ctaColorLight,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        /*  setState(() {
                          changeColorIndex = 1;
                        });
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(360),
                            ),
                            elevation: 0.0,
                            backgroundColor: Colors.transparent,
                            child: Container(
                              constraints:
                                  const BoxConstraints(minHeight: 250.0),
                              child:
                                  EndCallDialog2(), // Replace with your actual widget
                            ),
                          ),
                        );*/
                      },
                    ),
                    SizedBox(width: 12),
                    InkWell(
                      child: Container(
                        height: 40,
                        width: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(360),
                          border: Border.all(
                            width: changeColorIndex == 2 ? 0.0 : 1.0,
                            color: Constants.ctaColorLight,
                          ),
                          color: Constants.ctaColorLight,
                        ),
                        child: Center(
                          child: Text(
                            widget.type == "Call Center"
                                ? "Accept the Chat"
                                : "Dial",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 14,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          changeColorIndex = 2;
                        });

                        final userRef = FirebaseFirestore.instance
                            .collection('michats')
                            .doc('users')
                            .collection('user_profiles')
                            .doc(widget.cellphone);

                        userRef.update({
                          'cec_emp_id': Constants.cec_empid,
                          'updated_at': DateTime.now().toIso8601String(),
                        }).then((_) {
                          print(
                              "User profile updated successfully for ${widget.cellphone}");
                        }).catchError((error) {
                          print(
                              "Failed to update user profile for ${widget.cellphone}: $error");
                        });

                        CallCenterService().createNewUser(
                          phoneNumber: widget.cellphone,
                          username: widget.username,
                          messageBody: widget.initial_message,
                        );

                        print("ghgh ${widget.type}");

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Fieldsalesaffinity(), // Replace with your actual widget
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CallLeadDialogOld extends StatefulWidget {
  final Lead leadAvailable;
  final String type;

  const CallLeadDialogOld({
    super.key,
    required this.leadAvailable,
    required this.type,
  });

  @override
  State<CallLeadDialogOld> createState() => _CallLeadDialogOldState();
}

class _CallLeadDialogOldState extends State<CallLeadDialogOld> {
  bool _isMoved = false;

  @override
  void initState() {
    super.initState();
  }

  bool _selected = false;
  int changeColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    const double smallShape = 70;

    return StatefulBuilder(
        builder: (context, setState) => Dialog(
              backgroundColor: Colors.black.withOpacity(0.65),
              surfaceTintColor: Colors.black.withOpacity(0.65),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              elevation: 0.0,
              child: Container(
                //padding: const EdgeInsets.all(16.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(16),
                constraints: BoxConstraints(maxWidth: 700, maxHeight: 766),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: Text(
                        "Launching Call...",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 18,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w400,
                              color: Color(0XFFf39c12)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Center(
                      child: Text(
                        "Call Back",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 18,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w400,
                              color: Color(0XFFf39c12)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width - 00,
                        child: Row(
                          children: [
                            Expanded(child: MovingCircle()),
                          ],
                        )),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.person,
                            size: 42, color: Color(0XFF00a65a)),
                        SizedBox(
                          width: 12,
                        ),
                        Text(widget.leadAvailable.leadObject.toString()),
                        Text(
                          "${widget.leadAvailable.leadObject.firstName} ${widget.leadAvailable.leadObject.lastName}",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 32,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w900,
                                color: Color(0XFF00a65a)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.phone,
                            size: 42, color: Color(0XFF00a65a)),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          Constants.fieldSalesPhone,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 32,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w900,
                                color: Color(0XFF00a65a)),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Container(
                            height: 45,
                            width: 160,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    width: changeColorIndex == 1 ? 0.0 : 1.0,
                                    color: Color(0XFFf39c12)),
                                color: changeColorIndex == 1
                                    ? Constants.ctaColorLight
                                    : Colors.transparent),
                            child: Center(
                              child: Text(
                                "End Call",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            changeColorIndex = 1;
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                // set to false if you want to force a rating
                                builder: (context) => StatefulBuilder(
                                      builder: (context, setState) => Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        elevation: 0.0,
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                            constraints: const BoxConstraints(
                                                minHeight: 250.0),
                                            child: EndCallDialog2()),
                                      ),
                                    ));
                            setState(() {});
                          },
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        InkWell(
                          child: Container(
                            height: 45,
                            width: 160,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    width: changeColorIndex == 2 ? 0.0 : 1.0,
                                    color: Color(0XFFf39c12)),
                                color: changeColorIndex == 2
                                    ? Constants.ctaColorLight
                                    : Colors.transparent),
                            child: Center(
                              child: Text(
                                "Enter Script",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            changeColorIndex = 2;
                            if (widget.type == "Field") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Fieldsalesaffinity()),
                              );
                            } else if (widget.type == "Call Center") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Fieldsalesaffinity()),
                              );
                            } else {}

                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    Spacer()
                  ],
                ),
              ),
            ));
  }
}
