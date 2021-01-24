import 'package:meta/meta.dart';
import 'package:survey/data/http/http.dart';
import 'package:survey/data/models/models.dart';
import 'package:survey/domain/entities/survey_entity.dart';
import 'package:survey/domain/helpers/domain_error.dart';
import 'package:survey/domain/usecases/usecases.dart';

class RemoteLoadSurveys implements LoadSurveys {
  final HttpClient<List<Map>> httpClient;
  final String url;

  RemoteLoadSurveys({@required this.httpClient, @required this.url});

  @override
  Future<List<SurveyEntity>> load() async {
    try{
    
    final response = await httpClient.request(url: url, method: 'get');
    return response
        .map((json) => RemoteSurveyModel.fromJson(json).toEntity())
        .toList();
    }
    on HttpError{
      throw DomainError.unexpected;
    }
  }
}
