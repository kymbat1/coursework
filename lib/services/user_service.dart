// lib/services/user_service.dart

class UserService {
  // ФИКЦИВНОЕ ИМЯ ПОЛЬЗОВАТЕЛЯ, полученное при "регистрации"
  String _userName = "Имя";
  String _userSurname = "Пользователя";

  // Метод для получения полного имени
  String get userName => "$_userName $_userSurname";

  // Метод для обновления имени (например, после успешной регистрации/входа)
  void setUserName(String name, String surname) {
    _userName = name;
    _userSurname = surname;
  }
}