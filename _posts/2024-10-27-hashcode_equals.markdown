---
layout: post
title:  "Hashcode et equals"
date:   2024-10-27 11:26:10 +0100
categories: flutter code
---

## Code:

Hashcode:

```dart
@override
int get hashCode => style.hashCode;
```

Equals:

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

## Reference:

- [packages/flutter/lib/src/material/filled_button_theme.dart](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/filled_button_theme.dart)
