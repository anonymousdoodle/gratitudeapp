import 'dart:html';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'history.dart';
import 'questionnaire.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NewScreen(),
    );
  }
}

class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Questions'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getQuestion(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.hasData) {
              return QuestionWidget(question: snapshot.data!['question']);
            } else {
              return Text('No questions available.');
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }


  Future<Map<String, dynamic>> getQuestion() async {
    final response = await http.get('http://localhost/get_question.php' as Uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load question');
    }
  }
}

class QuestionWidget extends StatelessWidget {
  final String question;

  QuestionWidget({required this.question});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          question,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  double fontSize = 16.0;
  late AnimationController _controller;
  late Animation<int> _textAnimation;
  String currentImage = 'assets/speech_bubble1.png';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    _textAnimation = IntTween(begin: 0, end: "Hello there! How are you? Here is the question for today.".length).animate(_controller);
    _controller.forward();
  }

  void switchImage(String newImage) {
    setState(() {
      currentImage = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/APP_BG.png',
            fit: BoxFit.cover,
          ),
          // Clickable Images
          Positioned(
            top: 50.0,
            left: 0.0,
            right: 0.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    switchImage('assets/questionmark.png');
                  },
                  child: Image.asset(
                    currentImage,
                    fit: BoxFit.contain,
                    height: 150.0,
                    width: 150.0,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    switchImage('assets/questionmark.png');
                  },
                  child: Image.asset(
                    'assets/TERRI_BABY.gif',
                    fit: BoxFit.contain,
                    height: 200.0,
                    width: 250.0,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Questionnaire(),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/questionbubble3.png',
                        height: 340.0,
                        width: 400.0,
                      ),
                      Positioned(
                        top: 100.0,
                        left: 60.0,
                        right: 35.0,
                        child: TypewriterText(animation: _textAnimation),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80.0,
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text(
                  'Home',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryPage(
                        finishedQuestionnaires: [],
                        answers: {},
                      ),
                    ),
                  );
                },
                child: Text(
                  'History',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class TypewriterText extends StatelessWidget {
  final Animation<int> animation;

  TypewriterText({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        String text = "Hello there! How are you? Here is the question for today.";
        int length = animation.value.clamp(0, text.length);
        return Text(
          text.substring(0, length),
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}