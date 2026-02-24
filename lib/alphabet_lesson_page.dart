import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'alphabet_data.dart'; // ✅ shared data source

// ═══════════════════════════════════════════════════════════════════════════════
//  TIFINAGH ALPHABET LESSON PAGE  —  alphabet_lesson_page.dart
// ═══════════════════════════════════════════════════════════════════════════════

class _K {
  static const bgTop     = Color(0xFF002B6B);
  static const bgMid     = Color(0xFF003080);
  static const bgBottom  = Color(0xFF003D99);
  static const gold      = Color(0xFFFFD700);
  static const goldLight = Color(0xFFFFF176);
  static const green     = Color(0xFF00C44F);
  static const emerald   = Color(0xFF00C853);
  static const navy      = Color(0xFF001A44);
}

void _playSound(String text) {
  HapticFeedback.lightImpact();
  debugPrint('🔊 Playing: $text');
}

// ═══════════════════════════════════════════════════════════════════════════════
//  PAGE
// ═══════════════════════════════════════════════════════════════════════════════
class TifinaghAlphabetPage extends StatefulWidget {
  const TifinaghAlphabetPage({super.key});
  @override
  State<TifinaghAlphabetPage> createState() => _TifinaghAlphabetPageState();
}

class _TifinaghAlphabetPageState extends State<TifinaghAlphabetPage>
    with TickerProviderStateMixin {

  final PageController _pageCtrl = PageController();
  int _currentIndex = 0;

  late final AnimationController _dotCtrl;
  late final AnimationController _yazCtrl;
  late final Animation<double>   _yazFloat;
  late final AnimationController _letterCtrl;
  late final Animation<double>   _letterScale;
  late final Animation<double>   _letterFade;
  late final AnimationController _cardCtrl;
  late final Animation<Offset>   _cardSlide;
  late final Animation<double>   _cardFade;

  @override
  void initState() {
    super.initState();

    _dotCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();

    _yazCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 3200))
      ..repeat(reverse: true);
    _yazFloat = Tween<double>(begin: -14.0, end: 14.0)
        .animate(CurvedAnimation(parent: _yazCtrl, curve: Curves.easeInOut));

    _letterCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));
    _letterScale = Tween<double>(begin: 0.6, end: 1.0)
        .animate(CurvedAnimation(parent: _letterCtrl, curve: Curves.elasticOut));
    _letterFade = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _letterCtrl,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOut)));

    _cardCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 480));
    _cardSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOut));
    _cardFade = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOut));

    _letterCtrl.forward();
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) _cardCtrl.forward();
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose(); _dotCtrl.dispose(); _yazCtrl.dispose();
    _letterCtrl.dispose(); _cardCtrl.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    if (index < 0 || index >= alphabetLetters.length) return;
    _letterCtrl.reset(); _cardCtrl.reset();
    _pageCtrl.animateToPage(index,
        duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    setState(() => _currentIndex = index);
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) { _letterCtrl.forward(); _cardCtrl.forward(); }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size     = MediaQuery.of(context).size;
    final progress = (_currentIndex + 1) / alphabetLetters.length;

    return Scaffold(
      body: Stack(children: [

        Container(decoration: const BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          stops: [0.0, 0.55, 1.0],
          colors: [_K.bgTop, _K.bgMid, _K.bgBottom],
        ))),

        AnimatedBuilder(
          animation: _dotCtrl,
          builder: (_, __) => CustomPaint(size: size, painter: _GreenDotPainter(_dotCtrl.value)),
        ),

        Positioned.fill(child: AnimatedBuilder(
          animation: _yazFloat,
          builder: (_, __) => Transform.translate(
            offset: Offset(size.width * 0.12, _yazFloat.value),
            child: Center(child: Text('ⵣ', style: TextStyle(
              fontSize: size.width * 0.62,
              color: Colors.white.withOpacity(0.03),
              fontWeight: FontWeight.bold,
            ))),
          ),
        )),

        SafeArea(child: Column(children: [

          _TopBar(
            current: _currentIndex,
            total: alphabetLetters.length,
            progress: progress,
          ),

          Expanded(child: PageView.builder(
            controller: _pageCtrl,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: alphabetLetters.length,
            itemBuilder: (_, i) => _LetterSlide(
              letter:      alphabetLetters[i],
              letterCtrl:  _letterCtrl,
              letterScale: _letterScale,
              letterFade:  _letterFade,
              cardCtrl:    _cardCtrl,
              cardSlide:   _cardSlide,
              cardFade:    _cardFade,
            ),
          )),

          _NavBar(
            currentIndex: _currentIndex,
            total: alphabetLetters.length,
            onPrev: () => _goTo(_currentIndex - 1),
            onNext: () => _goTo(_currentIndex + 1),
            // زر Home في آخر حرف → يرجع للـ LessonHubPage
            onHome: () => Navigator.pop(context),
          ),

          const SizedBox(height: 10),
        ])),

      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  TOP BAR
// ═══════════════════════════════════════════════════════════════════════════════
class _TopBar extends StatelessWidget {
  final int    current;
  final int    total;
  final double progress;
  const _TopBar({required this.current, required this.total, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Column(children: [
        Row(children: [
          _GlassBtn(
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Tifinagh Alphabet', style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white,
              shadows: [Shadow(color: Colors.black45, blurRadius: 8)],
            )),
            Text('ⵜⵉⴼⵉⵏⴰⵖ · Huruf Amazigh', style: TextStyle(
              fontSize: 11, color: _K.goldLight.withOpacity(0.75), letterSpacing: 1.2,
            )),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _K.gold.withOpacity(0.18),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: _K.gold.withOpacity(0.45)),
            ),
            child: Text('${current + 1} / $total', style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w800, color: _K.gold, letterSpacing: 0.5,
            )),
          ),
        ]),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Stack(children: [
            Container(height: 6, color: Colors.white.withOpacity(0.12)),
            AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              widthFactor: progress,
              child: Container(height: 6, decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF00C853), _K.gold]),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [BoxShadow(color: _K.gold.withOpacity(0.55), blurRadius: 8)],
              )),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  LETTER SLIDE
