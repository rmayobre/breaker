import '../window/window_type.dart';

enum WindowClass implements WindowType {
  compact(panes: 1),
  medium(panes: 2),
  expanded(panes: 2),
  large(panes: 2),
  xlarge(panes: 3);

  const WindowClass({required this.panes});

  @override
  final int panes;
}