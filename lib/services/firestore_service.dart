import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Doctor>> fetchDoctors() async {
    final snapshot = await _firestore.collection('doctors').get();
    return snapshot.docs
        .map((doc) => Doctor.fromJson(doc.data(), doc.id))
        .toList();
  }

  Future<void> addDoctor(Doctor doctor) async {
    await _firestore.collection('doctors').add(doctor.toJson());
  }
}
