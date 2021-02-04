import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/cache/cache.dart';
import 'package:survey/data/usecases/usecases.dart';
import 'package:survey/domain/entities/entities.dart';
import 'package:survey/domain/helpers/helpers.dart';

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


