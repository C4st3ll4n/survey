import 'package:meta/meta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/usecases/usecases.dart';
import 'package:survey/domain/entities/entities.dart';
import 'package:survey/domain/usecases/usecases.dart';

void main() {
  RemoteLoadSurveysWithLocalFallback sut;
  RemoteLoadSurveys remote;
  
  setUp(() {
    remote  = RemoteLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote);
  });

  test("Should call remote load", () async {
    await sut.load();
    verify(remote.load()).called(1);
  });
}

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
  RemoteLoadSurveysWithLocalFallback({@required this.remote});
  
  final RemoteLoadSurveys remote;

  @override
  Future<List<SurveyEntity>> load() async {
    await remote.load();
  }
}
