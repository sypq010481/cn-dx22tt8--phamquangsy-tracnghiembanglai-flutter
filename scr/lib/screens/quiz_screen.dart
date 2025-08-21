import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question.dart';

class QuizScreen extends StatefulWidget {
  final String title;
  final List<Question> questions;

  const QuizScreen({super.key, required this.title, required this.questions});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Map<int, int> selectedAnswers = {};
  List<Question> wrongQuestions = [];
  int currentIndex = 0;
  bool submitted = false;
  bool isReviewing = false;
  int? reviewQuestionIndex;
  int correctCount = 0;

  late Timer _timer;
  int remainingSeconds = 20 * 60;

  @override
  void initState() {
    super.initState();
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

  void submitTest() {
    int count = 0;
    wrongQuestions.clear();
    for (int i = 0; i < widget.questions.length; i++) {
      if (selectedAnswers[i] == widget.questions[i].correctAnswerIndex) {
        count++;
      } else {
        wrongQuestions.add(widget.questions[i]);
      }
    }
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

  Widget buildQuestionView() {
    final question = widget.questions[currentIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Câu ${currentIndex + 1}: ${question.content}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        if (question.imageAsset != null && question.imageAsset!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Image.asset(question.imageAsset!),
          ),
        const SizedBox(height: 12),
        ...List.generate(question.options.length, (i) {
          Color? tileColor;
          if (submitted) {
            if (i == question.correctAnswerIndex) {
              tileColor = Colors.green.withAlpha(50);
            } else if (selectedAnswers[currentIndex] == i) {
              tileColor = Colors.red.withAlpha(50);
            }
          }

          return RadioListTile<int>(
            value: i,
            groupValue: selectedAnswers[currentIndex],
            title: Text(question.options[i]),
            onChanged: submitted
                ? null
                : (val) => setState(() => selectedAnswers[currentIndex] = val!),
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
                onPressed: selectedAnswers.length == widget.questions.length
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
              onPressed: currentIndex < widget.questions.length - 1
                  ? () => setState(() => currentIndex++)
                  : null,
              child: const Text('Tiếp →'),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildReview(Question question, int selectedIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          'Câu: ${question.content}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        if (question.imageAsset != null && question.imageAsset!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Image.asset(question.imageAsset!),
          ),
        const SizedBox(height: 12),
        ...List.generate(question.options.length, (i) {
          final isCorrect = i == question.correctAnswerIndex;
          final isSelected = i == selectedIndex;
          final bgColor = isCorrect
              ? Colors.green
              : isSelected
              ? Colors.red
              : Colors.transparent;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor.withAlpha(50),
              border: Border.all(color: bgColor.withAlpha(150)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(
                  isCorrect
                      ? Icons.check_circle
                      : isSelected
                      ? Icons.cancel
                      : Icons.circle_outlined,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bạn làm đúng $correctCount / ${widget.questions.length} câu',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          itemCount: widget.questions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
          ),
          itemBuilder: (_, index) {
            final isCorrect =
                selectedAnswers[index] ==
                widget.questions[index].correctAnswerIndex;
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
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
        if (isReviewing && reviewQuestionIndex != null)
          buildReview(
            widget.questions[reviewQuestionIndex!],
            selectedAnswers[reviewQuestionIndex!]!,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                formattedTime,
                style: const TextStyle(fontWeight: FontWeight.bold),
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
