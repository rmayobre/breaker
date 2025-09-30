import 'package:flutter/widgets.dart';

import 'window_type.dart';

final class WindowModel<T extends WindowType> extends InheritedWidget {
  const WindowModel({
    super.key,
    required this.type,
    required super.child
  });

  static WindowModel<T>? maybeOf<T extends WindowType>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  final T type;

  @override
  bool updateShouldNotify(covariant WindowModel oldWidget) => type != oldWidget.type;
}