import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HorizontalScaleTransition', (WidgetTester tester) async {
    final AnimationController controller = AnimationController(vsync: const TestVSync());
    final Widget widget = HorizontalScaleTransition(
      alignment: Alignment.topRight,
      scale: controller,
      child: Text(
        'Scale',
        textDirection: TextDirection.ltr,
      ),
    );

    await tester.pumpWidget(widget);

    Transform transform = tester.widget(find.byType(Transform));
    expect(transform.transform, Matrix4.identity()..scale(controller.value, 1.0, 1.0));

    controller.value = 0.5;
    await tester.pump();
    transform = tester.widget(find.byType(Transform));
    expect(transform.transform, Matrix4.identity()..scale(controller.value, 1.0, 1.0));

    controller.value = 0.75;
    await tester.pump();
    transform = tester.widget(find.byType(Transform));
    expect(transform.transform, Matrix4.identity()..scale(controller.value, 1.0, 1.0));
  });

  testWidgets('VerticalScaleTransition', (WidgetTester tester) async {
    final AnimationController controller = AnimationController(vsync: const TestVSync());
    final Widget widget = VerticalScaleTransition(
      alignment: Alignment.topRight,
      scale: controller,
      child: Text(
        'Scale',
        textDirection: TextDirection.ltr,
      ),
    );

    await tester.pumpWidget(widget);

    Transform transform = tester.widget(find.byType(Transform));
    expect(transform.transform, Matrix4.identity()..scale(1.0, controller.value, 1.0));

    controller.value = 0.5;
    await tester.pump();
    transform = tester.widget(find.byType(Transform));
    expect(transform.transform, Matrix4.identity()..scale(1.0, controller.value, 1.0));

    controller.value = 0.75;
    await tester.pump();
    transform = tester.widget(find.byType(Transform));
    expect(transform.transform, Matrix4.identity()..scale(1.0, controller.value, 1.0));
  });
}
