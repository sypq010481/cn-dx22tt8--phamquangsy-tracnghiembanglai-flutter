import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> loadInitialQuestionsFromJson() async {
  final prefs = await SharedPreferences.getInstance();
  final existing = prefs.getStringList('questions');
  if (existing != null && existing.isNotEmpty) return;

  final String jsonString = await rootBundle.loadString('assets/sample_questions.json');
  final List<dynamic> jsonList = jsonDecode(jsonString);
  final List<String> questionStrings =
      jsonList.map((q) => jsonEncode(q)).toList();

  await prefs.setStringList('questions', questionStrings);
}
