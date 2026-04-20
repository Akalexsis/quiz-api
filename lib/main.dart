import 'package:flutter/material.dart';
import 'api_config.dart';
import 'screens/quiz.dart';

void main() {
  AppConfig.validate();
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: MyApp(),
    );
  }
}

// display different quiz options
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // send user specific category to quiz screen
  void _toQuiz( BuildContext context, String? category ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScreen( quiz_category: category ),
      ),
    );
  }

  // send data to quiz page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App', style: TextStyle( fontSize: 24, color: Colors.white )),
        backgroundColor: Colors.teal
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Text('Welcome to the Quiz App!', style: TextStyle( fontSize: 24 ), textAlign: TextAlign.center),
            Text('Select a quiz catagory and difficulty to get started.', style: TextStyle( fontSize: 18 )),
            SizedBox(height: 16),

            // use default quiz options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [ 
                Text('Take this easy programming quiz to get started →', style: TextStyle( fontSize: 18 )),

                ElevatedButton(
                  onPressed: () => _toQuiz(context, null),
                  child: Text('Start Quiz'),
                )
              ]
            ),
            SizedBox(height: 20),

            // QUIZ CATEGORY
            Text('Category: ', style: TextStyle( fontSize: 18 ), textAlign: TextAlign.start),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionChip(
                  label: Text('Countries', style: TextStyle( fontSize: 16 )),
                  onPressed: () => _toQuiz(context, 'Countries')
                ),
                ActionChip(
                  label: Text('Famous People', style: TextStyle( fontSize: 16 )),
                  onPressed: () => _toQuiz(context, 'Famous People')
                ),
                ActionChip(
                  label: Text('History', style: TextStyle( fontSize: 16 )),
                  onPressed: () => _toQuiz(context, 'History')
                ),
                ActionChip(
                  label: Text('Movies', style: TextStyle( fontSize: 16 )),
                  onPressed: () => _toQuiz(context, 'Movies')
                ),
              ]
            ),
          ]
        )
      )
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [ 
//             Text( "Home" ),
//           ],
//         ),
//       ),
//     );
//   }
// }
