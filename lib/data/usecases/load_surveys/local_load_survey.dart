import 'package:meta/meta.dart';
import 'package:survey/data/models/local_survey_model.dart';
import 'package:survey/domain/helpers/domain_error.dart';
import '../../cache/cache.dart';
import '../../../domain/entities/survey_entity.dart';
import '../../../domain/usecases/usecases.dart';

class LocalLoadSurveys implements LoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({@required this.fetchCacheStorage});

  @override
  Future<List<SurveyEntity>> load() async {
    final response = await fetchCacheStorage.fetch("surveys");
    if(response?.isEmpty!=false){
      throw DomainError.unexpected;
    }
    return response
        .map<SurveyEntity>(
          (e) =>LocalSurveyModel.fromJson(e).toEntity()
        )
        .toList();
  }
}
