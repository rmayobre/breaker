import '../../breaker.dart';
import '../window/navigation_type.dart';

final List<WindowBreakpoint> materialWindowBreakpoints = const [
  WindowBreakpoint(
      maxWidth: 600,
      navigation: NavigationType.bottomBar,
      panes: 1
  ),
  WindowBreakpoint(
      minWidth: 600,
      maxWidth: 839,
      navigation: NavigationType.sideBar,
      panes: 2
  ),
  WindowBreakpoint(
    minWidth: 840,
    maxWidth: 1199,
    navigation: NavigationType.expandableSideBar,
    panes: 2,
  ),
  WindowBreakpoint(
    minWidth: 1200,
    maxWidth: 1599,
    navigation: NavigationType.expandableSideBar,
    panes: 2,
  ),
  WindowBreakpoint(
    minWidth: 1600,
    navigation: NavigationType.expandedSideBar,
    panes: 3,
  ),
];