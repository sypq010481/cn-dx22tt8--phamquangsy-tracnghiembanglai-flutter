import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/question.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'question_list_screen.dart';

class CreateQuestionScreen extends StatefulWidget {
  final Function(Question) onQuestionCreated;

  const CreateQuestionScreen({super.key, required this.onQuestionCreated});

  @override
  State<CreateQuestionScreen> createState() => _CreateQuestionScreenState();
}

class _CreateQuestionScreenState extends State<CreateQuestionScreen> {
  final _contentController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  int _correctAnswerIndex = 0;
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = pickedFile.name;
      final savedPath = '${directory.path}/$fileName';
      final savedFile = await File(pickedFile.path).copy(savedPath);
      setState(() {
        _imageFile = savedFile;
      });
    }
  }

  Future<void> _saveQuestion() async {
    final content = _contentController.text.trim();
    final options = _optionControllers.map((c) => c.text.trim()).toList();

    if (content.isEmpty || options.any((o) => o.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }

    final question = Question(
      content: content,
      options: options,
      correctAnswerIndex: _correctAnswerIndex,
      imageAsset: _imageFile?.path,
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/questions.json');

    List<Question> questions = [];
    if (await file.exists()) {
      final content = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(content);
      questions = jsonList.map((e) => Question.fromJson(e)).toList();
    }

    questions.add(question);
    await file.writeAsString(
      jsonEncode(questions.map((e) => e.toJson()).toList()),
    );

    widget.onQuestionCreated(question);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã lưu câu hỏi')));

    _clearForm();
  }

  void _clearForm() {
    _contentController.clear();
    for (var controller in _optionControllers) {
      controller.clear();
    }
    setState(() {
      _correctAnswerIndex = 0;
      _imageFile = null;
    });
  }

  void _addOptionField() {
    if (_optionControllers.length < 10) {
      setState(() {
        _optionControllers.add(TextEditingController());
      });
    }
  }

  void _removeOptionField(int index) {
    if (_optionControllers.length > 2) {
      setState(() {
        if (_correctAnswerIndex == index) {
          _correctAnswerIndex = 0;
        } else if (_correctAnswerIndex > index) {
          _correctAnswerIndex -= 1;
        }
        _optionControllers.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tạo câu hỏi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Nội dung câu hỏi'),
            ),
            const SizedBox(height: 16),
            Column(
              children: List.generate(_optionControllers.length, (index) {
                return Row(
                  children: [
                    Radio<int>(
                      value: index,
                      groupValue: _correctAnswerIndex,
                      onChanged: (value) {
                        setState(() {
                          _correctAnswerIndex = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _optionControllers[index],
                        decoration: InputDecoration(
                          labelText: 'Đáp án ${index + 1}',
                        ),
                      ),
                    ),
                    if (_optionControllers.length > 2)
                      IconButton(
                        onPressed: () => _removeOptionField(index),
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                      ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 8),
            if (_optionControllers.length < 10)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _addOptionField,
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm đáp án'),
                ),
              ),
            const SizedBox(height: 16),
            if (_imageFile != null) Image.file(_imageFile!, width: 200),
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Chọn ảnh'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveQuestion,
              child: const Text('Lưu câu hỏi'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const QuestionListScreen(),
                    ),
                  );
                },
                child: const Text('Xem danh sách câu hỏi đã tạo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
