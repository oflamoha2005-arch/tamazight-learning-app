import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'alphabet_lesson_page.dart';
import 'alphabet_test_page.dart'; // ✅ NEW IMPORT

class _C {
  static const bgTop       = Color(0xFF002B6B);
  static const bgMid       = Color(0xFF003080);
  static const bgBottom    = Color(0xFF003D99);
  static const gold        = Color(0xFFFFD700);
  static const goldLight   = Color(0xFFFFF176);
  static const goldDark    = Color(0xFFE65100);
  static const green       = Color(0xFF00C44F);
  static const navy        = Color(0xFF001A44);
  static const shimmerBase = Color(0xFF1A3A7A);
  static const shimmerHigh = Color(0xFF2A5AAA);
}

class LessonData {
  final String   name;
  final String   tifinagh;
  final IconData icon;
  final Color    accent;
  final String   studyImageUrl;
  final String   testImageUrl;

  const LessonData({
    required this.name,
    required this.tifinagh,
    required this.icon,
    required this.accent,
    required this.studyImageUrl,
    required this.testImageUrl,
  });
}

const _testImageUrl =
    'https://images.unsplash.com/photo-1606326608606-aa0b62935f2b?w=600&auto=format&fit=crop';

const List<LessonData> allLessons = [
  LessonData(name: 'Alphabet',          tifinagh: 'ⵜⵉⴼⵉⵏⴰⵖ',  icon: Icons.abc,            accent: Color(0xFF29B6F6), studyImageUrl: 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=600&auto=format&fit=crop',  testImageUrl: _testImageUrl),
  LessonData(name: 'Numbers',           tifinagh: 'ⵉⵎⴹⴽⴰⵏ',   icon: Icons.looks_one,       accent: Color(0xFFFFCA28), studyImageUrl: 'https://images.unsplash.com/photo-1509228468518-180dd4864904?w=600&auto=format&fit=crop',  testImageUrl: _testImageUrl),
  LessonData(name: 'Colors',            tifinagh: 'ⵉⵙⴻⴳⵣⴰⵡⵏ', icon: Icons.palette,         accent: Color(0xFFFF7043), studyImageUrl: 'https://images.unsplash.com/photo-1541701494587-cb58502866ab?w=600&auto=format&fit=crop',  testImageUrl: _testImageUrl),
  LessonData(name: 'Food',              tifinagh: 'ⵉⵎⴻⵏⵙⵉ',   icon: Icons.restaurant,      accent: Color(0xFF66BB6A), studyImageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600&auto=format&fit=crop',  testImageUrl: _testImageUrl),
  LessonData(name: 'Vegetables',        tifinagh: 'ⵉⵖⵓⴷⴰⵏ',   icon: Icons.grass,           accent: Color(0xFF26A69A), studyImageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=600&auto=format&fit=crop',  testImageUrl: _testImageUrl),
  LessonData(name: 'Fruits',            tifinagh: 'ⵉⵥⵥⴰⵏ',    icon: Icons.apple,           accent: Color(0xFFEF5350), studyImageUrl: 'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=600&auto=format&fit=crop',  testImageUrl: _testImageUrl),
  LessonData(name: 'Drinks',            tifinagh: 'ⵉⵙⵡⴰⵏ',    icon: Icons.local_cafe,      accent: Color(0xFFAB47BC), studyImageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600&auto=format&fit=crop',  testImageUrl: _testImageUrl),
  LessonData(name: 'Transport',         tifinagh: 'ⴰⵣⵣⵓⵍ',    icon: Icons.directions_car,  accent: Color(0xFF42A5F5), studyImageUrl: 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=600&auto=format&fit=crop',  testImageUrl: _testImageUrl),
  LessonData(name: 'Body',              tifinagh: 'ⴰⵖⵔⴱⴰⵣ',   icon: Icons.accessibility,   accent: Color(0xFFFF8A65), studyImageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=600&auto=format&fit=crop',  testImageUrl: _testImageUrl),
  LessonData(name: 'Animals',           tifinagh: 'ⵉⵖⵓⴷⴰⵏ',   icon: Icons.pets,            accent: Color(0xFF8D6E63), studyImageUrl: 'https://images.unsplash.com/photo-1474511320723-9a56873867b5?w=600&auto=format&fit=crop',  testImageUrl: _testImageUrl),
  LessonData(name: 'Days & Weeks',      tifinagh: 'ⵓⵙⵙⴰⵏ',    icon: Icons.calendar_month,  accent: Color(0xFF5C6BC0), studyImageUrl: 'https://images.unsplash.com/photo-1506784983877-45594efa4cbe?w=600&auto=format&fit=crop',  testImageUrl: _testImageUrl),
  LessonData(name: 'Months & Seasons',  tifinagh: 'ⵉⵢⵢⵓⵔⵏ',   icon: Icons.wb_sunny,        accent: Color(0xFFFFB300), studyImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&auto=format&fit=crop',  testImageUrl: _testImageUrl),
  LessonData(name: 'Clothing',          tifinagh: 'ⵉⵍⴱⵙⵏ',    icon: Icons.checkroom,       accent: Color(0xFFEC407A), studyImageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&auto=format&fit=crop',  testImageUrl: _testImageUrl),
  LessonData(name: 'Weather',           tifinagh: 'ⵉⴳⵏⵏⴰ',    icon: Icons.cloud,           accent: Color(0xFF78909C), studyImageUrl: 'https://images.unsplash.com/photo-1504608524841-42584120d693?w=600&auto=format&fit=crop',  testImageUrl: _testImageUrl),
  LessonData(name: 'Home',              tifinagh: 'ⴰⵊⴷⴰⵔ',    icon: Icons.home,            accent: Color(0xFF4DB6AC), studyImageUrl: 'https://images.unsplash.com/photo-1484101403633-562f891dc89a?w=600&auto=format&fit=crop',  testImageUrl: _testImageUrl),
  LessonData(name: 'Technology',        tifinagh: 'ⵜⵉⴽⵏⵓⵍⵓⵊⵉ', icon: Icons.computer,       accent: Color(0xFF7E57C2), studyImageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=600&auto=format&fit=crop',  testImageUrl: _testImageUrl),
  LessonData(name: 'Nature',            tifinagh: 'ⵜⴰⵎⵔⵜ',    icon: Icons.forest,          accent: Color(0xFF43A047), studyImageUrl: 'https://images.unsplash.com/photo-1448375240586-882707db888b?w=600&auto=format&fit=crop',  testImageUrl: _testImageUrl),
];

void playSoundEffect(String type) => debugPrint('🔊 Sound: $type');

// ═══════════════════════════════════════════════════════════════════════════════
//  PAGE
// ═══════════════════════════════════════════════════════════════════════════════
class LessonHubPage extends StatefulWidget {
  final LessonData lesson;
  const LessonHubPage({super.key, required this.lesson});

  @override
  State<LessonHubPage> createState() => _LessonHubPageState();
}

class _LessonHubPageState extends State<LessonHubPage>
    with TickerProviderStateMixin {

  late final AnimationController _entryCtrl;
  late final Animation<double>   _headerFade;
  late final Animation<Offset>   _headerSlide;
  late final Animation<double>   _card1Fade;
  late final Animation<Offset>   _card1Slide;
  late final Animation<double>   _card2Fade;
  late final Animation<Offset>   _card2Slide;
  late final AnimationController _dotCtrl;
  late final AnimationController _yazCtrl;
  late final Animation<double>   _yazFloat;
  late final AnimationController _shimmerCtrl;

  @override
  void initState() {
    super.initState();

    _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

    _headerFade  = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.00, 0.50, curve: Curves.easeOut)));
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.00, 0.60, curve: Curves.easeOut)));
    _card1Fade   = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.25, 0.75, curve: Curves.easeOut)));
    _card1Slide  = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.25, 0.80, curve: Curves.easeOut)));
    _card2Fade   = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.45, 0.95, curve: Curves.easeOut)));
    _card2Slide  = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.45, 1.00, curve: Curves.easeOut)));
    _entryCtrl.forward();

    _dotCtrl     = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
    _yazCtrl     = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))..repeat(reverse: true);
    _yazFloat    = Tween<double>(begin: -18.0, end: 18.0).animate(CurvedAnimation(parent: _yazCtrl, curve: Curves.easeInOut));
    _shimmerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _dotCtrl.dispose();
    _yazCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  void _onStudyTap() {
    HapticFeedback.lightImpact();
    playSoundEffect('study');
    debugPrint('🟢 COUR tapped: ${widget.lesson.name}');

    if (widget.lesson.name == 'Alphabet') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => const TifinaghAlphabetPage(),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('▶  COUR · ${widget.lesson.name}'),
        backgroundColor: _C.gold.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    }
  }

  // ✅ ONLY CHANGE: navigate to AlphabetTestPage for 'Alphabet', SnackBar for others
  void _onTestTap() {
    HapticFeedback.mediumImpact();
    playSoundEffect('test');
    debugPrint('🟡 TEST tapped: ${widget.lesson.name}');

    if (widget.lesson.name == 'Alphabet') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => const AlphabetTestPage(),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('▶  TEST · ${widget.lesson.name}'),
        backgroundColor: _C.gold.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size   = MediaQuery.of(context).size;
    final lesson = widget.lesson;

    return Scaffold(
      body: Stack(children: [

        // Background gradient
        Container(decoration: const BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          stops: [0.0, 0.55, 1.0],
          colors: [_C.bgTop, _C.bgMid, _C.bgBottom],
        ))),

        // Green dots
        AnimatedBuilder(
          animation: _dotCtrl,
          builder: (_, __) => CustomPaint(size: size, painter: _DotPainter(_dotCtrl.value)),
        ),

        // Watermark ⵣ
        Positioned.fill(child: AnimatedBuilder(
          animation: _yazFloat,
          builder: (_, __) => Transform.translate(
            offset: Offset(size.width * 0.15, _yazFloat.value),
            child: Center(child: Text('ⵣ', style: TextStyle(
              fontSize: size.width * 0.65,
              color: Colors.white.withOpacity(0.032),
              fontWeight: FontWeight.bold,
            ))),
          ),
        )),

        // Page content
        SafeArea(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            const SizedBox(height: 12),
            FadeTransition(opacity: _headerFade,
              child: SlideTransition(position: _headerSlide, child: _Header(lesson: lesson))),

            const SizedBox(height: 10),
            FadeTransition(opacity: _headerFade, child: _GoldDivider()),

            const SizedBox(height: 28),

            // COUR card
            FadeTransition(opacity: _card1Fade,
              child: SlideTransition(position: _card1Slide,
                child: _SelectionCard(
                  type: _CardType.study,
                  lesson: lesson,
                  shimmerCtrl: _shimmerCtrl,
                  onTap: _onStudyTap,
                ))),

            const SizedBox(height: 16),

            // TEST card
            FadeTransition(opacity: _card2Fade,
              child: SlideTransition(position: _card2Slide,
                child: _SelectionCard(
                  type: _CardType.test,
                  lesson: lesson,
                  shimmerCtrl: _shimmerCtrl,
                  onTap: _onTestTap,
                ))),

            const SizedBox(height: 24),

            FadeTransition(opacity: _card2Fade, child: Center(child: Text(
              'Choose your mode to begin',
              style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.38), letterSpacing: 1.0),
            ))),

          ]),
        )),

      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  CARD TYPE
