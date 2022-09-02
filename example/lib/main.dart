import 'dart:developer';

import 'package:controller_builder/controller_builder.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ControllerBuilderExample());
  }
}

class ControllerBuilderExample extends StatelessWidget {
  const ControllerBuilderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ControllerBuilder<TextEditingController>(
            create: () {
              final controller = TextEditingController(text: 'Hello, world!');
              return controller..addListener(someListener);
            },
            builder: (context, controller) {
              return TextField(
                controller: controller,
                onChanged: log,
              );
            },
            dispose: (controller) {
              controller
                ..removeListener(someListener)
                ..dispose();
            },
          ),
        ),
      ),
    );
  }
}

void someListener() {}
