import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cycle_entry.dart';

class CalendarService {
  final _firestore = FirebaseFirestore.instance;

  Future<Map<DateTime, List<CycleEntry>>> fetchEntries() async {
    final snapshot = await _firestore.collection('cycle_entries').get();
    final Map<DateTime, List<CycleEntry>> entries = {};

    for (var doc in snapshot.docs) {
      final entry = CycleEntry.fromJson(doc.data());
      final day = DateTime.utc(entry.date.year, entry.date.month, entry.date.day);
      entries.putIfAbsent(day, () => []).add(entry);
    }
    return entries;
  }

  Future<void> addEntry(DateTime date) async {
    final entry = CycleEntry(
      date: date,
      cycleDay: date.day,
      mood: "хорошее",
      symptoms: "нет",
    );
    await _firestore.collection('cycle_entries').add(entry.toJson());
  }
}
