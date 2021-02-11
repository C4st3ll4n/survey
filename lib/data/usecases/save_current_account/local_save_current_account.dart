import 'package:meta/meta.dart';
import '../../cache/cache.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
	final SaveSecureCacheStorage saveSecureCacheStorage;
	
	LocalSaveCurrentAccount({@required this.saveSecureCacheStorage});
	
	@override
	Future<void> save(AccountEntity account) async {
		try{
			await saveSecureCacheStorage.save(key: "token", value: account.token);
		}catch(e){
			throw DomainError.unexpected;
		}
	}
}