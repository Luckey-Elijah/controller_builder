import 'package:controller_builder/controller_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChangeNotifier extends Mock implements ChangeNotifier {}

void main() {
  group('ControllerBuilder', () {
    testWidgets('provides the created [controller] to [builder]',
        (tester) async {
      final mockNotifier = MockChangeNotifier();
      late MockChangeNotifier providedController;
      final builder = ControllerBuilder<MockChangeNotifier>(
        create: () => mockNotifier,
        builder: (context, controller) {
          providedController = controller;
          return const SizedBox();
        },
      );
      await tester.pumpWidgetWithApp((_) => builder);

      expect(identical(mockNotifier, providedController), isTrue);
    });

    testWidgets('properly [dispose] automatically ', (tester) async {
      final mockNotifier = MockChangeNotifier();
      final builder = ControllerBuilder<MockChangeNotifier>(
        create: () => mockNotifier,
        builder: (context, controller) => const SizedBox(),
      );

      const pageKey = Key('pageKey');
      const button1Key = Key('Button-1');
      const button2Key = Key('Button-2');

      final app = TestApp(
        builder: (context) => Builder(
          builder: (context) {
            return ElevatedButton(
              key: button1Key,
              child: const SizedBox(),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => Scaffold(
                      key: pageKey,
                      body: Row(
                        children: [
                          builder,
                          Builder(
                            builder: (context) {
                              return ElevatedButton(
                                key: button2Key,
                                onPressed: Navigator.of(context).pop,
                                child: const SizedBox(),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );

      await tester.pumpWidget(app);

      await tester.tap(find.byKey(button1Key));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(button2Key));
      await tester.pumpAndSettle();

      verify(mockNotifier.dispose).called(1);
    });

    testWidgets('properly executes [dispose] callback with non null',
        (tester) async {
      final mockNotifier = MockChangeNotifier();
      final builder = ControllerBuilder<MockChangeNotifier>(
        create: () => mockNotifier,
        builder: (context, controller) => const SizedBox(),
        dispose: (controller) => controller.dispose(),
      );

      const pageKey = Key('pageKey');
      const button1Key = Key('Button-1');
      const button2Key = Key('Button-2');

      final app = TestApp(
        builder: (context) => Builder(
          builder: (context) {
            return ElevatedButton(
              key: button1Key,
              child: const SizedBox(),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => Scaffold(
                      key: pageKey,
                      body: Row(
                        children: [
                          builder,
                          Builder(
                            builder: (context) {
                              return ElevatedButton(
                                key: button2Key,
                                onPressed: Navigator.of(context).pop,
                                child: const SizedBox(),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );

      await tester.pumpWidget(app);

      await tester.tap(find.byKey(button1Key));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(button2Key));
      await tester.pumpAndSettle();

      verify(mockNotifier.dispose).called(1);
    });
  });
}

class TestApp extends StatelessWidget {
  const TestApp({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) =>
      MaterialApp(home: Scaffold(body: builder(context)));
}

extension WidgetTesterHelper on WidgetTester {
  Future<void> pumpWidgetWithApp(WidgetBuilder builder) =>
      pumpWidget(TestApp(builder: builder));
}
