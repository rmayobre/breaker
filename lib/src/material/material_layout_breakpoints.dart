import '../layout_breakpoint.dart';

/// Layout breakpoints following the Material Design responsive layout grid.
///
/// Intended to be passed as the `breakpoints` of [BreakerLayout] or any
/// `Responsive*Layout` widget. Widths are in logical pixels.
final List<LayoutBreakpoint> materialLayoutBreakpoints = const [
  LayoutBreakpoint(maxWidth: 600, minMargin: 16, axes: 4, spacing: 4),
  LayoutBreakpoint(
    minWidth: 600,
    maxWidth: 905,
    minMargin: 32,
    axes: 8,
    spacing: 8,
  ),
  LayoutBreakpoint(
    minWidth: 905,
    maxWidth: 1240,
    body: 840,
    minMargin: 32,
    maxMargin: 199,
    axes: 12,
    spacing: 12,
  ),
  LayoutBreakpoint(
    minWidth: 1240,
    maxWidth: 1440,
    minMargin: 200,
    axes: 12,
    spacing: 24,
  ),
  LayoutBreakpoint(
    minWidth: 1440,
    minMargin: 200,
    body: 1040,
    axes: 12,
    spacing: 36,
  ),
];
