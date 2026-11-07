import '../../breaker.dart';

/// Window breakpoints based on the Material Design window size classes.
///
/// Intended to be passed as the `breakpoints` of [BreakerWindow]. Widths are in
/// logical pixels; adjacent ranges share a boundary value and the first match
/// wins.
final List<WindowBreakpoint> materialWindowBreakpoints = const [
  WindowBreakpoint(
    maxWidth: 600,
    navigation: NavigationType.bottomBar,
    panes: 1,
  ),
  WindowBreakpoint(
    minWidth: 600,
    maxWidth: 839,
    navigation: NavigationType.sideBar,
    panes: 2,
  ),
  WindowBreakpoint(
    minWidth: 839,
    maxWidth: 1199,
    navigation: NavigationType.expandableSideBar,
    panes: 2,
  ),
  WindowBreakpoint(
    minWidth: 1199,
    maxWidth: 1599,
    navigation: NavigationType.expandableSideBar,
    panes: 2,
  ),
  WindowBreakpoint(
    minWidth: 1599,
    navigation: NavigationType.expandedSideBar,
    panes: 3,
  ),
];
