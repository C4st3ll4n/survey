import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:survey/domain/entities/entities.dart';
import 'package:survey/domain/helpers/domain_error.dart';
import 'package:survey/domain/usecases/usecases.dart';

class SaveCacheStorageSpy extends Mock implements SaveSecureCacheStorage {}

abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({String key, String value});
}

void main() {
  LocalSaveCurrentAccount sut;
  AccountEntity account;
  SaveSecureCacheStorage secureCache;

  setUp(() {
    account = AccountEntity(faker.guid.guid());
    secureCache = SaveCacheStorageSpy();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: secureCache);
  });

  test(
    "Should call SaveSecureCacheStorage with correct values",
    () async {
      await sut.save(account);
      verify(secureCache.saveSecure(key: 'token', value: account.token));
    },
  );

  test(
    "Should throw unexpected error if SaveSecureCacheStorage",
    () async {
      when(
        secureCache.saveSecure(
          key: anyNamed("key"),
          value: anyNamed("value"),
        ),
      ).thenThrow(Exception());

      final future = sut.save(account);

      //verify(secureCache.saveSecure(key:'token',value:account.token));
      expect(future, throwsA(DomainError.unexpected));
    },
  );
}

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({this.saveSecureCacheStorage});

  @override
  Future<void> save(AccountEntity account) async {
    try{
      await saveSecureCacheStorage.saveSecure(key: "token", value: account.token);
    }catch(e){
      throw DomainError.unexpected;
    }
  }
}
