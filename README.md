# `controller_builder`

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

_Widget for abstracting initializing and disposing TextEditingController, ChangeNotifiers, etc._

```dart
ControllerBuilder<TextEditingController>(
  // Create a controller (or any `ChangeNotifier`).
  create: () {
    final controller = TextEditingController(text: 'Hello, world!');
    return controller..addListener(someListener);
  },

  // The controller you created in now available in the `builder` below.
  builder: (context, controller) {
    return TextField(
      controller: controller,
      onChanged: log,
    );
  },

  // Dispose will be called automatically unless
  // you provide a `dispose` callback like below.
  // You assume responsibility to call dispose then.
  dispose: (controller) {
    controller
      ..removeListener(someListener)
      ..dispose();
  },
)
```

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
