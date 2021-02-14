import 'package:meta/meta.dart';
import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

class RemoteLoadSurveyResultWithLocalFallback implements LoadSurveyResult {
	RemoteLoadSurveyResultWithLocalFallback({
		@required this.remote,
		@required this.local,
	});
	
	final RemoteLoadSurveyResult remote;
	final LocalLoadSurveyResult local;
	
  @override
  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async{
	  try{
		
		  final survey = await remote.loadBySurvey(surveyId: surveyId);
		  await local.save(surveyId, survey);
		  return survey;
	  }catch(err){
		  if(err == DomainError.accessDenied){
			  rethrow;
		  }
		  await local.validate(surveyId);
		  return local.loadBySurvey(surveyId: surveyId);
	  }
  }
}