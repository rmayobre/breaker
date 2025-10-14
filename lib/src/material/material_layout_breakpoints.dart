import '../../breaker.dart';

List<LayoutBreakpoint> materialLayoutBreakpoints = const [
  LayoutBreakpoint(
    maxWidth: 599,
    minMargin: 16,
    span: 4,
    spacing: 4,
  ),
  LayoutBreakpoint(
    minWidth: 600,
    maxWidth: 904,
    minMargin: 32,
    span: 8,
    spacing: 8,
  ),
  LayoutBreakpoint(
    minWidth: 905,
    maxWidth: 1239,
    body: 840,
    minMargin: 32,
    maxMargin: 199,
    span: 12,
    spacing: 12,
  ),
  LayoutBreakpoint(
    minWidth: 1240,
    maxWidth: 1439,
    minMargin: 200,
    span: 12,
    spacing: 24,
  ),
  LayoutBreakpoint(
    minWidth: 1440,
    minMargin: 200, // TODO check minMargin with body to add up the different. (200 * 2 - 1440 = 1040)
    // maxMargin: 300, TODO support scaling
    body: 1040,
    span: 12,
    spacing: 36,
  )
];