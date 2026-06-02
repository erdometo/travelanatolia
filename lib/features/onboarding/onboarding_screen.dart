import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:travelanatolia/ui/theme.dart';
import 'package:travelanatolia/ui/widgets/glass_panel.dart';
import 'package:travelanatolia/config.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentStep = 0;
  bool _isLoading = false;
  final Map<String, String> _answers = {};

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is your favorite travel style?',
      'options': [
        {'label': 'Adventure', 'desc': 'Active exploration & thrills', 'icon': LucideIcons.mountain},
        {'label': 'History', 'desc': 'Ancient ruins & museums', 'icon': LucideIcons.scrollText},
        {'label': 'Culinary', 'desc': 'Local tastings & food heritage', 'icon': LucideIcons.utensils},
        {'label': 'Relaxation', 'desc': 'Slow-paced & comfort', 'icon': LucideIcons.coffee},
      ],
      'key': 'travelStyle',
    },
    {
      'question': 'What is your typical daily budget?',
      'options': [
        {'label': 'Budget', 'desc': 'Affordable local experiences', 'icon': LucideIcons.wallet},
        {'label': 'Moderate', 'desc': 'Balanced comfort & tours', 'icon': LucideIcons.banknote},
        {'label': 'Luxury', 'desc': 'Premium dining & private guides', 'icon': LucideIcons.gem},
      ],
      'key': 'budget',
    },
    {
      'question': 'Who is your typical travel companion?',
      'options': [
        {'label': 'Solo', 'desc': 'Independent exploration', 'icon': LucideIcons.user},
        {'label': 'Partner', 'desc': 'Couples or duos', 'icon': LucideIcons.users},
        {'label': 'Family', 'desc': 'Multi-generational trips', 'icon': LucideIcons.users},
        {'label': 'Friends', 'desc': 'Adventures with buddies', 'icon': LucideIcons.users},
      ],
      'key': 'companion',
    },
    {
      'question': 'Which activities speak to your soul?',
      'options': [
        {'label': 'hiking, ballooning, nature, adventure', 'desc': 'Balloon rides & valley trekking', 'icon': LucideIcons.compass},
        {'label': 'museums, history, ancient ruins, caves', 'desc': 'Underground cities & historical sites', 'icon': LucideIcons.castle},
        {'label': 'fine dining, food tours, local cooking', 'desc': 'Traditional food tastings & culinary walks', 'icon': LucideIcons.chefHat},
        {'label': 'slow travel, hamam, thermal baths, photography', 'desc': 'Turkish baths, slow walks & scenic photos', 'icon': LucideIcons.camera},
      ],
      'key': 'activities',
    },
  ];

  Future<void> _nextStep(String selectedOption) async {
    final questionKey = _questions[_currentStep]['key'] as String;
    _answers[questionKey] = selectedOption;

    if (_currentStep < _questions.length - 1) {
      setState(() => _currentStep++);
    } else {
      setState(() => _isLoading = true);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          // 1. Analyze profile with Agentic-Core
          final idToken = await user.getIdToken();
          final baseUrl = kDebugMode ? AppConfig.backendBaseUrl : 'https://your-production-url';
          final url = Uri.parse('$baseUrl/analyzeProfileFlow');
          
          final response = await http.post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $idToken',
            },
            body: jsonEncode({
              'data': {
                'userId': user.uid,
                'fullName': user.displayName ?? 'Anatolian Traveler',
                'travelStyle': _answers['travelStyle'],
                'budget': _answers['budget'],
                'companion': _answers['companion'],
                'activities': _answers['activities'],
              },
            }),
          );

          Map<String, dynamic>? structuredProfile;
          if (response.statusCode == 200) {
            debugPrint('Successfully analyzed profile with Agentic-Core');
            try {
              final responseData = jsonDecode(response.body);
              structuredProfile = responseData['result'] as Map<String, dynamic>?;
            } catch (e) {
              debugPrint('Error parsing analyzeProfileFlow response: $e');
            }
          } else {
            debugPrint('Error from analyzeProfileFlow: ${response.statusCode} - ${response.body}');
          }

          // Fallback structured profile if Agentic-Core was unreachable or failed
          if (structuredProfile == null) {
            debugPrint('Using local fallback structured profile');
            structuredProfile = {
              'userId': user.uid,
              'fullName': user.displayName ?? 'Anatolian Traveler',
              'travelStyle': _answers['travelStyle'] ?? 'Adventure',
              'budgetRange': _answers['budget'] ?? 'Luxury',
              'companion': _answers['companion'] ?? 'Solo',
              'interests': (_answers['activities'] ?? '')
                  .split(',')
                  .map((e) => e.trim().toLowerCase())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              'personaDescription': '${user.displayName ?? 'Traveler'} is a enthusiast of ${_answers['travelStyle']?.toLowerCase() ?? 'adventure'} travel. They love ${_answers['activities'] ?? 'exploring Anatolia'} and prefer ${_answers['budget']?.toLowerCase() ?? 'moderate'} budget options.',
              'createdAt': DateTime.now().toIso8601String(),
            };
          }

          // 2. Persist locally to Firebase for the auth-guard redirect sync
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('onboarding')
              .doc('latest')
              .set({
            ..._answers,
            'completedAt': FieldValue.serverTimestamp(),
          });
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'identityProfileUpdated': true,
            'latestOnboardingData': _answers,
            'profile': structuredProfile,
            'lastUpdatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        } catch (e) {
          debugPrint('Error saving onboarding data: $e');
        } finally {
          setState(() => _isLoading = false);
        }
      }
      if (mounted) context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final question = _questions[_currentStep];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: AppColors.primary),
                      SizedBox(height: 24),
                      Text(
                        'Architecting your profile...',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'STEP ${_currentStep + 1} / ${_questions.length}',
                          style: theme.textTheme.labelLarge,
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.x),
                          onPressed: () => context.go('/'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (_currentStep + 1) / _questions.length,
                      backgroundColor: AppColors.surfaceVariant,
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 48),

                    // Question
                    FadeInRight(
                      key: ValueKey(_currentStep),
                      duration: const Duration(milliseconds: 600),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CONCIERGE',
                            style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 2, color: AppColors.primary),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            question['question'],
                            style: theme.textTheme.headlineLarge,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Options
                    Expanded(
                      child: ListView.separated(
                        itemCount: question['options'].length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final option = question['options'][index];
                          return FadeInUp(
                            delay: Duration(milliseconds: 100 * index),
                            child: _OptionCard(
                              label: option['label'],
                              desc: option['desc'],
                              icon: option['icon'],
                              onTap: () => _nextStep(option['label']),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String label;
  final String desc;
  final IconData icon;
  final VoidCallback onTap;

  const _OptionCard({
    required this.label,
    required this.desc,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: GlassPanel(
        padding: const EdgeInsets.all(24),
        borderRadius: 24,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(desc, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: AppColors.outlineVariant),
          ],
        ),
      ),
    );
  }
}
