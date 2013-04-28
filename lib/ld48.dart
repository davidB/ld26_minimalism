library ld48;

import "dart:math" as math;
import "dart:html";
import "dart:crypto";

class Abbrev {
  final String short;
  final String long;
  final int nbOccurences;
  Abbrev(this.short, this.long, this.nbOccurences);

  get score => long.length * nbOccurences;
  get id => CryptoUtils.bytesToHex(short.codeUnits);

  static int compareScore(Abbrev a, Abbrev b) {
    if (b.score > a.score) return 1;
    if (b.score < a.score) return -1;
    return 0;
  }
}

class Abbrevs {
  static List<Abbrev> generateTestSL(int nb)  {
    var b  = new List<Abbrev>(nb);
    for (var i = 0; i < nb; i++) {
      b[i] = new Abbrev("s${i}", "long${i}", 1);
    }
    return b;
  }

  //https://raw.github.com/wiki/davidB/ld48_minimalism/cat_test.md
  static List<Abbrev> generateFromCSV(String s)  {
    var b  = new List<Abbrev>();
    return b;
  }
}

class AbbrevsSelection {
  var _abbrevs = new Map<String,Abbrev>();
  var _abbrevBonus = null;

  get selected => _abbrevs.values;
  get abbrevBonus => _abbrevBonus;

  // return values in number of occurence
  get selected2 => shuffle(_abbrevs.values.expand((v) => new List.filled(v.nbOccurences, v)).toList());

  AbbrevsSelection() {
    _abbrevs.clear();
  }

  Abbrev tryAbbrev(String k) => _abbrevs.remove(k);

  //TODO improve shuffle
  void selectFrom(List<Abbrev> l, {num ratio : 0.8, int maxOccurences : 3}) {
    _abbrevs.clear();
    shuffle(l);
    var r = new math.Random();
    // select the n firsts of the list
    var nb = ((l.length - 1).toDouble() * ratio);
    for (var i = nb.toInt(); i > 0; i--) {
      var a = l[i];
      _abbrevs[a.short] = new Abbrev(a.short, a.long, 1 + r.nextInt(maxOccurences));
    }
    _abbrevBonus = new Abbrev(l[0].short, l[0].long, maxOccurences + 3);
  }

}

double toPixel(String s) {
  if (s.endsWith("px")) {
    return double.parse(s.substring(0, s.length - 2));
  }
  return 0.0;
}

double toWPixel(Element el) {
  var b = 0.0;
  try {
    b = toPixel(el.getComputedStyle('').width);
  } catch(e) {
    try {
      b = el.clientWidth.toDouble();
    } catch(e) {
    }
  }
  return b;
}


List shuffle(List l) {
  var r = new math.Random();
  //shuffle the list
  var lg = l.length;
  for(var nbPermuttation = r.nextInt(lg~/2 + 1); nbPermuttation > 0; nbPermuttation--) {
    var i1 = r.nextInt(lg);
    var i2 = r.nextInt(lg);
    var atmp = l[i2];
    l[i2] = l[i1];
    l[i1] = atmp;
  }
  return l;
}

class Player {
  final String id;
  var _total;
  var _lastStepText;
  var _progression;
  var _nbStep;
  var el;
  var _elW = -1;

  Player(this.id) {
    el = query("#${id}");
    reset(1);
  }


  get percent => "${(_progression * 100) / _total}%";
  get ratio => _progression / _total;
  get nbStep => _nbStep;
  get isFinished => _progression == _total;
  get progression => _progression;
  //@observable
  get lastStepText => _lastStepText;

  bool step(Abbrev a) {
    if (isFinished) return false;
    _nbStep++;
    if (a == null) {
      _lastStepText = " !! :-( !! ";
      _progression += 0;
    } else {
      _lastStepText = "${a.long.length} x ${a.nbOccurences} = ${a.score}";
      _progression += a.score;
    }
    _progression = math.min(_progression, _total);
    if (isFinished) {
      _lastStepText = "HOURRA !";
    }
    return true;
  }

  positionLeft(double railsW) {
    if (_elW <= 0.0) _elW = toWPixel(query("#${id} object")); //lazy
    if (_elW <= 0.0) _elW = toWPixel(el); //lazy (workaround for FF)
    if (railsW <= 0 || _elW <= 0) {
      print("fallback to % ${railsW} ${_elW}");
      el.style.left = "${ratio * 90}%";
    } else {
      el.style.left = "${(railsW - _elW / 2) * ratio}px";
    }
  }

  void reset(total) {
    _total = math.max(total, 1);
    _nbStep = 0;
    _lastStepText = "";
    _progression = 0;
  }
}

class PlayerIA extends Player {
  List<Abbrev> sequence;
  int _idx = 0;

  PlayerIA(id): super(id);

  void stepNext() {
    if (_idx < sequence.length) {
      step(sequence[_idx]);
      _idx++;
    }
  }

  void reset(total) {
    super.reset(total);
    _idx = 0;
  }
}