import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'alphabet_data.dart'; // ✅ shared data — AlphabetLetter + alphabetLetters

// ═══════════════════════════════════════════════════════════════════════════════
//  ALPHABET TEST PAGE  —  alphabet_test_page.dart
// ═══════════════════════════════════════════════════════════════════════════════

class _C {
  static const bgTop      = Color(0xFF002B6B);
  static const bgMid      = Color(0xFF003080);
  static const bgBottom   = Color(0xFF003D99);
  static const gold       = Color(0xFFFFD700);
  static const goldLight  = Color(0xFFFFF176);
  static const green      = Color(0xFF00C44F);
  static const emerald    = Color(0xFF00C853);
  static const red        = Color(0xFFEF5350);
  static const navy       = Color(0xFF001A44);
}

enum _QType { visualMatch, reverseMatch, phoneticMatch }

class _Question {
  final _QType             type;
  final AlphabetLetter     correct;         // ✅ AlphabetLetter (public)
  final List<AlphabetLetter> options;

  const _Question({required this.type, required this.correct, required this.options});
}

// ═══════════════════════════════════════════════════════════════════════════════
//  QUIZ BUILDER
// ═══════════════════════════════════════════════════════════════════════════════
List<_Question> _buildQuiz() {
  final rng  = Random();
  final pool = List<AlphabetLetter>.from(alphabetLetters)..shuffle(rng); // ✅
  final selected = pool.take(10).toList();

  return selected.map((correct) {
    final type   = _QType.values[rng.nextInt(_QType.values.length)];
    final similar = _similarTo(correct);
    final wrongs  = <AlphabetLetter>[];

    for (final s in similar) { if (wrongs.length < 3) wrongs.add(s); }

    final others = alphabetLetters // ✅
        .where((l) => l.letter != correct.letter && !wrongs.contains(l))
        .toList()..shuffle(rng);
    for (final o in others) { if (wrongs.length >= 3) break; wrongs.add(o); }

    final options = [correct, ...wrongs]..shuffle(rng);
    return _Question(type: type, correct: correct, options: options);
  }).toList();
}

List<AlphabetLetter> _similarTo(AlphabetLetter target) {
  const groups = [
    ['ⵎ', 'ⵏ', 'ⵐ'], ['ⴰ', 'ⴱ', 'ⴳ'], ['ⵜ', 'ⵟ', 'ⵡ'],
    ['ⵙ', 'ⵚ', 'ⵛ'], ['ⵔ', 'ⵕ', 'ⵖ'], ['ⵣ', 'ⵥ', 'ⵢ'],
    ['ⴷ', 'ⴹ', 'ⴼ'], ['ⵃ', 'ⵄ', 'ⵅ'], ['ⵉ', 'ⵊ', 'ⵍ'],
  ];
  for (final group in groups) {
    if (group.contains(target.letter)) {
      return alphabetLetters // ✅
          .where((l) => group.contains(l.letter) && l.letter != target.letter)
          .toList();
    }
  }
  return [];
}

// ═══════════════════════════════════════════════════════════════════════════════
//  PAGE
// ═══════════════════════════════════════════════════════════════════════════════
class AlphabetTestPage extends StatefulWidget {
  const AlphabetTestPage({super.key});
  @override
  State<AlphabetTestPage> createState() => _AlphabetTestPageState();
}

