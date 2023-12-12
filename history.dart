import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final List<String> finishedQuestionnaires;
  final Map<String, String> answers;

  HistoryPage({required this.finishedQuestionnaires, required this.answers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questionnaire History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: finishedQuestionnaires.length,
          itemBuilder: (context, index) {
            String question = finishedQuestionnaires[index];
            String answer = answers[question] ?? "Not answered";
            return Card(
              child: ListTile(
                title: Text(question),
                subtitle: Text(answer),
              ),
            );
          },
        ),
      ),
    );
  }
}