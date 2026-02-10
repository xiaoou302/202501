import 'package:flutter/material.dart';
import 'package:zenithsprint/core/constants/app_colors.dart';
import 'package:zenithsprint/core/constants/app_values.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppValues.padding_large),
        children: const [
          FaqItem(
            question: 'What is Zenith Sprint?',
            answer:
                'Zenith Sprint is a cognitive training app designed to improve your mental arithmetic skills, particularly under pressure.',
          ),
          FaqItem(
            question: 'How does the scoring work?',
            answer:
                'Your score is based on a combination of speed and accuracy. The faster you answer correctly, the higher your score.',
          ),
          FaqItem(
            question: 'How can I track my progress?',
            answer:
                'You can track your progress on the Insights screen, which provides detailed charts and metrics on your performance over time.',
          ),
          FaqItem(
            question: 'What are badges?',
            answer:
                'Badges are awarded for achieving specific milestones, such as completing a certain number of sessions or achieving a high score.',
          ),
        ],
      ),
    );
  }
}

class FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const FaqItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppValues.margin),
      child: ExpansionTile(
        title: Text(widget.question),
        onExpansionChanged: (isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        trailing: Icon(
          _isExpanded ? Icons.remove : Icons.add,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppValues.padding_large),
            child: Text(widget.answer),
          ),
        ],
      ),
    );
  }
}
