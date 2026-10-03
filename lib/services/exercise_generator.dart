import 'dart:math';

/// مفهوم واحد (كلمة أو جملة) بلغة واحدة
class PackConcept {
  final String t; // النص كما يُعرض
  final String h; // تلميح نطق (اختياري)
  final List<String> words; // الكلمات (تُستخرج تلقائياً، أو تُكتب يدوياً بالمفتاح w)
  final List<int> gaps; // أماكن الفراغ المفضلة في تمارين "أكمل" (المفتاح g)

  const PackConcept(this.t, this.h, this.words, this.gaps);

  static final RegExp _edge =
      RegExp(r'^[\s.,!?;:،؛؟"()«»]+|[\s.,!?;:،؛؟"()«»]+$');

  static List<String> tokenize(String t) => t
      .split(RegExp(r'\s+'))
      .map((w) => w.replaceAll(_edge, ''))
      .where((w) => w.isNotEmpty)
      .toList();

  /// الشكل المختصر: "hello": "Hello"
  /// أو الكامل:     "hello": {"t":"Hello","h":"/həˈloʊ/","g":[1],"w":["Hel","lo"]}
  factory PackConcept.fromJson(dynamic j) {
    if (j is String) return PackConcept(j, '', tokenize(j), const []);
    final m = Map<String, dynamic>.from(j as Map);
    final t = m['t'] as String;
    return PackConcept(
      t,
      (m['h'] ?? '') as String,
      m['w'] != null ? List<String>.from(m['w'] as List) : tokenize(t),
      m['g'] != null ? List<int>.from(m['g'] as List) : const [],
    );
  }
}

/// حزمة نصوص لغة واحدة لمستوى واحد
class LangPack {
  final String joiner; // ' ' للأغلب، و'' لليابانية والصينية
  final Map<String, String> titles; // عناوين الدروس
  final Map<String, PackConcept> concepts;

  LangPack(this.joiner, this.titles, this.concepts);

  factory LangPack.fromJson(Map<String, dynamic> j) {
    final c = <String, PackConcept>{};
    (j['c'] as Map<String, dynamic>)
        .forEach((k, v) => c[k] = PackConcept.fromJson(v));
    return LangPack(
      (j['joiner'] ?? ' ') as String,
      Map<String, String>.from((j['titles'] ?? {}) as Map),
      c,
    );
  }
}

class _Gap {
  final String sentence;
  final List<String> blanks;
  _Gap(this.sentence, this.blanks);
}

/// يبني تمارين الدرس الفعلية (بنفس صيغة ExerciseModel) من:
/// هيكل الدرس (محايد للغة) + حزمة لغة التعلم + حزمة لغة المستخدم الأم
class ExerciseGenerator {
  final LangPack tgt; // لغة التعلم
  final LangPack nat; // لغة المستخدم الأم
  final Random _r = Random();

  ExerciseGenerator(this.tgt, this.nat);

  bool _ok(String id) =>
      tgt.concepts.containsKey(id) && nat.concepts.containsKey(id);

  /// كل المفاهيم المذكورة في الدرس (لاختيار مشتّتات منها)
  List<String> poolOf(List<Map<String, dynamic>> raw) {
    final s = <String>{};
    for (final e in raw) {
      if (e['c'] != null) s.add(e['c'] as String);
      if (e['cs'] != null) s.addAll(List<String>.from(e['cs'] as List));
      if (e['d'] != null) s.addAll(List<String>.from(e['d'] as List));
    }
    return s.where(_ok).toList();
  }

  /// يُرجع null إذا نقص نص في إحدى اللغتين (يُتخطى التمرين بصمت)
  Map<String, dynamic>? build(Map<String, dynamic> e, List<String> pool) {
    try {
      switch (e['t']) {
        case 'choice':
          return _choice(e, pool);
        case 'build':
          return _build(e, pool);
        case 'fill':
          return _fill(e, pool);
        case 'listenpick':
          return _listenPick(e, pool);
        case 'typeword':
          return _typeWord(e);
        case 'speak':
          return _speak(e);
        case 'match':
          return _match(e);
      }
    } catch (_) {}
    return null;
  }

  // ---------- أدوات مساعدة ----------

  List<String> _pickIds(dynamic given, List<String> pool, String exclude, int n) {
    final out = <String>[
      ...(given == null ? <String>[] : List<String>.from(given as List))
    ].where(_ok).toList();
    final rest = pool.where((p) => p != exclude && !out.contains(p)).toList()
      ..shuffle(_r);
    while (out.length < n && rest.isNotEmpty) {
      out.add(rest.removeLast());
    }
    return out.take(n).toList();
  }

  List<String> _wordDistractors(LangPack p, dynamic given, List<String> pool,
      String exclude, List<String> avoid, int n) {
    final out = <String>[];
    void add(String w) {
      if (out.length < n && !avoid.contains(w) && !out.contains(w)) out.add(w);
    }

    if (given != null) {
      for (final id in List<String>.from(given as List)) {
        final c = p.concepts[id];
        if (c != null && c.words.length == 1) add(c.words.first);
      }
    }
    final all = <String>[];
    for (final id in pool) {
      if (id == exclude) continue;
      final c = p.concepts[id];
      if (c != null) all.addAll(c.words);
    }
    all.shuffle(_r);
    for (final w in all) {
      add(w);
    }
    return out;
  }

  int _defaultGap(List<String> w) {
    var best = w.length > 1 ? 1 : 0;
    for (var i = 0; i < w.length; i++) {
      if (i == 0 && w.length > 1) continue;
      if (w[i].length > w[best].length) best = i;
    }
    return best;
  }

