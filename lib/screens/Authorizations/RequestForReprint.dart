import 'package:flutter/material.dart';

import '../../models/ReprintRequestModel.dart';

class RequestForReprint extends StatefulWidget {
  const RequestForReprint({Key? key}) : super(key: key);

  @override
  State<RequestForReprint> createState() => _RequestForReprintState();
}

List<ReprintRequestModel> requestreprints = [];

class _RequestForReprintState extends State<RequestForReprint> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView.builder(
            itemCount: requestreprints.length,
            itemBuilder: (context, index) {
              return Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text(requestreprints[index].id.toString())),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child:
                                Text(requestreprints[index].requestdescription),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