class _AlphabetTestPageState extends State<AlphabetTestPage>
    with TickerProviderStateMixin {

  late List<_Question> _questions;
  int     _qIndex       = 0;
  int     _score        = 0;
  bool    _answered     = false;
  String? _selectedLetter;
  bool    _showResult   = false;
  final List<_Question> _wrongAnswers = [];

  late AnimationController _dotCtrl;
  late AnimationController _yazCtrl;
  late Animation<double>   _yazFloat;
  late AnimationController _shakeCtrl;
  late Animation<double>   _shake;
  late AnimationController _cardCtrl;
  late Animation<double>   _cardFade;
  late Animation<Offset>   _cardSlide;
  late AnimationController _resultCtrl;
  late Animation<double>   _resultScale;
  late Animation<double>   _resultFade;

  @override
  void initState() {
    super.initState();
    _questions = _buildQuiz();

    _dotCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();

    _yazCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 3400))
      ..repeat(reverse: true);
    _yazFloat = Tween<double>(begin: -16.0, end: 16.0)
        .animate(CurvedAnimation(parent: _yazCtrl, curve: Curves.easeInOut));

    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _shake = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0,  end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0,  end: -8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8.0,  end: 6.0),  weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0,   end: 0.0),  weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeOut));

    _cardCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _cardFade  = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOut));
    _cardSlide = Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOut));

    _resultCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _resultScale = Tween<double>(begin: 0.80, end: 1.0)
        .animate(CurvedAnimation(parent: _resultCtrl, curve: Curves.elasticOut));
    _resultFade  = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _resultCtrl,
            curve: const Interval(0, 0.5, curve: Curves.easeOut)));

    _cardCtrl.forward();
  }

  @override
  void dispose() {
    _dotCtrl.dispose(); _yazCtrl.dispose(); _shakeCtrl.dispose();
    _cardCtrl.dispose(); _resultCtrl.dispose();
    super.dispose();
  }

  void _onAnswer(AlphabetLetter chosen) {
    if (_answered) return;
    final correct = _questions[_qIndex].correct;
    final isRight = chosen.letter == correct.letter;
    setState(() { _answered = true; _selectedLetter = chosen.letter; });

    if (isRight) {
      _score++;
      HapticFeedback.lightImpact();
      debugPrint('🔔 DING — correct!');
    } else {
      HapticFeedback.heavyImpact();
      debugPrint('❌ Wrong — correct was ${correct.name}');
      _wrongAnswers.add(_questions[_qIndex]);
      _shakeCtrl.forward(from: 0);
    }
    Future.delayed(const Duration(milliseconds: 1100), _nextQuestion);
  }

  void _nextQuestion() {
    if (!mounted) return;
    if (_qIndex >= 9) {
      setState(() => _showResult = true);
      _resultCtrl.forward(from: 0);
      return;
    }
    setState(() { _qIndex++; _answered = false; _selectedLetter = null; });
    _cardCtrl.reset(); _cardCtrl.forward();
  }

  void _resetQuiz() {
    setState(() {
      _questions      = _buildQuiz();
      _qIndex         = 0; _score = 0;
      _answered       = false; _selectedLetter = null; _showResult = false;
      _wrongAnswers.clear();
    });
    _cardCtrl.reset(); _cardCtrl.forward();
  }

  int get _stars {
    if (_score >= 9) return 3;
    if (_score >= 7) return 2;
    if (_score >= 4) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [

        Container(decoration: const BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          stops: [0.0, 0.55, 1.0],
          colors: [_C.bgTop, _C.bgMid, _C.bgBottom],
        ))),

        AnimatedBuilder(animation: _dotCtrl,
          builder: (_, __) => CustomPaint(size: size, painter: _DotPainter(_dotCtrl.value))),

        Positioned.fill(child: AnimatedBuilder(animation: _yazFloat,
          builder: (_, __) => Transform.translate(
            offset: Offset(size.width * 0.14, _yazFloat.value),
            child: Center(child: Text('ⵣ', style: TextStyle(
              fontSize: size.width * 0.65,
              color: Colors.white.withOpacity(0.028),
              fontWeight: FontWeight.bold,
            ))),
          ),
        )),

        SafeArea(
          child: _showResult
              ? _ResultScreen(
                  score: _score, stars: _stars, wrongAnswers: _wrongAnswers,
                  scaleAnim: _resultScale, fadeAnim: _resultFade,
                  onRetry: _resetQuiz, onHome: () => Navigator.pop(context),
                )
              : _QuizBody(
                  question: _questions[_qIndex], qIndex: _qIndex,
                  answered: _answered, selectedLetter: _selectedLetter,
                  shake: _shake, cardFade: _cardFade, cardSlide: _cardSlide,
                  onAnswer: _onAnswer, onBack: () => Navigator.pop(context),
                ),
        ),

      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  QUIZ BODY
