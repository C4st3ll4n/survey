import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/usecases/usecases.dart';
import 'package:survey/main/composites/composites.dart';

class RemoteSpy extends Mock implements RemoteLoadSurveyResult {}

class LocalSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  String surveyId;
  RemoteLoadSurveyResultWithLocalFallback sut;
  RemoteLoadSurveyResult remoteSpy;
  LocalLoadSurveyResult localSpy;
  
  setUp(() {
    remoteSpy = RemoteSpy();
    localSpy = LocalSpy();
    surveyId = faker.guid.guid();
    
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remoteSpy, local: localSpy);
  });
  test("Should call remote loadBySurvey", () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remoteSpy.loadBySurvey(surveyId: surveyId)).called(1);
  });
}
