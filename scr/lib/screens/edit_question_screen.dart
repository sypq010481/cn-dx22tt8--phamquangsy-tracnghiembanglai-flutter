import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/question.dart';

class EditQuestionScreen extends StatefulWidget {
  final Question question;

  const EditQuestionScreen({super.key, required this.question});

  @override
  State<EditQuestionScreen> createState() => _EditQuestionScreenState();
}

class _EditQuestionScreenState extends State<EditQuestionScreen> {
  late TextEditingController _contentController;
  late List<TextEditingController> _optionControllers;
  int _correctIndex = 0;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.question.content);
    _optionControllers = widget.question.options
        .map((option) => TextEditingController(text: option))
        .toList();
    _correctIndex = widget.question.correctAnswerIndex;

    // nếu có ảnh cũ thì load vào _selectedImage để hiển thị luôn
    if (widget.question.imageAsset != null &&
        widget.question.imageAsset!.isNotEmpty) {
      _selectedImage = File(widget.question.imageAsset!);
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    for (var c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _save() {
    String content = _contentController.text.trim();
    List<String> options = _optionControllers
        .map((c) => c.text.trim())
        .toList();

    if (content.isEmpty || options.any((o) => o.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ nội dung và đáp án'),
        ),
      );
      return;
    }

    final updatedQuestion = Question(
      content: content,
      options: options,
      correctAnswerIndex: _correctIndex,
      imageAsset: _selectedImage?.path,
      imageUrl: widget.question.imageUrl,
      selectedAnswerIndex: null,
    );

    Navigator.pop(context, updatedQuestion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sửa câu hỏi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Nội dung câu hỏi'),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              itemCount: _optionControllers.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Radio<int>(
                    value: index,
                    groupValue: _correctIndex,
                    onChanged: (value) {
                      setState(() => _correctIndex = value!);
                    },
                  ),
                  title: TextField(
                    controller: _optionControllers[index],
                    decoration: InputDecoration(
                      labelText: 'Đáp án ${index + 1}',
                    ),
                  ),
                  trailing: _optionControllers.length > 2
                      ? IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _optionControllers.removeAt(index);
                              if (_correctIndex >= _optionControllers.length) {
                                _correctIndex = _optionControllers.length - 1;
                              }
                            });
                          },
                        )
                      : null,
                );
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _optionControllers.add(TextEditingController());
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Thêm đáp án'),
            ),
            const SizedBox(height: 24),
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  return const Text("Không thể hiển thị ảnh.");
                },
              ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Chọn ảnh từ thiết bị'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: _save, child: const Text('Lưu thay đổi')),
          ],
        ),
      ),
    );
  }
}