// ═══════════════════════════════════════════════════════════════════════════════
class _LetterSlide extends StatelessWidget {
  final AlphabetLetter        letter;      // ✅ uses AlphabetLetter (public)
  final AnimationController   letterCtrl;
  final Animation<double>     letterScale;
  final Animation<double>     letterFade;
  final AnimationController   cardCtrl;
  final Animation<Offset>     cardSlide;
  final Animation<double>     cardFade;

  const _LetterSlide({
    required this.letter,    required this.letterCtrl,
    required this.letterScale, required this.letterFade,
    required this.cardCtrl,  required this.cardSlide,
    required this.cardFade,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: [
        const SizedBox(height: 16),

        FadeTransition(
          opacity: letterFade,
          child: ScaleTransition(scale: letterScale, child: _HeroCircle(letter: letter)),
        ),

        const SizedBox(height: 12),

        FadeTransition(
          opacity: letterFade,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(letter.name, style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white,
              letterSpacing: 1.5,
              shadows: [Shadow(color: Colors.black, blurRadius: 10)],
            )),
            const SizedBox(width: 14),
            _AudioButton(soundKey: letter.letter),
          ]),
        ),

        const SizedBox(height: 16),

        Expanded(child: FadeTransition(
          opacity: cardFade,
          child: SlideTransition(
            position: cardSlide,
            child: _EducationCard(letter: letter),
          ),
        )),

        const SizedBox(height: 8),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  HERO CIRCLE
// ═══════════════════════════════════════════════════════════════════════════════
class _HeroCircle extends StatelessWidget {
  final AlphabetLetter letter;
  const _HeroCircle({super.key, required this.letter});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160, height: 160,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: _K.gold.withOpacity(0.35), blurRadius: 40, spreadRadius: 4),
            BoxShadow(color: _K.goldLight.withOpacity(0.18), blurRadius: 70, spreadRadius: 8),
          ],
        ),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              width: 160, height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withOpacity(0.18), Colors.white.withOpacity(0.06)],
                  stops: const [0.3, 1.0],
                ),
                border: Border.all(color: _K.gold.withOpacity(0.55), width: 1.5),
              ),
              child: Center(
                child: Text(letter.letter, textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 88, color: Colors.white,
                    fontWeight: FontWeight.bold, height: 1.0,
                    shadows: [
                      Shadow(color: _K.gold.withOpacity(0.6), blurRadius: 24),
                      const Shadow(color: Colors.black, blurRadius: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  AUDIO BUTTON
// ═══════════════════════════════════════════════════════════════════════════════
class _AudioButton extends StatefulWidget {
  final String soundKey;
  const _AudioButton({required this.soundKey});
  @override
  State<_AudioButton> createState() => _AudioButtonState();
}

class _AudioButtonState extends State<_AudioButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double>   _pulseAnim;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.15)
        .animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _pulse.dispose(); super.dispose(); }

  void _tap() async {
    setState(() => _playing = true);
    _playSound(widget.soundKey);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _playing = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _tap,
      child: AnimatedBuilder(
        animation: _pulseAnim,
        builder: (_, child) => Transform.scale(
          scale: _playing ? _pulseAnim.value : 1.0, child: child,
        ),
        child: Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [_K.emerald.withOpacity(0.70), const Color(0xFF009624).withOpacity(0.85)],
            ),
            border: Border.all(color: _K.emerald.withOpacity(0.80), width: 1.2),
            boxShadow: [BoxShadow(
              color: _K.emerald.withOpacity(_playing ? 0.60 : 0.35),
              blurRadius: _playing ? 22 : 14, spreadRadius: _playing ? 2 : 0,
            )],
          ),
          child: Icon(
            _playing ? Icons.volume_up_rounded : Icons.play_arrow_rounded,
            color: Colors.white, size: 26,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  EDUCATION CARD
// ═══════════════════════════════════════════════════════════════════════════════
class _EducationCard extends StatelessWidget {
  final AlphabetLetter letter;
  const _EducationCard({super.key, required this.letter});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Colors.white.withOpacity(0.10), Colors.white.withOpacity(0.05)],
            ),
            border: Border.all(color: _K.gold.withOpacity(0.32), width: 1.1),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.20), blurRadius: 24, offset: const Offset(0, 6)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                _SectionLabel(label: 'Example Word · ⵉⵎⴰⵡⴰⵍ'),
                const SizedBox(height: 14),

                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [

                  Container(
                    width: 58, height: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white.withOpacity(0.08),
                      border: Border.all(color: _K.gold.withOpacity(0.30), width: 1),
                    ),
                    child: Icon(letter.icon, color: _K.gold, size: 28),
                  ),

                  const SizedBox(width: 12),

                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(letter.example, style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w700,
                        color: _K.goldLight, letterSpacing: 3, height: 1.1,
                        shadows: [Shadow(color: _K.gold.withOpacity(0.55), blurRadius: 12)],
                      )),
                      const SizedBox(height: 3),
                      Text(letter.trans, style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.70), letterSpacing: 0.4,
                      )),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _K.emerald.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _K.emerald.withOpacity(0.40), width: 0.8),
                        ),
                        child: Text(letter.en, style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white,
                          letterSpacing: 0.3,
                          shadows: [Shadow(color: Colors.black54, blurRadius: 6)],
                        )),
                      ),
                    ],
                  )),

                  const SizedBox(width: 10),
                  _AudioButton(soundKey: letter.example),
                ]),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 3, height: 14,
        decoration: BoxDecoration(
          color: _K.emerald, borderRadius: BorderRadius.circular(2),
          boxShadow: [BoxShadow(color: _K.emerald.withOpacity(0.5), blurRadius: 6)],
        ),
      ),
      const SizedBox(width: 8),
      Text(label, style: TextStyle(
        fontSize: 11.5, fontWeight: FontWeight.w700,
        color: Colors.white.withOpacity(0.55), letterSpacing: 0.8,
      )),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  NAV BAR
