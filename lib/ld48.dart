library ld48;

import "dart:math" as math;
import "dart:html";

class Abbrev {
  final String short;
  final String long;
  final int nbOccurences;
  Abbrev(this.short, this.long, this.nbOccurences);

  get score => long.length * nbOccurences;

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
      b[i] = new Abbrev("short${i}", "long${i}", 1);
    }
    return b;
  }
}

class AbbrevsSelection {
  var _abbrevs = new Map<String,Abbrev>();
  get selected => _abbrevs.values;

  // return values in number of occurence
  get selected2 => shuffle(_abbrevs.values.expand((v) => new List.filled(v.nbOccurences, v)).toList());

  AbbrevsSelection() {
    _abbrevs.clear();
  }

  Abbrev tryAbbrev(String k) => _abbrevs.remove(k);

  //TODO improve shuffle
  void selectFrom(List<Abbrev> l, {num ratio : 0.7, int maxOccurences : 3}) {
    _abbrevs.clear();
    shuffle(l);
    var r = new math.Random();
    // select the n firsts of the list
    var nb = (l.length.toDouble() * ratio) - 1;
    for (var i = nb.toInt(); i > 0; i--) {
      var a = l[i];
      _abbrevs[a.short] = new Abbrev(a.short, a.long, 1 + r.nextInt(maxOccurences - 1));
    }
    print("abbrevs.size : ${_abbrevs.length}");
  }

}

double toPixel(String s) {
  if (s.endsWith("px")) {
    return double.parse(s.substring(0, s.length - 2));
  }
  return 0.0;
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
  var elW;

  Player(this.id) {
    el = query("#${id}");
    elW = toPixel(el.query("object").getComputedStyle().width);
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
    el.style.left = "${(railsW - elW / 2) * ratio}px";
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