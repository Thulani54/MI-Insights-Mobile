import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../constants/Constants.dart';
import '../../../models/map_class.dart';
import '../../customwidgets/CustomCard.dart';
import '../../services/MyNoyifier.dart';
import 'newmemberdialog.dart';

MyNotifier? myNotifier;
UniqueKey unique_key1 = UniqueKey();
final needsAnalysisValueNotifier2 = ValueNotifier<int>(0);

class NeedAnalysis extends StatefulWidget {
  const NeedAnalysis({
    super.key,
  });

  @override
  State<NeedAnalysis> createState() => _NeedAnalysisState();
}

class _NeedAnalysisState extends State<NeedAnalysis> {
  bool containsMembers = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: containsMembers == true
          ? Column(
              children: [
                Row(
                  children: [
                    Text(
                      Constants.currentleadAvailable!.additionalMembers.length
                              .toString() +
                          (Constants.currentleadAvailable!.additionalMembers
                                      .length ==
                                  1
                              ? " Member Available"
                              : " Members Available"),
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 14,
                            letterSpacing: 0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'YuGothic'),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                Divider(color: Colors.grey.withOpacity(0.35)),
                if (Constants.currentleadAvailable != null)
                  ListView.builder(
                    key: unique_key1,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: Constants
                        .currentleadAvailable!.additionalMembers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          height: 130,
                          child: AdvancedMemberCard2(
                            member: Constants
                                .currentleadAvailable!.additionalMembers[index],
                          ),
                        ),
                      );
                    },
                  ),
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: InkWell(
                    child: Container(
                      height: 45,
                      width: 160,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(360),
                        color: Constants.ftaColorLight,
                      ),
                      child: Center(
                        child: Text(
                          "New Member",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 14,
                                letterSpacing: 0,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic'),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NewMemberDialog2(
                          current_member_index: 0,
                          canAddMember: false,
                        ),
                      ));
                    },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    "No Members are available for this lead. Kindly add a new member below to continue.",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'YuGothic',
                      color: Colors.grey,
                    ),
                  ),
                ),
                Center(
                  child: InkWell(
                    child: Container(
                      height: 45,
                      width: 160,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(360),
                        color: Constants.ctaColorLight,
                      ),
                      child: Center(
                        child: Text(
                          "New Member",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 14,
                                letterSpacing: 0,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'YuGothic'),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NewMemberDialog2(
                          current_member_index: 0,
                          canAddMember: false,
                        ),
                      ));
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  height: 300,
                ),
              ],
            ),
    );
  }

  @override
  void initState() {
    myNotifier = MyNotifier(needsAnalysisValueNotifier2, context);
    needsAnalysisValueNotifier2.addListener(_handleNeedsAnalysisUpdate);
    //getExtractedDob();
    // validateMember();
    print("jdshdsk");
    containsMembers = checkLeadContainsMembers();

    super.initState();
  }

  void _handleNeedsAnalysisUpdate() {
    containsMembers = checkLeadContainsMembers();
    unique_key1 = UniqueKey();
    // Only call setState if the widget is still mounted
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // Always remove your listener here
    needsAnalysisValueNotifier2.removeListener(_handleNeedsAnalysisUpdate);
    super.dispose();
  }

  bool checkLeadContainsMembers() {
    if (Constants.currentleadAvailable != null) {
      if (Constants.currentleadAvailable!.additionalMembers.isNotEmpty) {
        print(
            "Current lead contains members ${Constants.currentleadAvailable!.additionalMembers.length}");
        return true;
      } else {
        print("Current lead does not contain members.");
        return false;
      }
    }
    return false;
  }

  validateMember() {
    var year = 0;
    for (int j = 0; j < Constants.additionalMember.length; j++) {
      if (Constants.additionalMember[j].dob.isNotEmpty) {
        var idDob = Constants.formatter
            .format(DateTime.parse(Constants.additionalMember[j].dob));
        print("dsdsadadafre1625 $idDob");
        var yearX = int.parse(idDob.substring(0, 4));
        var monthX = idDob.substring(5, 7);
        var dayX = idDob.substring(8, 10);
        print("dsdsadadafre1625 $yearX ---  $monthX ----$dayX");

        var dobX = DateTime(year, int.parse(monthX), int.parse(dayX));
        final yrX = DateTime.now().year - dobX.year;
      } else {
        var id = Constants.additionalMember[j].id;
        var x = int.parse(id.substring(0, 2));
        var month = id.substring(2, 4);
        var day = id.substring(4, 6);
        if (x < 10) {
          year = x + 2000;
        } else {
          year = x + 1900;
        }
        var dob = DateTime(year, int.parse(month), int.parse(day));
        final yr = DateTime.now().year - dob.year;
      }
    }
  }

  getExtractedDob() {
    var yearP = 0;
    var year = 0;

    for (int i = 0;
        i <= Constants.currentleadAvailable!.additionalMembers.length - 1;
        i++) {
      print(
          "sdwewe ${Constants.currentleadAvailable!.additionalMembers[i].toJson()}");

      if (Constants.additionalMember[i].relationship == "Partner") {
        Constants.idP = Constants.additionalMember[i].id;

        var xP = int.parse(Constants.idP.substring(0, 2));
        var monthP = Constants.idP.substring(2, 4);
        var dayP = Constants.idP.substring(4, 6);

        if (xP < 10) {
          yearP = xP + 2000;
        } else {
          yearP = xP + 1900;
        }

        var dobP = DateTime(yearP, int.parse(monthP), int.parse(dayP));
        final yrP = DateTime.now().year - dobP.year;
      }
    }
    if (Constants.currentleadAvailable != null) {
      var id = Constants.currentleadAvailable!.leadObject.customerIdNumber;
      var x = int.parse(id.substring(0, 2));
      var month = id.substring(2, 4);
      var day = id.substring(4, 6);

      if (x < 10) {
        year = x + 2000;
      } else {
        year = x + 1900;
      }
      var dob = DateTime(year, int.parse(month), int.parse(day));
      final yr = DateTime.now().year - dob.year;
      Constants.mainDOB = Constants.formatter.format(dob);
      Constants.mainAGE = yr;
    }
  }
}

