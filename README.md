# Breaker

A responsive and adaptive design library built for Flutter.

## Features

 - Window Breakpoints
   - Mobile/Desktop
   - Platforms (Android, iOS, Web, Windows, Linux, Mac, etc.)
   - Screen Orientation
   - Navigation Types (Bottom Bar, Sidebar, etc.)
   - Panes Count
 - Layout Breakpoints
   - Height Breakpoint Ranges (min/max)
   - Width Breakpoint Ranges (min/max)
   - Body Size Constraint
   - Axes Count (Number of columns/rows)
   - Margins (Static and Scaling support)
   - Axis Spacing
 - Material Breakpoints
   - Window Class based
   - Material 2 responsive layout breakpoints
 - Layout builder
 - Inherited Models (Window and Layout)
 - Vertical Layout Widget
 - Grid Layout Widget
 - Debug Overlay Widget

## Getting started

Import the Breaker package (`package:breaker/breaker.dart`). For the Material Design implementation, import the material package (`package:breaker/material.dart`).

For a Window breakpoint system, use the `BreakerWindow` widget towards the root of the widget tree. Descending widgets can
then depend on the `WindowModel` by referencing the `Breaker` static methods:

```dart
Widget build(BuildContext context) {
  Breaker.device(context); // Get breakpoint's device type.
  Breaker.platform(context); // Get breakpoint's platform type.
  Breaker.orientation(context); // Get breakpoint's orientation type.
  Breaker.navigation(context); // Get breakpoint's navigation type.
  Breaker.panes(context); // Get number of panes supported by Breakpoint.
}
```

For the Layout breakpoint system, use the `BreakerLayout` widget after the `BreakerWindow`. All descending widgets gain access
to the Layout Breakpoint values. Use the `Breaker` static methods to access each value.

```dart
Widget build(BuildContext context) {
  Breaker.body(context); // Get breakpoint's device type.
  Breaker.axes(context); // Get breakpoint's platform type.
  Breaker.axisSize(context); // Get breakpoint's orientation type.
  Breaker.margin(context); // Get breakpoint's navigation type.
  Breaker.spacing(context); // Get number of panes supported by Breakpoint.
}
```

To build custom layouts with support for the `LayoutBreakpoint`s, use the `ResponsiveLayoutBuilder`. There are readily
available widgets built with the `ResponsiveLayoutBuilder` (e.g. `ResponsiveVerticalLayout`, `ResponsiveGridLayout`, 
and `ResponsiveLayoutOverlay`).

```dart
Widget build(BuildContext context) {
  return ResponsiveLayoutBuilder(context, builder: (context, constraints) {
    final body = constraints.body;
    final axes = constraints.axes;
    final axisSize = constraints.axisSize;
    final margin = constraints.margin;
    final spacing = constraints.spacing;
    return MyResponsiveWidget(...);
  });
}
```

## Usage

Creating a simple two Breakpoint window breakpoint system with a responsive vertical layout. This will use the readily available
widget `ResponsiveVerticalLayout`.

```dart
import 'package:flutter/widgets.dart';
import 'package:breaker/breaker.dart';


class MyWindow extends StatelessWidget {
  const MyWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return BreakerWindow(
        breakpoints: const [
          WindowBreakpoint( // Small Screen or Mobile Window
              maxWidth: 600,
              navigation: NavigationType.bottomBar,
              panes: 1
          ),
          WindowBreakpoint( // Anything larger than a Mobile screen
              minWidth: 600,
              navigation: NavigationType.sideBar,
              panes: 2
          ),
        ],
        child: const MyLayout()
    );
  }
}

class MyLayout extends StatelessWidget {
   const MyLayout({super.key});

   @override
   Widget build(BuildContext context) {
      final panes = Breaker.panes(context);
      return ResponsiveVerticalLayout(
         debugOverlay: true, // false to remove overlay
         breakpoints: const [
            LayoutBreakpoint(
               maxWidth: 905,
               minMargin: 16,
               axes: 4,
               spacing: 4,
            ),
            LayoutBreakpoint(
               minWidth: 905,
               body: 840,
               minMargin: 32,
               axes: 12,
               spacing: 12,
            ),
         ],
         cells: [
            if (panes == 1)
               Cell(
                  span: (constraints) => constraints.axes.toInt(),
                  child: Column(
                     children: [
                        Flexible(child: Placeholder(color: Colors.blue, strokeWidth: 4)),
                        SizedBox(height: 4),
                        Flexible(child: Placeholder(color: Colors.red, strokeWidth: 4)),
                     ],
                  ),
               ),
            if (panes == 2)
               Cell(
                  span: (constraints) => (constraints.axes / 2).toInt(),
                  child: Placeholder(color: Colors.blue, strokeWidth: 4),
               ),
            if (panes == 2)
               Cell(
                  span: (constraints) => (constraints.axes / 2).toInt(),
                  child: Placeholder(color: Colors.red, strokeWidth: 4),
               ),
         ],
      );
   }
}
```

### Material

The Material Design breakpoint systems are also available in the `breaker/material.dart` package. Change from the standard
`breaker/breaker.dart` package and reference the available `materialWindowBreakpoints` and `materialLayoutBreakpoints`. 
This will provide the same adaptive and responsive systems supported in Material 2 & 3.

```dart
import 'package:flutter/widgets.dart';
import 'package:breaker/material.dart';

class MyWindow extends StatelessWidget {
  const MyWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return BreakerWindow(
        breakpoints: materialWindowBreakpoints,
        child: const MyLayout()
    );
  }
}

class MyLayout extends StatelessWidget {
  const MyLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final panes = Breaker.panes(context);
    return ResponsiveVerticalLayout(
      debugOverlay: true, // false to remove overlay
      breakpoints: materialLayoutBreakpoints,
      cells: [
        if (panes == 1)
          Cell(
            span: (constraints) => constraints.axes.toInt(),
            child: Column(
              children: [
                Flexible(child: Placeholder(color: Colors.blue, strokeWidth: 4)),
                SizedBox(height: 4),
                Flexible(child: Placeholder(color: Colors.red, strokeWidth: 4)),
                SizedBox(height: 4),
                Flexible(child: Placeholder(color: Colors.green, strokeWidth: 4)),
              ],
            ),
          ),
        if (panes == 2)
          Cell(
            span: (constraints) => (constraints.axes / 2).toInt(),
            child: Column(
              children: [
                Flexible(child: Placeholder(color: Colors.blue, strokeWidth: 4)),
                SizedBox(height: 4),
                Flexible(child: Placeholder(color: Colors.red, strokeWidth: 4)),
              ],
            ),
          ),
        if (panes == 2)
          Cell(
            span: (constraints) => (constraints.axes / 2).toInt(),
            child: Placeholder(color: Colors.green, strokeWidth: 4),
          ),
        if (panes == 3)
          Cell(
            span: (constraints) => (constraints.axes / 3).toInt(),
            child: Placeholder(color: Colors.blue, strokeWidth: 4),
          ),
        if (panes == 3)
          Cell(
            span: (constraints) => (constraints.axes / 3).toInt(),
            child: Placeholder(color: Colors.red, strokeWidth: 4),
          ),
        if (panes == 3)
          Cell(
            span: (constraints) => (constraints.axes / 3).toInt(),
            child: Placeholder(color: Colors.green, strokeWidth: 4),
          ),
      ],
    );
  }
}
```
