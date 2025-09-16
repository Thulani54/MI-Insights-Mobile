import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vmath;

class CSSLoadLoader extends StatefulWidget {
  @override
  _CSSLoadLoaderState createState() => _CSSLoadLoaderState();
}

class _CSSLoadLoaderState extends State<CSSLoadLoader>
    with TickerProviderStateMixin {
  late AnimationController _controllerOne;
  late AnimationController _controllerTwo;
  late AnimationController _controllerThree;

  @override
  void initState() {
    super.initState();

    _controllerOne = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _controllerTwo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _controllerThree = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controllerOne.dispose();
    _controllerTwo.dispose();
    _controllerThree.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          _buildRotatingCircle(_controllerOne, 35, -45, Colors.blueAccent, 'bottom'),
          _buildRotatingCircle(_controllerTwo, 50, 10, Colors.grey.shade700, 'right'),
          _buildRotatingCircle(_controllerThree, 35, 55, Colors.redAccent, 'top'),
        ],
      ),
    );
  }

  Widget _buildRotatingCircle(AnimationController controller, double rotateX,
      double rotateY, Color color, String borderSide) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateX(vmath.radians(rotateX))
            ..rotateY(vmath.radians(rotateY))
            ..rotateZ(controller.value * 2 * math.pi),
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: _getPartialBorder(color, borderSide),
            ),
          ),
        );
      },
    );
  }

  Border _getPartialBorder(Color color, String side) {
    switch (side) {
      case 'bottom':
        return Border(
          bottom: BorderSide(color: color, width: 5),
        );
      case 'right':
        return Border(
          right: BorderSide(color: color, width: 5),
        );
      case 'top':
        return Border(
          top: BorderSide(color: color, width: 5),
        );
      default:
        return Border.all(color: color, width: 5);
    }
  }
}

