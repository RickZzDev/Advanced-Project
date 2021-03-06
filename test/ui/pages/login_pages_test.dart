import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:advancedProject/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter;
  StreamController<String> emailErrorController;
  StreamController<String> passwordErrorController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;
  StreamController<String> mainErrorController;
  StreamController<String> navigateToController;

  void initStreams() {
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
    mainErrorController = StreamController<String>();
    navigateToController = StreamController<String>();
  }

  void mockStreams() {
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);

    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);

    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);

    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);

    when(presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);

    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
    navigateToController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    initStreams();
    mockStreams();
    final loginPage = GetMaterialApp(
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage(presenter)),
        GetPage(
            name: '/any_route',
            page: () => Scaffold(
                  body: Text("fake page"),
                )),
      ],
    );
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    closeStreams();
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
      expect(find.byType(CircularProgressIndicator), findsNothing);
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

  testWidgets(
    "Should present no error if email is valid",
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add(null);
      await tester.pump();

      expect(
        find.descendant(
          of: find.bySemanticsLabel("Email"),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    "Should present no error if email is valid",
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add('');
      await tester.pump();

      expect(
        find.descendant(
          of: find.bySemanticsLabel("Email"),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    "Should present error if password is invalid",
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add("any error");
      await tester.pump();

      expect(find.text("any error"), findsOneWidget);
    },
  );

  testWidgets(
    "Should present no error if password is valid",
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add(null);
      await tester.pump();

      expect(
        find.descendant(
          of: find.bySemanticsLabel("Senha"),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    "Should present no password if email is valid",
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add('');
      await tester.pump();

      expect(
        find.descendant(
          of: find.bySemanticsLabel("Senha"),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    "Should enable form button if form is valid",
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(true);
      await tester.pump();

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
      expect(button.onPressed, isNotNull);
    },
  );

  testWidgets(
    "Should enable form button if form is valid",
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(false);
      await tester.pump();

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
      expect(button.onPressed, null);
    },
  );

  testWidgets(
    "Should call Authentication on form submit",
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(true);
      await tester.pump();
      await tester.tap(find.byType(RaisedButton));
      await tester.pump();

      verify(presenter.auth()).called(1);
    },
  );

  testWidgets(
    "Should show loading",
    (WidgetTester tester) async {
      await loadPage(tester);

      isLoadingController.add(true);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    "Should hide loading",
    (WidgetTester tester) async {
      await loadPage(tester);

      isLoadingController.add(true);
      await tester.pump();

      isLoadingController.add(false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets(
    "Should present error message if auth fails ",
    (WidgetTester tester) async {
      await loadPage(tester);

      mainErrorController.add('main error');
      await tester.pump();

      expect(find.text('main error'), findsOneWidget);
    },
  );

  testWidgets(
    "Should close streams on dispose",
    (WidgetTester tester) async {
      await loadPage(tester);

      addTearDown(() {
        verify(presenter.dispose()).called(1);
      });
    },
  );

  testWidgets(
    "Should change page",
    (WidgetTester tester) async {
      await loadPage(tester);
      navigateToController.add('/any_route');
      await tester.pumpAndSettle();
      expect(Get.currentRoute, '/any_route');
      expect(find.text('fake page'), findsOneWidget);
    },
  );
}
