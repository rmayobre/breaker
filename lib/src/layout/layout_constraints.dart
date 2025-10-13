final class LayoutConstraints {

  const LayoutConstraints({
    this.body,
    required this.span,
    required this.spanSize,
    required this.margin,
    required this.spacing,
  });

  final double? body;
  final int span;
  final double spanSize;
  final double margin;
  final double spacing;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LayoutConstraints && runtimeType == other.runtimeType &&
              body == other.body && span == other.span &&
              spanSize == other.spanSize && margin == other.margin &&
              spacing == other.spacing;

  @override
  int get hashCode =>
      Object.hash(
          body,
          span,
          spanSize,
          margin,
          spacing);

  @override
  String toString() {
    return 'LayoutConstraints{'
        'body: $body, '
        'span: $span, '
        'spanSize: $spanSize, '
        'margin: $margin, '
        'spacing: $spacing}';
  }
}