import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/cache/save_secure_cache_storage.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  LocalStorageAdapter sut;
  String key;
  String value;
  FlutterSecureStorage secureStorage;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);

    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  test("Shloud call save secure with correct values", () async {
    await sut.saveSecure(key: key, value: value);

    verify(secureStorage.write(key: key, value: value));
  });

  test("Shloud call save secure with correct values", () async {
    Exception e = Exception(); //FIXME
    when(
      secureStorage.write(
        key: anyNamed("key"),
        value: anyNamed("value"),
      ),
    ).thenThrow(e);

    final future = sut.saveSecure(key: key, value: value);

    //verify(secureStorage.write(key: key, value: value));
    expect(future, throwsA(e));
  });
}

class LocalStorageAdapter implements SaveSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageAdapter({@required this.secureStorage});

  @override
  Future<void> saveSecure(
      {@required String key, @required String value}) async {
    await secureStorage.write(key: key, value: value);
  }
}