// ═══════════════════════════════════════════════════════════════════════════════
class _QuizBody extends StatelessWidget {
  final _Question              question;
  final int                    qIndex;
  final bool                   answered;
  final String?                selectedLetter;
  final Animation<double>      shake;
  final Animation<double>      cardFade;
  final Animation<Offset>      cardSlide;
  final void Function(AlphabetLetter) onAnswer;
  final VoidCallback           onBack;

  const _QuizBody({
    required this.question, required this.qIndex, required this.answered,
    required this.selectedLetter, required this.shake, required this.cardFade,
    required this.cardSlide, required this.onAnswer, required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _TopBar(qIndex: qIndex, progress: (qIndex + 1) / 10, onBack: onBack),
      const SizedBox(height: 10),
      FadeTransition(
        opacity: cardFade,
        child: SlideTransition(position: cardSlide,
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _QuestionCard(question: question))),
      ),
      const SizedBox(height: 12),
      Expanded(child: AnimatedBuilder(
        animation: shake,
        builder: (_, child) => Transform.translate(
          offset: Offset(answered && selectedLetter != question.correct.letter ? shake.value : 0, 0),
          child: child,
        ),
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _OptionsGrid(
            question: question, answered: answered,
            selectedLetter: selectedLetter, onAnswer: onAnswer,
          )),
      )),
      const SizedBox(height: 8),
    ]);
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final int qIndex; final double progress; final VoidCallback onBack;
  const _TopBar({required this.qIndex, required this.progress, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Column(children: [
        Row(children: [
          _GlassBtn(onTap: onBack,
            child: const Icon(Icons.close_rounded, color: Colors.white, size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Alphabet Test', style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white,
              shadows: [Shadow(color: Colors.black45, blurRadius: 8)],
            )),
            Text('ⵜⵉⴼⵉⵏⴰⵖ · Quiz Mode', style: TextStyle(
              fontSize: 11, color: _C.goldLight.withOpacity(0.75), letterSpacing: 1.2,
            )),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: _C.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(50),
              border: Border.all(color: _C.gold.withOpacity(0.45)),
            ),
            child: Text('${qIndex + 1} / 10', style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w900, color: _C.gold, letterSpacing: 0.5,
            )),
          ),
        ]),
        const SizedBox(height: 12),
        ClipRRect(borderRadius: BorderRadius.circular(50),
          child: Stack(children: [
            Container(height: 6, color: Colors.white.withOpacity(0.12)),
            AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 400), curve: Curves.easeOut,
              widthFactor: progress,
              child: Container(height: 6, decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF00C853), _C.gold]),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [BoxShadow(color: _C.gold.withOpacity(0.55), blurRadius: 8)],
              )),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ── Question card ─────────────────────────────────────────────────────────────
class _QuestionCard extends StatelessWidget {
  final _Question question;
  const _QuestionCard({required this.question});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Colors.white.withOpacity(0.12), Colors.white.withOpacity(0.05)]),
            border: Border.all(color: _C.gold.withOpacity(0.35), width: 1.2),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.22), blurRadius: 24, offset: const Offset(0, 6))],
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            _TypePill(type: question.type),
            const SizedBox(height: 6),
            _QuestionStimulus(question: question),
          ]),
        ),
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  final _QType type;
  const _TypePill({required this.type});
  String get _label => switch (type) {
    _QType.visualMatch   => '👁  Identify the Letter',
    _QType.reverseMatch  => '🔤  Find the Character',
    _QType.phoneticMatch => '🔊  Listen & Match',
  };
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10), borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white.withOpacity(0.20)),
      ),
      child: Text(_label, style: const TextStyle(
        fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.8,
      )),
    );
  }
}

