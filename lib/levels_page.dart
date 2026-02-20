import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  LEVELS PAGE — Standalone file
//
//  To navigate here from LandingPage / main.dart, use:
//
//    Navigator.push(
//      context,
//      PageRouteBuilder(
//        pageBuilder: (_, anim, __) => const LevelsPage(),
//        transitionsBuilder: (_, anim, __, child) => FadeTransition(
//          opacity: anim,
//          child: SlideTransition(
//            position: Tween<Offset>(
//              begin: const Offset(0, 0.08), end: Offset.zero,
//            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
//            child: child,
//          ),
//        ),
//        transitionDuration: const Duration(milliseconds: 500),
//      ),
//    );
// ═══════════════════════════════════════════════════════════════════════════════

// ── Colour palette for this page ──────────────────────────────────────────────
class _LvlColors {
  // Background blues
  static const bgTop    = Color(0xFF002B6B); // deep navy
  static const bgBottom = Color(0xFF003D99); // rich royal blue
  // Accent
  static const yellow   = Color(0xFFFFD700);
  static const green    = Color(0xFF00C44F); // slightly brighter for dots on dark bg
  // Card accent colours (per level)
  static const lvl1     = Color(0xFF29B6F6); // sky
  static const lvl2     = Color(0xFF66BB6A); // sage green
  static const lvl3     = Color(0xFFFFCA28); // amber
}

// ═══════════════════════════════════════════════════════════════════════════════
//  PAGE WIDGET
// ═══════════════════════════════════════════════════════════════════════════════
class LevelsPage extends StatefulWidget {
  const LevelsPage({super.key});
  @override
  State<LevelsPage> createState() => _LevelsPageState();
}

class _LevelsPageState extends State<LevelsPage> with TickerProviderStateMixin {
  // ── Per-card staggered controllers ────────────────────────────────────────
  late final List<AnimationController> _cardCtrl;
  late final List<Animation<double>>   _cardFade;
  late final List<Animation<Offset>>   _cardSlide;

  // ── Background dot animation ──────────────────────────────────────────────
  late final AnimationController _dotCtrl;

  // ── Giant watermark ⵣ float ───────────────────────────────────────────────
  late final AnimationController _yazCtrl;
  late final Animation<double>   _yazFloat;

