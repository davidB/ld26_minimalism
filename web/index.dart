import 'dart:html';
import 'dart:math' as math;
import 'dart:async';
import 'package:web_ui/web_ui.dart';
import 'package:ld48/ld48.dart';

var abbrevs = new AbbrevsSelection();

@observable
var abbrevsSelected = new List();

@observable
var abbrev = "";

@observable
var abbrevSample = "";

@observable
var lastStepText = "";

@observable
var scSlowest = 0;

@observable
var scFastest = 0;

@observable
var scPlayer = 0;

var sortedSelected = null;

var player1;

var pFastest;

var pSlowest;

@observable
var levels = ["1","2","3","4","5","6","7","8","9","10"];
@observable
get level => _level.toString();
@observable
set level(String s) {window.location.hash = "/a/${category}/${s}";}
var _level = 1;

var rHide = new math.Random();

var _bonusPlayed = -1;
var _bonusTimer = null;

@observable
var categories = ['smiley', 'gaming', 'forum', 'chat' ];
@observable
get category => _category;
@observable
set category(String s) {window.location.hash = "/a/${s}/${level}";}
var _category = "";
var _abbrevsOfCategory = new Future.value(new List());

get scoreR {
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
    _setupRoutes();
  //});
}
void _setupRoutes() {
  Window.hashChangeEvent.forTarget(window).listen((e) {
    _route(window.location.hash);
  });
  _route(window.location.hash);
}

void _route(String hash) {
  RegExp exp = new RegExp(r"#/a/(\w+)/(\d+)");
  var m = exp.firstMatch(hash);
  if (m != null) {
    var cat = m.group(1);
    _level = math.min(10, math.max(1, int.parse(m.group(2))));
    if (cat != category) {
      category = cat;
      _abbrevsOfCategory = Abbrevs.generateFromCategoryPage(cat);
    }
    _reset();
  } else {
    window.location.hash = '/a/${categories[0]}/${levels[0]}';
  }
}
//TODO make testcase (with random generator of k : ala QuickCheck)
bool tryAbbrev() {
  var k = abbrev;
  var a = (k.isEmpty)? null : abbrevs.tryAbbrev(k);
  if (a == null && (_bonusPlayed == 0)&& abbrevs.abbrevBonus.short == k) {
    a = abbrevs.abbrevBonus;
    _bonusPlayed = 1;
  }
  scPlayer = player1.step(a);
  scFastest = pFastest.stepNext();
  scSlowest = pSlowest.stepNext();
  var railsW = toWPixel(query("#rails"));
  player1.positionLeft(railsW);
  pFastest.positionLeft(railsW);
  pSlowest.positionLeft(railsW);
  if (a != null) {
    queryAll(".abb_${a.id}").forEach((Element abbrevEl){
      abbrevEl.classes.remove("show0");
      abbrevEl.classes.add("hide${rHide.nextInt(6)}");
    });
  }
  lastStepText = (a == null)? "'${abbrev}' not found = +0":"'${a.long}' x ${a.nbOccurences} = +${a.score}";
  abbrev = '';
  if (player1.isFinished) _finish();
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

_reset() {
  abbrev = "";
  _abbrevsOfCategory.then(_reset0);
}

_reset0(l) {
  abbrevs.selectFrom(l, ratio: _level/10);
  var total = abbrevs.selected.fold(0, (acc, a) => acc += a.score);
  var sortedSelected = abbrevs.selected.toList(growable: false)..sort(Abbrev.compareScore);
  abbrevSample = sortedSelected.isEmpty ? '' : sortedSelected[0].short;
  _bonusPlayed = -1;
  if (_bonusTimer != null){
    _bonusTimer.cancel();
    _bonusTimer = null;
  }
  abbrevsSelected = abbrevs.selected2;
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

_finish() {
  print("FINISH");
  if (_bonusTimer != null){
    _bonusTimer.cancel();
    _bonusTimer = null;
  }
}