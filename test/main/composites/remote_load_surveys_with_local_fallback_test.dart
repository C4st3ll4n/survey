import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/usecases/usecases.dart';
import 'package:survey/domain/entities/entities.dart';
import 'package:survey/domain/usecases/usecases.dart';

void main() {
  RemoteLoadSurveysWithLocalFallback sut;
  RemoteLoadSurveys remote;
  LocalLoadSurveys local;
  List<SurveyEntity> surveys;
  List<SurveyEntity> _mockValidSurveys() => [
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(50),
            dateTime: faker.date.dateTime(),
            didAnswer: true)
      ];

  void mockRemoteLoad() {
    surveys = _mockValidSurveys();
    when(remote.load()).thenAnswer((_) async => surveys);
  }

  setUp(() {
    remote = RemoteLoadSurveysSpy();
    local = LocalLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote, local: local);
    mockRemoteLoad();
  });

  test("Should call remote load", () async {
    await sut.load();
    verify(remote.load()).called(1);
  });

  test("Should call local save with remote data", () async {
    await sut.load();
    verify(local.save(surveys)).called(1);
  });

  test("Should return remote data", () async {
    final result = await sut.load();
    expect(result, surveys);
  });
}

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
  RemoteLoadSurveysWithLocalFallback({
    @required this.remote,
    @required this.local,
  });

  final RemoteLoadSurveys remote;
  final LocalLoadSurveys local;

  @override
  Future<List<SurveyEntity>> load() async {
    final data = await remote.load();
    await local.save(data);
    return data;
  }
}
