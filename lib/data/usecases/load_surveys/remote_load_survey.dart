import 'package:meta/meta.dart';
import 'package:survey/data/http/http.dart';
import 'package:survey/domain/entities/survey_entity.dart';
import 'package:survey/domain/usecases/usecases.dart';

class RemoteLoadSurveys implements LoadSurveys{
  final HttpClient httpClient;
  final String url;
  RemoteLoadSurveys({@required this.httpClient, @required this.url});
  
  @override
  Future<List<SurveyEntity>> load()async {
    await httpClient.request(url: url, method: 'get');
  }
	
}