class _QuestionStimulus extends StatefulWidget {
  final _Question question;
  const _QuestionStimulus({required this.question});
  @override
  State<_QuestionStimulus> createState() => _QuestionStimulusState();
}

class _QuestionStimulusState extends State<_QuestionStimulus>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double>   _pulseScale;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 650))
      ..repeat(reverse: true);
    _pulseScale = Tween<double>(begin: 1.0, end: 1.12)
        .animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _pulse.dispose(); super.dispose(); }

  void _playSound() async {
    setState(() => _playing = true);
    HapticFeedback.lightImpact();
    debugPrint('🔊 Playing: ${widget.question.correct.name}');
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _playing = false);
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    switch (q.type) {
      case _QType.visualMatch:
        return Column(children: [
          Container(
            width: 84, height: 84,
            decoration: BoxDecoration(shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: _C.gold.withOpacity(0.40), blurRadius: 28, spreadRadius: 3)]),
            child: ClipOval(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [Colors.white.withOpacity(0.18), Colors.white.withOpacity(0.06)]),
                  border: Border.all(color: _C.gold.withOpacity(0.55), width: 1.5),
                ),
                child: Center(child: Text(q.correct.letter, style: TextStyle(
                  fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold, height: 1.0,
                  shadows: [Shadow(color: _C.gold.withOpacity(0.65), blurRadius: 20)],
                ))),
              ),
            )),
          ),
          const SizedBox(height: 4),
          Text('What is this character?', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.60), letterSpacing: 0.5)),
        ]);

      case _QType.reverseMatch:
        return Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: _C.gold.withOpacity(0.15),
              border: Border.all(color: _C.gold.withOpacity(0.50), width: 1.5),
              boxShadow: [BoxShadow(color: _C.gold.withOpacity(0.20), blurRadius: 16)],
            ),
            child: Text(q.correct.name, style: const TextStyle(
              fontSize: 30, fontWeight: FontWeight.w900, color: _C.gold,
              letterSpacing: 2, shadows: [Shadow(color: Colors.black, blurRadius: 12)],
            )),
          ),
          const SizedBox(height: 4),
          Text('Choose the matching Tifinagh character', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.60), letterSpacing: 0.5)),
        ]);

      case _QType.phoneticMatch:
        return Column(children: [
          GestureDetector(
            onTap: _playSound,
            child: AnimatedBuilder(animation: _pulseScale,
              builder: (_, child) => Transform.scale(scale: _playing ? _pulseScale.value : 1.0, child: child),
              child: Container(
                width: 68, height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [_C.emerald.withOpacity(0.75), const Color(0xFF007A33).withOpacity(0.90)]),
                  border: Border.all(color: _C.emerald.withOpacity(0.80), width: 1.5),
                  boxShadow: [BoxShadow(
                    color: _C.emerald.withOpacity(_playing ? 0.65 : 0.40),
                    blurRadius: _playing ? 30 : 18, spreadRadius: _playing ? 4 : 0,
                  )],
                ),
                child: Icon(_playing ? Icons.volume_up_rounded : Icons.play_arrow_rounded,
                  color: Colors.white, size: 30),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text('"${q.correct.name}"', style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white,
            letterSpacing: 1.5, shadows: [Shadow(color: Colors.black, blurRadius: 8)],
          )),
          const SizedBox(height: 2),
          Text('Pick the matching Tifinagh character', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.55), letterSpacing: 0.5)),
        ]);
    }
  }
}

// ── Options grid ──────────────────────────────────────────────────────────────
class _OptionsGrid extends StatelessWidget {
  final _Question                  question;
  final bool                       answered;
  final String?                    selectedLetter;
  final void Function(AlphabetLetter) onAnswer;

