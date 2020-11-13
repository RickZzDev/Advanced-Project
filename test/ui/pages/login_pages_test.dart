import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:advancedProject/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter;
  StreamController<String> emailErrorController;
  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    emailErrorController = StreamController<String>();
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    final loginPage = MaterialApp(home: LoginPage(presenter));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
  });

  testWidgets(
    "Should load with correct initial state",
    (WidgetTester tester) async {
      await loadPage(tester);

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

  testWidgets(
    "Should call validate with correct values",
    (WidgetTester tester) async {
      await loadPage(tester);
      //Criando texto de email fake
      final emailTxt = faker.internet.email();
      //Procurando o form de email e injetando o texto criado acima
      await tester.enterText(find.bySemanticsLabel("Email"), emailTxt);
      //Verifica se o método do presenter foi chamado com o texto designado acima
      verify(presenter.validateEmail(emailTxt));

      final senhaTxt = faker.internet.password();
      //Procurando o form de senha e injetando o texto criado acima
      await tester.enterText(find.bySemanticsLabel("Senha"), senhaTxt);
      //Verifica se o método do presenter foi chamado com o texto designado acima
      verify(presenter.validatePassword(senhaTxt));
    },
  );

  testWidgets(
    "Should present error if email is invalid",
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add("any error");
      await tester.pump();

      expect(find.text("any error"), findsOneWidget);
    },
  );
}
