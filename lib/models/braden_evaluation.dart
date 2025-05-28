class BradenEvaluation {
  final int sensoryPerception;
  final int moisture;
  final int activity;
  final int mobility;
  final int nutrition;
  final int frictionShear;
  final int totalScore;
  final String classification;
  final DateTime timestamp;

  BradenEvaluation({
    required this.sensoryPerception,
    required this.moisture,
    required this.activity,
    required this.mobility,
    required this.nutrition,
    required this.frictionShear,
    required this.totalScore,
    required this.classification,
    required this.timestamp,
  });

  factory BradenEvaluation.fromJson(Map<String, dynamic> json) => BradenEvaluation(
        sensoryPerception: json['sensoryPerception'],
        moisture: json['moisture'],
        activity: json['activity'],
        mobility: json['mobility'],
        nutrition: json['nutrition'],
        frictionShear: json['frictionShear'],
        totalScore: json['totalScore'],
        classification: json['classification'],
        timestamp: DateTime.parse(json['timestamp']),
      );

  Map<String, dynamic> toJson() => {
        'sensoryPerception': sensoryPerception,
        'moisture': moisture,
        'activity': activity,
        'mobility': mobility,
        'nutrition': nutrition,
        'frictionShear': frictionShear,
        'totalScore': totalScore,
        'classification': classification,
        'timestamp': timestamp.toIso8601String(),
      };
}