  @override
  void initState() {
    super.initState();

    // Slow drift for green dot pattern
    _dotCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 18))
      ..repeat();

    // Watermark float
    _yazCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3200))
      ..repeat(reverse: true);
    _yazFloat = Tween<double>(begin: -16.0, end: 16.0).animate(
        CurvedAnimation(parent: _yazCtrl, curve: Curves.easeInOut));

    // Card controllers
    _cardCtrl = List.generate(
        3,
        (_) => AnimationController(
            vsync: this, duration: const Duration(milliseconds: 650)));

    _cardFade = _cardCtrl
        .map((c) => Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();

    _cardSlide = _cardCtrl
        .map((c) => Tween<Offset>(
                begin: const Offset(0, 0.55), end: Offset.zero)
            .animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();

    // Stagger: 200 · 390 · 580 ms
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: 200 + i * 190), () {
        if (mounted) _cardCtrl[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _cardCtrl) c.dispose();
    _dotCtrl.dispose();
    _yazCtrl.dispose();
    super.dispose();
  }

  // ── Level definitions (all unlocked, Level 3 grammar removed) ─────────────
  static const _levels = [
    _LevelData(
      number: 1,
      tifinagh: 'ⵜⵉⴼⵉⵏⴰⵖ',
      latin: 'Basics & Alphabet',
      subtitle: 'Master the Tifinagh script from scratch',
      icon: Icons.auto_stories,
      accentColor: _LvlColors.lvl1,
      stars: 3,
    ),
    _LevelData(
      number: 2,
      tifinagh: 'ⵉⵎⴰⵡⴰⵍⵏ',
      latin: 'Vocabulary & Colors',
      subtitle: 'Build your first 200 essential words',
      icon: Icons.color_lens,
      accentColor: _LvlColors.lvl2,
      stars: 1,
    ),
    _LevelData(
      number: 3,
      tifinagh: 'ⵜⴰⵎⵙⵉⵔⵜ',
      latin: 'Conversation & Speaking',   // ← grammar removed
      subtitle: 'Speak Tamazight with confidence',
      icon: Icons.forum,
      accentColor: _LvlColors.lvl3,
      stars: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── 1. Deep blue gradient background ────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.6, 1.0],
                colors: [
                  _LvlColors.bgTop,
                  Color(0xFF003080),
                  _LvlColors.bgBottom,
                ],
              ),
            ),
          ),

          // ── 2. Green dot decorative pattern ─────────────────────────────
          AnimatedBuilder(
            animation: _dotCtrl,
            builder: (_, __) => CustomPaint(
              size: size,
              painter: _GreenDotPainter(_dotCtrl.value),
            ),
          ),

          // ── 3. Giant watermark ⵣ ─────────────────────────────────────────
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _yazFloat,
              builder: (_, __) => Transform.translate(
                offset: Offset(size.width * 0.18, _yazFloat.value),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'ⵣ',
                    style: TextStyle(
                      fontSize: size.width * 0.68,
                      color: Colors.white.withOpacity(0.035),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── 4. Page content ──────────────────────────────────────────────
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 24, 0),
                  child: Row(
                    children: [
                      _GlassIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Choose Your Level',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.35),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                          ),
                          Text(
                            'ⵙⵉⵏ ⵜⴰⵙⴽⵉⵏⵜ  ·  Select a path',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.55),
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Progress badge
                      _ProgressBadge(done: _levels.where((l) => l.stars > 0).length),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Level cards
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
                    itemCount: _levels.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (ctx, i) => FadeTransition(
                      opacity: _cardFade[i],
                      child: SlideTransition(
                        position: _cardSlide[i],
                        child: LevelCard(data: _levels[i]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  DATA MODEL
// ═══════════════════════════════════════════════════════════════════════════════
class _LevelData {
  final int number;
  final String tifinagh;
  final String latin;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final int stars;

  const _LevelData({
    required this.number,
    required this.tifinagh,
    required this.latin,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.stars,
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
//  LEVEL CARD  (StatefulWidget for tap-scale)
// ═══════════════════════════════════════════════════════════════════════════════
class LevelCard extends StatefulWidget {
  final _LevelData data;
  const LevelCard({super.key, required this.data});
  @override
  State<LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<LevelCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tapCtrl;
  late final Animation<double> _tapScale;

  @override
  void initState() {
    super.initState();
    _tapCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 130));
    _tapScale = Tween<double>(begin: 1.0, end: 1.035).animate(
        CurvedAnimation(parent: _tapCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _tapCtrl.dispose();
    super.dispose();
  }

  void _down(_)    => _tapCtrl.forward();
  void _up(_)      => _tapCtrl.reverse();
  void _cancel()   => _tapCtrl.reverse();

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return GestureDetector(
      onTapDown:   _down,
      onTapUp:     _up,
      onTapCancel: _cancel,
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('▶  Starting: ${d.latin}'),
          backgroundColor: d.accentColor.withOpacity(0.92),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      child: ScaleTransition(
        scale: _tapScale,
        child: _CardBody(data: d),
      ),
    );
  }
}

// ─── Card Body ────────────────────────────────────────────────────────────────
class _CardBody extends StatelessWidget {
  final _LevelData data;
  const _CardBody({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final d = data;
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            // Slightly brighter glass on deep blue = cleaner look
            color: Colors.white.withOpacity(0.10),
            border: Border.all(
              color: d.accentColor.withOpacity(0.38),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: d.accentColor.withOpacity(0.15),
                blurRadius: 28,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // ── Yellow level badge ──────────────────────────────────────
              _LevelBadge(data: d),
              const SizedBox(width: 18),

              // ── Text content ────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tifinagh (white, clean)
                    Text(
                      d.tifinagh,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    // Latin title
                    Text(
                      d.latin,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.92),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Subtitle
                    Text(
                      d.subtitle,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.white.withOpacity(0.52),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Stars
                    _StarRow(earned: d.stars, color: _LvlColors.yellow),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // ── Chevron ─────────────────────────────────────────────────
              Icon(
                Icons.chevron_right_rounded,
                color: d.accentColor.withOpacity(0.75),
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Yellow Level Badge ───────────────────────────────────────────────────────
class _LevelBadge extends StatelessWidget {
  final _LevelData data;
  const _LevelBadge({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final d = data;
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Yellow fill — pops against deep blue
        gradient: const RadialGradient(
          colors: [Color(0xFFFFE657), _LvlColors.yellow],
          stops: [0.3, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: _LvlColors.yellow.withOpacity(0.45),
            blurRadius: 20,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(d.icon, color: const Color(0xFF002B6B), size: 24),
          const SizedBox(height: 2),
          Text(
            'LV ${d.number}',
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
              color: Color(0xFF002B6B), // dark navy on yellow = readable
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Star Row ────────────────────────────────────────────────────────────────
class _StarRow extends StatelessWidget {
  final int earned;
  final Color color;
  const _StarRow({required this.earned, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        3,
        (i) => Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Icon(
            i < earned ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 17,
            color: i < earned ? color : Colors.white.withOpacity(0.22),
          ),
        ),
      ),
    );
  }
}

// ─── Progress Badge (top right) ──────────────────────────────────────────────
class _ProgressBadge extends StatelessWidget {
  final int done;
  const _ProgressBadge({required this.done});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: _LvlColors.yellow.withOpacity(0.15),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: _LvlColors.yellow.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events_rounded,
              color: _LvlColors.yellow, size: 14),
          const SizedBox(width: 5),
          Text(
            '$done / 3',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _LvlColors.yellow,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Glass Back Button ───────────────────────────────────────────────────────
class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  GREEN DOT PATTERN PAINTER
//  Renders small semi-transparent green circles scattered across the background.
//  They breathe/drift very slowly with the animation value.
// ═══════════════════════════════════════════════════════════════════════════════
class _GreenDotPainter extends CustomPainter {
  final double progress;
  const _GreenDotPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rng   = math.Random(7); // fixed seed → stable layout
    final paint = Paint()..style = PaintingStyle.fill;

    const dotCount = 48;

    for (int i = 0; i < dotCount; i++) {
      final baseX  = rng.nextDouble() * size.width;
      final baseY  = rng.nextDouble() * size.height;
      final radius = 1.2 + rng.nextDouble() * 2.8;
      final speed  = 0.15 + rng.nextDouble() * 0.35;
      final phase  = rng.nextDouble() * math.pi * 2;
      final alpha  = 0.06 + rng.nextDouble() * 0.11; // very subtle

      // Very gentle drift
      final x = baseX + math.sin(progress * math.pi * 2 * speed + phase) * 8;
      final y = baseY + math.cos(progress * math.pi * 2 * speed * 0.6 + phase) * 6;

      paint.color = _LvlColors.green.withOpacity(alpha);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // A second pass with larger, more transparent accent dots
    final rng2 = math.Random(99);
    for (int i = 0; i < 12; i++) {
      final baseX = rng2.nextDouble() * size.width;
      final baseY = rng2.nextDouble() * size.height;
      final radius = 4.0 + rng2.nextDouble() * 5.0;
      final speed  = 0.08 + rng2.nextDouble() * 0.15;
      final phase  = rng2.nextDouble() * math.pi * 2;

      final x = baseX + math.sin(progress * math.pi * 2 * speed + phase) * 12;
      final y = baseY + math.cos(progress * math.pi * 2 * speed * 0.5 + phase) * 8;

      paint.color = _LvlColors.green.withOpacity(0.04);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_GreenDotPainter old) => old.progress != progress;
}