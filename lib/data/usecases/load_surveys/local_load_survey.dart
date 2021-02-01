import 'package:meta/meta.dart';
import '../../cache/cache.dart';
import '../../../domain/entities/survey_entity.dart';
import '../../../domain/usecases/usecases.dart';

class LocalLoadSurveys implements LoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({@required this.fetchCacheStorage});

  @override
  Future<List<SurveyEntity>> load() {
    fetchCacheStorage.fetch("surveys");
  }
	
}