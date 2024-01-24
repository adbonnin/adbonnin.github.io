import 'package:intl/intl.dart';

extension NumberExtension on num {
  int countDigits() {
    var n = toInt();

    if (this == 0) {
      return 1;
    }

    var count = 0;

    while (n != 0) {
      n = (n / 10).floor();
      ++count;
    }

    return count;
  }
}

class Numbers {
  Numbers._();

  static NumberFormat numberFormatFromDigits(int value) {
    final pattern = List.filled(value.countDigits(), '0').join('');
    return NumberFormat(pattern);
  }
}