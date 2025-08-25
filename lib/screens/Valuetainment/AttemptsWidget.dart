import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/Constants.dart';
import '../../models/ValutainmentModels.dart';

class AttemptsWidget extends StatelessWidget {
  final List<Attempt> attempts;

  AttemptsWidget({required this.attempts});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: attempts.take(3).map((attempt) {
        return ListTile(
          title: Text(
            'Score: ${attempt.score}',
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            'Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(attempt.date))}',
            style: TextStyle(color: Colors.white70),
          ),
        );
      }).toList(),
    );
  }
}

void saveAttempt(double score) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> attempts = prefs.getStringList('attempts') ?? [];

  Attempt newAttempt = Attempt(
      date: DateTime.now().toString(),
      score: score,
      id: -1,
      cecClientId: Constants.cec_client_id,
      cecEmployeeId: Constants.cec_employeeid,
      employee: Constants.myDisplayname,
      module: "-1",
      completedAt: '',
      attempt: 0,
      attemptsLeft: 0,
      result: '',
      responses: []);
  attempts.add(jsonEncode(newAttempt.toJson()));

  if (attempts.length > 3) {
    attempts.removeAt(0); // Keep only the last three attempts
  }

  prefs.setStringList('attempts', attempts);
}
