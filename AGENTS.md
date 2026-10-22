# AGENTS.md

Guidance for AI coding agents working on this repository.

## Project

`breaker` is a Flutter package for responsive and adaptive layouts, built on a
breakpoint system. It has two parts:

- **Window breakpoints** (`WindowBreakpoint`, `BreakerWindow`, `WindowModel`):
  device type, platform, orientation, navigation type and pane count.
- **Layout breakpoints** (`LayoutBreakpoint`, `BreakerLayout`, `LayoutModel`):
  width/height ranges, body constraint, axes, margin and spacing.

Dart SDK `^3.9.0`, Flutter stable. The only dependency is Flutter itself.

## Layout

```
lib/breaker.dart              Public API: exports + the `Breaker` static accessors
lib/material.dart             Public Material-specific API (import separately)
lib/src/breakpoint_resolver.dart  Shared resolveBreakpoint<T>() (match -> fallback -> first)
lib/src/window/               BreakerWindow, WindowModel, NavigationType
lib/src/layout/               BreakerLayout, LayoutModel, LayoutConstraints, Cell,
                              ResponsiveLayoutBuilder / VerticalLayout / GridLayout / Overlay
lib/src/material/             Material window-class and Material 2 layout breakpoints
test/                         Mirrors lib/src/ (e.g. test/layout/cell_test.dart)
example/                      Demo app; depends on the library via `path: ../`
```

## Commands

```sh
flutter pub get
flutter test                      # run the whole suite
flutter test test/layout/cell_test.dart   # a single file
flutter analyze                   # must be clean
dart format .                     # the codebase is formatted; keep it that way
```

The example app is built for web and deployed to GitHub Pages by
`.github/workflows/web.yml` on pushes to `main`. CI runs `flutter test` before
building, so a failing test blocks the deploy.

## Conventions

- **Imports:** the `prefer_relative_imports` lint is on. Use relative imports
  inside `lib/`; never `package:breaker/...` there.
- **Public API:** anything users should see must be exported from
  `lib/breaker.dart` or `lib/material.dart`. Files under `lib/src/` are
  private. Add new public types to the export list.
- **Breakpoint resolution:** always go through `resolveBreakpoint<T>()`. Don't
  call `firstWhere` without `orElse` on breakpoint lists; a gap in the list
  must fall back, not throw.
- **Breakpoint-driven widgets** take an optional `fallback` and assert
  `breakpoints.isNotEmpty`. Keep new widgets consistent with that.
- **Inherited models:** `WindowModel` and `LayoutModel` use aspects.
  `updateShouldNotify` / `updateShouldNotifyDependent` must compare every
  field that has an aspect. A missed field means dependents silently don't
  rebuild.
- **Platform detection:** check `kIsWeb || kIsWasm` before touching
  `dart:io` `Platform.*`, which throws on web.
- **`WindowModel` values** are the detected device/platform/orientation, not
  the nullable filter fields on the breakpoint.
- `LayoutBreakpoint` limits default to `double.infinity`, and `axes` must be
  `>= 1` (axis size divides by it).

## Testing

- Every behavior change or bug fix needs a test in the matching path under
  `test/`. Use `flutter_test` widget tests for widgets, plain unit tests for
  pure logic.
- Run `flutter test` and `flutter analyze` before finishing.

## Docs and releases

- User-visible changes go in `CHANGELOG.md`; update `README.md` when public
  API or usage changes.
- `PR_DESCRIPTION.md` is an untracked scratch file for the current PR. Don't
  commit it or treat it as documentation.
- Don't hand-edit generated or platform folders under `example/` (android,
  ios, macos, linux, windows, web) unless the task is about them.
