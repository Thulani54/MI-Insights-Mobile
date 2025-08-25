import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MovingCircle extends StatefulWidget {
  @override
  _MovingCircleState createState() => _MovingCircleState();
}

class _MovingCircleState extends State<MovingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Define the container and circle dimensions
  final double containerWidth = 250;
  final double containerHeight = 250;
  final double circleSize = 30;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Calculate the maximum offset
    final double maxOffset = containerWidth - circleSize;

    // Initialize the animation only once
    _animation = Tween<double>(begin: 0, end: maxOffset).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerWidth,
      height: 40,
      // color: Colors.grey[300],
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                left: _animation.value,
                top: 0, // Center vertically
                child: child!,
              );
            },
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MovingCircle2 extends StatefulWidget {
  @override
  _MovingCircle2State createState() => _MovingCircle2State();
}

class _MovingCircle2State extends State<MovingCircle2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Define the container and circle dimensions
  final double containerWidth = 250;
  final double containerHeight = 250;
  final double circleSize = 30;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Calculate the maximum offset
    final double maxOffset = containerWidth - circleSize;

    // Initialize the animation only once
    _animation = Tween<double>(begin: 0, end: maxOffset).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerWidth,
      height: 40,
      // color: Colors.grey[300],
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                left: _animation.value,
                top: 0, // Center vertically
                child: child!,
              );
            },
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
