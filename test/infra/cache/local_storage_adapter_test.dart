import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/infra/cache/cache.dart';

void main(){
	LocalStorageAdapter sut;
	LocalStorage localStorageSpy;
	String key;
	dynamic value;
	
	setUp((){
		key = faker.randomGenerator.string(18);
		value = faker.randomGenerator.string(18);
		localStorageSpy = LocalStorageSpy();
		sut = LocalStorageAdapter(localStorageSpy);
	});
	
	test("Ensure calls save with correct values",()async{
		await sut.save(key: key,value: value);
		verify(localStorageSpy.deleteItem(key)).called(1);
		verify(localStorageSpy.setItem(key, value)).called(1);
	});
	
	test("Ensure calls delete with correct values",()async{
		await sut.delete(key);
		verify(localStorageSpy.deleteItem(key)).called(1);
	});
	
}
	class LocalStorageSpy extends Mock implements LocalStorage{}
