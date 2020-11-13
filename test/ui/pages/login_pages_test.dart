import 'package:advancedProject/ui/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    "Should load with correct initial state",
    (WidgetTester tester) async {
      //ARRANGE
      final loginPage = MaterialApp(home: LoginPage());
      await tester.pumpWidget(loginPage);

      //EXPECT

      //Buscando os filhos do text form field
      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel("Email"),
        matching: find.byType(Text),
      );
      expect(emailTextChildren, findsOneWidget,
          reason:
              "Esse teste ira buscar os filhos do text form field com label email, se tivel mais que um filho do tipo texto, quer dizer que tem erros");

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel("Senha"),
        matching: find.byType(Text),
      );
      expect(passwordTextChildren, findsOneWidget,
          reason:
              "Esse teste ira buscar os filhos do text form field com label senha, se tivel mais que um filho do tipo texto, quer dizer que tem erros");

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
      expect(button.onPressed, null);
    },
  );
}
