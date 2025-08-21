import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';

class LocalStorage {
  static const String _key = 'questions';

  // Lưu danh sách câu hỏi
  static Future<void> saveQuestions(List<Question> questions) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(questions.map((q) => q.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  // Đọc danh sách câu hỏi
  static Future<List<Question>> loadQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((e) => Question.fromJson(e)).toList();
  }

  // Xóa toàn bộ câu hỏi (nếu cần)
  static Future<void> clearQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
