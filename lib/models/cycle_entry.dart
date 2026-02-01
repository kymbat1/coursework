class CycleEntry {
  final DateTime date;
  final int cycleDay;
  final String? mood;
  final String? symptoms;

  CycleEntry({
    required this.date,
    required this.cycleDay,
    this.mood,
    this.symptoms,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'cycleDay': cycleDay,
    'mood': mood,
    'symptoms': symptoms,
  };

  factory CycleEntry.fromJson(Map<String, dynamic> json) {
    return CycleEntry(
      date: DateTime.parse(json['date']),
      cycleDay: json['cycleDay'],
      mood: json['mood'],
      symptoms: json['symptoms'],
    );
  }
}
