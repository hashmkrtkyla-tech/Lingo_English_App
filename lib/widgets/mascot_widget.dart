import 'package:flutter/material.dart';

// حالات تعبير التميمة - تُستخدم في كل شاشات التطبيق
enum MascotMood { happy, sad, waving, thinking, celebrating }

class MascotWidget extends StatelessWidget {
  final MascotMood mood;
  final double size;

  const MascotWidget({
    super.key,
    this.mood = MascotMood.happy,
    this.size = 90,
  });

  // إيموجي مؤقت لكل حالة - يمكن استبداله لاحقًا بصور SVG مخصصة للتميمة
  String get _emoji {
    switch (mood) {
      case MascotMood.happy:
        return '🦉';
      case MascotMood.sad:
        return '😔';
      case MascotMood.waving:
        return '👋';
      case MascotMood.thinking:
        return '🤔';
      case MascotMood.celebrating:
        return '🎉';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(_emoji, style: TextStyle(fontSize: size));
  }
}
