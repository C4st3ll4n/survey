import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/ui/pages/pages.dart';

class SplashPresenterSpy extends Mock implements SplashPresenter {}


void main() {
  SplashPresenter presenter;
  StreamController<String> navigateToController;

  void _mockStream() {
    when(presenter.navigateToStream)
        .thenAnswer((realInvocation) => navigateToController.stream);
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPresenterSpy();
    navigateToController = StreamController();
    _mockStream();

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: "/",
        getPages: [
          GetPage(name: "/", page: () => SplashPage(presenter: presenter)),
          GetPage(
              name: "any_route",
              page: () => Scaffold(
                    body: Text("fakePage"),
                  ))
        ],
      ),
    );
  }

  tearDown(() {
    navigateToController.close();
  });

  testWidgets("Should present spinner on page load", (tester) async {
    await loadPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("Should call load current account", (tester) async {
    await loadPage(tester);
    //expect(find.byType(CircularProgressIndicator), findsOneWidget);

    verify(presenter.checkAccount(durationInSeconds: 3)).called(1);
  });

  testWidgets("Should change page", (tester) async {
    await loadPage(tester);

    navigateToController.add("any_route");
    await tester.pumpAndSettle();

    expect(Get.currentRoute, "any_route");
    expect(find.text("fakePage"), findsOneWidget);
  });


  testWidgets("Shouldnt change page", (tester) async {
    await loadPage(tester);
  
    navigateToController.add("");
    await tester.pump();
    expect(Get.currentRoute, "/");

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, "/");
  
  });
}

