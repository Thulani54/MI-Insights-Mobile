import 'package:flutter/material.dart';

import '../services/window_manager.dart';

class ComingSoon extends StatefulWidget {
  const ComingSoon({super.key});

  @override
  State<ComingSoon> createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            leading: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              "Coming Soon",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Spacer(),
              Text(
                "Coming Soon",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "We are currently working on this page.It should be available soon.",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                      color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 55,
              ),
              Spacer(),
            ],
          ),
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
