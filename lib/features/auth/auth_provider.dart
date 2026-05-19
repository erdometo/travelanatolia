import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<User?> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // NOTE: On some devices, you may need to provide the webClientId from your Firebase Console 
  // (under Project Settings > General > Your Apps > Web App > google-services.json equivalent)
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthNotifier() : super(null) {
    _auth.authStateChanges().listen((user) {
      print('Auth State Changed: ${user?.uid}');
      state = user;
    });
  }

  Future<void> signInAnonymously() async {
    try {
      print('Attempting Anonymous Sign In...');
      await _auth.signInAnonymously();
    } catch (e) {
      print('Anonymous Auth Error: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      print('Starting Google Sign In Flow...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('Google Sign In Cancelled by User.');
        return;
      }

      print('Google User Found: ${googleUser.email}. Fetching Authentication...');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      print('Authentication Fetched. Creating Firebase Credential...');
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('Signing into Firebase with Credential...');
      final userCredential = await _auth.signInWithCredential(credential);
      print('Firebase Sign In Successful: ${userCredential.user?.uid}');
      
    } catch (e) {
      print('🚨 Google Auth Error: $e');
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      print('Attempting Email Sign In for $email...');
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('Email Auth Error: $e');
      if (e is FirebaseAuthException && (e.code == 'user-not-found' || e.code == 'invalid-credential' || e.code == 'wrong-password')) {
        print('User not found or invalid. Attempting Auto-Signup...');
        await signUpWithEmail(email, password);
      }
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      print('Creating account for $email...');
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('Email Signup Error: $e');
    }
  }

  Future<void> signOut() async {
    print('Signing Out...');
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
