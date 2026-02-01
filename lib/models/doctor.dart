// lib/models/doctor.dart

import 'package:flutter/material.dart';

class Doctor {
  final String name;
  final String specialty;
  final String university;
  final String hospital;
  final double rating;
  final int yearsOfExperience;
  final double consultationFee;
  final String description;
  final bool isOnline;
  final Color statusColor;
  final String gender; // Добавлено для фильтрации по полу (для "Женское Здоровье KZ")

  Doctor({
    required this.name,
    required this.specialty,
    required this.university,
    required this.hospital,
    required this.rating,
    required this.yearsOfExperience,
    required this.consultationFee,
    required this.description,
    this.isOnline = true,
    this.statusColor = const Color(0xFF4DD63B), // Ярко-зеленый
    required this.gender,
  });
}

// Пример данных врачей (для Казахстана: акцент на женщинах-специалистах)
final List<Doctor> dummyDoctors = [
  Doctor(
    name: "Dr. Асель Сатова",
    specialty: "Гинеколог-репродуктолог",
    university: "КазНМУ им. Асфендиярова",
    hospital: "Центр Женского Здоровья 'Аяла'",
    rating: 4.9,
    yearsOfExperience: 15,
    consultationFee: 7500.0, // Цена в тенге
    description: "Ведущий специалист по ЭКО и планированию семьи. Помогла сотням пар.",
    isOnline: true,
    gender: 'Female',
  ),
  Doctor(
    name: "Dr. Ляззат Куанышева",
    specialty: "Маммолог",
    university: "АГУ им. Кунаева",
    hospital: "Клиника 'Мейірім'",
    rating: 4.8,
    yearsOfExperience: 10,
    consultationFee: 6500.0,
    description: "Эксперт в области диагностики и лечения заболеваний молочных желез.",
    isOnline: true,
    gender: 'Female',
  ),
  Doctor(
    name: "Dr. Ronald Richards",
    specialty: "Терапевт",
    university: "Harvard University",
    hospital: "Central Hospital",
    rating: 4.7,
    yearsOfExperience: 7,
    consultationFee: 4000.0,
    description: "Профессиональный терапевт с 7-летним стажем. Доступен для общих консультаций.",
    isOnline: false, // Оффлайн
    statusColor: Colors.grey,
    gender: 'Male',
  ),
  Doctor(
    name: "Dr. Leslie Alexander", // Обновленный врач по скриншоту
    specialty: "Акушер-гинеколог",
    university: "Alabama University",
    hospital: "Gangnam Hospitality",
    rating: 4.99,
    yearsOfExperience: 6,
    consultationFee: 5000.0,
    description: "Я профессиональный доктор с 6-летним опытом. Я здесь, чтобы помочь решить ваши проблемы со здоровьем.",
    isOnline: true,
    gender: 'Female',
  ),
];

// Модель для товаров
class HealthProduct {
  final String name;
  final double price;
  final String imagePath;

  HealthProduct({
    required this.name,
    required this.price,
    required this.imagePath,
  });
}

// Пример данных товаров
final List<HealthProduct> dummyProducts = [
  HealthProduct(name: "Бутылка Мед.", price: 4500, imagePath: "assets/bottle.png"),
  HealthProduct(name: "Таблетки Капсулы", price: 8500, imagePath: "assets/capsule.png"),
  HealthProduct(name: "Тест-полоска", price: 2000, imagePath: "assets/test.png"),
];