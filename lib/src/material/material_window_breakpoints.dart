import '../../breaker.dart';
import 'window_class.dart';

final List<WindowBreakpoint<WindowClass>> materialWindowBreakpoints = const [
  WindowBreakpoint(
    maxWidth: 600,
    window: WindowClass.compact,
  ),
  WindowBreakpoint(
    minWidth: 600,
    maxWidth: 839,
    window: WindowClass.medium,
  ),
  WindowBreakpoint(
    minWidth: 840,
    maxWidth: 1199,
    window: WindowClass.expanded,
  ),
  WindowBreakpoint(
    minWidth: 1200,
    maxWidth: 1599,
    window: WindowClass.large,
  ),
  WindowBreakpoint(
    minWidth: 1600,
    window: WindowClass.xlarge,
  ),
];