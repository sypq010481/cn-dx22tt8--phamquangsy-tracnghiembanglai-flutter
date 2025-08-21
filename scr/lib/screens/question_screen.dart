import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trac_nghiem_bang_lai/main.dart';
import '../models/question.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _RandomTestScreenState();
}

class _RandomTestScreenState extends State<QuestionScreen> {
  List<Question> questions = [];
  List<Question> allQuestions = [];
  List<Question> wrongQuestions = [];
  Map<int, int> selectedAnswers = {};
  int currentIndex = 0;
  bool submitted = false;
  int correctCount = 0;
  bool isReviewing = false;
  int? reviewQuestionIndex;
  late Timer _timer;
  int remainingSeconds = 20 * 60;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAllQuestions();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds <= 0) {
        timer.cancel();
        submitTest();
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  Future<void> loadAllQuestions() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/questions.json');
    if (await file.exists()) {
      final content = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(content);
      List<Question> combined = jsonList
          .map((e) => Question.fromJson(e))
          .toList();

      combined.shuffle();
      setState(() {
        allQuestions = combined;
        questions = combined.take(25).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void submitTest() {
    int count = 0;
    wrongQuestions.clear();
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i].correctAnswerIndex) {
        count++;
      } else {
        wrongQuestions.add(questions[i]);
      }
    }
    wrongQuestionsGlobal = List.from(wrongQuestions);
    setState(() {
      submitted = true;
      correctCount = count;
    });
    _timer.cancel();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Widget buildImage(Question question) {
    if (question.imageUrl != null && question.imageUrl!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Image.network(
          question.imageUrl!,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Text("Không thể tải ảnh từ URL.");
          },
        ),
      );
    }
    if (question.imageAsset != null && question.imageAsset!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Image.file(
          File(question.imageAsset!),
          height: 180,
          width: double.infinity,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Text("Không thể tải ảnh từ file.");
          },
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget buildQuestionView() {
    final question = questions[currentIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Câu ${currentIndex + 1}: ${question.content}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        buildImage(question),
        const SizedBox(height: 12),
        ...List.generate(question.options.length, (index) {
          Color? tileColor;
          if (submitted) {
            if (index == question.correctAnswerIndex) {
              tileColor = Colors.green.withValues(alpha: 0.2);
            } else if (selectedAnswers[currentIndex] == index &&
                index != question.correctAnswerIndex) {
              tileColor = Colors.red.withValues(alpha: 0.2);
            }
          }

          return RadioListTile<int>(
            title: Text(question.options[index]),
            value: index,
            groupValue: selectedAnswers[currentIndex],
            onChanged: submitted
                ? null
                : (value) {
                    setState(() {
                      selectedAnswers[currentIndex] = value!;
                    });
                  },
            tileColor: tileColor,
          );
        }),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: currentIndex > 0
                  ? () => setState(() => currentIndex--)
                  : null,
              child: const Text('← Trước'),
            ),
            if (!submitted)
              ElevatedButton(
                onPressed: selectedAnswers.length == questions.length
                    ? submitTest
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text('Nộp bài'),
              ),
            ElevatedButton(
              onPressed: currentIndex < questions.length - 1
                  ? () => setState(() => currentIndex++)
                  : null,
              child: const Text('Tiếp →'),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildReviewQuestion(Question question, int selectedIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          'Câu hỏi: ${question.content}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        buildImage(question),
        const SizedBox(height: 12),
        ...List.generate(question.options.length, (i) {
          final isCorrect = i == question.correctAnswerIndex;
          final isSelected = i == selectedIndex;

          Color bgColor;
          if (isCorrect) {
            bgColor = Colors.green;
          } else if (isSelected) {
            bgColor = Colors.red;
          } else {
            bgColor = Colors.transparent;
          }

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor.withValues(alpha: 0.2),
              border: Border.all(color: bgColor.withValues(alpha: 0.6)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(
                  isCorrect
                      ? Icons.check_circle
                      : isSelected
                      ? Icons.cancel
                      : Icons.radio_button_unchecked,
                  color: bgColor,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(question.options[i])),
              ],
            ),
          );
        }),
        const SizedBox(height: 12),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                isReviewing = false;
                reviewQuestionIndex = null;
              });
            },
            child: const Text('Đóng xem lại'),
          ),
        ),
      ],
    );
  }

  Widget buildResultGrid() {
    return Column(
      children: [
        Text(
          'Bạn làm đúng $correctCount / ${questions.length} câu',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          itemCount: questions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
          ),
          itemBuilder: (context, index) {
            final isCorrect =
                selectedAnswers[index] == questions[index].correctAnswerIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  isReviewing = true;
                  reviewQuestionIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isCorrect ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
        if (isReviewing && reviewQuestionIndex != null)
          buildReviewQuestion(
            questions[reviewQuestionIndex!],
            selectedAnswers[reviewQuestionIndex!]!,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Bạn chưa tạo câu hỏi nào',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đề Ôn Thi'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Text(
                formattedTime,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: submitted ? buildResultGrid() : buildQuestionView(),
        ),
      ),
    );
  }
}