class AdvancedMemberCard2 extends StatefulWidget {
  final AdditionalMember member;

  const AdvancedMemberCard2({
    Key? key,
    required this.member,
  }) : super(key: key);

  @override
  _AdvancedMemberCard2State createState() => _AdvancedMemberCard2State();
}

class _AdvancedMemberCard2State extends State<AdvancedMemberCard2> {
  @override
  Widget build(BuildContext context) {
    return CustomCard2(
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      boderRadius: 12,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        padding: const EdgeInsets.all(0.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Avatar
            Column(
              children: [
                Expanded(
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        color: Constants.ftaColorLight.withOpacity(0.15)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Constants.ftaColorLight,
                          child: Icon(
                            widget.member.gender.toLowerCase() == "female"
                                ? Icons.female
                                : Icons.male,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16.0),

            // Member Information
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date of Birth
                    Text(
                      'Date of Birth: ${(DateFormat('EEE, dd MMM yyyy').format(DateTime.parse(widget.member.dob)).toString())}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'YuGothic',
                          color: Colors.black),
                    ),
                    const SizedBox(height: 8.0),

                    // Member Name
                    Expanded(
                      child: Text(
                        widget.member.title +
                            " " +
                            widget.member.name +
                            " " +
                            widget.member.surname,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    // Relationship
                    Row(
                      children: [
                        const Icon(
                          Icons.people_alt,
                          color: Colors.black,
                          size: 16,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          'Relationship: ${widget.member.relationship}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Edit Button
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16, right: 16),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          barrierDismissible:
                              false, // set to false if you want to force a rating
                          builder: (context) => StatefulBuilder(
                                builder: (context, setState) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(64),
                                  ),
                                  elevation: 0.0,
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    // width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    constraints: BoxConstraints(
                                      maxWidth: 1200,
                                    ),
                                    margin: const EdgeInsets.only(top: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 10.0,
                                          offset: Offset(0.0, 10.0),
                                        ),
                                      ],
                                    ),
                                    child: NewMemberDialog2(
                                      isEditMode: true,
                                      relationship: widget.member.relationship,
                                      title: widget.member.title,
                                      name: widget.member.name,
                                      surname: widget.member.surname,
                                      dob: widget.member.dob,
                                      gender: widget.member.gender,
                                      phone: widget.member.contact,
                                      idNumber: widget.member.id,
                                      sourceOfIncome:
                                          widget.member.sourceOfIncome,
                                      sourceOfWealth:
                                          widget.member.sourceOfWealth,
                                      autoNumber: widget.member.autoNumber,
                                      current_member_index: 0,
                                      canAddMember: true,
                                    ),
                                  ),
                                ),
                              ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Constants.ftaColorLight.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            color: Constants.ftaColorLight, width: 1.5),
                      ),
                      child:
                          //add a edit and delete icon
                          Icon(Icons.edit,
                              color: Constants.ftaColorLight, size: 18)

                      /*Icon(
                                  Icons.edit,
                                  color: Colors.orangeAccent,
                                  size: 20,
                                )*/
                      ,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        _showDeleteMemberDialog(
                          0007887,
                          widget.member.autoNumber,
                          widget.member.title +
                              " " +
                              widget.member.name +
                              " " +
                              widget.member.surname,
                        );
                      },
                      child: Icon(CupertinoIcons.delete,
                          color: Colors.grey, size: 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteMemberDialog(
      int, member_id, String member_name) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return DeleteMemberDialog(
            member_id: member_id, member_name: member_name);
      },
    );

