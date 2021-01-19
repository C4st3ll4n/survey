import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/domain/entities/account_entity.dart';
import 'package:survey/domain/usecases/load_current_account.dart';

void main(){
	
	
	LocalLoadCurrentAccount sut;
	FetchSecureCacheStorage fetchSecureCacheStorage;
	setUp((){
		fetchSecureCacheStorage  = FetchSecureCacheStorageSpy();
		sut = LocalLoadCurrentAccount(fetchSecureCacheStorage);
	});
	
	test("Should call FetchSecureCacheStorage with correct value",() async {
		
		await sut.load();
		
		verify(fetchSecureCacheStorage.fetchSecure("token"));
	});
}

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {
}

abstract class FetchSecureCacheStorage {
	Future<void> fetchSecure(String key);
}

class LocalLoadCurrentAccount implements LoadCurrentAccount {
	final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount(this.fetchSecureCacheStorage);
  @override
  Future<AccountEntity> load() {
  	fetchSecureCacheStorage.fetchSecure("token");
  }
}