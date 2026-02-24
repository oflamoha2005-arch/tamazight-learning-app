import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'lesson_hub_page.dart'; 

// ═══════════════════════════════════════════════════════════════════════════════
//  LEVEL 1 HUB PAGE  — with Unsplash background images per card
// ═══════════════════════════════════════════════════════════════════════════════

class _HubColors {
  static const bgTop       = Color(0xFF002B6B);
  static const bgMid       = Color(0xFF003080);
  static const bgBottom    = Color(0xFF003D99);
  static const yellow      = Color(0xFFFFD700);
  static const yellowLight = Color(0xFFFFE657);
  static const green       = Color(0xFF00C44F);
  static const navy        = Color(0xFF002B6B);
}

// ── Lesson model (+ imageUrl) ─────────────────────────────────────────────────
class _Lesson {
  final String   name;
  final IconData icon;
  final Color    accent;
  final String   imageUrl;

  const _Lesson({
    required this.name,
    required this.icon,
    required this.accent,
    required this.imageUrl,
  });
}

// ── 17 lessons with curated Unsplash images (w=600 for fast loading) ──────────
const List<_Lesson> _lessons = [
  _Lesson(
    name: 'Alphabet',
    icon: Icons.abc,
    accent: Color(0xFF29B6F6),
    imageUrl: 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=600&auto=format&fit=crop',
  ),
  _Lesson(
    name: 'Numbers',
    icon: Icons.looks_one,
    accent: Color(0xFFFFCA28),
    imageUrl: 'https://images.unsplash.com/photo-1509228468518-180dd4864904?w=600&auto=format&fit=crop',
  ),
  _Lesson(
    name: 'Colors',
    icon: Icons.palette,
    accent: Color(0xFFFF7043),
    imageUrl: 'https://images.unsplash.com/photo-1541701494587-cb58502866ab?w=600&auto=format&fit=crop',
  ),
  _Lesson(
    name: 'Food',
    icon: Icons.restaurant,
    accent: Color(0xFF66BB6A),
    imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600&auto=format&fit=crop',
  ),
  _Lesson(
    name: 'Vegetables',
    icon: Icons.grass,
    accent: Color(0xFF26A69A),
    imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=600&auto=format&fit=crop',
  ),
  _Lesson(
    name: 'Fruits',
    icon: Icons.apple,
    accent: Color(0xFFEF5350),
    imageUrl: 'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=600&auto=format&fit=crop',
  ),
  _Lesson(
    name: 'Drinks',
    icon: Icons.local_cafe,
    accent: Color(0xFFAB47BC),
    imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600&auto=format&fit=crop',
  ),
  _Lesson(
    name: 'Transport',
    icon: Icons.directions_car,
    accent: Color(0xFF42A5F5),
    imageUrl: 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=600&auto=format&fit=crop',
  ),
  _Lesson(
    name: 'Body',
    icon: Icons.accessibility,
    accent: Color(0xFFFF8A65),
    imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=600&auto=format&fit=crop',
  ),
  _Lesson(
    name: 'Animals',
    icon: Icons.pets,
    accent: Color(0xFF8D6E63),
    imageUrl: 'https://images.unsplash.com/photo-1474511320723-9a56873867b5?w=600&auto=format&fit=crop',
  ),
  _Lesson(
    name: 'Days & Weeks',
    icon: Icons.calendar_month,
    accent: Color(0xFF5C6BC0),
    imageUrl: 'https://images.unsplash.com/photo-1506784983877-45594efa4cbe?w=600&auto=format&fit=crop',
  ),
  _Lesson(
    name: 'Months & Seasons',
    icon: Icons.wb_sunny,
    accent: Color(0xFFFFB300),
    imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&auto=format&fit=crop',
  ),
  _Lesson(
    name: 'Clothing',
    icon: Icons.checkroom,
    accent: Color(0xFFEC407A),
    imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&auto=format&fit=crop',
  ),
  _Lesson(
    name: 'Weather',
    icon: Icons.cloud,
    accent: Color(0xFF78909C),
    imageUrl: 'https://images.unsplash.com/photo-1504608524841-42584120d693?w=600&auto=format&fit=crop',
  ),
  _Lesson(
    name: 'Home',
    icon: Icons.home,
    accent: Color(0xFF4DB6AC),
    imageUrl: 'https://images.unsplash.com/photo-1484101403633-562f891dc89a?w=600&auto=format&fit=crop',
  ),
  _Lesson(
    name: 'Technology',
    icon: Icons.computer,
    accent: Color(0xFF7E57C2),
    imageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=600&auto=format&fit=crop',
  ),
  _Lesson(
    name: 'Nature',
    icon: Icons.forest,
    accent: Color(0xFF43A047),
    imageUrl: 'https://images.unsplash.com/photo-1448375240586-882707db888b?w=600&auto=format&fit=crop',
  ),
];

