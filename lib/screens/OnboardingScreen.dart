import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mi_insights/Login.dart';
import 'package:mi_insights/constants/Constants.dart';

import '../services/window_manager.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (_) =>
              const Login()), // Make sure you have a GettingStarted() widget or replace it with your home widget.
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Padding(
      padding: const EdgeInsets.only(top: 35.0),
      child: Image.asset(
        '$assetName',
        fit: BoxFit.contain,
        width: width,
        height: MediaQuery.of(context).size.height * 0.55,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 30,
        fontFamily: "TradeGothic",
        letterSpacing: 0.8,
        fontWeight: FontWeight.w600,
      ),
      bodyTextStyle: TextStyle(
        fontFamily: "TradeGothic",
        color: Colors.black,
        fontSize: 14.5,
        fontWeight: FontWeight.normal,
      ),
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      animationDuration: 1000,
      infiniteAutoScroll: true,
      autoScrollDuration: 2000,
      globalHeader: Container(
        height: 55,
      ),
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      pages: [
        PageViewModel(
          bodyWidget: Column(
            children: [
              Text(
                "Welcome to MI Insights",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: "TradeGothic",
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Experience next-gen insights analytics at the tip of your fingertips ",
                style: TextStyle(
                  fontFamily: "TradeGothic",
                  color: Colors.black,
                  fontSize: 14.5,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          titleWidget: _buildImage('assets/intro/image_.28 (3).jpeg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          bodyWidget: Column(
            children: [
              Text(
                "All your reports in one place!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: "TradeGothic",
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Access your reports on the go with Insights",
                style: TextStyle(
                  fontFamily: "TradeGothic",
                  color: Colors.black,
                  fontSize: 14.5,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          titleWidget: _buildImage('assets/intro/image_.39 (2).jpeg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          bodyWidget: Column(
            children: [
              Text(
                "For Every Executive",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: "TradeGothic",
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Realtime premium collection by collection method",
                style: TextStyle(
                  fontFamily: "TradeGothic",
                  color: Colors.black,
                  fontSize: 14.5,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          titleWidget: _buildImage('assets/intro/image_.09.jpeg'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: Container(
        decoration: BoxDecoration(
            color: Constants.ctaColorLight,
            borderRadius: BorderRadius.circular(360)),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 12.0, right: 12, top: 8, bottom: 8),
          child: const Text(
            'Skip Intro',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: "TradeGothic",
              letterSpacing: 0.9,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: Colors.black,
      ),
      done: const Text(
        'Done',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.5,
          fontFamily: "TradeGothic",
          letterSpacing: 0.9,
          fontWeight: FontWeight.w600,
        ),
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeColor: Constants.ctaColorLight,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

  @override
  void initState() {
    secureScreen();

    super.initState();
  }
}
