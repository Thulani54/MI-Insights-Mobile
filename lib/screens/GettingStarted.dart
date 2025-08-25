import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GettingStarted extends StatefulWidget {
  const GettingStarted({Key? key}) : super(key: key);

  @override
  State<GettingStarted> createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Spacer(),
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: SvgPicture.asset("assets/logo.svg"),
            ),
          ],
        ),
      ),
    );
  }
}
