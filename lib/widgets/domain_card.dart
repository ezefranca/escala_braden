// Copyright® Braden, Bergstrom 1988. Adaptada e validada para o Brasil por Paranhos, Santos 1999.
// Paranhos WY, Santos VLCG. Avaliação de risco para úlceras de pressão por meio da Escala de Braden, na língua portuguesa. Rev Esc Enferm USP. 1999; 33 (nº esp): 191-206.
// Disponível em: <http://www.bradenscale.com/translations.htm> e <http://143.107.173.8/reeusp/upload/pdf/799.pdf>.

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/foundation.dart';
import 'score_option_selector.dart';

class DomainCard extends StatelessWidget {
  final String domainKey;
  final int? value;
  final ValueChanged<int> onChanged;

  const DomainCard({
    super.key,
    required this.domainKey,
    required this.value,
    required this.onChanged,
  });

  static const Map<String, Map<String, dynamic>> bradenDomains = {
    'sensoryPerception': {
      'title': 'Percepção sensorial',
      'desc': 'Capacidade de reagir significativamente à pressão relacionada ao desconforto.',
      'options': [
        '1. Totalmente limitado: Não reage (não geme, não se segura a nada, não se esquiva) a estímulo doloroso, devido ao nível de consciência diminuído ou devido à sedação ou capacidade limitada de sentir dor na maior parte do corpo.',
        '2. Muito limitado: Somente reage a estímulo doloroso. Não é capaz de comunicar desconforto exceto através de gemido ou agitação. Ou possui alguma deficiência sensorial que limita a capacidade de sentir dor ou desconforto em mais de metade do corpo.',
        '3. Levemente limitado: Responde a comando verbal, mas nem sempre é capaz de comunicar o desconforto ou expressar necessidade de ser mudado de posição ou tem um certo grau de deficiência sensorial que limita a capacidade de sentir dor ou desconforto em 1 ou 2 extremidades.',
        '4. Nenhuma limitação: Responde a comandos verbais. Não tem déficit sensorial que limitaria a capacidade de sentir ou verbalizar dor ou desconforto.'
      ]
    },
    'moisture': {
      'title': 'Umidade',
      'desc': 'Nível ao qual a pele é exposta a umidade.',
      'options': [
        '1. Completamente molhada: A pele é mantida molhada quase constantemente por transpiração, urina, etc. Umidade é detectada às movimentações do paciente.',
        '2. Muito molhada: A pele está frequentemente, mas nem sempre molhada. A roupa de cama deve ser trocada pelo menos uma vez por turno.',
        '3. Ocasionalmente molhada: A pele fica ocasionalmente molhada requerendo uma troca extra de roupa de cama por dia.',
        '4. Raramente molhada: A pele geralmente está seca, a troca de roupa de cama é necessária somente nos intervalos de rotina.'
      ]
    },
    'activity': {
      'title': 'Atividade',
      'desc': 'Grau de atividade física.',
      'options': [
        '1. Acamado: Confinado a cama.',
        '2. Confinado a cadeira: A capacidade de andar está severamente limitada ou nula. Não é capaz de sustentar o próprio peso e/ou precisa ser ajudado a se sentar.',
        '3. Anda ocasionalmente: Anda ocasionalmente durante o dia, embora distâncias muito curtas, com ou sem ajuda. Passa a maior parte de cada turno na cama ou cadeira.',
        '4. Anda frequentemente: Anda fora do quarto pelo menos 2 vezes por dia e dentro do quarto pelo menos uma vez a cada 2 horas durante as horas em que está acordado.'
      ]
    },
    'mobility': {
      'title': 'Mobilidade',
      'desc': 'Capacidade de mudar e controlar a posição do corpo.',
      'options': [
        '1. Totalmente imóvel: Não faz nem mesmo pequenas mudanças na posição do corpo ou extremidades sem ajuda.',
        '2. Bastante limitado: Faz pequenas mudanças ocasionais na posição do corpo ou extremidades mas é incapaz de fazer mudanças frequentes ou significantes sozinho.',
        '3. Levemente limitado: Faz frequentes, embora pequenas, mudanças na posição do corpo ou extremidades sem ajuda.',
        '4. Não apresenta limitações: Faz importantes e frequentes mudanças sem auxílio.'
      ]
    },
    'nutrition': {
      'title': 'Nutrição',
      'desc': 'Padrão usual de consumo alimentar.',
      'options': [
        '1. Muito pobre: Nunca come uma refeição completa. Raramente come mais de 1/3 do alimento oferecido. Come 2 porções ou menos de proteína (carnes ou laticínios) por dia. Ingere pouco líquido. Não aceita suplemento alimentar líquido. Ou é mantido em jejum e/ou mantido com dieta líquida ou IVs por mais de cinco dias.',
        '2. Provavelmente inadequado: Raramente come uma refeição completa. Geralmente come cerca de metade do alimento oferecido. Ingestão de proteína inclui somente 3 porções de carne ou laticínios por dia. Ocasionalmente aceitará um suplemento alimentar ou recebe abaixo da quantidade satisfatória de dieta líquida ou alimentação por sonda.',
        '3. Adequado: Come mais da metade da maioria das refeições. Come um total de 4 porções de alimento rico em proteína (carne e laticínios) todo dia. Ocasionalmente recusará uma refeição, mas geralmente aceitará um complemento oferecido. Ou é alimentado por sonda ou regime de nutrição parenteral total, o qual provavelmente satisfaz a maior parte das necessidades nutricionais.',
        '4. Excelente: Come a maior parte de cada refeição. Nunca recusa uma refeição. Geralmente ingere um total de 4 ou mais porções de carne e laticínios. Ocasionalmente come entre as refeições. Não requer suplemento alimentar.'
      ]
    },
    'frictionShear': {
      'title': 'Fricção e Cisalhamento',
      'desc': 'Fricção e/ou forças de cisalhamento presentes.',
      'options': [
        '1. Problema: Requer assistência moderada a máxima para se mover. É impossível levantá-lo ou erguê-lo completamente sem que haja atrito da pele com o lençol. Frequentemente escorrega na cama ou cadeira, necessitando frequentes ajustes de posição com o máximo de assistência. Espasticidade, contratura ou agitação leva a quase constante fricção.',
        '2. Problema em potencial: Move-se mas, sem vigor ou requer mínima assistência. Durante o movimento provavelmente ocorre um certo atrito da pele com o lençol, cadeira ou outros. Na maior parte do tempo mantém posição relativamente boa na cama ou na cadeira mas ocasionalmente escorrega.',
        '3. Nenhum problema: Move-se sozinho na cama ou cadeira e tem suficiente força muscular para erguer-se completamente durante o movimento. Sempre mantém boa posição na cama ou cadeira.'
      ]
    },
  };

