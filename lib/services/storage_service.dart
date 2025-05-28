import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/patient.dart';
import '../models/braden_evaluation.dart';

class StorageService {
  static const String _patientsKey = 'patients_list';

  Future<List<Patient>> getPatients() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_patientsKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list.map((e) => Patient.fromJson(e)).toList();
  }

  Future<void> savePatients(List<Patient> patients) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(patients.map((e) => e.toJson()).toList());
    await prefs.setString(_patientsKey, data);
  }

  Future<Patient?> getPatientById(String id) async {
    final patients = await getPatients();
    try {
      return patients.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addPatient(Patient patient) async {
    final patients = await getPatients();
    patients.add(patient);
    await savePatients(patients);
  }

  Future<void> addEvaluation(String patientId, BradenEvaluation evaluation) async {
    final patients = await getPatients();
    final idx = patients.indexWhere((p) => p.id == patientId);
    if (idx == -1) return;
    final updated = Patient(
      id: patients[idx].id,
      evaluations: [...patients[idx].evaluations, evaluation],
    );
    patients[idx] = updated;
    await savePatients(patients);
  }
}
