import 'package:flutter/material.dart';
import '../models/braden_evaluation.dart';
import '../services/storage_service.dart';
import '../utils/score_interpreter.dart';
import '../widgets/domain_card.dart';
import '../widgets/ios_assessment_carousel.dart';

class NewEvaluationScreen extends StatefulWidget {
  final String? patientId;
  const NewEvaluationScreen({super.key, required this.patientId});

  @override
  State<NewEvaluationScreen> createState() => _NewEvaluationScreenState();
}

class _NewEvaluationScreenState extends State<NewEvaluationScreen> {
  int? sensoryPerception;
  int? moisture;
  int? activity;
  int? mobility;
  int? nutrition;
  int? frictionShear;
  bool _saving = false;

  String? get patientId {
    if (widget.patientId != null && widget.patientId!.isNotEmpty) {
      return widget.patientId;
    }
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.isNotEmpty) {
      return args;
    }
    return null;
  }

  bool get isComplete => [
    sensoryPerception,
    moisture,
    activity,
    mobility,
    nutrition,
    frictionShear
  ].every((v) => v != null);

  int get totalScore => [
    sensoryPerception ?? 0,
    moisture ?? 0,
    activity ?? 0,
    mobility ?? 0,
    nutrition ?? 0,
    frictionShear ?? 0
  ].reduce((a, b) => a + b);

  String get classification => ScoreInterpreter.interpret(totalScore)['risk'];

  Future<void> _saveEvaluation() async {
    if (patientId == null) return;
    setState(() => _saving = true);
    final eval = BradenEvaluation(
      sensoryPerception: sensoryPerception!,
      moisture: moisture!,
      activity: activity!,
      mobility: mobility!,
      nutrition: nutrition!,
      frictionShear: frictionShear!,
      totalScore: totalScore,
      classification: classification,
      timestamp: DateTime.now(),
    );
    final service = StorageService();
    await service.addEvaluation(patientId!, eval);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final domains = [
      {
        'key': 'sensoryPerception',
        'title': 'Percepção sensorial',
        'desc': 'Capacidade de responder de forma significativa ao desconforto relacionado à pressão.',
        'widget': DomainCard(
          domainKey: 'sensoryPerception',
          value: sensoryPerception,
          onChanged: (int v) => setState(() => sensoryPerception = v),
        ),
        'value': sensoryPerception,
        'onChanged': (int v) => setState(() => sensoryPerception = v),
      },
      {
        'key': 'moisture',
        'title': 'Umidade',
        'desc': 'Grau em que a pele está exposta à umidade.',
        'widget': DomainCard(
          domainKey: 'moisture',
          value: moisture,
          onChanged: (int v) => setState(() => moisture = v),
        ),
        'value': moisture,
        'onChanged': (int v) => setState(() => moisture = v),
      },
      {
        'key': 'activity',
        'title': 'Atividade',
        'desc': 'Grau de atividade física do paciente.',
        'widget': DomainCard(
          domainKey: 'activity',
          value: activity,
          onChanged: (int v) => setState(() => activity = v),
        ),
        'value': activity,
        'onChanged': (int v) => setState(() => activity = v),
      },
      {
        'key': 'mobility',
        'title': 'Mobilidade',
        'desc': 'Capacidade de mudar e controlar a posição do corpo.',
        'widget': DomainCard(
          domainKey: 'mobility',
          value: mobility,
          onChanged: (int v) => setState(() => mobility = v),
        ),
        'value': mobility,
        'onChanged': (int v) => setState(() => mobility = v),
      },
      {
        'key': 'nutrition',
        'title': 'Nutrição',
        'desc': 'Padrão usual de alimentação.',
        'widget': DomainCard(
          domainKey: 'nutrition',
          value: nutrition,
          onChanged: (int v) => setState(() => nutrition = v),
        ),
        'value': nutrition,
        'onChanged': (int v) => setState(() => nutrition = v),
      },
      {
        'key': 'frictionShear',
        'title': 'Fricção e cisalhamento',
        'desc': 'Grau em que a pele é submetida à fricção e/ou cisalhamento.',
        'widget': DomainCard(
          domainKey: 'frictionShear',
          value: frictionShear,
          onChanged: (int v) => setState(() => frictionShear = v),
        ),
        'value': frictionShear,
        'onChanged': (int v) => setState(() => frictionShear = v),
      },
    ];
    if (isIOS) {
      // iOS: Carousel/stepper style
      return IOSAssessmentCarousel(
        domains: domains,
        isComplete: isComplete,
        saving: _saving,
        onSave: _saveEvaluation,
      );
    } else {
      // Android/Web: vertical form
      final form = ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final d in domains)
            DomainCard(
              domainKey: d['key'] as String,
              value: d['value'] as int?,
              onChanged: d['onChanged'] as ValueChanged<int>,
            ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: isComplete && !_saving && patientId != null ? _saveEvaluation : null,
            child: const Text('Calcular risco'),
          ),
        ],
      );
      return Scaffold(
        appBar: AppBar(
          title: const Text('Nova Avaliação'),
        ),
        body: SafeArea(child: form),
      );
    }
  }
}
