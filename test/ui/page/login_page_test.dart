import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/ui/pages/pages.dart';

void main() {
  LoginPresenter presenter;
  setUp((){
  
  });
  
  Future<void> loadPage(WidgetTester tester) async{
    presenter = LoginPresenterSpy();
    final loginPage = MaterialApp(home: LoginPage(presenter: presenter,));
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

      expect(emailTextChildren,
          findsOneWidget, reason: "When a TextFormField has only one text"
              " child, means it has no errors, since one of the child is"
              " always the label text");

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel("Senha"),
        matching: find.byType(Text),
      );

      expect(passwordTextChildren,
          findsOneWidget, reason: "When a TextFormField has only one text"
              " child, means it has no errors, since one of the child is"
              " always the label text");
      
      final raisedButton = tester.widget<RaisedButton>(find.byType(RaisedButton));
      expect(raisedButton.onPressed, null);
    },
  );

  testWidgets(
      "Shoud call validate with correct values",
  (tester) async {
    await loadPage(tester);
    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel("Email"), email);
    
    
    verify(
      presenter.validateEmail(email)
    );
    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel("Senha"), password);


    verify(
        presenter.validatePassword(password)
    );
    
  });
  
}

class LoginPresenterSpy extends Mock implements LoginPresenter {
}
