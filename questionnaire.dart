import 'package:flutter/material.dart';
import 'history.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class Questionnaire extends StatefulWidget {
  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  List<String> questions = [
    "What are you grateful for today?",
    "What made you smile today?",
    "What challenges did you face today?",
  ];

  Map<String, String> answers = {};
  Set<String> answeredQuestions = {};

  @override
  Widget build(BuildContext context) {
    List<String> unansweredQuestions = questions
        .where((question) => !answeredQuestions.contains(question))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Questionnaire'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: unansweredQuestions.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _navigateToAnswerQuestionPage(unansweredQuestions[index]);
              },
              child: Card(
                child: ListTile(
                  title: Text(unansweredQuestions[index]),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryPage(
                finishedQuestionnaires: answeredQuestions.toList(),
                answers: answers,
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToAnswerQuestionPage(String question) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnswerQuestionPage(
          question: question,
          onAnswered: (answer) {
            setState(() {
              answers[question] = answer;
              answeredQuestions.add(question);
            });
          },
        ),
      ),
    );
  }
}

class AnswerQuestionPage extends StatelessWidget {
  final String question;
  final Function(String) onAnswered;

  AnswerQuestionPage({required this.question, required this.onAnswered});

  @override
  Widget build(BuildContext context) {
    String answer = '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Answer Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              question,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            TextField(
              onChanged: (value) {
                answer = value;
              },
              decoration: InputDecoration(
                labelText: 'Your Answer',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                onAnswered(answer);
                Navigator.pop(context);
              },
              child: Text('Submit Answer'),
            ),
          ],
        ),
      ),
    );
  }
}