import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';
import '../models/patient.dart';
import '../models/braden_evaluation.dart';
import '../utils/score_interpreter.dart';
import '../screens/summary_view.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Patient? _patient;
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final patientId = ModalRoute.of(context)?.settings.arguments as String?;
    if (patientId != null) {
      _loadPatient(patientId);
    }
  }

  Future<void> _loadPatient(String id) async {
    setState(() => _loading = true);
    final service = StorageService();
    final patient = await service.getPatientById(id);
    setState(() {
      _patient = patient;
      _loading = false;
    });
  }

  Future<void> _deletePatient() async {
    if (_patient == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir paciente?'),
        content: const Text('Tem certeza que deseja excluir este paciente e todo o seu histórico?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final service = StorageService();
      final patients = await service.getPatients();
      patients.removeWhere((p) => p.id == _patient!.id);
      await service.savePatients(patients);
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = kIsWeb;
    final isIOS = !isWeb && Platform.isIOS;
    Widget content;
    if (_loading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_patient == null) {
      content = const Center(child: Text('Paciente não encontrado.'));
    } else if (_patient!.evaluations.isEmpty) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Sem avaliações para este paciente.'),
            const SizedBox(height: 24),
            isIOS
                ? CupertinoButton.filled(
                    onPressed: () async {
                      final result = await Navigator.of(context).pushNamed(
                        '/new_evaluation',
                        arguments: _patient!.id,
                      );
                      if (result == true) _loadPatient(_patient!.id);
                    },
                    child: const Text('Nova Avaliação'),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.of(context).pushNamed(
                        '/new_evaluation',
                        arguments: _patient!.id,
                      );
                      if (result == true) _loadPatient(_patient!.id);
                    },
                    child: const Text('Nova Avaliação'),
                  ),
          ],
        ),
      );
    } else {
      final evals = List<BradenEvaluation>.from(_patient!.evaluations);
      evals.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      content = Stack(
        children: [
          ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: evals.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, i) {
              final e = evals[i];
              final risk = ScoreInterpreter.interpret(e.totalScore);
              final color = risk['color'] as Color;
              final icon = risk['icon'] as String;
              final date = '${e.timestamp.day.toString().padLeft(2, '0')}/${e.timestamp.month.toString().padLeft(2, '0')}/${e.timestamp.year}';
              final time = '${e.timestamp.hour.toString().padLeft(2, '0')}:${e.timestamp.minute.toString().padLeft(2, '0')}';
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SummaryView(evaluation: e),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color, width: 1.2),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(icon, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 8),
                          Text(
                            risk['risk'],
                            style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 18),
                          ),
                          const Spacer(),
                          Icon(Icons.chevron_right, color: color),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 18, color: Colors.grey[700]),
                          const SizedBox(width: 4),
                          Text(
                            date,
                            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.access_time, size: 18, color: Colors.grey[700]),
                          const SizedBox(width: 4),
                          Text(
                            time,
                            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: isIOS
                ? CupertinoButton.filled(
                    onPressed: () async {
                      final result = await Navigator.of(context).pushNamed(
                        '/new_evaluation',
                        arguments: _patient!.id,
                      );
                      if (result == true) _loadPatient(_patient!.id);
                    },
                    child: const Text('Nova Avaliação'),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.of(context).pushNamed(
                        '/new_evaluation',
                        arguments: _patient!.id,
                      );
                      if (result == true) _loadPatient(_patient!.id);
                    },
                    child: const Text('Nova Avaliação'),
                  ),
          ),
        ],
      );
    }
    final title = _patient != null ? 'Histórico de avaliações – ${_patient!.id}' : 'Histórico';
    if (isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(title),
          trailing: _patient != null
              ? GestureDetector(
                  onTap: _deletePatient,
                  child: const Icon(CupertinoIcons.delete, color: CupertinoColors.destructiveRed),
                )
              : null,
        ),
        child: SafeArea(child: content),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: _patient != null
              ? [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Excluir paciente',
                    onPressed: _deletePatient,
                  ),
                ]
              : null,
        ),
        body: SafeArea(child: content),
      );
    }
  }
}
