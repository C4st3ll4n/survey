import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/domain/entities/account_entity.dart';
import 'package:survey/domain/helpers/domain_error.dart';
import 'package:survey/domain/usecases/load_current_account.dart';

void main() {
  LocalLoadCurrentAccount sut;
  FetchSecureCacheStorage fetchSecureCacheStorage;
  String token;

  PostExpectation _mockFetchSecure() =>
      when(fetchSecureCacheStorage.fetchSecure(any));

  void mockFetchSecureSuccess() =>
      _mockFetchSecure().thenAnswer((realInvocation) async => token);

  void mockFetchSecureFail() {
    _mockFetchSecure().thenThrow(Exception());
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage);

    token = faker.guid.guid();

    mockFetchSecureSuccess();
  });

  test("Should call FetchSecureCacheStorage with correct value", () async {
    await sut.load();

    verify(fetchSecureCacheStorage.fetchSecure("token"));
  });

  test("Should return an accountEntity", () async {
    final account = await sut.load();

    expect(account, AccountEntity(token));
  });

  test(
    "Should throw an UnexpectedError if FetchSecure throws",
    () async {
      mockFetchSecureFail();

      final future = sut.load();

      expect(
        future,
        throwsA(DomainError.unexpected),
      );
    },
  );
}

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

abstract class FetchSecureCacheStorage {
  Future<String> fetchSecure(String key);
}

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount(this.fetchSecureCacheStorage);

  @override
  Future<AccountEntity> load() async {
    try{
    final token = await fetchSecureCacheStorage.fetchSecure("token");
    return AccountEntity(token);
    } catch(ex, stck){
      throw DomainError.unexpected;
    }
  }
}
