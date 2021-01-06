import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:survey/domain/entities/entities.dart';
import 'package:survey/domain/usecases/usecases.dart';

class SaveCacheStorageSpy extends Mock implements SaveSecureCacheStorage{}

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
    "Should call SaveCacheStorage",
    () async {
    	
      await sut.save(account);
      verify(secureCache.saveSecure(key:'token',value:account.token));
    },
  );
}

class LocalSaveCurrentAccount implements SaveCurrentAccount {
	final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({this.saveSecureCacheStorage});
  @override
  Future<void> save(AccountEntity account) async {
    await saveSecureCacheStorage.saveSecure(key: "token",value: account.token);
  }
}
