class AlphabetLetter {
  final String letter;   // الحرف نفسه
  final String name;     // اسم الحرف المنطوق (مثال: "إيه" لحرف A)

  AlphabetLetter({required this.letter, required this.name});

  factory AlphabetLetter.fromJson(Map<String, dynamic> json) {
    return AlphabetLetter(
      letter: json['letter'] as String,
      name: json['name'] as String,
    );
  }
}
