/// Returns the first element of [breakpoints] for which [matches] returns
/// true. If none match, returns [fallback] if provided, otherwise the first
/// element of [breakpoints].
///
/// [breakpoints] must not be empty; callers are expected to enforce this
/// themselves (e.g. via a constructor assert) before calling this function.
T resolveBreakpoint<T>({
  required List<T> breakpoints,
  required bool Function(T breakpoint) matches,
  T? fallback,
}) {
  for (final breakpoint in breakpoints) {
    if (matches(breakpoint)) return breakpoint;
  }
  return fallback ?? breakpoints.first;
}
