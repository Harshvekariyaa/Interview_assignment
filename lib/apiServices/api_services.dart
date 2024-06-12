// lib/services/api_service.dart
import 'dart:convert';
import 'package:booksapp_assignment/model/lead.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<Lead>> fetchLeads() async {
    final response = await http.post(
      Uri.parse('https://api.thenotary.app/lead/getLeads'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'notaryId': '6668baaed6a4670012a6e406'}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == 1) {
        List<dynamic> leadsJson = data['leads'];
        return leadsJson.map((json) => Lead.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load leads');
      }
    } else {
      throw Exception('Failed to load leads');
    }
  }
}
