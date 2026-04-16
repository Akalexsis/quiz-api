class AppConfig {
  static const quizApiKey = String.fromEnvironment('QUIZ_API_KEY');
}

if (AppConfig.quizApiKey.isEmpty) {
  throw Exception('Missing QUIZ_API_KEY. Run with --dart-define.');
}