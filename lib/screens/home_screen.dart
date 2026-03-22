import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import 'input_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    Future.delayed(const Duration(milliseconds: 100), () {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background grid pattern
          CustomPaint(
            size: Size.infinite,
            painter: _GridPainter(),
          ),

          // Radial glow top center
          Positioned(
            top: -100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 500,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accent.withOpacity(0.07),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 48),

                      // Top badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accentDim,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.accent.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'AI-POWERED · ATS OPTIMIZED',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 10,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Hero title
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Resume\n',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 52,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -2,
                                height: 1.0,
                              ),
                            ),
                            TextSpan(
                              text: 'Tailor',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 52,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -2,
                                height: 1.1,
                              ),
                            ),
                            TextSpan(
                              text: ' AI',
                              style: TextStyle(
                                color: AppColors.gold,
                                fontSize: 52,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -2,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Subtitle
                      const Text(
                        'Paste your resume & job description.\nGet an ATS-optimized version in seconds.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          height: 1.7,
                          letterSpacing: 0.1,
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Floating stat cards
                      AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          return Row(
                            children: [
                              _StatCard(
                                value: '98%',
                                label: 'ATS Pass Rate',
                                offset: math.sin(_floatController.value * math.pi * 2) * 4,
                                delay: 0,
                              ),
                              const SizedBox(width: 12),
                              _StatCard(
                                value: '2x',
                                label: 'Interview Chances',
                                offset: math.sin((_floatController.value + 0.33) * math.pi * 2) * 4,
                                delay: 1,
                              ),
                              const SizedBox(width: 12),
                              _StatCard(
                                value: '<30s',
                                label: 'Processing Time',
                                offset: math.sin((_floatController.value + 0.66) * math.pi * 2) * 4,
                                delay: 2,
                              ),
                            ],
                          );
                        },
                      ),

                      const Spacer(),

                      // Feature list
                      ...[
                        (Icons.auto_fix_high_rounded, 'Keyword optimization for ATS systems'),
                        (Icons.check_circle_outline_rounded, 'Job description matching'),
                        (Icons.download_rounded, 'Export to PDF'),
                      ].map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Icon(item.$1, size: 16, color: AppColors.accent),
                            const SizedBox(width: 12),
                            Text(
                              item.$2,
                              style: const TextStyle(
                                color: AppColors.textPrimary, // ✅ fixed: was textSecondary
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )),

                      const SizedBox(height: 32),

                      // CTA Button
                      _GradientButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, animation, __) => const InputScreen(),
                              transitionsBuilder: (_, animation, __, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.05),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 400),
                            ),
                          );
                        },
                        label: 'Start Optimizing',
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final double offset;
  final int delay;

  const _StatCard({
    required this.value,
    required this.label,
    required this.offset,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Transform.translate(
        offset: Offset(0, offset),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary, // ✅ fixed: was textMuted
                  fontSize: 10,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;

  const _GradientButton({required this.onPressed, required this.label});

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.accent, Color(0xFF0066FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded, color: Colors.black, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Subtle grid background painter
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.surfaceBorder.withOpacity(0.3)
      ..strokeWidth = 0.5;

    const spacing = 40.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}