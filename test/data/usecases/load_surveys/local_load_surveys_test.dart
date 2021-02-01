import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/cache/cache.dart';
import 'package:survey/data/usecases/load_surveys/load_surveys.dart';

void main(){
	
	LocalLoadSurveys sut;
	List<Map> listData;
	FetchCacheStorage fetchCacheStorageSpy;
	
	setUp((){
		fetchCacheStorageSpy = FetchCacheStorageSpy();
		sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorageSpy);
	});
	
	test("Should call FetchCacheStorage with correct key",()async{
		await sut.load();
		verify(fetchCacheStorageSpy.fetch('surveys')).called(1);
	});
}

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage{}