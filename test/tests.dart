import 'dart:html';
import 'dart:async';
import 'dart:math' as math;
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

}