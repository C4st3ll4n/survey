import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/infra/cache/cache.dart';

void main() {
  LocalStorageAdapter sut;
  LocalStorage localStorageSpy;
  String key;
  dynamic value;

  setUp(() {
    key = faker.randomGenerator.string(18);
    value = faker.randomGenerator.string(18);
    localStorageSpy = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorageSpy);
  });

  void _mockDeleteError() {
    when(localStorageSpy.deleteItem(any)).thenThrow(Exception());
  }

  void _mockFetchError() {
    when(localStorageSpy.getItem(any)).thenThrow(Exception());
  }

  void _mockSaveError() {
    when(
      localStorageSpy.setItem(
        any,
        any,
      ),
    ).thenThrow(Exception());
  }

  group("save", () {
    test("Ensure calls save with correct values", () async {
      await sut.save(key: key, value: value);
      verify(localStorageSpy.deleteItem(key)).called(1);
      verify(localStorageSpy.setItem(key, value)).called(1);
    });

    test("Ensure calls delete with correct values", () async {
      await sut.save(key: key, value: value);
      verify(localStorageSpy.deleteItem(key)).called(1);
    });

    test("Should throw if DeleteItem throw", () async {
      _mockDeleteError();
      final future = sut.save(key: key, value: value);
      expect(future, throwsA(Exception));
    });

    test("Should throw if SaveItem throw", () async {
      _mockSaveError();
      final future = sut.save(key: key, value: value);
      expect(future, throwsA(Exception));
    });
  });

  group("delete", () {
    
    test("Ensure calls delete with correct values", () async {
      await sut.delete(key);
      verify(localStorageSpy.deleteItem(key)).called(1);
    });

    test("Should throw if DeleteItem throw", () async {
      _mockDeleteError();
      final future = sut.delete(key);
      expect(future, throwsA(Exception));
    });
  });

  group("fetch", () {
    
    String result;
    void _mockFetchSuccess() {
      when(localStorageSpy.getItem(any)).thenAnswer((_) async => result);
    }

    setUp(() {
      result = faker.randomGenerator.string(50);
      _mockFetchSuccess();
    });

    test("Ensure calls fetch with correct values", () async {
      await sut.fetch(key);
      verify(localStorageSpy.getItem(key)).called(1);
    });

    test("Ensure returns same value as LocalStorage", () async {
      _mockFetchSuccess();
      final data = await sut.fetch(key);
      expect(data, result);
    });

    test("Should throw if Fetch throw", () async {
      _mockFetchError();
      final future = sut.fetch(key);
      expect(future, throwsA(Exception));
    });
  });
}

class LocalStorageSpy extends Mock implements LocalStorage {}
