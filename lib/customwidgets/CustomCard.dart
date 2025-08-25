import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final Widget child;
  final double elevation;
  final double? boderRadius;
  final Color color;
  final ShapeBorder? shape;
  final Color? surfaceTintColor;
  const CustomCard(
      {super.key,
      required this.child,
      required this.elevation,
      required this.color,
      this.shape,
      this.boderRadius,
      this.surfaceTintColor});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius:
            BorderRadius.all(Radius.circular(widget.boderRadius ?? 20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
    );
  }
}

class CustomCard2 extends StatefulWidget {
  final Widget child;
  final double elevation;
  final double boderRadius;
  final Color color;
  final ShapeBorder shape;
  final Color? surfaceTintColor;
  const CustomCard2(
      {super.key,
      required this.child,
      required this.elevation,
      required this.color,
      required this.shape,
      required this.boderRadius,
      this.surfaceTintColor});

  @override
  State<CustomCard2> createState() => _CustomCard2State();
}

class _CustomCard2State extends State<CustomCard2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.all(Radius.circular(widget.boderRadius)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: widget.elevation,
            offset: Offset(0, 3),
          ),
        ],
      ),
    );
  }
}

class CustomCard3 extends StatefulWidget {
  final Widget child;
  final double elevation;
  final double boderRadius;
  final Color color;
  final ShapeBorder shape;
  final Color? surfaceTintColor;
  const CustomCard3(
      {super.key,
      required this.child,
      required this.elevation,
      required this.color,
      required this.shape,
      required this.boderRadius,
      this.surfaceTintColor});

  @override
  State<CustomCard3> createState() => _CustomCard3State();
}

class _CustomCard3State extends State<CustomCard3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.all(Radius.circular(widget.boderRadius)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 3,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
    );
  }
}
