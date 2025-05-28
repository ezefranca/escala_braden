import 'package:flutter_test/flutter_test.dart';
import 'package:escala_braden/models/braden_evaluation.dart';
import 'package:escala_braden/utils/score_interpreter.dart';

void main() {
  group('BradenEvaluation', () {
    test('Serialization and deserialization', () {
      final now = DateTime(2025, 5, 28, 14, 30);
      final eval = BradenEvaluation(
        sensoryPerception: 3,
        moisture: 2,
        activity: 4,
        mobility: 3,
        nutrition: 2,
        frictionShear: 2,
        totalScore: 16,
        classification: 'Baixo risco',
        timestamp: now,
      );
      final json = eval.toJson();
      final fromJson = BradenEvaluation.fromJson(json);
      expect(fromJson.sensoryPerception, 3);
      expect(fromJson.moisture, 2);
      expect(fromJson.activity, 4);
      expect(fromJson.mobility, 3);
      expect(fromJson.nutrition, 2);
      expect(fromJson.frictionShear, 2);
      expect(fromJson.totalScore, 16);
      expect(fromJson.classification, 'Baixo risco');
      expect(fromJson.timestamp, now);
    });
  });

  group('ScoreInterpreter', () {
    test('Risk classification and color-coding', () {
      final risks = [
        {'score': 8, 'risk': 'Risco muito alto'},
        {'score': 11, 'risk': 'Risco alto'},
        {'score': 13, 'risk': 'Risco moderado'},
        {'score': 16, 'risk': 'Baixo risco'},
        {'score': 20, 'risk': 'Sem risco'},
      ];
      for (final r in risks) {
        final result = ScoreInterpreter.interpret(r['score'] as int);
        expect(result['risk'], r['risk']);
        expect(result['color'], isNotNull);
        expect(result['icon'], isNotNull);
      }
    });
  });
}
