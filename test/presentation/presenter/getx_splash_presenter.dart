import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/domain/entities/account_entity.dart';
import 'package:survey/domain/usecases/usecases.dart';
import 'package:survey/ui/pages/splash/splash.dart';

void main() {
  SplashPresenter sut;
  LoadCurrentAccount loadCurrentAccountSpy;

  setUp(() {
    loadCurrentAccountSpy = LoadCurrentAccountSpy();
    sut = GetXSplashPresenter(loadCurrentAccountSpy);
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
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

class GetXSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount localLoadCurrentAccount;

  var _navigateTo = RxString();

  GetXSplashPresenter(this.localLoadCurrentAccount);

  @override
  Future<void> checkAccount() async {
    final account = await localLoadCurrentAccount.load();
    _navigateTo.value = '/surveys';
  }

  @override
  Stream<String> get navigateToStream => _navigateTo.stream.distinct();
}
