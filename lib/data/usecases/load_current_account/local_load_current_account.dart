import '../../../data/cache/cache.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

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