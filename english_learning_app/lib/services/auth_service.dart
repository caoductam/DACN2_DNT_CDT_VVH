import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ⚠️ CẤU HÌNH IP BACKEND (Máy ảo dùng 10.0.2.2, Máy thật dùng 192.168.1.X)
  static const String _backendUrl = 'http://10.0.2.2:5000/api/auth/sync'; 

  // --- 1. ĐĂNG KÝ EMAIL/PASS ---
  Future<bool> signUpWithEmail(String email, String password, String fullName, BuildContext context) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      await credential.user?.updateDisplayName(fullName);
      await _syncToBackend(credential.user);
      await _auth.signOut();
      
      return true; 
    } on FirebaseAuthException catch (e) {
      _showError(context, _handleFirebaseError(e));
      return false;
    } catch (e) {
      _showError(context, "Lỗi đăng ký: $e");
      return false;
    }
  }

  // --- 2. ĐĂNG NHẬP EMAIL/PASS ---
  Future<User?> loginWithEmail(String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      await _syncToBackend(credential.user);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      _showError(context, _handleFirebaseError(e));
      return null;
    } catch (e) {
      _showError(context, "Lỗi đăng nhập: $e");
      return null;
    }
  }

  // --- 3. ĐĂNG NHẬP GOOGLE ---
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      await _syncToBackend(userCredential.user);
      return userCredential.user;
    } catch (e) {
      _showError(context, "Lỗi Google: $e");
      return null;
    }
  }

  // --- 4. ĐĂNG NHẬP FACEBOOK (ĐÃ SỬA .tokenString) ---
  Future<User?> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        
        // --- SỬA Ở ĐÂY: Dùng .tokenString thay vì .token ---
        final AuthCredential credential = FacebookAuthProvider.credential(accessToken.tokenString);
        
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        await _syncToBackend(userCredential.user);
        return userCredential.user;
      }
      return null;
    } catch (e) {
      _showError(context, "Lỗi Facebook: $e");
      return null;
    }
  }

  // --- HÀM ĐỒNG BỘ BACKEND ---
  Future<void> _syncToBackend(User? user) async {
    if (user == null) return;
    try {
      final String? idToken = await user.getIdToken(true);
      
      print("⏳ Syncing to Backend...");
      final response = await http.post(
        Uri.parse(_backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Backend Synced Success!");
      } else {
        print("⚠️ Backend Error: ${response.body}");
      }
    } catch (e) {
      print("⚠️ Connection Error (Skip Backend): $e");
    }
  }

  // --- HELPER ---
  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  String _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use': return "Email này đã được sử dụng.";
      case 'user-not-found': return "Tài khoản không tồn tại.";
      case 'wrong-password': return "Mật khẩu không đúng.";
      case 'invalid-email': return "Email không hợp lệ.";
      default: return "Lỗi: ${e.message}";
    }
  }

  Future<void> signOut() async {
    try { await _googleSignIn.signOut(); } catch (_) {}
    await _auth.signOut();
  }
}