  const _OptionsGrid({required this.question, required this.answered,
    required this.selectedLetter, required this.onAnswer});

  @override
  Widget build(BuildContext context) {
    final isNameType = question.type == _QType.visualMatch;
    // ✅ FIX 1+4: Much more compact — 4 buttons always visible, no scroll needed
    // visualMatch (names): wide & short  |  Tifinagh: square-ish but compact
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: isNameType ? 3.2 : 2.0, // ✅ FIX 1+4: compact — 4 buttons fit on screen
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: question.options.map((opt) {
        final isCorrect  = opt.letter == question.correct.letter;
        final isSelected = opt.letter == selectedLetter;
        Color borderColor = Colors.white.withOpacity(0.20);
        Color bgColor     = Colors.white.withOpacity(0.08);
        Color textColor   = Colors.white;
        if (answered) {
          if (isCorrect)        { borderColor = _C.emerald; bgColor = _C.emerald.withOpacity(0.22); textColor = _C.goldLight; }
          else if (isSelected)  { borderColor = _C.red;     bgColor = _C.red.withOpacity(0.20);     textColor = Colors.white70; }
        }
        return GestureDetector(
          onTap: () => onAnswer(opt),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16), color: bgColor,
              border: Border.all(color: borderColor, width: answered && isCorrect ? 1.8 : 1.1),
              boxShadow: answered && isCorrect ? [BoxShadow(color: _C.emerald.withOpacity(0.40), blurRadius: 16)] : [],
            ),
            child: Center(child: _OptionContent(
              letter: opt, type: question.type, textColor: textColor,
              isCorrect: answered && isCorrect, isWrong: answered && isSelected && !isCorrect,
            )),
          ),
        );
      }).toList(),
    );
  }
}

class _OptionContent extends StatelessWidget {
  final AlphabetLetter letter;
  final _QType         type;
  final Color          textColor;
  final bool           isCorrect;
  final bool           isWrong;

  const _OptionContent({required this.letter, required this.type,
    required this.textColor, required this.isCorrect, required this.isWrong});

  @override
  Widget build(BuildContext context) {
    final showTifinagh = type != _QType.visualMatch;
    return Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
      if (showTifinagh) ...[
        // FIX 2: حرف تيفيناغ بوحده — بدون اسم لاتيني تحتو (منع الغش)
        // FIX 4: حرف كبير واضح مركّز حتى في الأزرار الصغيرة
        Text(letter.letter, textAlign: TextAlign.center, style: TextStyle(
          fontSize: 42, color: textColor, fontWeight: FontWeight.bold, height: 1.0,
          shadows: isCorrect
              ? [Shadow(color: _C.emerald.withOpacity(0.9), blurRadius: 18)]
              : isWrong
              ? [Shadow(color: _C.red.withOpacity(0.7), blurRadius: 14)]
              : [Shadow(color: Colors.black54, blurRadius: 6)],
        )),
        // أيقونة صغيرة بعد الجواب فقط
        if (isCorrect) ...[const SizedBox(height: 3), const Icon(Icons.check_circle_rounded, color: _C.emerald, size: 14)],
        if (isWrong)   ...[const SizedBox(height: 3), const Icon(Icons.cancel_rounded,       color: _C.red,     size: 14)],
      ] else ...[
        // visualMatch: الاسم اللاتيني هو الجواب — يبقى كما هو
        if (isCorrect) ...[const Icon(Icons.check_circle_rounded, color: _C.emerald, size: 14), const SizedBox(height: 2)],
        if (isWrong)   ...[const Icon(Icons.cancel_rounded,       color: _C.red,     size: 14), const SizedBox(height: 2)],
        Text(letter.name, textAlign: TextAlign.center, style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.w800, color: textColor, letterSpacing: 0.6,
        )),
      ],
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  RESULT SCREEN
// ═══════════════════════════════════════════════════════════════════════════════
class _ResultScreen extends StatelessWidget {
  final int              score;
  final int              stars;
  final List<_Question>  wrongAnswers;
  final Animation<double> scaleAnim;
  final Animation<double> fadeAnim;
  final VoidCallback     onRetry;
  final VoidCallback     onHome;

