import 'braden_evaluation.dart';

class Patient {
  final String id;
  final List<BradenEvaluation> evaluations;

  Patient({required this.id, required this.evaluations});

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json['id'],
        evaluations: (json['evaluations'] as List)
            .map((e) => BradenEvaluation.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'evaluations': evaluations.map((e) => e.toJson()).toList(),
      };
}
