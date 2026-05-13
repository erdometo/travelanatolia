import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelanatolia/router.dart';
import 'package:travelanatolia/ui/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('192.168.1.6', 8080);
      await FirebaseAuth.instance.useAuthEmulator('192.168.1.6', 9099);
      FirebaseFunctions.instanceFor(region: 'europe-west3').useFunctionsEmulator('192.168.1.6', 5001);
      print('Connected to Firebase Emulators at 192.168.1.6');
    } catch (e) {
      print('Error connecting to emulators: $e');
    }
  }

  runApp(
    // ProviderScope required for Riverpod
    const ProviderScope(
      child: TravelAnatoliaApp(),
    ),
  );
}

class TravelAnatoliaApp extends ConsumerWidget {
  const TravelAnatoliaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'TravelAnatolia',
      theme: travelAnatoliaTheme,
      routerConfig: router,
    );
  }
}
