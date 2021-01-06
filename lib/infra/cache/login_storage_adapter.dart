import 'package:meta/meta.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/cache/save_secure_cache_storage.dart';

class LocalStorageAdapter implements SaveSecureCacheStorage {
	final FlutterSecureStorage secureStorage;
	
	LocalStorageAdapter({@required this.secureStorage});
	
	@override
	Future<void> saveSecure(
			{@required String key, @required String value}) async {
		await secureStorage.write(key: key, value: value);
	}
}
