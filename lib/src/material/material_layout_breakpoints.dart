import '../layout_breakpoint.dart';

List<LayoutBreakpoint> materialLayoutBreakpoints = const [
  LayoutBreakpoint(
    maxWidth: 599,
    minMargin: 16,
    axes: 4,
    spacing: 4,
  ),
  LayoutBreakpoint(
    minWidth: 600,
    maxWidth: 904,
    minMargin: 32,
    axes: 8,
    spacing: 8,
  ),
  LayoutBreakpoint(
    minWidth: 905,
    maxWidth: 1239,
    body: 840,
    minMargin: 32,
    maxMargin: 199,
    axes: 12,
    spacing: 12,
  ),
  LayoutBreakpoint(
    minWidth: 1240,
    maxWidth: 1439,
    minMargin: 200,
    axes: 12,
    spacing: 24,
  ),
  LayoutBreakpoint(
    minWidth: 1440,
    minMargin: 200, // TODO putting larger minMargin no longer overflows pixels. It should not safe-guard against this and instead assert proper numbers.
    body: 1040,
    axes: 12,
    spacing: 36,
  )
];