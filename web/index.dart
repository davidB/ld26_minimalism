import 'dart:html';
import 'dart:math' as math;
import 'dart:async';
import 'package:web_ui/web_ui.dart';
import 'package:ld48/ld48.dart';
import 'package:simple_audio/simple_audio.dart';

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
var level = 1;

var rHide = new math.Random();

var _bonusPlayed = -1;
var _bonusTimer = null;

@observable
var categories = ['smiley', 'gaming', 'forum', 'chat' ];
@observable
var category = "";
var _abbrevsOfCategory = new Future.value(new List());

AudioManager _audioManager = null;
//var _worldRenderSystem;
//var _hudRenderSystem;

get masterMute => _audioManager == null ? "0" : _audioManager.mute;
set masterMute(v) {if (_audioManager == null) return; _audioManager.mute = v; }
get masterVolume => _audioManager == null ? "0" :_audioManager.masterVolume.toString();
set masterVolume(v) { if (_audioManager == null) return; _audioManager.masterVolume = double.parse(v) ; }
get musicVolume => _audioManager == null ? "0" :_audioManager.musicVolume.toString();
set musicVolume(v) { if (_audioManager == null) return; _audioManager.musicVolume = double.parse(v) ; }
get sourceVolume => _audioManager == null ? "0" : _audioManager.sourceVolume.toString();
set sourceVolume(v) { if (_audioManager == null) return; _audioManager.sourceVolume = double.parse(v) ; }
//get scoreR {
//  return math.max(0, pSlowest.nbStep - player1.nbStep) * 100 /math.max(1, pFastest.nbStep - pSlowest.nbStep);
//}
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
    //new Timer(const Duration(), () {
      _audioManager = newAudioManager();
    //});
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
    level = math.min(10, math.max(1, int.parse(m.group(2))));
    if (cat != category) {
      category = cat;
      _abbrevsOfCategory = Abbrevs.generateFromCategoryPage(cat);
    }
    reset();
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
  scPlayer = player1.step(a).toInt();
  scFastest = pFastest.stepNext().toInt();
  scSlowest = pSlowest.stepNext().toInt();
  var railsW = toWPixel(query("#rails"));
  player1.positionLeft(railsW);
  pFastest.positionLeft(railsW);
  pSlowest.positionLeft(railsW);
  if (a != null) {
    queryAll(".abb_${a.id}").forEach((Element abbrevEl){
      abbrevEl.classes.remove("show0");
      abbrevEl.classes.add("hide${rHide.nextInt(6)}");
    });
  } else {
    playCoinSound();
  }
  lastStepText = (a == null)? "'${abbrev}' not found = +0":"'${a.long}' x ${a.nbOccurences} = +${a.score}";
  abbrev = '';
  if (player1.isFinished || pFastest.isFinished || pSlowest.isFinished) _finish();
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
  _abbrevsOfCategory.then(_reset0);
}

_reset0(l) {
  abbrevs.selectFrom(l, ratio: level/10);
  var total = abbrevs.selected.fold(0, (acc, a) => acc += a.score) * 0.75;
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
  var el = query('#runresult_dialog');
  el.style.visibility = "visible";
  el.xtag.show();
  if (_bonusTimer != null){
    _bonusTimer.cancel();
    _bonusTimer = null;
  }
}

String findBaseUrl() {
  String location = window.location.pathname;
  int slashIndex = location.lastIndexOf('/');
  if (slashIndex < 0) {
    return '/';
  } else {
    return location.substring(0, slashIndex);
  }
}

var snddefs = [
   "1,,0.0769,0.5058,0.3492,0.4109,,,,,,0.3014,0.5982,,,,,,1,,,,,0.5",
   "0,,0.0304,0.5968,0.3597,0.4033,,,,,,0.5875,0.5816,,,,,,1,,,,,0.5",
   "0,,0.01,0.425,0.4598,0.725,,,,,,0.2781,0.5226,,,,,,1,,,,,0.5",
   "0,,0.0853,0.3454,0.4048,0.6396,,,,,,0.5753,0.5561,,,,,,1,,,,,0.5",
   "0,,0.1088,,0.1969,0.2376,,0.3673,,,,,,0.5446,,0.4156,,,1,,,,,0.5",
   "0,,0.25,,0.4908,0.3207,,0.3852,,,,,,0.3595,,0.6301,,,1,,,,,0.5",
   "1,,0.2849,,0.1339,0.4261,,0.4938,,,,,,,,0.6863,,,1,,,,,0.5",
   "3,,0.3245,0.5047,0.3143,0.0547,,0.2659,,,,,,,,,,,1,,,,,0.5",
   "0,,0.3341,,0.1518,0.42,,0.2433,,,,,,0.1835,,,,,0.5469,,,0.0103,,0.5",
   "0,,0.1091,,0.2994,0.5632,,0.1088,,,,,,0.3084,,,,,0.8766,,,,,0.5",
   "0,,0.0746,,0.3832,0.4597,,0.3346,,,,,,0.1457,,0.5706,,,1,,,,,0.5",
   "0,,0.0746,,0.3832,0.4597,,0.3346,,,,,,0.1457,,0.5706,,,1,,,,,0.5"
];
var sndNb = 0;
newAudioManager() {
	try {
		var audioManager = new AudioManager(findBaseUrl());
		audioManager.mute = false;
		audioManager.masterVolume = 1.0;
		audioManager.musicVolume = 0.1;
		audioManager.sourceVolume = 0.9;
		AudioClip musicClip = audioManager.makeClip('music0', 'music.ogg');
		musicClip.load().then((m) {
			audioManager.music.clip = m;
			audioManager.music.play();
		});
		AudioSource source = audioManager.makeSource('Source A');
		source.positional = false;
    new Timer(const Duration(seconds: 1), () {
      for(var i = 0; i < snddefs.length; i++) {
  		  var clipUrl = AudioClip.SFXR_PREFIX.concat(snddefs[i]);
  		  AudioClip clip = audioManager.makeClip('sound${i}', clipUrl);
  		  clip.load();
  		  sndNb++;
      }
    });
		return audioManager;
  } catch (e) {
  	print(e);
  	return null;
  }
}

playCoinSound() {
  if (_audioManager != null) _audioManager.playClipFromSource('Source A', 'sound${rHide.nextInt(sndNb)}');
}