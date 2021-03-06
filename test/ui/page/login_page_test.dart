import 'dart:async';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/ui/helpers/helpers.dart';
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

      final raisedButton =
          tester.widget<RaisedButton>(find.byType(RaisedButton));
      expect(raisedButton.onPressed, null);

      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets("Shoud call validate with correct values", (tester) async {
    await loadPage(tester);
    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel("Email"), email);

    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel("Senha"), password);

    verify(presenter.validatePassword(password));
  });

  testWidgets(
    "Shoud present error if email is invalid",
    (tester) async {
      await loadPage(tester);
      emailErrorController.add(UIError.invalidField);
      await tester.pump();

      expect(find.text(UIError.invalidField.description), findsOneWidget);
    },
  );

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
    "Shoud present no error password is valid",
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
    "Shoud present error if password is invalid",
    (tester) async {
      await loadPage(tester);
      passwordErrorController.add(UIError.unexpected);
      await tester.pump();

      expect(find.text(UIError.unexpected.description), findsOneWidget);
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
    "Shoud call authentication on form submit",
    (tester) async {
      await loadPage(tester);
      isFormValidController.add(true);
      await tester.pump();

      await tester.tap(find.byType(RaisedButton));
      await tester.pump();

      verify(presenter.auth()).called(1);
    },
  );

  testWidgets(
    "Shoud call loading on form submit",
    (tester) async {
      await loadPage(tester);
      isLoadingController.add(true);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    "Shoud hide loading",
    (tester) async {
      await loadPage(tester);
      isLoadingController.add(true);
      await tester.pump();

      isLoadingController.add(false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets(
    "Shoud present error message if authentication fails",
    (tester) async {
      await loadPage(tester);
      mainErrorController.add(UIError.unexpected);
      await tester.pump();

      expect(find.text(UIError.unexpected.description), findsOneWidget);
    },
  );

  testWidgets(
    "Shoud change page",
    (tester) async {
      await loadPage(tester);
      navigateToController.add("/fake_page");
      await tester.pumpAndSettle();

      expect(Get.currentRoute, "/fake_page");
      expect(find.text('fake page'), findsOneWidget);
    },
  );

  testWidgets("Shouldnt change page", (tester) async {
    await loadPage(tester);
  
    navigateToController.add("");
    await tester.pump();
    expect(Get.currentRoute, "/login");
  
    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, "/login");
  
  });


  testWidgets(
    "Should go to signup page on click",
        (tester) async {
      await loadPage(tester);
      final button = find.text("Criar conta");
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pump();
    
      verify(presenter.goToSignup()).called(1);
    },
  );
/*
  testWidgets("Should close streams on dispose", (tester) async {
    await loadPage(tester);
    addTearDown(() {
      verify(presenter.dispose()).called(1);
    });
  });*/
}

class LoginPresenterSpy extends Mock implements LoginPresenter {}
