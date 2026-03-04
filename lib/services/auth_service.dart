import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ===============================
  /// 🔐 TOKEN (UID) STORAGE
  /// ===============================

  Future<void> saveToken(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
  }

  Future<String?> currentUser() async {
    return await getToken();
  }

  /// ===============================
  /// 🟣 REGISTER
  /// ===============================

  Future<void> register(String name, String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user;

      if (user == null) {
        throw Exception('user-null');
      }

      // Сохраняем UID
      await saveToken(user.uid);

      // Сохраняем данные в Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'name': name.trim(),
        'email': email.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

    } on FirebaseAuthException catch (e) {
      print("🔥 FIREBASE REGISTER ERROR CODE: ${e.code}");
      print("🔥 FIREBASE REGISTER MESSAGE: ${e.message}");
      throw Exception(e.code);
    } catch (e) {
      print("🔥 UNKNOWN REGISTER ERROR: $e");
      throw Exception('unknown-error');
    }
  }

  /// ===============================
  /// 🔵 LOGIN
  /// ===============================

  Future<void> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user;

      if (user == null) {
        throw Exception('user-null');
      }

      await saveToken(user.uid);

    } on FirebaseAuthException catch (e) {
      print("🔥 FIREBASE LOGIN ERROR CODE: ${e.code}");
      print("🔥 FIREBASE LOGIN MESSAGE: ${e.message}");
      throw Exception(e.code);
    } catch (e) {
      print("🔥 UNKNOWN LOGIN ERROR: $e");
      throw Exception('unknown-error');
    }
  }

  /// ===============================
  /// 🚪 LOGOUT
  /// ===============================

  Future<void> signOut() async {
    await _auth.signOut();
    await deleteToken();
  }
}