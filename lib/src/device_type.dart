/// The kind of device the app is running on.
enum DeviceType {
  /// A phone or tablet (Android and iOS).
  mobile,

  /// A browser. Mobile and desktop browsers are not currently distinguished.
  web,

  /// A desktop operating system (Linux, macOS and Windows).
  desktop,
}
