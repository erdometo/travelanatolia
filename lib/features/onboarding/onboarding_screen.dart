import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:travelanatolia/ui/theme.dart';
import 'package:travelanatolia/ui/widgets/glass_panel.dart';
import 'package:travelanatolia/ui/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentStep = 0;
  final Map<String, String> _answers = {};

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What kind of traveler are you?',
      'options': ['The History Buff', 'The Nature Lover', 'The Foodie', 'The Adventurer'],
      'key': 'traveler_type',
    },
    {
      'question': 'What is your preferred pace?',
      'options': ['Fast-paced exploration', 'Relaxed and slow', 'A mix of both'],
      'key': 'pace',
    },
    {
      'question': 'Which landscape calls to you?',
      'options': ['Coastal vistas', 'Mountain peaks', 'Urban jungles', 'Desert sands'],
      'key': 'landscape',
    },
  ];

  Future<void> _nextStep(String selectedOption) async {
    final questionKey = _questions[_currentStep]['key'] as String;
    _answers[questionKey] = selectedOption;

    if (_currentStep < _questions.length - 1) {
      setState(() => _currentStep++);
    } else {
      // Save to Firestore
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('onboarding')
              .doc('latest')
              .set({
            ..._answers,
            'completedAt': FieldValue.serverTimestamp(),
          });
        } catch (e) {
          print('Error saving onboarding data: $e');
        }
      }
      if (mounted) {
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentStep];

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFEF8F3), Color(0xFFF3EDE8)],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_currentStep + 1) / _questions.length,
                      backgroundColor: AppColors.surfaceVariant,
                      color: AppColors.primary,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'PERSONALIZING\nYOUR JOURNEY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: AppColors.primary.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    question['question'],
                    style: GoogleFonts.notoSerif(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Expanded(
                    child: ListView.separated(
                      itemCount: question['options'].length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final option = question['options'][index];
                        return GestureDetector(
                          onTap: () => _nextStep(option),
                          child: GlassPanel(
                            padding: const EdgeInsets.all(24),
                            borderRadius: 16,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    option,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.chevron_right, color: AppColors.primary),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () => context.go('/'),
                      child: Text(
                        'SKIP FOR NOW',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurfaceVariant.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
