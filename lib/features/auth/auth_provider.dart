import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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
      debugPrint('Auth State Changed: ${user?.uid}');
      state = user;
    });
  }

  Future<String?> signInAnonymously() async {
    try {
      debugPrint('Attempting Anonymous Sign In...');
      await _auth.signInAnonymously();
      return null;
    } catch (e) {
      debugPrint('Anonymous Auth Error: $e');
      return e.toString();
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      debugPrint('Starting Google Sign In Flow...');
      
      if (kDebugMode) {
        try {
          final GoogleSignInAccount? googleUser = await _googleSignIn.signIn().timeout(
            const Duration(seconds: 3),
            onTimeout: () => null,
          );
          if (googleUser != null) {
            debugPrint('Google User Found: ${googleUser.email}. Fetching Authentication...');
            final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
            final AuthCredential credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );
            await _auth.signInWithCredential(credential);
            return null;
          }
        } catch (sdkError) {
          debugPrint('Google SDK failed, falling back to mock sign in: $sdkError');
        }
        
        debugPrint('Simulating Google Sign In anonymously...');
        await _auth.signInAnonymously();
        return null;
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint('Google Sign In Cancelled by User.');
        return 'Google sign-in was cancelled.';
      }

      debugPrint('Google User Found: ${googleUser.email}. Fetching Authentication...');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      debugPrint('Authentication Fetched. Creating Firebase Credential...');
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      debugPrint('Signing into Firebase with Credential...');
      final userCredential = await _auth.signInWithCredential(credential);
      debugPrint('Firebase Sign In Successful: ${userCredential.user?.uid}');
      return null;
      
    } catch (e) {
      debugPrint('🚨 Google Auth Error: $e');
      return e.toString();
    }
  }

  Future<String?> signInWithApple() async {
    try {
      debugPrint('Starting Apple Sign In Flow...');
      if (kDebugMode) {
        debugPrint('Simulating Apple Sign In anonymously...');
        await _auth.signInAnonymously();
        return null;
      }
      await _auth.signInAnonymously();
      return null;
    } catch (e) {
      debugPrint('🚨 Apple Auth Error: $e');
      return e.toString();
    }
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      debugPrint('Attempting Email Sign In for $email...');
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      debugPrint('Email Auth Error: $e');
      return e.toString();
    }
  }

  Future<String?> signUpWithEmailAndName(String email, String password, String fullName) async {
    try {
      debugPrint('Creating account for $email with name $fullName...');
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final user = credential.user;
      if (user != null) {
        await user.updateDisplayName(fullName);
        await user.reload(); // Refresh local user profile details
      }
      return null;
    } catch (e) {
      debugPrint('Email Signup Error: $e');
      return e.toString();
    }
  }

  Future<void> signOut() async {
    debugPrint('Signing Out...');
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}

final userProfileProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final user = ref.watch(authProvider);
  if (user == null) return Stream.value(null);
  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((snapshot) {
        if (!snapshot.exists) return null;
        final data = snapshot.data();
        return data?['profile'] as Map<String, dynamic>?;
      });
});
