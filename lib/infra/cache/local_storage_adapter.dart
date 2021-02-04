import 'package:meta/meta.dart';
import 'package:localstorage/localstorage.dart';
import '../../data/cache/cache.dart';

class LocalStorageAdapter implements CacheStorage{
  final LocalStorage localStorage;

  LocalStorageAdapter(this.localStorage);
  @override
  Future<void> delete(String key) {
  }

  @override
  Future fetch(String key) {
  }

  @override
  Future<void> save({@required String key,@required dynamic value}) {
    localStorage.setItem(key, value);
  }

}
