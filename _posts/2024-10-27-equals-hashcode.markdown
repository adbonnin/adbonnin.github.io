---
layout: post
title:  "Equals et hashcode"
date:   2024-10-27 11:26:10 +0100
categories: flutter code
---

Equals:

```dart
@override
int get hashCode => style.hashCode;
```

Hashcode:

```dart
@override
bool operator ==(Object other) {
  if (identical(this, other)) {
    return true;
  }
  if (other.runtimeType != runtimeType) {
    return false;
  }
  return other is FilledButtonThemeData && other.style == style;
}
```

[packages/flutter/lib/src/material/filled_button_theme.dart]: https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/filled_button_theme.dart
