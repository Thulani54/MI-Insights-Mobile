import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PaymentErrorScreen extends StatefulWidget {
  const PaymentErrorScreen({Key? key}) : super(key: key);

  @override
  State<PaymentErrorScreen> createState() => _PaymentErrorScreenState();
}

class _PaymentErrorScreenState extends State<PaymentErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 85,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: SvgPicture.asset(
                            "lib/assets/logo.svg",
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 12),
              child: Row(
                children: [
                  Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(360),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Center(
                          child: Icon(
                        CupertinoIcons.clear,
                        color: Colors.white,
                        size: 70,
                      )),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(
                "Payment Unsuccessful",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.red),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          width: 1.2,
                          color: Color(0xffED7D32),
                        )),
                    padding: EdgeInsets.only(left: 0, right: 16),
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    child: Center(
                        child: Text(
                      "Go back to Search",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xffED7D32)),
                    ))),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
