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
    when(loadCurrentAccountSpy.load())
        .thenAnswer((realInvocation) async => AccountEntity("token"));

    loadCurrentAccountSpy = LoadCurrentAccountSpy();
    sut = GetXSplashPresenter(loadCurrentAccountSpy);
  });

  test("Should call LoadCurrentAccount", () async {
    await sut.checkAccount();
    verify(loadCurrentAccountSpy.load()).called(1);
  });

  test("Should return AccountEntity", () async {
    final account = await sut.checkAccount();
    expect(account, AccountEntity("token"));
  });
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

class GetXSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount localLoadCurrentAccount;

  var _navigateTo = RxString();

  GetXSplashPresenter(this.localLoadCurrentAccount);

  @override
  Future<AccountEntity> checkAccount() async {
    final account = await localLoadCurrentAccount.load();
    return account;
  }

  @override
  Stream<String> get navigateToStream => _navigateTo.stream.distinct();
}