  @override
  Widget build(BuildContext context) {
    final isWeb = kIsWeb;
    final isIOS = !isWeb && Platform.isIOS;
    final domain = bradenDomains[domainKey]!;
    if (isIOS) {
      // Custom full-width radio/checkbox list for iOS
      final options = List<String>.from(domain['options']);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(options.length, (i) {
              final idx = i + 1;
              final selected = value == idx;
              return GestureDetector(
                onTap: () => onChanged(idx),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  decoration: BoxDecoration(
                    color: selected
                        ? CupertinoColors.systemFill.resolveFrom(context).withOpacity(0.25)
                        : Colors.transparent,
                    borderRadius: i == 0
                        ? const BorderRadius.vertical(top: Radius.circular(14))
                        : i == options.length - 1
                            ? const BorderRadius.vertical(bottom: Radius.circular(14))
                            : BorderRadius.zero,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selected
                            ? CupertinoIcons.check_mark_circled_solid
                            : CupertinoIcons.circle,
                        color: selected
                            ? CupertinoColors.activeBlue
                            : CupertinoColors.inactiveGray,
                        size: 28,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          options[i],
                          style: TextStyle(
                            fontSize: 16,
                            color: CupertinoColors.label.resolveFrom(context),
                            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      );
    } else {
      return ExpansionTile(
        title: Text(domain['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(domain['desc'], style: const TextStyle(fontSize: 15)),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ScoreOptionSelector(
              descriptions: List<String>.from(domain['options']),
              value: value,
              onChanged: onChanged,
            ),
          ),
        ],
      );
    }
  }
}
