import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';
import 'edit_question_screen.dart';

class QuestionListScreen extends StatefulWidget {
  const QuestionListScreen({super.key});

  @override
  QuestionListScreenState createState() => QuestionListScreenState();
}

class QuestionListScreenState extends State<QuestionListScreen> {
  List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/questions.json');

    if (await file.exists()) {
      final content = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(content);
      setState(() {
        _questions = jsonList.map((e) => Question.fromJson(e)).toList();
      });
    } else {
      setState(() {
        _questions = [];
      });
    }
  }

  void _editQuestion(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditQuestionScreen(question: _questions[index]),
      ),
    );

    if (result != null && result is Question) {
      setState(() {
        _questions[index] = result;
      });

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/questions.json');
      await file.writeAsString(
        jsonEncode(_questions.map((q) => q.toJson()).toList()),
      );
    }
  }

  void _deleteQuestion(int index) async {
    setState(() {
      _questions.removeAt(index);
    });

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/questions.json');
    await file.writeAsString(
      jsonEncode(_questions.map((q) => q.toJson()).toList()),
    );
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xoá'),
        content: const Text('Bạn có chắc muốn xoá câu hỏi này không?'),
        actions: [
          TextButton(
            child: const Text('Huỷ'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xoá'),
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteQuestion(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionTile(Question q, int index) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(q.content, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            if (q.imageAsset != null && q.imageAsset!.isNotEmpty)
              Image.file(
                File(q.imageAsset!),
                height: 150,
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Text("Không thể tải ảnh.");
                },
              ),
            const SizedBox(height: 8),
            ...List.generate(q.options.length, (i) {
              return Text(
                '${i + 1}. ${q.options[i]}${i == q.correctAnswerIndex ? " (Đúng)" : ""}',
                style: TextStyle(
                  fontWeight: i == q.correctAnswerIndex
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: i == q.correctAnswerIndex
                      ? Colors.green
                      : Colors.black,
                ),
              );
            }),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _editQuestion(index),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(context, index),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách câu hỏi')),
      body: _questions.isEmpty
          ? const Center(child: Text('Chưa có câu hỏi nào.'))
          : ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, index) =>
                  _buildQuestionTile(_questions[index], index),
            ),
    );
  }
}