// ═══════════════════════════════════════════════════════════════════════════════
enum _CardType { study, test }

// ═══════════════════════════════════════════════════════════════════════════════
//  SELECTION CARD
// ═══════════════════════════════════════════════════════════════════════════════
class _SelectionCard extends StatefulWidget {
  final _CardType           type;
  final LessonData          lesson;
  final AnimationController shimmerCtrl;
  final VoidCallback        onTap;

  const _SelectionCard({
    required this.type,
    required this.lesson,
    required this.shimmerCtrl,
    required this.onTap,
  });

  @override
  State<_SelectionCard> createState() => _SelectionCardState();
}

class _SelectionCardState extends State<_SelectionCard>
    with SingleTickerProviderStateMixin {

  late final AnimationController _tapCtrl;
  late final Animation<double>   _tapScale;
  bool _imageLoaded = false;

  @override
  void initState() {
    super.initState();
    _tapCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 140));
    _tapScale = Tween<double>(begin: 1.0, end: 0.965)
        .animate(CurvedAnimation(parent: _tapCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _tapCtrl.dispose(); super.dispose(); }

  bool     get _isStudy    => widget.type == _CardType.study;
  String   get _imageUrl   => _isStudy ? widget.lesson.studyImageUrl : widget.lesson.testImageUrl;
  String   get _title      => _isStudy ? 'COUR'              : 'TEST';
  String   get _subtitle   => _isStudy ? 'Study the lesson'  : 'Mini Exam';
  String   get _tifinagh   => _isStudy ? 'ⵜⵓⵙⵙⵏⴰ'           : 'ⵜⵉⵎⵙⵉⵜⵏ';
  IconData get _icon       => _isStudy ? Icons.menu_book_rounded : Icons.emoji_events_rounded;
  Color    get _accentColor => _isStudy ? const Color(0xFF29B6F6) : const Color(0xFFFFCA28);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown:   (_) => _tapCtrl.forward(),
      onTapUp:     (_) { _tapCtrl.reverse(); widget.onTap(); },
      onTapCancel: ()  => _tapCtrl.reverse(),
      child: ScaleTransition(
        scale: _tapScale,
        child: _CardBody(
          isStudy:     _isStudy,
          imageUrl:    _imageUrl,
          title:       _title,
          subtitle:    _subtitle,
          tifinagh:    _tifinagh,
          icon:        _icon,
          accentColor: _accentColor,
          lessonName:  widget.lesson.name,
          shimmerCtrl: widget.shimmerCtrl,
          imageLoaded: _imageLoaded,
          onImageLoad: () => setState(() => _imageLoaded = true),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  CARD BODY
// ═══════════════════════════════════════════════════════════════════════════════
class _CardBody extends StatelessWidget {
  final bool                isStudy;
  final String              imageUrl;
  final String              title;
  final String              subtitle;
  final String              tifinagh;
  final IconData            icon;
  final Color               accentColor;
  final String              lessonName;
  final AnimationController shimmerCtrl;
  final bool                imageLoaded;
  final VoidCallback        onImageLoad;

  const _CardBody({
    required this.isStudy,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.tifinagh,
    required this.icon,
    required this.accentColor,
    required this.lessonName,
    required this.shimmerCtrl,
    required this.imageLoaded,
    required this.onImageLoad,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(22)),
      child: Stack(fit: StackFit.expand, children: [

        // Layer 1: shimmer
        if (!imageLoaded) _ShimmerBox(ctrl: shimmerCtrl),

        // Layer 2: network image
        Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) {
            if (progress == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) => onImageLoad());
              return child;
            }
            return const SizedBox.shrink();
          },
          errorBuilder: (_, __, ___) => Container(
            color: accentColor.withOpacity(0.15),
            child: Icon(icon, color: accentColor.withOpacity(0.4), size: 60),
          ),
        ),

        // Layer 3: dark overlay
        Container(decoration: BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topRight, end: Alignment.bottomLeft,
          colors: [
            Colors.black.withOpacity(0.10),
            Colors.black.withOpacity(0.35),
            _C.navy.withOpacity(0.50),
          ],
        ))),

        // Layer 4: accent tint
        Container(decoration: BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [accentColor.withOpacity(0.06), Colors.transparent],
        ))),

        // Layer 5: glass + content
        IgnorePointer(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
              child: _GradientBorderContainer(
                borderRadius: 22,
                borderWidth: 1.2,
                gradientColors: isStudy
                    ? [_C.goldLight.withOpacity(0.55), _C.gold.withOpacity(0.35), _C.gold.withOpacity(0.18)]
                    : [_C.gold.withOpacity(0.45), _C.goldLight.withOpacity(0.30), _C.gold.withOpacity(0.15)],
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                      colors: [Colors.white.withOpacity(0.10), Colors.white.withOpacity(0.04)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(children: [
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ModePill(label: title, color: accentColor),
                          const SizedBox(height: 10),
                          Text(lessonName, style: const TextStyle(
                            fontSize: 27, fontWeight: FontWeight.w900, color: Colors.white,
                            letterSpacing: 0.2, height: 1.05,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 20, offset: Offset(0, 3)),
                              Shadow(color: Color(0xCC000000), blurRadius: 8, offset: Offset(0, 1)),
                            ],
                          )),
                          const SizedBox(height: 5),
                          Text(tifinagh, style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700,
                            color: const Color(0xFFFFF176), letterSpacing: 3.0,
                            shadows: [
                              Shadow(color: _C.gold.withOpacity(0.80), blurRadius: 18),
                              Shadow(color: _C.gold.withOpacity(0.40), blurRadius: 6),
                              const Shadow(color: Colors.black, blurRadius: 8),
                            ],
                          )),
                          const SizedBox(height: 8),
                          Text(subtitle, style: TextStyle(
                            fontSize: 11.5, fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.65), letterSpacing: 0.4,
                            shadows: const [Shadow(color: Colors.black, blurRadius: 8)],
                          )),
                        ],
                      )),
                      const SizedBox(width: 16),
                      _IconCircle(icon: icon, accent: accentColor),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ),

      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  GRADIENT BORDER CONTAINER
