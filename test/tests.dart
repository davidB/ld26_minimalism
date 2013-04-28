import 'dart:html';
import 'dart:async';
import 'dart:math' as math;
import 'dart:json' as JSON;
import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'package:ld48/ld48.dart';

main() {
  useHtmlEnhancedConfiguration();
  group('Abbrevs', gAbbrevs);
  print('tests complete.');
}

gAbbrevs() {
  var areaId = "foo";

  test("generateTestSL should generate the nb of entry requested", () {
    var r = new math.Random();
    for (var i = 0; i < 10; i++) {
      var nb = r.nextInt(50);
      expect(Abbrevs.generateTestSL(nb).length, equals(nb));
    }
  });

  test("generateFromString", () {
    var abs = Abbrevs.generateFromString(sample);
    expect(abs.length, equals(87-34 + 1)); // number come from line numbers
  });

}

var sample = r"""
& Speechless 
& Tongue tied 
'( Crying 
') Crying with joy 
( Sad 
( Unhappy 
) Happy 
* Kiss 
*$ Starbucks 
*$$ Starbucks 
-( Sad 
-) Smile 
-* Kiss 
/ Sarcasm 
;( Crying 
;) Wink 
;-) Wink 
;D Wink 
;O Joking 
;P Winking and sticking tongue out 
< Frowning 
< Sad 
=) Happy 
=.= Tired 
=/= Not equal to 
=[ Sad 
=] Happy 
=W= Weezer 
>: Mischievous smile 
<3  a Heart        
?4U Question For You         
@NER8 At Any Rate        
@TEOTD  At The End Of The Day        
a/s/l Age / Sex / Location         
A3  Anyplace, Anywhere, Anytime        
AA  Ask About        
AAA Awesome Awesome Awesome        
AACT  Adults And Children Talking        
AAF Always And Forever         
AAF As A Friend        
AAG Almost Anything Goes         
AAIFTM  And All In For This Match (sports betting forums)        
AAK Asleep At the Keyboard         
AAM After All Men        
AAM All About Me         
AAN Another Author's Note        
AATP  All About The Paper        
ABH Anonymous Blow Hard        
ABK Any Body Killer        
ABM A Big Mistake        
ABOFAL  Alright, But Only For A Little         
ABP Already Been Posted        
ABS Albino BlackSheep        
ABT About
""";
