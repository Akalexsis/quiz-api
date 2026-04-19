import 'package:flutter/material.dart';
import 'quiz.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;


  const ResultScreen({super.key, required this.score, required this.total});

  String get _message {
    final pct = score / total;
    if (pct == 1.0) return 'Perfect Score! 🏆'; 
    if (pct >= 0.8) return 'Excellent! 🎉';
    if (pct >= 0.6) return 'Good Job! 👍';
    if (pct >= 0.4) return 'Keep Practicing! 💪'; 
    return 'Better luck next time! ';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_message, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text('$score / $total', style: const TextStyle(fontSize: 36)),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizScreen()),
                ),
                child: const Text('Play Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