  const _ResultScreen({required this.score, required this.stars, required this.wrongAnswers,
    required this.scaleAnim, required this.fadeAnim, required this.onRetry, required this.onHome});

  String get _message => switch (stars) {
    3 => 'Outstanding! You\'ve mastered the alphabet! 🏆',
    2 => 'Great work! Keep practicing to get 3 stars!',
    1 => 'Good effort! Review the missed letters and try again.',
    _ => 'Keep going — every expert was once a beginner! 💪',
  };

  @override
  Widget build(BuildContext context) {
    // ✅ FIX 3: SingleChildScrollView wraps everything — Review section NEVER clipped
    return FadeTransition(opacity: fadeAnim,
      child: ScaleTransition(scale: scaleAnim,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          child: Column(children: [

            // ── Result card — compact spacing ────────────────────────────────
            ClipRRect(borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                      colors: [Colors.white.withOpacity(0.13), Colors.white.withOpacity(0.06)]),
                    border: Border.all(color: _C.gold.withOpacity(0.40), width: 1.3),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 28, offset: const Offset(0, 6))],
                  ),
                  child: Column(children: [
                    const Text('Test Complete!', style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white,
                      letterSpacing: 0.5, shadows: [Shadow(color: Colors.black, blurRadius: 12)],
                    )),
                    const SizedBox(height: 3),
                    Text('ⵜⴰⵎⵙⵉⵜⵏ ⵜⴻⵙⵙⵉⵡⴻⴹ', style: TextStyle(fontSize: 11, color: _C.goldLight.withOpacity(0.70), letterSpacing: 1.5)),
                    const SizedBox(height: 14),
                    // ✅ Smaller stars to save vertical space
                    _StarsRow(stars: stars),
                    const SizedBox(height: 14),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      _ScorePill(label: 'Correct', value: score,      color: _C.emerald),
                      const SizedBox(width: 10),
                      _ScorePill(label: 'Wrong',   value: 10 - score, color: _C.red),
                      const SizedBox(width: 10),
                      _ScorePill(label: 'Score',   value: score,      color: _C.gold, suffix: '/10'),
                    ]),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.12))),
                      child: Text(_message, textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.82), height: 1.45, letterSpacing: 0.3)),
                    ),
                    const SizedBox(height: 16),
                    Row(children: [
                      Expanded(child: _ActionBtn(label: 'Try Again', icon: Icons.refresh_rounded, isPrimary: false, onTap: onRetry)),
                      const SizedBox(width: 10),
                      Expanded(child: _ActionBtn(label: 'Home', icon: Icons.home_rounded, isPrimary: true, onTap: onHome)),
                    ]),
                  ]),
                ),
              ),
            ),

            // ── Wrong answers review — always fully visible ──────────────────
            if (wrongAnswers.isNotEmpty) ...[
              const SizedBox(height: 14),
              _WrongAnswersSection(wrongAnswers: wrongAnswers),
            ],

          ]),
        ),
      ),
    );
  }
}

class _StarsRow extends StatelessWidget {
  final int stars;
  const _StarsRow({required this.stars});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) {
      final filled = i < stars;
      return Padding(padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Icon(filled ? Icons.star_rounded : Icons.star_outline_rounded,
          color: filled ? _C.gold : Colors.white.withOpacity(0.22),
          size: 40, // ✅ reduced from 48 → saves ~24px vertical space
          shadows: filled ? [Shadow(color: _C.gold.withOpacity(0.70), blurRadius: 16)] : []));
    }));
  }
}

