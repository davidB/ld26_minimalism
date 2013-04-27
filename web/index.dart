import 'dart:html';
import 'dart:math' as math;
import 'dart:async';
import 'package:web_ui/web_ui.dart';
import 'package:ld48/ld48.dart';

@observable
var abbrevs = new AbbrevsSelection();

@observable
var abbrev = "";

var scope = 2/3;
var sortedSelected = null;

var player1;

var pFastest;

var pSlowest;

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
bool tryAbbrev([String k]) {
  if (k == null) k = abbrev;

  var a = (k.isEmpty)? null : abbrevs.tryAbbrev(k);
  player1.step(a);
  pFastest.stepNext();
  pSlowest.stepNext();
  var railsW = toPixel(query("#rails").getComputedStyle().width);
  player1.positionLeft(railsW);
  pFastest.positionLeft(railsW);
  pSlowest.positionLeft(railsW);
  //query("#${pFastest.id}").style.left = pFastest.percent;
  //query("#${pSlowest.id}").style.left = pSlowest.percent;
  return false;
}

reset() {
  abbrev = "";
  abbrevs.selectFrom(Abbrevs.generateTestSL(50));
  var total = abbrevs.selected.fold(0, (acc, a) => acc += a.score) * scope;
  var sortedSelected = abbrevs.selected.toList(growable: false)..sort(Abbrev.compareScore);

  print("ll ${sortedSelected.length}");

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