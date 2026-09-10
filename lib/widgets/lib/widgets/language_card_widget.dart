import 'package:flutter/material.dart';
import '../data/language_config.dart';

class LanguageCardWidget extends StatelessWidget {
  final LanguageOption language;
  final VoidCallback onTap;

  const LanguageCardWidget({
    super.key,
    required this.language,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool locked = !language.isAvailable;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: locked ? 0.4 : 1.0,
                    child: Text(language.flagEmoji, style: const TextStyle(fontSize: 46)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    language.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: locked ? Colors.grey : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            if (locked)
              const Positioned(
                top: 8,
                left: 8,
                child: Icon(Icons.lock_outline_rounded, color: Colors.grey, size: 18),
              ),
          ],
        ),
      ),
    );
  }
}
