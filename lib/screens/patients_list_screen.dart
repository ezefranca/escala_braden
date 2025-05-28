// Tela principal que exibe a lista de pacientes

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/patient.dart';
import '../services/storage_service.dart';
import '../app.dart';

class PatientsListScreen extends StatefulWidget {
  const PatientsListScreen({super.key});

  @override
  State<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> with RouteAware {
  List<Patient> _patients = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.unsubscribe(this);
    }
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    final service = StorageService();
    final patients = await service.getPatients();
    setState(() {
      _patients = patients;
      _loading = false;
    });
  }

  Future<void> _addPatient() async {
    final service = StorageService();
    final existingIds = _patients.map((p) => p.id).toSet();
    int idx = 1;
    String newId;
    do {
      newId = 'Paciente #${idx.toString().padLeft(3, '0')}';
      idx++;
    } while (existingIds.contains(newId));
    final newPatient = Patient(id: newId, evaluations: []);
    await service.addPatient(newPatient);
    await _loadPatients();
    if (!mounted) return;
    Navigator.of(context).pushNamed('/history', arguments: newPatient.id);
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    Widget content;
    if (_loading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_patients.isEmpty) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bem-vindo! Nenhum paciente cadastrado.'),
            const SizedBox(height: 24),
            isIOS
                ? CupertinoButton.filled(
                    onPressed: _addPatient,
                    child: const Text('Adicionar primeiro paciente'),
                  )
                : ElevatedButton(
                    onPressed: _addPatient,
                    child: const Text('Adicionar primeiro paciente'),
                  ),
          ],
        ),
      );
    } else {
      content = ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _patients.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, i) {
          final p = _patients[i];
          final evalCount = p.evaluations.length;
          final lastEval = evalCount > 0 ? p.evaluations.last.timestamp : null;
          String dateText = 'Sem avaliações';
          if (lastEval != null) {
            final date =
                  '${lastEval.day.toString().padLeft(2, '0')}/${lastEval.month.toString().padLeft(2, '0')}/${lastEval.year}';
            dateText = 'Última avaliação: ${date}';
          }
          if (isIOS) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/history', arguments: p.id);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.person, color: CupertinoColors.activeBlue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.id, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          Text(dateText, style: const TextStyle(fontSize: 14, color: CupertinoColors.systemGrey)),
                        ],
                      ),
                    ),
                    const Icon(CupertinoIcons.right_chevron, color: CupertinoColors.systemGrey2),
                  ],
                ),
              ),
            );
          } else {
            return ListTile(
              leading: const Icon(Icons.person),
              title: Text(p.id),
              subtitle: Text(dateText),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).pushNamed('/history', arguments: p.id);
              },
            );
          }
        },
      );
    }
    if (isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Pacientes'),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _addPatient,
            child: const Icon(CupertinoIcons.add),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: content),
              Container(
                width: double.infinity,
                color: Colors.yellow[100],
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: const Text(
                  'Este aplicativo é destinado a profissionais da saúde e cuidadores treinados. A Escala de Braden é uma ferramenta auxiliar e não substitui julgamento clínico ou diagnóstico médico.',
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.transparent,
                padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16, top: 2),
                child: const Text(
                  'Copyright® Braden, Bergstrom 1988. Adaptada e validada para o Brasil por Paranhos, Santos 1999. Paranhos WY, Santos VLCG. Rev Esc Enferm USP. 1999; 33 (nº esp): 191-206. Disponível em: bradenscale.com/translations.htm e 143.107.173.8/reeusp/upload/pdf/799.pdf.',
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Pacientes'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: content),
              Container(
                width: double.infinity,
                color: Colors.yellow[100],
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: const Text(
                  'Este aplicativo é destinado a profissionais da saúde e cuidadores treinados. A Escala de Braden é uma ferramenta auxiliar e não substitui julgamento clínico ou diagnóstico médico.',
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.transparent,
                padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16, top: 2),
                child: const Text(
                  'Copyright® Braden, Bergstrom 1988. Adaptada e validada para o Brasil por Paranhos, Santos 1999. Paranhos WY, Santos VLCG. Rev Esc Enferm USP. 1999; 33 (nº esp): 191-206. Disponível em: bradenscale.com/translations.htm e 143.107.173.8/reeusp/upload/pdf/799.pdf.',
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _patients.isNotEmpty
            ? FloatingActionButton(
                onPressed: _addPatient,
                child: const Icon(Icons.add),
              )
            : null,
      );
    }
  }
}
