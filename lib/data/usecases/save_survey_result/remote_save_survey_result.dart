import 'package:meta/meta.dart';
import '../../http/http.dart';
import '../../models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class RemoteSaveSurveyResult implements SaveSurveyResult {
  final HttpClient httpClient;
  final String url;

  RemoteSaveSurveyResult({@required this.httpClient, @required this.url});

  @override
  Future<SurveyResultEntity> save({String answer}) async{
    try{
      final response = await httpClient.request(url: url, method: "put", body: {'answer':answer});
      //return response;
    }on HttpError catch(error){
      throw error == HttpError.forbidden?
          DomainError.accessDenied:
          DomainError.unexpected;
    }
  }
}
