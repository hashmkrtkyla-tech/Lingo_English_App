class LanguageModel {
  final String code, nameAr, native, flag;
  const LanguageModel(
      {required this.code,
      required this.nameAr,
      required this.native,
      required this.flag});

  factory LanguageModel.fromJson(Map<String, dynamic> j) => LanguageModel(
      code: j['code'],
      nameAr: j['nameAr'],
      native: j['native'],
      flag: j['flag']);
}