// ═══════════════════════════════════════════════════════════════════════════════
class _GradientBorderContainer extends StatelessWidget {
  final double      borderRadius;
  final double      borderWidth;
  final List<Color> gradientColors;
  final Widget      child;

  const _GradientBorderContainer({
    required this.borderRadius,
    required this.borderWidth,
    required this.gradientColors,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(borderWidth),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius - borderWidth),
          color: Colors.transparent,
        ),
        child: child,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  SHIMMER BOX
// ═══════════════════════════════════════════════════════════════════════════════
class _ShimmerBox extends StatelessWidget {
  final AnimationController ctrl;
  const _ShimmerBox({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        final s = ctrl.value;
        return Container(decoration: BoxDecoration(gradient: LinearGradient(
          begin: Alignment(-1.5 + s * 3.5, -0.5),
          end:   Alignment(-0.5 + s * 3.5,  0.5),
          colors: const [_C.shimmerBase, _C.shimmerHigh, _C.shimmerBase],
          stops: const [0.0, 0.5, 1.0],
        )));
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  SMALL WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════
class _Header extends StatelessWidget {
  final LessonData lesson;
  const _Header({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _GlassIconButton(icon: Icons.arrow_back_ios_new_rounded, onTap: () => Navigator.pop(context)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(lesson.icon, color: lesson.accent, size: 18),
          const SizedBox(width: 8),
          Text(lesson.name, style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white,
            shadows: [Shadow(color: Colors.black38, blurRadius: 8)],
          )),
        ]),
        const SizedBox(height: 2),
        Text(lesson.tifinagh, style: TextStyle(
          fontSize: 13, color: _C.gold.withOpacity(0.7), letterSpacing: 2.5,
        )),
      ])),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [_C.goldLight, _C.gold]),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [BoxShadow(color: _C.gold.withOpacity(0.4), blurRadius: 10)],
        ),
        child: const Text('LV 1', style: TextStyle(
          fontSize: 10, fontWeight: FontWeight.w900, color: _C.navy, letterSpacing: 1,
        )),
      ),
    ]);
  }
}

