import 'package:flutter/material.dart';
import '../api_config.dart';
import '../model/quiz_model.dart';
import '../service/quiz_service.dart';
import 'results.dart';

class QuizScreen extends StatefulWidget {
  final String? quiz_category;
  const QuizScreen({super.key, this.quiz_category = 'Programming'});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  //  all possible responses from API
  List<Question> _questions = [];
  List<String> _currentAnswers = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _loading = true;
  bool _answered = false;
  String? _selectedAnswer;
  String? _errorMessage;
  late String? quiz_category;

  @override
  void initState() {
    super.initState();
    quiz_category = widget.quiz_category;
    _loadQuestions(); // fetch questions when app initializes
  }

  // make get request
  Future<void> _loadQuestions( ) async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final questions = await TriviaService.fetchQuestions(
        apiKey: AppConfig.quizApiKey,
        category: quiz_category
        // TO-DO - UPDATE TO GET DIFFERENT QUESTIONS
      );

      // save questions if fetch successful
      setState(() {
        _questions = questions;
        _currentIndex = 0;
        _score = 0;
        _prepareQuestion();
        _loading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
        _loading = false;
      });
    }
  }

  // get current answer choices
  void _prepareQuestion() {
    if (_questions.isEmpty) return;
    _currentAnswers = _questions[_currentIndex].shuffledAnswers;
    _answered = false;
    _selectedAnswer = null;
  }

  void _onAnswerTap(String answer) {
    if (_answered) return; // do nothing if user has alr selected this answer option

    // get correct answer and check if user answer is correct
    final correct = _questions[_currentIndex].correctAnswer;

    setState(() {
      _selectedAnswer = answer;
      _answered = true;
      if (answer == correct) _score++;
    });

    // display pop-up message if answer is correct
    final isCorrect = answer == correct;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? '✅ Correct!' : '❌ Wrong! Correct: $correct'),
        backgroundColor: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

  }

  void _nextQuestion() {
    if (!mounted) return;

    // navigate to results screen after user answers all questions
    if (_currentIndex + 1 >= _questions.length) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(score: _score, total: _questions.length),
        ),
      );
      return;
    }

    setState(() {
      _currentIndex++;
      _prepareQuestion();
    });
  }

  void _prevQuestion() {
    if (!mounted) return;

    // handle if alr on first question
    if (_currentIndex == 0) return;

    setState(() {
      _currentIndex--;
      _prepareQuestion();
    });
  }

  // controls appearance of answer choices
  Color _buttonColor(String option) {
    if (!_answered) return Colors.white;

    final correct = _questions[_currentIndex].correctAnswer;

    if (option == correct) return Colors.green.shade100;
    if (option == _selectedAnswer) return Colors.red.shade100;
    return Colors.grey.shade100;
  }

  @override
  Widget build(BuildContext context) {
    // loading state
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // handle error messages
    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                const Text('Error loading questions'),
                const SizedBox(height: 8),
                Text(_errorMessage!, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: () { _loadQuestions(); }, child: const Text('Retry')),
              ],
            ),
          ),
        ),
      );
    }

    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    // return questions if successful
    return Scaffold(
      appBar: AppBar(
        // replace with quiz name
        title: Text('${question.difficulty} ${question.category} Quiz'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text('Score: $_score')),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // progress bar
            LinearProgressIndicator(value: progress, minHeight: 6, color: Colors.teal.shade600),
            SizedBox(height: 20),

            Text(
              "Question ${_currentIndex + 1} / ${_questions.length}: ${question.question}", 
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 20),

            // use map method to display each answer choice
            ..._currentAnswers.map((option) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ElevatedButton(
                onPressed: () => _onAnswerTap(option),
                style: ElevatedButton.styleFrom(backgroundColor: _buttonColor(option)),
                child: Text(option),
              ),
            )),
            SizedBox(height:12),

            // navigation buttons
            Row(
              children: [
                ActionChip(
                  avatar: Icon(Icons.arrow_back),
                  label: Text('Back', style: const TextStyle(fontSize: 16, color: Colors.teal),),
                  onPressed: _prevQuestion,
                ),
                SizedBox(width: 8),
                ActionChip(
                  avatar: Icon(Icons.arrow_forward),
                  label: Text('Next', style: const TextStyle(fontSize: 16, color: Colors.teal),),
                  onPressed: _nextQuestion,
                ),

              ]
            )
          ],
        ),
      ),
    );
  }
}