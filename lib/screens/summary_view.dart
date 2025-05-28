import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/braden_evaluation.dart';
import '../utils/score_interpreter.dart';

class SummaryView extends StatelessWidget {
  final BradenEvaluation evaluation;
  const SummaryView({super.key, required this.evaluation});

  @override
  Widget build(BuildContext context) {
    final risk = ScoreInterpreter.interpret(evaluation.totalScore);
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final color = risk['color'] as Color;
    final icon = risk['icon'] as String;
    final date = '${evaluation.timestamp.day.toString().padLeft(2, '0')}/${evaluation.timestamp.month.toString().padLeft(2, '0')}/${evaluation.timestamp.year}';
    final time = '${evaluation.timestamp.hour.toString().padLeft(2, '0')}:${evaluation.timestamp.minute.toString().padLeft(2, '0')}';
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
            const SizedBox(width: 4),
            Text(date, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 16),
            const Icon(Icons.access_time, size: 20, color: Colors.grey),
            const SizedBox(width: 4),
            Text(time, style: const TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color, width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 8),
              Text(
                risk['risk'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                'Pontuação: ${evaluation.totalScore}',
                style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 18, color: Colors.grey[700]),
                  const SizedBox(width: 4),
                  Text(
                    date,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.access_time, size: 18, color: Colors.grey[700]),
                  const SizedBox(width: 4),
                  Text(
                    time,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Data: $date',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recomendação:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 4),
              Text(
                risk['recommendation'],
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 24),
              Text('Domínios:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 8),
              _domainRow('Percepção sensorial', evaluation.sensoryPerception),
              _domainRow('Umidade', evaluation.moisture),
              _domainRow('Atividade', evaluation.activity),
              _domainRow('Mobilidade', evaluation.mobility),
              _domainRow('Nutrição', evaluation.nutrition),
              _domainRow('Fricção e cisalhamento', evaluation.frictionShear),
            ],
          ),
        ),
      ],
    );
    if (isIOS) {
      return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Resumo da Avaliação'),
        ),
        child: SafeArea(child: SingleChildScrollView(child: content)),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text('Resumo da Avaliação')),
        body: SafeArea(child: SingleChildScrollView(child: content)),
      );
    }
  }

  Widget _domainRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
