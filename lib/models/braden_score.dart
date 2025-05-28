class BradenScore {
  final String patientId;
  final int sensoryPerception;
  final int moisture;
  final int activity;
  final int mobility;
  final int nutrition;
  final int frictionShear;
  final DateTime timestamp;

  BradenScore({
    required this.patientId,
    required this.sensoryPerception,
    required this.moisture,
    required this.activity,
    required this.mobility,
    required this.nutrition,
    required this.frictionShear,
    required this.timestamp,
  });

  int get totalScore => sensoryPerception + moisture + activity + mobility + nutrition + frictionShear;

  Map<String, dynamic> toJson() => {
        'patientId': patientId,
        'sensoryPerception': sensoryPerception,
        'moisture': moisture,
        'activity': activity,
        'mobility': mobility,
        'nutrition': nutrition,
        'frictionShear': frictionShear,
        'timestamp': timestamp.toIso8601String(),
      };

  factory BradenScore.fromJson(Map<String, dynamic> json) => BradenScore(
        patientId: json['patientId'] ?? '',
        sensoryPerception: json['sensoryPerception'],
        moisture: json['moisture'],
        activity: json['activity'],
        mobility: json['mobility'],
        nutrition: json['nutrition'],
        frictionShear: json['frictionShear'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
