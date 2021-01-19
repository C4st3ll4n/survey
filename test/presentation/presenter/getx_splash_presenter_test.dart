import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/domain/entities/account_entity.dart';
import 'package:survey/domain/usecases/usecases.dart';
import 'package:survey/presentation/presenters/getx_splash_presenter.dart';
import 'package:survey/ui/pages/splash/splash.dart';

void main() {
  SplashPresenter sut;
  LoadCurrentAccount loadCurrentAccountSpy;

  //void _mockCall()

  void mockLoadCurrentAccount({account}) {
    when(loadCurrentAccountSpy.load()).thenAnswer((realInvocation)
    async => account);
  }

  void mockLoadCurrentAccountError() {
	  when(loadCurrentAccountSpy.load()).thenThrow(Exception());
  }

  setUp(() {
    loadCurrentAccountSpy = LoadCurrentAccountSpy();
    sut = GetXSplashPresenter(loadCurrentAccountSpy);
    mockLoadCurrentAccount(account: AccountEntity("token"));
  });

  test("Should call LoadCurrentAccount", () async {
    await sut.checkAccount();
    verify(loadCurrentAccountSpy.load()).called(1);
  });

  test("Should go to surveys page on success", () async {
    sut.navigateToStream.listen(
      expectAsync1(
        (callback) {
          expect(callback, "/surveys");
        },
      ),
    );
    await sut.checkAccount();
  });
  
  test("Should go to login page on null result", () async {
    
    mockLoadCurrentAccount(account:null);
    
    sut.navigateToStream.listen(
      expectAsync1(
        (page) {
          expect(page, "/login");
        },
      ),
    );
    await sut.checkAccount();
  });
  
  test("Should go to login page on error", () async {
   
    mockLoadCurrentAccountError();
    
    sut.navigateToStream.listen(
      expectAsync1(
        (page) {
          expect(page, "/login");
        },
      ),
    );
    await sut.checkAccount();
  });
}



class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}
