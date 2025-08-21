import 'package:flutter/material.dart';
import 'utils/init_data.dart';
import 'models/question.dart';
import 'screens/review_by_category_screen.dart';
import 'screens/traffic_sign_screen.dart';
import 'screens/create_question_screen.dart';
import 'screens/question_screen.dart';

List<Question> wrongQuestionsGlobal = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await loadInitialQuestionsFromJson();
  runApp(const ThiBangLaiXeApp());
}

class ThiBangLaiXeApp extends StatelessWidget {
  const ThiBangLaiXeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ôn Thi Bằng Lái Xe A',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.light,
          primary: Colors.amber,
          secondary: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        cardColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ôn Thi Bằng Lái Xe Hạng A')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: const [
            MenuCard(title: 'Tạo Câu Hỏi', icon: Icons.add_circle_outline),
            MenuCard(title: 'Đề ôn thi', icon: Icons.library_books),
            MenuCard(title: 'Các Biển Báo', icon: Icons.traffic),
            MenuCard(title: 'Thi Theo Bộ Đề', icon: Icons.library_books),
          ],
        ),
      ),
    );
  }
}

final Map<String, Widget Function()> screenMap = {
  'Thi Theo Bộ Đề': () => const ReviewByCategoryScreen(),
  'Các Biển Báo': () => const TrafficSignScreen(),
  'Tạo Câu Hỏi': () => CreateQuestionScreen(onQuestionCreated: (_) {}),
  'Đề ôn thi': () => const QuestionScreen(),
};

class MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const MenuCard({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final screenBuilder = screenMap[title];
        if (screenBuilder != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screenBuilder()),
          );
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.amber),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
