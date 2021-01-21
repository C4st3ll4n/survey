import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/ui/helpers/errors/errors.dart';
import 'package:survey/ui/pages/pages.dart';

void main() {
  LoginPresenter presenter;
  StreamController<UIError> emailErrorController;
  StreamController<UIError> passwordErrorController;
  StreamController<UIError> mainErrorController;
  StreamController<String> navigateToController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;

  void _initStreams() {
    emailErrorController = StreamController();
    passwordErrorController = StreamController();
    isFormValidController = StreamController();
    isLoadingController = StreamController();
    mainErrorController = StreamController();
    navigateToController = StreamController();
  }

  void _closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
    navigateToController.close();
  }

  void _mockStreams() {
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

  setUp(() {});

  tearDown(
    () {
      _closeStreams();
    },
  );

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    _initStreams();
    _mockStreams();
    final loginPage = GetMaterialApp(
    
      initialRoute: "/login",
      getPages: [
        GetPage(
          name: "/login",
          page: () => LoginPage(
            presenter: presenter,
          ),
        ),
        GetPage(
          name: "/fake_page",
          page: () => Scaffold(
            body: Text("fake page"),
          ),
        ),
      ],
    );
    await tester.pumpWidget(loginPage);
  }

  testWidgets(
    "Shoud load with correct initial state",
    (tester) async {
      await loadPage(tester);

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel("Email"),
        matching: find.byType(Text),
      );

      expect(emailTextChildren, findsOneWidget,
          reason: "When a TextFormField has only one text"
              " child, means it has no errors, since one of the child is"
              " always the label text");

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel("Senha"),
        matching: find.byType(Text),
      );
      
      expect(passwordTextChildren, findsOneWidget,
          reason: "When a TextFormField has only one text"
              " child, means it has no errors, since one of the child is"
              " always the label text");

      final nameTextChildren = find.descendant(
        of: find.bySemanticsLabel("Nome"),
        matching: find.byType(Text),
      );

      expect(nameTextChildren, findsOneWidget,
          reason: "When a TextFormField has only one text"
              " child, means it has no errors, since one of the child is"
              " always the label text");
      
      final confirmPasswordTextChildren = find.descendant(
        of: find.bySemanticsLabel("Confirmar senha"),
        matching: find.byType(Text),
      );

      expect(confirmPasswordTextChildren, findsOneWidget,
          reason: "When a TextFormField has only one text"
              " child, means it has no errors, since one of the child is"
              " always the label text");

      final raisedButton =
          tester.widget<RaisedButton>(find.byType(RaisedButton));
      expect(raisedButton.onPressed, null);

      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

}

class LoginPresenterSpy extends Mock implements LoginPresenter {}
