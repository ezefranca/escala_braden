// Tela Inicial do aplicativo, onde se pude adicionar pacientes e acessar avaliações
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/domain_card.dart';
import '../providers/braden_score_provider.dart';

const disclaimerKey = 'disclaimer_accepted';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    _checkDisclaimer();
  }

  Future<void> _checkDisclaimer() async {
    final prefs = await SharedPreferences.getInstance();
    final accepted = prefs.getBool(disclaimerKey) ?? false;
    if (!accepted) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showDisclaimer());
    }
  }

  Future<void> _showDisclaimer() async {
    final isIOS = !kIsWeb && Platform.isIOS;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => isIOS
          ? CupertinoAlertDialog(
              title: const Text('Aviso'),
              content: const Text('Este aplicativo é destinado a profissionais da saúde e cuidadores treinados. A Escala de Braden é uma ferramenta auxiliar e não substitui julgamento clínico ou diagnóstico médico.'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('Continuar'),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool(disclaimerKey, true);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          : AlertDialog(
              title: const Text('Aviso'),
              content: const Text('Este aplicativo é destinado a profissionais da saúde e cuidadores treinados. A Escala de Braden é uma ferramenta auxiliar e não substitui julgamento clínico ou diagnóstico médico.'),
              actions: [
                TextButton(
                  child: const Text('Continuar'),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool(disclaimerKey, true);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BradenScoreProvider>(context);
    final isWeb = kIsWeb;
    final isIOS = !isWeb && Platform.isIOS;
    int getDomainValue(String key) {
      switch (key) {
        case 'sensoryPerception':
          return provider.sensoryPerception ?? 0;
        case 'moisture':
          return provider.moisture ?? 0;
        case 'activity':
          return provider.activity ?? 0;
        case 'mobility':
          return provider.mobility ?? 0;
        case 'nutrition':
          return provider.nutrition ?? 0;
        case 'frictionShear':
          return provider.frictionShear ?? 0;
        default:
          return 0;
      }
    }
    final domains = [
      {
        'key': 'sensoryPerception',
        'title': 'Percepção sensorial',
        'desc': [
          '1 - Completamente limitada',
          '2 - Muito limitada',
          '3 - Ligeiramente limitada',
          '4 - Nenhuma limitação',
        ],
      },
      {
        'key': 'moisture',
        'title': 'Umidade',
        'desc': [
          '1 - Sempre úmida',
          '2 - Muito úmida',
          '3 - Ocasionalmente úmida',
          '4 - Raramente úmida',
        ],
      },
      {
        'key': 'activity',
        'title': 'Atividade',
        'desc': [
          '1 - Acamado',
          '2 - Confinado à cadeira',
          '3 - Anda ocasionalmente',
          '4 - Anda frequentemente',
        ],
      },
      {
        'key': 'mobility',
        'title': 'Mobilidade',
        'desc': [
          '1 - Completamente imóvel',
          '2 - Muito limitada',
          '3 - Ligeiramente limitada',
          '4 - Sem limitação',
        ],
      },
      {
        'key': 'nutrition',
        'title': 'Nutrição',
        'desc': [
          '1 - Muito pobre',
          '2 - Provavelmente inadequada',
          '3 - Adequada',
          '4 - Excelente',
        ],
      },
      {
        'key': 'frictionShear',
        'title': 'Fricção e cisalhamento',
        'desc': [
          '1 - Problema',
          '2 - Problema potencial',
          '3 - Nenhum aparente',
          '4 - Nenhum',
        ],
      },
    ];
    final form = ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final domain in domains)
          DomainCard(
            domainKey: domain['key'] as String,
            value: getDomainValue(domain['key'] as String) == 0 ? null : getDomainValue(domain['key'] as String),
            onChanged: (v) => provider.setDomain(domain['key'] as String, v),
          ),
        const SizedBox(height: 24),
        isIOS
            ? CupertinoButton.filled(
                onPressed: provider.isComplete ? () {} : null,
                child: const Text('Calcular risco'),
              )
            : ElevatedButton(
                onPressed: provider.isComplete ? () {} : null,
                child: const Text('Calcular risco'),
              ),
      ],
    );
    return isIOS
        ? CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text('Escala de Braden'),
            ),
            child: SafeArea(child: form),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Escala de Braden'),
            ),
            body: SafeArea(child: form),
          );
  }
}