    // If user confirmed, download the file
    if (confirmed == true) {}
  }
}

class DeleteMemberDialog extends StatefulWidget {
  final int member_id;
  final String member_name;

  const DeleteMemberDialog(
      {super.key, required this.member_id, required this.member_name});

  @override
  State<DeleteMemberDialog> createState() => _DeleteMemberDialogState();
}

class _DeleteMemberDialogState extends State<DeleteMemberDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text('Delete Member'),
      content: Text(
        'Are you sure you wou like to delete the following member"(${widget.member_name})"?',
        style: const TextStyle(fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // User declined
          },
          child: const Text('Not Now',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'YuGothic',
                color: Colors.black,
              )),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(12),
            backgroundColor: Constants.ftaColorLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(360),
            ),
          ),
          onPressed: () {
            removeMember(context, widget.member_id.toString());
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24),
            child: const Text('Delete Member',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'YuGothic',
                  color: Colors.white,
                )),
          ),
        ),
      ],
    );
  }

  Future<void> removeMember(BuildContext context, String memberId) async {
    String baseUrl = "${Constants.insightsBackendBaseUrl}fieldV6/removeMember/";

    try {
      // Prepare the payload
      Map<String, dynamic> payload = {
        "auto_number": memberId, // Assuming `memberId` is the `auto_number`
      };

      // Set headers
      var headers = {
        'Content-Type': 'application/json',
      };

      // Send the POST request
      var response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: json.encode(payload),
      );

      // Handle response
      if (response.statusCode == 200) {
        int deletedCount = int.parse(response.body);
        print(
            "Member removed successfully. $memberId Deleted count: $deletedCount");

        if (Constants.currentleadAvailable != null) {
          for (int i = 0;
              i < Constants.currentleadAvailable!.additionalMembers.length;
              i++) {
            print(
                "ffgghh $i ${Constants.currentleadAvailable!.additionalMembers[i].autoNumber} $memberId ${Constants.currentleadAvailable!.additionalMembers[i].autoNumber}");
          }
          Constants.currentleadAvailable!.additionalMembers.removeWhere(
              (element) => element.autoNumber == int.parse(memberId));
        }
        needsAnalysisValueNotifier2.value++;

        Navigator.of(context).pop(true);
      } else {
        print("Failed to remove member: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error occurred while removing member: $e");
    }
  }
}
