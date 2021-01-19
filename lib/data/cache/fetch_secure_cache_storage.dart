import 'package:meta/meta.dart';

abstract class FetchSecureCacheStorage {
	Future<String> fetchSecure(String key);
}