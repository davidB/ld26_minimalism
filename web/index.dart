import 'dart:html';
import 'dart:math' as math;
import 'dart:async';
import 'package:web_ui/web_ui.dart';
import 'package:ld48/ld48.dart';

@observable
var abbrevs = new AbbrevsSelection();

@observable
var abbrev = "";

@observable
var abbrevSample = "";

@observable
var lastStepText = "";

var scope = 2/3;
var sortedSelected = null;

var player1;

var pFastest;

var pSlowest;

var rHide = new math.Random();

var _bonusPlayed = -1;
var _bonusTimer = null;

@observable
get score {
  if (player1 == null) return 0;
  while (!pSlowest.isFinished && !pFastest.isFinished){
    tryAbbrev('');
  }
  return math.max(0, pSlowest.nbStep - player1.nbStep) * 100 /math.max(1, pFastest.nbStep - pSlowest.nbStep);
}
/**
 * Learn about the Web UI package by visiting
 * http://www.dartlang.org/articles/dart-web-components/.
 */
void main() {
  // Enable this to use Shadow DOM in the browser.
  //useShadowDom = true;
  //new Timer(const Duration(), () {
    player1 = new Player("player1");
    pFastest = new PlayerIA("pFastest");
    pSlowest = new PlayerIA("pSlowest");
    reset();
  //});
}
//TODO make testcase (with random generator of k : ala QuickCheck)
bool tryAbbrev() {
  var k = abbrev;
  var a = (k.isEmpty)? null : abbrevs.tryAbbrev(k);
  if (a == null && (_bonusPlayed == 0)&& abbrevs.abbrevBonus.short == k) {
    a = abbrevs.abbrevBonus;
    _bonusPlayed = 1;
  }
  player1.step(a);
  pFastest.stepNext();
  pSlowest.stepNext();
  var railsW = toWPixel(query("#rails"));
  player1.positionLeft(railsW);
  pFastest.positionLeft(railsW);
  pSlowest.positionLeft(railsW);
  if (a != null) {
    abbrev = '';
    queryAll(".abb_${a.id}").forEach((Element abbrevEl){
      abbrevEl.classes.remove("show0");
      abbrevEl.classes.add("hide${rHide.nextInt(6)}");
    });
  }
  lastStepText = (a == null)? "not found = +0":"'${a.long}' x ${a.nbOccurences} = +${a.score}";
  if (player1.isFinished) finish();
  return false;
}

playBonus() {
  if (_bonusPlayed != -1) return;
  _bonusPlayed = 0;
  var el = new Element.tag("div");
  el.classes.add("abb_${abbrevs.abbrevBonus.id}");
  el.classes.add("abbrevBonus");
  el.style.top = "50%";
  el.style.right = "0%";
  el.text = abbrevs.abbrevBonus.long;
  query("#abbrevs").children.add(el);
  el.classes.add("playBonus");
}

reset() {
  abbrev = "";
  abbrevs.selectFrom(Abbrevs.generateTestSL(50));
  var total = abbrevs.selected.fold(0, (acc, a) => acc += a.score) * scope;
  var sortedSelected = abbrevs.selected.toList(growable: false)..sort(Abbrev.compareScore);
  abbrevSample = sortedSelected.isEmpty ? '' : sortedSelected[0].short;
  _bonusPlayed = -1;
  if (_bonusTimer != null){
    _bonusTimer.cancel();
    _bonusTimer = null;
  }

  // should take care of the width and height of sequence
  new Timer(const Duration(milliseconds:500), (){
    var r = new math.Random();
    var abs = query("#abbrevs");
    //var w = abs.clientWidth;
    //var h = abs.clientHeight;
    abs.children.forEach((Element abbrevEl){
      abbrevEl.classes.add("show0");
      abbrevEl.style.top = "${r.nextDouble() * 90}%";
      abbrevEl.style.left = "${r.nextDouble() * 90}%";
      // failed to use transform : run as expetec until we start animation that ignore previous translation,...
      //abbrevEl.style.transform = "translate(${((r.nextDouble() * 0.9) - 0.5)* w}px,${((r.nextDouble() * 0.9) - 0.5)* h}px)";
    });
    if (r.nextBool()) {
      var t = new Duration(seconds:r.nextInt(180) + 1);
      //var t = const Duration(seconds:1);
      _bonusTimer = new Timer(t, playBonus);
    }
  });

  player1.reset(total);

  pFastest.sequence = sortedSelected;
  pFastest.reset(total);

  pSlowest.sequence = sortedSelected.reversed.toList();
  pSlowest.reset(total);

  var railsW = toPixel(query("#rails").getComputedStyle().width);
  player1.positionLeft(railsW);
  pFastest.positionLeft(railsW);
  pSlowest.positionLeft(railsW);
}

finish() {
  print("FINISH");
  if (_bonusTimer != null){
    _bonusTimer.cancel();
    _bonusTimer = null;
  }
}