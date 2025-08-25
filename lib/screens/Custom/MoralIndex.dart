import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MoraleIndex extends StatefulWidget {
  const MoraleIndex({super.key});

  @override
  State<MoraleIndex> createState() => _MoraleIndexState();

  void onPressed() {}
}

class _MoraleIndexState extends State<MoraleIndex>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Color?> _colorAnimation;
  double _gaugeValue = 0.0; // Initial value for the radial gauge

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _sizeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: -math.pi, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation =
        ColorTween(begin: Colors.grey, end: Colors.green).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    setState(() {
      _controller.reset();

      // Update the animations for the next page transition
      _rotationAnimation = Tween<double>(begin: 0.0, end: math.pi).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
      _sizeAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );

      _controller.forward().then((_) {
        setState(() {
          _gaugeValue = 1.0; // Move gauge to 100%
        });

        // Delay to allow the gauge to complete before navigating
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SecondMoralIndexPage()),
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 6,
            leading: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.black.withOpacity(0.6),
            centerTitle: true,
            title: const Text(
              "Morale Index",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )),
        body: Column(
          children: [
            SizedBox(
              height: 55,
            ),
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _sizeAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: SvgPicture.asset(
                        "assets/icons/Happy.svg",
                        color: _colorAnimation.value,
                        width: MediaQuery.of(context).size.width * 0.65,
                      ),
                    ),
                  );
                },
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: CircularProgressIndicator(
                value: _gaugeValue,
                strokeWidth: 10.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                backgroundColor: Colors.grey[200],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
          child: InkWell(
            onTap: () {
              _goToNextPage();
            },
            child: Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(360), color: Colors.blue),
              child: Center(
                  child: Text(
                    "Next Page",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}




class SecondMoralIndexPage extends StatefulWidget {
  const SecondMoralIndexPage({super.key});

  @override
  State<SecondMoralIndexPage> createState() => _SecondMoralIndexPageState();
}

class _SecondMoralIndexPageState extends State<SecondMoralIndexPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _sizeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.5), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.5, end: 2.0), weight: 1),
    ]).animate(_controller);

    _rotationAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: -math.pi, end: -math.pi / 2), weight: 1),
      TweenSequenceItem(
          tween: Tween<double>(begin: -math.pi / 2, end: 0.0), weight: 1),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Second Morale Index Page"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 55,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 24.0 + (3.0) * 20.0),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _sizeAnimation.value,
                      child: Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: SvgPicture.asset(
                          "assets/icons/Happy.svg",
                          width: MediaQuery.of(context).size.width * 0.20,
                          height: MediaQuery.of(context).size.width * 0.20,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20), // Spacing between SVGs
              Padding(
                padding: EdgeInsets.only(bottom: 24.0 + (3.0) * 20.0),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _sizeAnimation.value,
                      child: Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: SvgPicture.asset(
                          "assets/icons/Happy.svg",
                          width: MediaQuery.of(context).size.width * 0.20,
                          height: MediaQuery.of(context).size.width * 0.20,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20), // Spacing between SVGs
              Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _sizeAnimation.value,
                      child: Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: SvgPicture.asset(
                          "assets/icons/Happy.svg",
                          width: MediaQuery.of(context).size.width * 0.20,
                          height: MediaQuery.of(context).size.width * 0.20,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
