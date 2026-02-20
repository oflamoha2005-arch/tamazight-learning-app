import 'dart:math' as math;
import 'package:flutter/material.dart';
// تأكد أنك صاوبتي هاد الملف وحطيتي فيه كود المستويات اللي عطاك Claude
import 'levels_page.dart'; 

void main() {
  runApp(const TamazightApp());
}

class TamazightApp extends StatelessWidget {
  const TamazightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tamazight Learning',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const LandingPage(),
    );
  }
}

// ─── Landing Page ─────────────────────────────────────────────────────────────
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _pulseController;
  late final AnimationController _floatController;
  late final AnimationController _particleController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _pulse;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _logoController,
          curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _float = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _textController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  static const Color _blue = Color(0xFF0062CC);
  static const Color _green = Color(0xFF009900);
  static const Color _yellow = Color(0xFFFFD700);
  static const Color _red = Color(0xFFD32F2F);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.45, 0.72, 1.0],
                colors: [
                  _blue,
                  Color(0xFF005BBB),
                  _green,
                  _yellow,
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, _) {
              return CustomPaint(
                size: size,
                painter: _ParticlePainter(_particleController.value),
              );
            },
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      FadeTransition(
                        opacity: _textFade,
                        child: SlideTransition(
                          position: _textSlide,
                          child: _GlassBadge(
                            child: Text(
                              'TAMAZIGHT',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 4,
                                color: Colors.white.withOpacity(0.95),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      AnimatedBuilder(
                        animation: _float,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _float.value),
                            child: child,
                          );
                        },
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: FadeTransition(
                            opacity: _logoFade,
                            child: _YazSymbol(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      FadeTransition(
                        opacity: _textFade,
                        child: SlideTransition(
                          position: _textSlide,
                          child: _TifinaghBubble(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeTransition(
                        opacity: _textFade,
                        child: Text(
                          'Discover the Amazigh Language & Heritage',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.82),
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 52),
                      AnimatedBuilder(
                        animation: _pulse,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulse.value,
                            child: child,
                          );
                        },
                        child: _PlayButton(color: _red),
                      ),
                      const SizedBox(height: 32),
                      FadeTransition(
                        opacity: _textFade,
                        child: Text(
                          'Tap to begin your journey',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.6),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      FadeTransition(
                        opacity: _textFade,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 10,
                          children: const [
                            _FeatureChip(icon: Icons.record_voice_over, label: 'Pronunciation'),
                            _FeatureChip(icon: Icons.auto_stories, label: 'Scripts'),
                            _FeatureChip(icon: Icons.history_edu, label: 'Culture'),
                            _FeatureChip(icon: Icons.emoji_events, label: 'Progress'),
                          ],
                        ),
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

// ─── ⵣ Central Symbol ──────────────────────────────────────────────────────
class _YazSymbol extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0x55FFFFFF), Color(0x11FFFFFF)],
          stops: [0.3, 1.0],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 40,
            spreadRadius: 4,
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(color: Colors.white.withOpacity(0.08)),
            const Text(
              'ⵣ',
              style: TextStyle(
                fontSize: 88,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tifinagh Text Bubble ──────────────────────────────────────────────────
class _TifinaghBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.13),
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
      ),
      child: Column(
        children: [
          const Text(
            'ⵜⴰⵎⴰⵣⵉⵖⵜ',
            style: TextStyle(
              fontSize: 34,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tamazight',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.65),
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassBadge extends StatelessWidget {
  final Widget child;
  const _GlassBadge({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: child,
    );
  }
}

// ─── Play Button (Updated to Navigate) ──────────────────────────────────────
class _PlayButton extends StatelessWidget {
  final Color color;
  const _PlayButton({required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // هاد السطر هو اللي كيديك لصفحة المستويات
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LevelsPage()),
        );
      },
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.6),
              blurRadius: 30,
              spreadRadius: 4,
            ),
          ],
        ),
        child: const Icon(
          Icons.play_arrow_rounded,
          color: Colors.white,
          size: 46,
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.85), size: 15),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double progress;
  _ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 18; i++) {
      final baseX = rng.nextDouble() * size.width;
      final baseY = rng.nextDouble() * size.height;
      final radius = 1.5 + rng.nextDouble() * 3;
      final speed = 0.3 + rng.nextDouble() * 0.7;
      final phase = rng.nextDouble() * math.pi * 2;

      final x = baseX + math.sin(progress * math.pi * 2 * speed + phase) * 18;
      final y = baseY + math.cos(progress * math.pi * 2 * speed * 0.7 + phase) * 12;

      paint.color = Colors.white.withOpacity(0.06 + rng.nextDouble() * 0.08);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}
