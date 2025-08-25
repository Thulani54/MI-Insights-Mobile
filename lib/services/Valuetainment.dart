import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/Constants.dart';
import '../models/ValutainmentModels.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<Questionnaire> getQuestionnaire(int id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/get-questionnaire/$id/'));

    if (response.statusCode == 200) {
      return Questionnaire.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load questionnaire');
    }
  }

  Future<void> submitQuestionnaire(Attempt attempt) async {
    final response = await http.post(
      Uri.parse('$baseUrl/submit-questionnaire/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(attempt.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to submit questionnaire');
    }
  }
}

class QuestionnaireService {
  final ApiService apiService;

  QuestionnaireService(this.apiService);

  Future<Questionnaire> fetchQuestionnaire(int id) async {
    return await apiService.getQuestionnaire(id);
  }

  Future<void> submitQuestionnaire(Attempt attempt) async {
    await apiService.submitQuestionnaire(attempt);
  }
}

