import 'package:flutter/material.dart';

enum NodeType { lesson, checkpoint, chest }
enum NodeState { completed, active, locked }

class PathNode {
  final String title;
  final IconData icon;
  final NodeType type;
  final NodeState state;

  PathNode({
    required this.title,
    required this.icon,
    this.type = NodeType.lesson,
    required this.state,
  });
}

class UnitData {
  final String title;
  final String subtitle;
  final Color color;
  final List<PathNode> nodes;

  UnitData({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.nodes,
  });
}

final Map<String, List<UnitData>> courseDataByLanguage = {
  'en': [_starterUnit('Greetings & Introductions', const Color(0xFF58CC02), 'Say Hello', 'Introduce Yourself')],
  'es': [_starterUnit('Saludos y Presentaciones', const Color(0xFFFF6B6B), 'Decir Hola', 'Preséntate')],
  'fr': [_starterUnit('Salutations et Présentations', const Color(0xFF4A6FE3), 'Dire Bonjour', 'Se Présenter')],
  'de': [_starterUnit('Begrüßungen & Vorstellung', const Color(0xFFFFC93C), 'Hallo Sagen', 'Sich Vorstellen')],
  'it': [_starterUnit('Saluti e Presentazioni', const Color(0xFF00B8A9), 'Dire Ciao', 'Presentarsi')],
  'ja': [_starterUnit('挨拶と自己紹介', const Color(0xFFE84393), 'こんにちは', '自己紹介')],
  'ko': [_starterUnit('인사와 소개', const Color(0xFF6C5CE7), '인사하기', '자기소개')],
  'tr': [_starterUnit('Selamlaşma ve Tanışma', const Color(0xFFFF7675), 'Merhaba De', 'Kendini Tanıt')],
  'ru': [_starterUnit('Приветствия и знакомство', const Color(0xFF0984E3), 'Поздороваться', 'Представиться')],
  'pt': [_starterUnit('Saudações e Apresentações', const Color(0xFF00CEC9), 'Dizer Olá', 'Apresentar-se')],
};

UnitData _starterUnit(String subtitle, Color color, String lesson1, String lesson2) {
  return UnitData(
    title: 'الوحدة 1',
    subtitle: subtitle,
    color: color,
    nodes: [
      PathNode(title: lesson1, icon: Icons.waving_hand_rounded, state: NodeState.active),
      PathNode(title: lesson2, icon: Icons.person_rounded, state: NodeState.locked),
    ],
  );
}