// ═══════════════════════════════════════════════════════════════════════════════
class _NavBar extends StatelessWidget {
  final int currentIndex, total;
  final VoidCallback onPrev, onNext, onHome;
  const _NavBar({required this.currentIndex, required this.total, required this.onPrev, required this.onNext, required this.onHome});

  @override
  Widget build(BuildContext context) {
    final isLast = currentIndex >= total - 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _NavArrow(icon: Icons.arrow_back_ios_rounded, enabled: currentIndex > 0, onTap: onPrev),
        _DotRow(current: currentIndex, total: total),
        // آخر حرف → زر Home ذهبي بدل سهم اليمين
        if (isLast)
          _HomeBtn(onTap: onHome)
        else
          _NavArrow(icon: Icons.arrow_forward_ios_rounded, enabled: true, onTap: onNext),
      ]),
    );
  }
}

class _NavArrow extends StatelessWidget {
  final IconData icon; final bool enabled; final VoidCallback onTap;
  const _NavArrow({required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.30,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: enabled ? Colors.white.withOpacity(0.12) : Colors.white.withOpacity(0.05),
            border: Border.all(
              color: enabled ? _K.gold.withOpacity(0.45) : Colors.white.withOpacity(0.10),
              width: 1.1,
            ),
            boxShadow: enabled ? [BoxShadow(color: _K.gold.withOpacity(0.18), blurRadius: 12)] : [],
          ),
          child: Icon(icon, color: enabled ? _K.gold : Colors.white.withOpacity(0.3), size: 20),
        ),
      ),
    );
  }
}

// زر Home — يبان فقط في آخر حرف
class _HomeBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _HomeBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52, height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFFFFF176), Color(0xFFFFD700)],
          ),
          boxShadow: [BoxShadow(color: _K.gold.withOpacity(0.55), blurRadius: 18, spreadRadius: 1)],
        ),
        child: const Icon(Icons.home_rounded, color: Color(0xFF001A44), size: 26),
      ),
    );
  }
}

class _DotRow extends StatelessWidget {
  final int current, total;
  const _DotRow({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    const maxDots = 7;
    final half  = maxDots ~/ 2;
    final start = (current - half).clamp(0, (total - maxDots).clamp(0, total));
    final end   = (start + maxDots).clamp(0, total);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(end - start, (i) {
        final active = (start + i) == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 22 : 7, height: 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: active ? _K.gold : Colors.white.withOpacity(0.25),
            boxShadow: active ? [BoxShadow(color: _K.gold.withOpacity(0.5), blurRadius: 8)] : [],
          ),
        );
      }),
    );
  }
}

class _GlassBtn extends StatelessWidget {
  final Widget child; final VoidCallback onTap;
  const _GlassBtn({required this.child, required this.onTap});

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
        child: Center(child: child),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  GREEN DOT PAINTER
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
      paint.color = _K.green.withOpacity(al);
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
      paint.color = _K.green.withOpacity(0.035);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(_GreenDotPainter old) => old.progress != progress;
}