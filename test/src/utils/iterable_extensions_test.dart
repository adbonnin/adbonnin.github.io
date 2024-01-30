import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/src/utils/iterable_extensions.dart';

void main() {
  group("ListExtension", () {
    test("should set the length", () {
      expect([0, 1, 2].setLength(2, (i) => i), equals([0, 1]));
      expect([0, 1, 2].setLength(5, (i) => i), equals([0, 1, 2, 3, 4]));
    });
  });
}
