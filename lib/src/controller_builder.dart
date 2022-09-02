import 'package:flutter/widgets.dart';

/// Callback for creating a [ChangeNotifier]
typedef ControllerCreateCallback<T extends ChangeNotifier> = T Function();

/// Callback providing a [ChangeNotifier] in a builder
typedef ControllerWidgetBuilder<T extends ChangeNotifier> = Widget Function(
  BuildContext,
  T,
);

/// An optional callback for providing a [ChangeNotifier] so it's resources can
/// be disposed and cleaned up.
typedef ControllerDisposeCallback<T extends ChangeNotifier> = void Function(T)?;

/// {@template controller_builder}
/// Creates a widget that initializes a "controller" (which
/// `extends ChangeNotifier`) and provides the controller to it's children.
/// This widget is used to abstract the initialization and disposing of the
/// given controller.
/// {@endtemplate}
class ControllerBuilder<T extends ChangeNotifier> extends StatefulWidget {
  /// {@macro controller_builder}
  const ControllerBuilder({
    super.key,
    required this.create,
    required this.builder,
    this.dispose,
  });

  /// Function that creates the controller when the widget is initialized.
  final ControllerCreateCallback<T> create;

  /// Widget builder callback that provides the create controller.
  final ControllerWidgetBuilder<T> builder;

  /// Callback that allows you to handle disposing manually. If `null` the
  /// widget will call `dispose`; otherwise you should call `dispose` yourself.
  final ControllerDisposeCallback<T> dispose;

  @override
  State<ControllerBuilder> createState() => ControllerBuilderState<T>();
}

@visibleForTesting
// ignore: public_member_api_docs
class ControllerBuilderState<T extends ChangeNotifier>
    extends State<ControllerBuilder<T>> {
  late final T _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.create();
  }

  @override
  void dispose() {
    if (widget.dispose != null) {
      widget.dispose!(_controller);
    } else {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _controller);
}
