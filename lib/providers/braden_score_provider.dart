import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/braden_score.dart';

class BradenScoreProvider extends ChangeNotifier {
  int? sensoryPerception;
  int? moisture;
  int? activity;
  int? mobility;
  int? nutrition;
  int? frictionShear;
  BradenScore? lastScore;

  void setDomain(String domain, int value) {
    switch (domain) {
      case 'sensoryPerception':
        sensoryPerception = value;
        break;
      case 'moisture':
        moisture = value;
        break;
      case 'activity':
        activity = value;
        break;
      case 'mobility':
        mobility = value;
        break;
      case 'nutrition':
        nutrition = value;
        break;
      case 'frictionShear':
        frictionShear = value;
        break;
    }
    notifyListeners();
  }

  bool get isComplete =>
      sensoryPerception != null &&
      moisture != null &&
      activity != null &&
      mobility != null &&
      nutrition != null &&
      frictionShear != null;

  int get totalScore =>
      (sensoryPerception ?? 0) +
      (moisture ?? 0) +
      (activity ?? 0) +
      (mobility ?? 0) +
      (nutrition ?? 0) +
      (frictionShear ?? 0);
      
  void reset() {
    sensoryPerception = null;
    moisture = null;
    activity = null;
    mobility = null;
    nutrition = null;
    frictionShear = null;
    lastScore = null;
    notifyListeners();
  }

  void saveScore(String patientId) {
    if (sensoryPerception == null ||
        moisture == null ||
        activity == null ||
        mobility == null ||
        nutrition == null ||
        frictionShear == null) {
      return;
    }
    lastScore = BradenScore(
      patientId: patientId,
      sensoryPerception: sensoryPerception!,
      moisture: moisture!,
      activity: activity!,
      mobility: mobility!,
      nutrition: nutrition!,
      frictionShear: frictionShear!,
      timestamp: DateTime.now(),
    );
    notifyListeners();
  }
}
