import 'package:flutter/material.dart';

class ScoreInterpreter {
  static Map<String, dynamic> interpret(int totalScore) {
    if (totalScore >= 6 && totalScore <= 9) {
      return {
        'risk': 'Risco muito alto',
        'recommendation':
            'Avaliação da pele sobre proeminências ósseas e abaixo de dispositivos médicos\n'
            'Hidratação da pele\n'
            'Reposicionamento do paciente seguindo o cronograma estabelecido\n'
            'Uso de uma superfície de suporte adequada (colchão viscoelástico, pneumático)\n'
            'Elevação dos calcâneos associado a cobertura para prevenção\n'
            'Gerenciamento da umidade\n'
            'Acompanhamento nutricional\n'
            'Observar alterações na condição clínica e no risco do paciente.',
        'color': Color(0xFFD32F2F), // Deep Red
        'icon': '🛑',
        'textColor': Colors.black,
      };
    } else if (totalScore >= 10 && totalScore <= 12) {
      return {
        'risk': 'Risco alto',
        'recommendation':
            'Avaliação da pele sobre proeminências ósseas e abaixo de dispositivos médicos\n'
            'Hidratação da pele\n'
            'Reposicionamento do paciente seguindo o cronograma estabelecido\n'
            'Uso de uma superfície de suporte adequada (colchão viscoelástico, pneumático)\n'
            'Elevação dos calcâneos associado a cobertura para prevenção\n'
            'Gerenciamento da umidade\n'
            'Acompanhamento nutricional\n'
            'Observar alterações na condição clínica e no risco do paciente.',
        'color': Color(0xFFF44336), // Red
        'icon': '❗',
        'textColor': Colors.black,
      };
    } else if (totalScore >= 13 && totalScore <= 14) {
      return {
        'risk': 'Risco moderado',
        'recommendation':
            'Avaliação da pele sobre proeminências ósseas e abaixo de dispositivos médicos\n'
            'Hidratação da pele\n'
            'Reposicionamento do paciente seguindo o cronograma estabelecido\n'
            'Uso de uma superfície de suporte adequada (colchão viscoelástico, pneumático)\n'
            'Elevação dos calcâneos associado a cobertura para prevenção\n'
            'Gerenciamento da umidade\n'
            'Acompanhamento nutricional\n'
            'Observar alterações na condição clínica e no risco do paciente.',
        'color': Color(0xFFFFC107), // Amber
        'icon': '⚠️',
        'textColor': Color(0xFF212121),
      };
    } else if (totalScore >= 15 && totalScore <= 18) {
      return {
        'risk': 'Baixo risco',
        'recommendation':
            'Avaliação da pele sobre proeminências ósseas e abaixo de dispositivos médicos\n'
            'Hidratação da pele\n'
            'Gerenciamento da umidade\n'
            'Acompanhamento nutricional\n'
            'Observar alterações na condição clínica e no risco do paciente.',
        'color': Color(0xFF4CAF50), // Green
        'icon': '✅',
        'textColor': Colors.black,
      };
    } else if (totalScore >= 19 && totalScore <= 23) {
      return {
        'risk': 'Sem risco',
        'recommendation': 'Manter cuidados básicos de enfermagem.',
        'color': Color(0xFF1976D2), // Blue
        'icon': '🟦',
        'textColor': Colors.black,
      };
    } else {
      return {
        'risk': 'Pontuação inválida',
        'recommendation': 'Pontuação fora do intervalo válido da escala de Braden (6-23).',
        'color': Colors.grey,
        'icon': '❓',
        'textColor': Colors.black,
      };
    }
  }
}
