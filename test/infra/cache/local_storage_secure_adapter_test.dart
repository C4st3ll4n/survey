import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/infra/cache/cache.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  LocalStorageSecureAdapter sut;
  String key;
  String value;
  FlutterSecureStorage secureStorage;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageSecureAdapter(secureStorage: secureStorage);

    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group("Save Secure", () {
    test("Shloud call save secure with correct values", () async {
      await sut.save(key: key, value: value);

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

      final future = sut.save(key: key, value: value);

      //verify(secureStorage.write(key: key, value: value));
      expect(future, throwsA(e));
    });
  });


  group("delete", () {
  
    void _mockDeleteError() {
      when(secureStorage.delete(key: anyNamed("key"))).thenThrow(Exception());
    }
  
    test("Ensure calls delete with correct key", () async {
      await sut.delete(key);
      verify(secureStorage.delete(key:key)).called(1);
    });
  
    test("Should throw if Delete throw", () async {
      _mockDeleteError();
      final future = sut.delete(key);
      expect(future, throwsA(Exception));
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
      await sut.fetch(key);

      verify(
        secureStorage.read(
          key: key,
        ),
      );
    });
    test(
      "Should return correct value on success",
      () async {
       
        
        final fetchedValue = await sut.fetch(key);

        expect(fetchedValue, value );
        
      },
    );

    test("Should throws an Exception", () async {
      Exception e = Exception(); //FIXME
      when(
        secureStorage.read(
          key: anyNamed("key"),
        ),
      ).thenThrow(e);

      final future = sut.fetch(key);

      //verify(secureStorage.write(key: key, value: value));
      expect(future, throwsA(e));
    });
  });
}
