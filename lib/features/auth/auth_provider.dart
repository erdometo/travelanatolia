import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = NotifierProvider<AuthNotifier, User?>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<User?> {
  @override
  User? build() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      state = user;
    });
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> signInAnonymously() async {
    print('Attempting anonymous sign-in...');
    try {
      final credential = await FirebaseAuth.instance.signInAnonymously();
      print('Sign-in successful: ${credential.user?.uid}');
    } catch (e) {
      print('Sign-in error: $e');
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