class _GoldDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(
      colors: [Colors.transparent, _C.gold.withOpacity(0.45), Colors.transparent],
    )));
  }
}

class _ModePill extends StatelessWidget {
  final String label;
  final Color  color;
  const _ModePill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0x7200C853), Color(0x88009624)],
            ),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: const Color(0xFF00C853), width: 1.3),
            boxShadow: const [BoxShadow(color: Color(0x5900C853), blurRadius: 14)],
          ),
          child: Text(label, style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white,
            letterSpacing: 2.5,
            shadows: [Shadow(color: Colors.black, blurRadius: 10, offset: Offset(0, 1))],
          )),
        ),
      ),
    );
  }
}

class _IconCircle extends StatelessWidget {
  final IconData icon;
  final Color    accent;
  const _IconCircle({required this.icon, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72, height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.30),
        border: Border.all(color: accent.withOpacity(0.55), width: 1.5),
        boxShadow: [BoxShadow(color: accent.withOpacity(0.30), blurRadius: 20, spreadRadius: 1)],
      ),
      child: Icon(icon, color: accent, size: 34),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData     icon;
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

// ═══════════════════════════════════════════════════════════════════════════════
//  DOT PAINTER
// ═══════════════════════════════════════════════════════════════════════════════
class _DotPainter extends CustomPainter {
  final double progress;
  const _DotPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final rng   = math.Random(7);
    for (int i = 0; i < 48; i++) {
      final bx = rng.nextDouble() * size.width;
      final by = rng.nextDouble() * size.height;
      final r  = 1.2 + rng.nextDouble() * 2.6;
      final sp = 0.12 + rng.nextDouble() * 0.28;
      final ph = rng.nextDouble() * math.pi * 2;
      final al = 0.04 + rng.nextDouble() * 0.09;
      final x  = bx + math.sin(progress * math.pi * 2 * sp + ph) * 7;
      final y  = by + math.cos(progress * math.pi * 2 * sp * 0.6 + ph) * 5;
      paint.color = _C.green.withOpacity(al);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(_DotPainter old) => old.progress != progress;
}