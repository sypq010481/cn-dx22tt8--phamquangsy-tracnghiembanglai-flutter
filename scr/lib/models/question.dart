import 'dart:convert';

class Question {
  final String content;
  final List<String> options;
  final int correctAnswerIndex;
  final String? imageAsset;
  final String? imageUrl;

  int? selectedAnswerIndex;

  Question({
    required this.content,
    required this.options,
    required this.correctAnswerIndex,
    this.imageAsset,
    this.imageUrl,
    this.selectedAnswerIndex,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      content: json['content']?.toString() ?? '',
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      correctAnswerIndex: json['correctAnswerIndex'] is int
          ? json['correctAnswerIndex']
          : int.tryParse(json['correctAnswerIndex'].toString()) ?? 0,
      imageAsset: json['imageAsset']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      selectedAnswerIndex: json['selectedAnswerIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'imageAsset': imageAsset,
      'imageUrl': imageUrl,
      'selectedAnswerIndex': selectedAnswerIndex,
    };
  }

  String toJsonString() => jsonEncode(toJson());
}
