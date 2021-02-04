import 'package:meta/meta.dart';

abstract class CacheStorage {
	Future<dynamic> fetch(String key);

  Future<void> delete(String key);

  Future<void> save({@required String key, @required List<Map> value});
}