import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Цвета и стили
  final Color primaryPink = const Color(0xFFFF89AC);
  final Color darkTextColor = const Color(0xFF4A4A6A);
  final Color lightBackgroundColor = const Color(0xFFFDEEF2);

  // Контроллеры для полей ввода (для демо-данных)
  final TextEditingController _nameController = TextEditingController(text: 'Лесли Александр');
  final TextEditingController _emailController = TextEditingController(text: 'leslie.alexander@example.com');
  final TextEditingController _passwordController = TextEditingController(text: '********');

  // Флаг для загрузки
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Функция для имитации сохранения данных
  void _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    // Имитация задержки сохранения
    await Future.delayed(const Duration(seconds: 1));

    // Показываем сообщение об успехе
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Профиль успешно обновлен!'),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 1500),
      ),
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Редактировать Профиль',
          style: TextStyle(
            color: darkTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryPink),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            // --- Секция Аватара ---
            _buildAvatarSection(),
            const SizedBox(height: 40),

            // --- Поля ввода ---
            _buildTextField(
              controller: _nameController,
              label: 'Имя',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              isReadOnly: true, // Email часто нельзя изменить
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _passwordController,
              label: 'Пароль',
              icon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 50),

            // --- Кнопка Сохранить ---
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  // --- Вспомогательные виджеты ---

  Widget _buildAvatarSection() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: primaryPink.withOpacity(0.2),
          child: Icon(Icons.person, size: 70, color: primaryPink),
          // В реальном приложении здесь было бы Image.network или Image.file
        ),
        InkWell(
          onTap: () {
            // Здесь будет логика для выбора нового фото
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Выбрать новое фото...'), duration: Duration(milliseconds: 700)),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryPink,
              shape: BoxShape.circle,
              border: Border.all(color: lightBackgroundColor, width: 3),
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool isReadOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        readOnly: isReadOnly,
        style: TextStyle(color: darkTextColor, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(icon, color: primaryPink),
          suffixIcon: isReadOnly
              ? Icon(Icons.lock_outline, color: Colors.grey.shade400, size: 20)
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          shadowColor: primaryPink.withOpacity(0.4),
        ),
        child: _isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        )
            : const Text(
          'Сохранить изменения',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}