class _ScorePill extends StatelessWidget {
  final String label; final int value; final Color color; final String suffix;
  const _ScorePill({required this.label, required this.value, required this.color, this.suffix = ''});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.45)),
          boxShadow: [BoxShadow(color: color.withOpacity(0.20), blurRadius: 12)]),
        child: Text('$value$suffix', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color,
          shadows: [const Shadow(color: Colors.black, blurRadius: 8)])),
      ),
      const SizedBox(height: 6),
      Text(label, style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.50), letterSpacing: 0.5)),
    ]);
  }
}

class _ActionBtn extends StatelessWidget {
  final String label; final IconData icon; final bool isPrimary; final VoidCallback onTap;
  const _ActionBtn({required this.label, required this.icon, required this.isPrimary, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isPrimary ? const LinearGradient(colors: [_C.goldLight, _C.gold]) : null,
          color: isPrimary ? null : Colors.white.withOpacity(0.10),
          border: Border.all(color: isPrimary ? Colors.transparent : Colors.white.withOpacity(0.22)),
          boxShadow: isPrimary ? [BoxShadow(color: _C.gold.withOpacity(0.35), blurRadius: 16)] : [],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 20, color: isPrimary ? _C.navy : Colors.white),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800,
            color: isPrimary ? _C.navy : Colors.white, letterSpacing: 0.5)),
        ]),
      ),
    );
  }
}

class _WrongAnswersSection extends StatelessWidget {
  final List<_Question> wrongAnswers;
  const _WrongAnswersSection({required this.wrongAnswers});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(22),
            color: Colors.white.withOpacity(0.07),
            border: Border.all(color: _C.red.withOpacity(0.30), width: 1)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 3, height: 14, decoration: BoxDecoration(
                color: _C.red, borderRadius: BorderRadius.circular(2),
                boxShadow: [BoxShadow(color: _C.red.withOpacity(0.5), blurRadius: 6)])),
              const SizedBox(width: 8),
              Text('Review · ${wrongAnswers.length} Missed', style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.55), letterSpacing: 0.8)),
            ]),
            const SizedBox(height: 14),
            Wrap(spacing: 10, runSpacing: 10,
              children: wrongAnswers.map((q) => _MissedChip(question: q)).toList()),
          ]),
        ),
      ),
    );
  }
}

class _MissedChip extends StatelessWidget {
  final _Question question;
  const _MissedChip({required this.question});
  @override
  Widget build(BuildContext context) {
    final l = question.correct;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: _C.red.withOpacity(0.12), borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.red.withOpacity(0.30))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(l.letter, style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold, height: 1.0)),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
          Text(l.en,   style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.55))),
        ]),
      ]),
    );
  }
}

// ── Glass button ──────────────────────────────────────────────────────────────
class _GlassBtn extends StatelessWidget {
  final Widget child; final VoidCallback onTap;
  const _GlassBtn({required this.child, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,
      child: Container(
        width: 42, height: 42,
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white.withOpacity(0.20))),
        child: Center(child: child),
      ),
    );
  }
}

// ── Dot painter ───────────────────────────────────────────────────────────────
class _DotPainter extends CustomPainter {
  final double progress;
  const _DotPainter(this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final rng   = Random(7);
    for (int i = 0; i < 48; i++) {
      final bx = rng.nextDouble() * size.width;
      final by = rng.nextDouble() * size.height;
      final r  = 1.2 + rng.nextDouble() * 2.6;
      final sp = 0.12 + rng.nextDouble() * 0.28;
      final ph = rng.nextDouble() * pi * 2;
      final al = 0.04 + rng.nextDouble() * 0.09;
      final x  = bx + sin(progress * pi * 2 * sp + ph) * 7;
      final y  = by + cos(progress * pi * 2 * sp * 0.6 + ph) * 5;
      paint.color = _C.green.withOpacity(al);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }
  @override
  bool shouldRepaint(_DotPainter old) => old.progress != progress;
}