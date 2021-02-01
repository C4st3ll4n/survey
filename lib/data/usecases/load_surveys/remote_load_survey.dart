import 'package:meta/meta.dart';
import '../../http/http.dart';
import '../../models/models.dart';
import '../../../domain/entities/survey_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class RemoteLoadSurveys implements LoadSurveys {
  final HttpClient httpClient;
  final String url;

  RemoteLoadSurveys({@required this.httpClient, @required this.url});

  @override
  Future<List<SurveyEntity>> load() async {
    try{
    
    final response = await httpClient.request(url: url, method: 'get');
    return response
        .map<SurveyEntity>((json) => RemoteSurveyModel.fromJson(json).toEntity())
        .toList();
    }
    on HttpError catch(e){
      throw e == HttpError.forbidden? DomainError.accessDenied:
      DomainError.unexpected;
    }
  }
}
