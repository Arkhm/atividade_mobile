import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:atividade/main.dart';

void main() {
  testWidgets('mostra erros com campos vazios', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('CADASTRAR'));
    await tester.pump();

    expect(find.text('Digite seu nome'), findsWidgets);
    expect(find.text('Digite seu e-mail'), findsWidgets);
    expect(find.text('Digite seu CPF'), findsOneWidget);
    expect(find.text('Digite uma senha'), findsOneWidget);
  });

  testWidgets('cadastro válido mostra SnackBar de sucesso',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(0), 'Maria');
    await tester.enterText(campos.at(1), 'maria@teste.com');
    await tester.enterText(campos.at(2), '12345678901');
    await tester.enterText(campos.at(3), '11999998888');
    await tester.enterText(campos.at(4), 'senha123');
    await tester.enterText(campos.at(5), 'senha123');
    await tester.tap(find.text('CADASTRAR'));
    await tester.pump();

    expect(find.textContaining('Cadastro realizado com sucesso'),
        findsOneWidget);
  });
}
