// lib/models/mood.dart

import 'package:flutter/material.dart';

// Модель настроения
class Mood {
  final String name;
  final IconData icon;
  final Color color;

  Mood({required this.name, required this.icon, required this.color});
}

// 30 различных настроений
final List<Mood> moodsData = [
  // -------------------- Позитивные и Нейтральные --------------------
  Mood(name: 'Happy', icon: Icons.sentiment_very_satisfied, color: Colors.amber.shade700),
  Mood(name: 'Joyful', icon: Icons.celebration, color: Colors.yellow.shade700),
  Mood(name: 'Calm', icon: Icons.sentiment_neutral, color: Colors.lightBlue.shade600),
  Mood(name: 'Peaceful', icon: Icons.self_improvement, color: Colors.cyan.shade400),
  Mood(name: 'Energetic', icon: Icons.electric_bolt, color: Colors.lime.shade600),
  Mood(name: 'Excited', icon: Icons.flash_on, color: Colors.orange.shade700),
  Mood(name: 'Loving', icon: Icons.favorite, color: Colors.pink.shade500),
  Mood(name: 'Grateful', icon: Icons.handshake, color: Colors.purple.shade400),
  Mood(name: 'Proud', icon: Icons.emoji_events, color: Colors.amber.shade400),
  Mood(name: 'Content', icon: Icons.check_circle, color: Colors.lightGreen.shade600),
  Mood(name: 'Hopeful', icon: Icons.lightbulb_outline, color: Colors.green.shade400),
  Mood(name: 'Relaxed', icon: Icons.cloudy_snowing, color: Colors.teal.shade300),
  Mood(name: 'Playful', icon: Icons.games, color: Colors.deepOrangeAccent.shade100),
  Mood(name: 'Curious', icon: Icons.search, color: Colors.blue.shade400),
  Mood(name: 'Amused', icon: Icons.sentiment_very_satisfied_outlined, color: Colors.greenAccent),

  // -------------------- Сложные и Негативные --------------------
  Mood(name: 'Tired', icon: Icons.bedtime, color: Colors.indigo.shade400),
  Mood(name: 'Stressed', icon: Icons.warning, color: Colors.deepOrange.shade600),
  Mood(name: 'Anxious', icon: Icons.lock_clock, color: Colors.teal.shade600),
  Mood(name: 'Sad', icon: Icons.sentiment_dissatisfied, color: Colors.blueGrey.shade700),
  Mood(name: 'Angry', icon: Icons.local_fire_department, color: Colors.red.shade700),
  Mood(name: 'Bored', icon: Icons.watch_later, color: Colors.brown.shade400),
  Mood(name: 'Confused', icon: Icons.help_outline, color: Colors.grey.shade600),
  Mood(name: 'Lonely', icon: Icons.person_off, color: Colors.blueGrey.shade900),
  Mood(name: 'Overwhelmed', icon: Icons.filter_tilt_shift, color: Colors.purpleAccent),
  Mood(name: 'Disappointed', icon: Icons.sentiment_very_dissatisfied, color: Colors.deepOrange.shade300),
  Mood(name: 'Frustrated', icon: Icons.cancel, color: Colors.red.shade400),
  Mood(name: 'Vulnerable', icon: Icons.healing_outlined, color: Colors.pink.shade200),
  Mood(name: 'Awe', icon: Icons.star_border, color: Colors.indigo.shade200),
  Mood(name: 'Jealous', icon: Icons.remove_red_eye, color: Colors.green.shade800),
];