  _Gap _gap(PackConcept c, String joiner, {bool single = false}) {
    var g = c.gaps.isNotEmpty ? [...c.gaps] : [_defaultGap(c.words)];
    if (single) g = [g.first];
    g = g.where((i) => i >= 0 && i < c.words.length).toList()..sort();
    final parts = <String>[];
    for (var i = 0; i < c.words.length; i++) {
      parts.add(g.contains(i) ? '___' : c.words[i]);
    }
    final endP =
        RegExp(r'[.!?؟。！？]$').firstMatch(c.t.trim())?.group(0) ?? '';
    var s = parts.join(joiner);
    if (endP.isNotEmpty) s += (joiner.isEmpty ? '' : ' ') + endP;
    return _Gap(s, g.map((i) => c.words[i]).toList());
  }

  // ---------- أنواع التمارين ----------

  /// {"t":"choice","c":"hello","dir":"t2n","big":true,"d":["thanks","yes"]}
  /// dir: t2n = تظهر كلمة اللغة المتعلَّمة والخيارات بلغتك، n2t = العكس
  Map<String, dynamic> _choice(Map<String, dynamic> e, List<String> pool) {
    final id = e['c'] as String;
    final t2n = (e['dir'] ?? 't2n') == 't2n';
    final tc = tgt.concepts[id]!, nc = nat.concepts[id]!;
    final ansPack = t2n ? nat : tgt;
    final ids = _pickIds(e['d'], pool, id, 2);
    final opts = <String>[ansPack.concepts[id]!.t];
    for (final d in ids) {
      opts.add(ansPack.concepts[d]!.t);
    }
    return {
      'type': 'choice',
      'layout': e['big'] == true ? 'bigcard' : 'plain',
      'prompt': t2n ? tc.t : nc.t,
      'hint': t2n ? tc.h : '',
      'promptLang': t2n ? 'target' : 'native',
      'audio': t2n ? tc.t : '',
      'audioLang': 'target',
      'answerLang': t2n ? 'native' : 'target',
      'options': opts,
      'answer': opts.first,
      'meaning': nc.t,
    };
  }

  /// {"t":"build","c":"my_name_is","dir":"n2t|t2n|audio","d":["friend","country"]}
  Map<String, dynamic> _build(Map<String, dynamic> e, List<String> pool) {
    final id = e['c'] as String;
    final dir = (e['dir'] ?? 'n2t') as String;
    final tc = tgt.concepts[id]!, nc = nat.concepts[id]!;
    final ansTarget = dir != 't2n';
    final ansPack = ansTarget ? tgt : nat;
    final words = ansPack.concepts[id]!.words;
    final dis = _wordDistractors(ansPack, e['d'], pool, id, words, 2);
    return {
      'type': 'build',
      'prompt': dir == 'n2t' ? nc.t : (dir == 't2n' ? tc.t : ''),
      'promptLang': dir == 'n2t' ? 'native' : 'target',
      'promptIsAudio': dir == 'audio',
      'audio': dir == 'n2t' ? '' : tc.t,
      'audioLang': 'target',
      'answerLang': ansTarget ? 'target' : 'native',
      'joiner': ansPack.joiner,
      'words': words,
      'distractors': dis,
      'meaning': nc.t,
    };
  }

  /// {"t":"fill","c":"good_morning"}  (مكان الفراغ من g في حزمة اللغة)
  Map<String, dynamic> _fill(Map<String, dynamic> e, List<String> pool) {
    final id = e['c'] as String;
    final tc = tgt.concepts[id]!, nc = nat.concepts[id]!;
    final g = _gap(tc, tgt.joiner);
    final n = max(1, 4 - g.blanks.length);
    final dis = _wordDistractors(tgt, e['d'], pool, id, tc.words, n);
    return {
      'type': 'fill',
      'sentence': g.sentence,
      'audio': tc.t,
      'blanks': g.blanks,
      'distractors': dis,
      'meaning': nc.t,
    };
  }

  /// {"t":"listenpick","c":"nice_meet"}
  Map<String, dynamic> _listenPick(Map<String, dynamic> e, List<String> pool) {
    final id = e['c'] as String;
    final tc = tgt.concepts[id]!, nc = nat.concepts[id]!;
    final g = _gap(tc, tgt.joiner, single: true);
    final dis = _wordDistractors(tgt, e['d'], pool, id, tc.words, 1);
    if (dis.isEmpty) throw StateError('no distractor');
    return {
      'type': 'listenpick',
      'sentence': g.sentence,
      'audio': tc.t,
      'options': [g.blanks.first, dis.first],
      'answer': g.blanks.first,
      'meaning': nc.t,
    };
  }

  /// {"t":"typeword","c":"how_are_you"}
  Map<String, dynamic> _typeWord(Map<String, dynamic> e) {
    final id = e['c'] as String;
    final tc = tgt.concepts[id]!, nc = nat.concepts[id]!;
    final g = _gap(tc, tgt.joiner, single: true);
    return {
      'type': 'typeword',
      'sentence': g.sentence,
      'audio': tc.t,
      'answer': g.blanks.first,
      'meaning': nc.t,
    };
  }

  /// {"t":"speak","c":"hello"}
  Map<String, dynamic> _speak(Map<String, dynamic> e) {
    final id = e['c'] as String;
    return {
      'type': 'speak',
      'sentence': tgt.concepts[id]!.t,
      'meaning': nat.concepts[id]!.t,
    };
  }

  /// {"t":"match","cs":["hello","goodbye","thanks","please"]}
  Map<String, dynamic> _match(Map<String, dynamic> e) {
    final ids = List<String>.from(e['cs'] as List);
    return {
      'type': 'match',
      'layout': (e['layout'] ?? 'audio') as String,
      'pairs': ids.map((i) => [tgt.concepts[i]!.t, nat.concepts[i]!.t]).toList(),
    };
  }
}
