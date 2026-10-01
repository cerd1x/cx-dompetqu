import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dompetqu/core/theme/widgets/dompet_text_field.dart';

void main() {
  String? visibleText(WidgetTester tester) {
    final state = tester.state<EditableTextState>(find.byType(EditableText));
    return state.renderEditable.text?.toPlainText();
  }

  testWidgets('obscure toggle after typing', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DompetTextField.password(controller: controller),
        ),
      ),
    );

    controller.text = 'secret123';
    controller.selection = TextSelection.collapsed(offset: controller.text.length);
    await tester.pumpAndSettle();

    final editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.obscureText, isTrue, reason: 'awalnya harus obscure');
    expect(visibleText(tester), '•••••••••', reason: 'teks harus bullet');

    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pumpAndSettle();

    final editable2 = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable2.obscureText, isFalse, reason: 'setelah toggle harus reveal');
    expect(visibleText(tester), 'secret123', reason: 'teks harus tampil');
    expect(controller.text, 'secret123');

    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pumpAndSettle();

    final editable3 = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable3.obscureText, isTrue, reason: 'toggle balik ke obscure');
    expect(visibleText(tester), '•••••••••', reason: 'teks harus bullet lagi');
    expect(controller.text, 'secret123');
  });
}
