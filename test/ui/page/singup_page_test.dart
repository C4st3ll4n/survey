import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/ui/helpers/helpers.dart';
import 'package:survey/ui/pages/pages.dart';

void main() {
  SignupPresenterSpy presenter;
  StreamController<UIError> nameErrorController;
  StreamController<UIError> passwordConfirmationErrorController;
  StreamController<UIError> emailErrorController;
  StreamController<UIError> passwordErrorController;
  StreamController<UIError> mainErrorController;
  StreamController<String> navigateToController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;

  void _initStreams() {
    nameErrorController = StreamController();
    passwordConfirmationErrorController = StreamController();
    emailErrorController = StreamController();
    passwordErrorController = StreamController();
    isFormValidController = StreamController();
    isLoadingController = StreamController();
    mainErrorController = StreamController();
    navigateToController = StreamController();
  }

  void _closeStreams() {
    passwordConfirmationErrorController.close();
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
    navigateToController.close();
  }

  void _mockStreams() {
    when(presenter.passwordConfirmationErrorStream)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);

    when(presenter.nameErrorStream)
        .thenAnswer((_) => nameErrorController.stream);

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
    presenter = SignupPresenterSpy();
    _initStreams();
    _mockStreams();
    final singupPage = GetMaterialApp(
      initialRoute: "/signup",
      getPages: [
        GetPage(
          name: "/signup",
          page: () => SignUpPage(
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
    await tester.pumpWidget(singupPage);
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

  testWidgets("Shoud call validate with correct values", (tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel("Nome"), name);
    verify(presenter.validateName(name));
    
    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel("Email"), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel("Senha"), password);
    verify(presenter.validatePassword(password));

    await tester.enterText(find.bySemanticsLabel("Confirmar senha"), password);
    verify(presenter.validatePasswordConfirmation(password));
  });


  testWidgets(
    "Shoud present no error email is valid",
        (tester) async {
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
    "Shoud present no error if password is valid",
        (tester) async {
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
    "Shoud present no error if passwordConfirmation is valid",
        (tester) async {
      await loadPage(tester);
      passwordConfirmationErrorController.add(null);
      await tester.pump();
    
      expect(
        find.descendant(
          of: find.bySemanticsLabel("Confirmar senha"),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    "Shoud present no error if name is valid",
        (tester) async {
      await loadPage(tester);
      nameErrorController.add(null);
      await tester.pump();
    
      expect(
        find.descendant(
          of: find.bySemanticsLabel("Nome"),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    "Shoud present password error",
        (tester) async {
      await loadPage(tester);
      passwordErrorController.add(UIError.invalidField);
      await tester.pump();
      expect(find.text(UIError.invalidField.description), findsOneWidget);

      passwordErrorController.add(UIError.unexpected);
      await tester.pump();
      expect(find.text(UIError.unexpected.description), findsOneWidget);

      passwordErrorController.add(UIError.requiredField);
      await tester.pump();
      expect(find.text(UIError.requiredField.description), findsOneWidget);
    },
  );

  testWidgets(
    "Shoud present email error",
        (tester) async {
      await loadPage(tester);
      emailErrorController.add(UIError.invalidField);
      await tester.pump();
      expect(find.text(UIError.invalidField.description), findsOneWidget);

      emailErrorController.add(UIError.unexpected);
      await tester.pump();
      expect(find.text(UIError.unexpected.description), findsOneWidget);

      emailErrorController.add(UIError.requiredField);
      await tester.pump();
      expect(find.text(UIError.requiredField.description), findsOneWidget);
    },
  );
  
  testWidgets(
    "Shoud present name error",
        (tester) async {
      await loadPage(tester);
      nameErrorController.add(UIError.invalidField);
      await tester.pump();
      expect(find.text(UIError.invalidField.description), findsOneWidget);

      nameErrorController.add(UIError.unexpected);
      await tester.pump();
      expect(find.text(UIError.unexpected.description), findsOneWidget);

      nameErrorController.add(UIError.requiredField);
      await tester.pump();
      expect(find.text(UIError.requiredField.description), findsOneWidget);
    },
  );
  
  testWidgets(
    "Shoud present passwordConfirmation error",
        (tester) async {
      await loadPage(tester);
      passwordConfirmationErrorController.add(UIError.invalidField);
      await tester.pump();
      expect(find.text(UIError.invalidField.description), findsOneWidget);

      passwordConfirmationErrorController.add(UIError.unexpected);
      await tester.pump();
      expect(find.text(UIError.unexpected.description), findsOneWidget);

      passwordConfirmationErrorController.add(UIError.requiredField);
      await tester.pump();
      expect(find.text(UIError.requiredField.description), findsOneWidget);
    },
  );


  testWidgets("Shoud enable buttom if form is valid", (tester) async {
    await loadPage(tester);
    isFormValidController.add(true);
  
    await tester.pump();
  
    final raisedButton = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(raisedButton.onPressed, isNotNull);
  });


  testWidgets("Shoud disable buttom if form is invalid", (tester) async {
    await loadPage(tester);
    isFormValidController.add(false);
  
    await tester.pump();
  
    final raisedButton = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(raisedButton.onPressed, isNull);
  });

  testWidgets(
    "Shoud call signup on form submit",
        (tester) async {
      await loadPage(tester);
      isFormValidController.add(true);
      await tester.pump();
      
      final button = find.byType(RaisedButton);
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pump();
    
      verify(presenter.signup()).called(1);
    },
  );
  
  
  
}

class SignupPresenterSpy extends Mock implements SignUpPresenter {}
