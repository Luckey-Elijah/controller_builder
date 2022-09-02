import 'package:controller_builder/controller_builder.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: ControllerBuilderExample(),
          ),
        ),
      ),
    );
  }
}

class ControllerBuilderExample extends StatelessWidget {
  const ControllerBuilderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ControllerBuilder<TextEditingController>(
      create: () {
        final controller = TextEditingController(text: 'Hello, world!');
        return controller..addListener(someListener);
      },
      builder: (context, controller) => TextField(controller: controller),
      dispose: (controller) {
        controller
          ..removeListener(someListener)
          ..dispose();
      },
    );
  }
}

void someListener() {}
