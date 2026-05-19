import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:travelanatolia/features/auth/auth_provider.dart';
import 'package:travelanatolia/ui/theme.dart';
import 'package:travelanatolia/ui/widgets/custom_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _showEmailFields = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Gradient Overlay
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1527838832700-5059252407fa?auto=format&fit=crop&q=80&w=1200',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      'TRAVEL\nANATOLIA',
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  const Spacer(),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!_showEmailFields) ...[
                          Text(
                            'Your Agentic Journey\nStarts Here.',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Discover the timeless beauty of Asia Minor through the eyes of AI.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 48),
                          StitchButton(
                            label: 'BEGIN YOUR JOURNEY',
                            onPressed: () {
                              ref.read(authProvider.notifier).signInAnonymously();
                            },
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: TextButton(
                              onPressed: () => setState(() => _showEmailFields = true),
                              child: Text(
                                'OR SIGN IN WITH EMAIL',
                                style: theme.textTheme.labelLarge?.copyWith(color: Colors.white70),
                              ),
                            ),
                          ),
                        ] else ...[
                          _buildEmailForm(theme),
                        ],
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _SocialIconButton(
                              icon: LucideIcons.mail, 
                              onTap: () => setState(() => _showEmailFields = !_showEmailFields),
                            ),
                            const SizedBox(width: 24),
                            _SocialIconButton(
                              icon: Icons.g_mobiledata, 
                              onTap: () => ref.read(authProvider.notifier).signInWithGoogle(),
                            ),
                            const SizedBox(width: 24),
                            _SocialIconButton(
                              icon: Icons.apple, 
                              onTap: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: Text(
                            'BY CONTINUING, YOU AGREE TO OUR TERMS',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.4),
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailForm(ThemeData theme) {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration('Email Address', LucideIcons.mail),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration('Password', LucideIcons.lock),
        ),
        const SizedBox(height: 24),
        StitchButton(
          label: 'SIGN IN',
          onPressed: () {
            ref.read(authProvider.notifier).signInWithEmail(
              _emailController.text,
              _passwordController.text,
            );
          },
        ),
        TextButton(
          onPressed: () => setState(() => _showEmailFields = false),
          child: const Text('Back', style: TextStyle(color: Colors.white60)),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.white70, size: 20),
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.1),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          color: Colors.white.withValues(alpha: 0.1),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
