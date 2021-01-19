import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/infra/cache/cache.dart';

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

  group("Save Secure", () {
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
  });
  group("Fetch Secure", () {
    
    setUp((){
      when(
        secureStorage.read(
          key: anyNamed("key"),
        ),
      ).thenAnswer((e) async => value);
    });
    
    test("Should call fetch secure with correct value", () async {
      await sut.fetchSecure(key);

      verify(
        secureStorage.read(
          key: key,
        ),
      );
    });
    test(
      "Should return correct value on success",
      () async {
       
        
        final fetchedValue = await sut.fetchSecure(key);

        expect(fetchedValue, value );
        
      },
    );

    test("Should throws an Exception", () async {
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
  });
}