// ═══════════════════════════════════════════════════════════════════════════════
//  PAGE
// ═══════════════════════════════════════════════════════════════════════════════
class LevelOneHubPage extends StatefulWidget {
  const LevelOneHubPage({super.key});
  @override
  State<LevelOneHubPage> createState() => _LevelOneHubPageState();
}

class _LevelOneHubPageState extends State<LevelOneHubPage>
    with TickerProviderStateMixin {

  late final List<AnimationController> _cardCtrl;
  late final List<Animation<double>>   _cardFade;
  late final List<Animation<Offset>>   _cardSlide;
  late final AnimationController       _dotCtrl;
  late final AnimationController       _headerCtrl;
  late final Animation<double>         _headerFade;
  late final Animation<Offset>         _headerSlide;

  static const int _count = 17;

  @override
  void initState() {
    super.initState();

    _dotCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 20))
      ..repeat();

    _headerCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut));
    _headerSlide = Tween<Offset>(
            begin: const Offset(0, -0.25), end: Offset.zero)
        .animate(CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut));
    _headerCtrl.forward();

    _cardCtrl = List.generate(
        _count,
        (_) => AnimationController(
            vsync: this, duration: const Duration(milliseconds: 520)));

    _cardFade = _cardCtrl
        .map((c) => Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();

    _cardSlide = _cardCtrl
        .map((c) => Tween<Offset>(
                begin: const Offset(0, 0.45), end: Offset.zero)
            .animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();

    for (int i = 0; i < _count; i++) {
      Future.delayed(Duration(milliseconds: 300 + i * 55), () {
        if (mounted) _cardCtrl[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _cardCtrl) c.dispose();
    _dotCtrl.dispose();
    _headerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── Background gradient ─────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.55, 1.0],
                colors: [_HubColors.bgTop, _HubColors.bgMid, _HubColors.bgBottom],
              ),
            ),
          ),

          // ── Animated green dots ─────────────────────────────────────────
          AnimatedBuilder(
            animation: _dotCtrl,
            builder: (_, __) => CustomPaint(
              size: size,
              painter: _GreenDotPainter(_dotCtrl.value),
            ),
          ),

          // ── Content ─────────────────────────────────────────────────────
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                FadeTransition(
                  opacity: _headerFade,
                  child: SlideTransition(
                    position: _headerSlide,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _GlassIconButton(
                            icon: Icons.arrow_back_ios_new_rounded,
                            onTap: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    _LevelPill(label: 'LEVEL 1'),
                                    const SizedBox(width: 10),
                                    Text(
                                      'ⵜⵉⴼⵉⵏⴰⵖ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 2.5,
                                        shadows: [
                                          Shadow(
                                            color: _HubColors.yellow.withOpacity(0.4),
                                            blurRadius: 8,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Master the Tifinagh script from scratch',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: Colors.white.withOpacity(0.52),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _CountBadge(total: _count),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Divider
                FadeTransition(
                  opacity: _headerFade,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.transparent,
                          _HubColors.yellow.withOpacity(0.35),
                          Colors.transparent,
                        ]),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 28),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: _count,
                    itemBuilder: (ctx, i) => FadeTransition(
                      opacity: _cardFade[i],
                      child: SlideTransition(
                        position: _cardSlide[i],
                        child: LessonCard(
                          lesson: _lessons[i],
                          index: i,
                          // ✅ Pass allLessons[i] from lesson_hub_page.dart
                          lessonData: allLessons[i],
                        ),
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
//  LESSON CARD
// ═══════════════════════════════════════════════════════════════════════════════
class LessonCard extends StatefulWidget {
  final _Lesson    lesson;
  final int        index;
  final LessonData lessonData; // 

  const LessonCard({
    super.key,
    required this.lesson,
    required this.index,
    required this.lessonData,
  });

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tapCtrl;
  late final Animation<double>   _tapScale;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _tapCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _tapScale = Tween<double>(begin: 1.0, end: 0.93).animate(
        CurvedAnimation(parent: _tapCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _tapCtrl.dispose(); super.dispose(); }

  void _down(_)  { setState(() => _pressed = true);  _tapCtrl.forward(); }
  void _up(_)    { setState(() => _pressed = false); _tapCtrl.reverse(); }
  void _cancel() { setState(() => _pressed = false); _tapCtrl.reverse(); }

  @override
  Widget build(BuildContext context) {
    final l = widget.lesson;
    return GestureDetector(
      onTapDown:   _down,
      onTapUp:     _up,
      onTapCancel: _cancel,
      // ✅ UPDATED onTap — navigates to LessonHubPage
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, anim, __) =>
              LessonHubPage(lesson: widget.lessonData),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
              child: child,
            ),
          ),
          transitionDuration: const Duration(milliseconds: 450),
        ),
      ),
      child: ScaleTransition(
        scale: _tapScale,
        child: _CardFace(lesson: l, pressed: _pressed),
      ),
    );
  }
}

// ─── Card Face (unchanged) ────────────────────────────────────────────────────
class _CardFace extends StatelessWidget {
  final _Lesson lesson;
  final bool    pressed;
  const _CardFace({super.key, required this.lesson, required this.pressed});

  @override
  Widget build(BuildContext context) {
    final l = lesson;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        fit: StackFit.expand,
        children: [

          // ── Layer 1: Unsplash background image ───────────────────────────
          Image.network(
            l.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Container(
                color: l.accent.withOpacity(0.15),
                child: Center(
                  child: CircularProgressIndicator(
                    color: l.accent.withOpacity(0.6),
                    strokeWidth: 2,
                  ),
                ),
              );
            },
            errorBuilder: (_, __, ___) => Container(
              color: l.accent.withOpacity(0.15),
              child: Icon(l.icon, color: l.accent.withOpacity(0.5), size: 40),
            ),
          ),

          // ── Layer 2: Dark gradient overlay ───────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.45, 1.0],
                colors: [
                  Colors.black.withOpacity(0.30),
                  Colors.black.withOpacity(0.45),
                  Colors.black.withOpacity(0.75),
                ],
              ),
            ),
          ),

          // ── Layer 3: Accent colour tint ──────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  l.accent.withOpacity(0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // ── Layer 4: Border + content ────────────────────────────────────
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: pressed
                      ? _HubColors.yellow.withOpacity(0.95)
                      : _HubColors.yellow.withOpacity(0.42),
                  width: pressed ? 2.0 : 1.2,
                ),
                boxShadow: pressed
                    ? [
                        BoxShadow(
                          color: _HubColors.yellow.withOpacity(0.30),
                          blurRadius: 22,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: l.accent.withOpacity(0.25),
                          blurRadius: 28,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
              child: Padding(
                padding: const EdgeInsets.all(13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.35),
                            border: Border.all(
                              color: l.accent.withOpacity(0.55),
                              width: 1.2,
                            ),
                          ),
                          child: Icon(l.icon, color: l.accent, size: 22),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.30),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'ⵣ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: _HubColors.yellow.withOpacity(0.85),
                              shadows: [
                                Shadow(
                                  color: _HubColors.yellow.withOpacity(0.4),
                                  blurRadius: 6,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      l.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.2,
                        height: 1.25,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 8,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 30, height: 2.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: l.accent,
                        boxShadow: [
                          BoxShadow(
                            color: l.accent.withOpacity(0.6),
                            blurRadius: 6,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  SHARED SMALL WIDGETS (unchanged)
// ═══════════════════════════════════════════════════════════════════════════════
class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassIconButton({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42, height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white.withOpacity(0.20)),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

class _LevelPill extends StatelessWidget {
  final String label;
  const _LevelPill({required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [_HubColors.yellowLight, _HubColors.yellow]),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(color: _HubColors.yellow.withOpacity(0.45), blurRadius: 10),
        ],
      ),
      child: const Text(
        'LEVEL 1',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: _HubColors.navy,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int total;
  const _CountBadge({required this.total});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: _HubColors.yellow.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.grid_view_rounded,
              color: _HubColors.yellow.withOpacity(0.85), size: 13),
          const SizedBox(width: 5),
          Text(
            '$total Lessons',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  GREEN DOT PAINTER (unchanged)
// ═══════════════════════════════════════════════════════════════════════════════
class _GreenDotPainter extends CustomPainter {
  final double progress;
  const _GreenDotPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final rng = math.Random(7);
    for (int i = 0; i < 52; i++) {
      final bx = rng.nextDouble() * size.width;
      final by = rng.nextDouble() * size.height;
      final r  = 1.2 + rng.nextDouble() * 2.6;
      final sp = 0.12 + rng.nextDouble() * 0.28;
      final ph = rng.nextDouble() * math.pi * 2;
      final al = 0.05 + rng.nextDouble() * 0.10;
      final x  = bx + math.sin(progress * math.pi * 2 * sp + ph) * 7;
      final y  = by + math.cos(progress * math.pi * 2 * sp * 0.6 + ph) * 5;
      paint.color = _HubColors.green.withOpacity(al);
      canvas.drawCircle(Offset(x, y), r, paint);
    }

    final rng2 = math.Random(99);
    for (int i = 0; i < 14; i++) {
      final bx = rng2.nextDouble() * size.width;
      final by = rng2.nextDouble() * size.height;
      final r  = 4.0 + rng2.nextDouble() * 5.5;
      final sp = 0.06 + rng2.nextDouble() * 0.12;
      final ph = rng2.nextDouble() * math.pi * 2;
      final x  = bx + math.sin(progress * math.pi * 2 * sp + ph) * 10;
      final y  = by + math.cos(progress * math.pi * 2 * sp * 0.5 + ph) * 7;
      paint.color = _HubColors.green.withOpacity(0.035);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(_GreenDotPainter old) => old.progress != progress;
}
