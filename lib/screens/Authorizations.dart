import 'package:flutter/material.dart';
import 'package:mi_insights/constants/Constants.dart';

class RequestReprint extends StatefulWidget {
  const RequestReprint({Key? key}) : super(key: key);

  @override
  State<RequestReprint> createState() => _RequestReprintState();
}

class _RequestReprintState extends State<RequestReprint> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                      color: Constants.ctaColorLight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Request for reprint"),
                      )),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                      color: Constants.ctaColorLight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Cancel transaction"),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
