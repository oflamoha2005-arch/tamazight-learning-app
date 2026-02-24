import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  SHARED ALPHABET DATA  —  alphabet_data.dart
//
//  Import this file in BOTH:
//    • alphabet_lesson_page.dart
//    • alphabet_test_page.dart
//
//  Usage:
//    import 'alphabet_data.dart';
// ═══════════════════════════════════════════════════════════════════════════════

/// Public model for a single Tifinagh letter.
/// Named with capital letter so it's accessible across files.
class AlphabetLetter {
  final String   letter;   // Tifinagh character  e.g. ⴰ
  final String   name;     // Latin name          e.g. Ya
  final String   example;  // Tifinagh word       e.g. ⴰⵎⵍⵍⴰⵍ
  final String   trans;    // Latin transcription  e.g. Amellal
  final String   en;       // English translation  e.g. White
  final IconData icon;     // Visual icon

  const AlphabetLetter({
    required this.letter,
    required this.name,
    required this.example,
    required this.trans,
    required this.en,
    required this.icon,
  });
}

/// Public list — accessible from any file that imports alphabet_data.dart
const List<AlphabetLetter> alphabetLetters = [
  AlphabetLetter(letter:'ⴰ', name:'Ya',   example:'ⴰⵎⵍⵍⴰⵍ', trans:'Amellal',  en:'White',         icon:Icons.circle_outlined),
  AlphabetLetter(letter:'ⴱ', name:'Yab',  example:'ⴱⴰⴱⴰ',   trans:'Baba',     en:'Father',        icon:Icons.person),
  AlphabetLetter(letter:'ⴳ', name:'Yag',  example:'ⴳⴰⵎⴰ',   trans:'Gama',     en:'Moon',          icon:Icons.nightlight_round),
  AlphabetLetter(letter:'ⴷ', name:'Yad',  example:'ⴷⴰⴷⴰ',   trans:'Dada',     en:'Elder brother', icon:Icons.people),
  AlphabetLetter(letter:'ⴹ', name:'Yaḍ',  example:'ⴹⴰⵕⴹⴰⵕ', trans:'Ḍarḍar',   en:'River',         icon:Icons.water),
  AlphabetLetter(letter:'ⴻ', name:'Ye',   example:'ⴻⵃⴻⴷ',   trans:'Ehed',     en:'One',           icon:Icons.looks_one),
  AlphabetLetter(letter:'ⴼ', name:'Yaf',  example:'ⴼⵓⵍⴽⵉ',  trans:'Fulki',    en:'Beautiful',     icon:Icons.star),
  AlphabetLetter(letter:'ⴽ', name:'Yak',  example:'ⴽⵔⴰ',    trans:'Kra',      en:'Something',     icon:Icons.category),
  AlphabetLetter(letter:'ⵀ', name:'Yah',  example:'ⵀⴰⵡ',    trans:'Haw',      en:'Here',          icon:Icons.back_hand),
  AlphabetLetter(letter:'ⵃ', name:'Yaḥ',  example:'ⵃⴰⵎⴰⵎ',  trans:'Ḥamam',   en:'Bath',          icon:Icons.bathtub),
  AlphabetLetter(letter:'ⵄ', name:'Yaɛ',  example:'ⵄⴰⵢⵏ',   trans:'ɛayn',     en:'Eye',           icon:Icons.visibility),
  AlphabetLetter(letter:'ⵅ', name:'Yax',  example:'ⵅⴰⵎ',    trans:'Xam',      en:'Tent',          icon:Icons.cabin),
  AlphabetLetter(letter:'ⵇ', name:'Yaq',  example:'ⵇⵇⵓⵔ',   trans:'Qqur',     en:'Heavy',         icon:Icons.fitness_center),
  AlphabetLetter(letter:'ⵉ', name:'Yi',   example:'ⵉⵍⵍ',    trans:'Ill',      en:'Sea',           icon:Icons.waves),
  AlphabetLetter(letter:'ⵊ', name:'Yaj',  example:'ⵊⵓⵊⵓ',   trans:'Juju',     en:'Chicken',       icon:Icons.egg_alt),
  AlphabetLetter(letter:'ⵍ', name:'Yal',  example:'ⵍⴽⵎ',    trans:'Lkem',     en:'Speak',         icon:Icons.record_voice_over),
  AlphabetLetter(letter:'ⵎ', name:'Yam',  example:'ⵎⵓⵙ',    trans:'Mus',      en:'Cat',           icon:Icons.pets),
  AlphabetLetter(letter:'ⵏ', name:'Yan',  example:'ⵏⵏⵉ',    trans:'Nni',      en:'Say',           icon:Icons.chat_bubble),
  AlphabetLetter(letter:'ⵐ', name:'Yaŋ',  example:'ⵐⵐⴰ',    trans:'Ŋŋa',      en:'Me',            icon:Icons.person_pin),
  AlphabetLetter(letter:'ⵓ', name:'Yu',   example:'ⵓⵔⵔⵉ',   trans:'Urri',     en:'Run',           icon:Icons.directions_run),
  AlphabetLetter(letter:'ⵔ', name:'Yar',  example:'ⵔⵓⵎⵉ',   trans:'Rumi',     en:'European',      icon:Icons.public),
  AlphabetLetter(letter:'ⵕ', name:'Yaṛ',  example:'ⵕⵕⴱⵉ',   trans:'Ṛṛbi',     en:'Spring',        icon:Icons.local_florist),
  AlphabetLetter(letter:'ⵙ', name:'Yas',  example:'ⵙⴽⴽⵓ',   trans:'Skku',     en:'Be quiet',      icon:Icons.volume_off),
  AlphabetLetter(letter:'ⵚ', name:'Yaṣ',  example:'ⵚⵓⵕⵜ',   trans:'Ṣuṛt',     en:'Picture',       icon:Icons.image),
  AlphabetLetter(letter:'ⵛ', name:'Yac',  example:'ⵛⵛⵛⵛ',   trans:'Cccc',     en:'Thing',         icon:Icons.help_outline),
  AlphabetLetter(letter:'ⵜ', name:'Yat',  example:'ⵜⴰⴼⵓⴽⵜ', trans:'Tafukt',   en:'Sun',           icon:Icons.wb_sunny),
  AlphabetLetter(letter:'ⵟ', name:'Yaṭ',  example:'ⵟⵟⴰⵍ',   trans:'Ṭṭal',     en:'Shadow',        icon:Icons.wb_shade),
  AlphabetLetter(letter:'ⵡ', name:'Yaw',  example:'ⵡⴰⵍ',    trans:'Wal',      en:'No',            icon:Icons.cancel),
  AlphabetLetter(letter:'ⵢ', name:'Yay',  example:'ⵢⴰⴼⵓ',   trans:'Yafu',     en:'Air',           icon:Icons.air),
  AlphabetLetter(letter:'ⵣ', name:'Yaz',  example:'ⵣⴰⵢⵢⴰⵏ', trans:'Zayyane',  en:'Magnificent',   icon:Icons.auto_awesome),
  AlphabetLetter(letter:'ⵥ', name:'Yaẓ',  example:'ⵥⵥⵓⵍ',   trans:'Ẓẓul',     en:'Strong',        icon:Icons.bolt),
  AlphabetLetter(letter:'ⵯ', name:'Yaw̱',  example:'ⵯⵉⵯⵉ',   trans:'W̱iw̱i',    en:'Bird',          icon:Icons.flutter_dash),
  AlphabetLetter(letter:'ⵖ', name:'Yaɣ',  example:'ⵖⵓⵔⴷⴰ',  trans:'Ɣurda',    en:'Rabbit',        icon:Icons.cruelty_free),
];