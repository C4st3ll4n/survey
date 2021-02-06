import 'package:meta/meta.dart';
import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
	RemoteLoadSurveysWithLocalFallback({
		@required this.remote,
		@required this.local,
	});
	
	final RemoteLoadSurveys remote;
	final LocalLoadSurveys local;
	
	@override
	Future<List<SurveyEntity>> load() async {
		try{
			
			final data = await remote.load();
			await local.save(data);
			return data;
		}catch(err){
			if(err == DomainError.accessDenied){
				rethrow;
			}
			await local.validate();
			return local.load();
		}
	}
}