import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/Constants.dart';
import '../../screens/Reports/Executive/ExecutiveMicroLearnReport.dart';

class MicroLearnService {
  static Future<MicroLearnData?> fetchMicroLearnData({
    required String startDate,
    required String endDate,
    String? module,
    String? team,
  }) async {
    try {
      final url = Uri.parse('${Constants.analitixAppBaseUrl}microlearn/get_results/');
      
      final body = {
        'client_id': Constants.cec_client_id,
        'start_date': startDate,
        'end_date': endDate,
        if (module != null && module != 'All Modules') 'module': module,
        if (team != null && team != 'All Teams') 'team': team,
      };

      final response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return parseMicroLearnData(jsonData);
      } else {
        print('Failed to load microlearn data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching microlearn data: $e');
      return null;
    }
  }

  static MicroLearnData parseMicroLearnData(Map<String, dynamic> json) {
    // Parse top performers
    List<MicroLearnPerformer> topPerformers = [];
    if (json['top_performers'] != null) {
      topPerformers = (json['top_performers'] as List)
          .map((p) => MicroLearnPerformer(
                name: p['name'] ?? '',
                score: (p['score'] ?? 0).toDouble(),
                attempts: p['attempts'] ?? 0,
                passed: p['passed'] ?? false,
                module: p['module'] ?? '',
                team: p['team'] ?? '',
              ))
          .toList();
    }

    // Parse bottom performers
    List<MicroLearnPerformer> bottomPerformers = [];
    if (json['bottom_performers'] != null) {
      bottomPerformers = (json['bottom_performers'] as List)
          .map((p) => MicroLearnPerformer(
                name: p['name'] ?? '',
                score: (p['score'] ?? 0).toDouble(),
                attempts: p['attempts'] ?? 0,
                passed: p['passed'] ?? false,
                module: p['module'] ?? '',
                team: p['team'] ?? '',
              ))
          .toList();
    }

    return MicroLearnData(
      totalParticipants: json['total_participants'] ?? 0,
      totalCompleted: json['total_completed'] ?? 0,
      totalPassed: json['total_passed'] ?? 0,
      averageScore: (json['average_score'] ?? 0).toDouble(),
      passRate: (json['pass_rate'] ?? 0).toDouble(),
      topPerformers: topPerformers,
      bottomPerformers: bottomPerformers,
    );
  }
}