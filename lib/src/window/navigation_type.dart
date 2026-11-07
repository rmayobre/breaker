/// The style of navigation a window should present.
enum NavigationType {
  /// A bar along the bottom edge, typically for compact windows.
  bottomBar,

  /// A persistent, collapsed side bar (e.g. a navigation rail).
  sideBar,

  /// A side bar that the user can expand and collapse.
  expandableSideBar,

  /// A side bar that is always fully expanded.
  expandedSideBar,
}
