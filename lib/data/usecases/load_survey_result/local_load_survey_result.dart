import 'dart:developer';

import 'package:meta/meta.dart';
import '../../cache/cache.dart';
import '../../models/models.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

class LocalLoadSurveyResult implements LoadSurveyResult {
	final CacheStorage cacheStorage;
	
	LocalLoadSurveyResult({@required this.cacheStorage});
	
	@override
	Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
		try {
			final response = await cacheStorage.fetch("survey_result/$surveyId");
			if (response?.isEmpty != false) {
				throw Exception("Cache data is invalid or null");
			}
			return LocalSurveyResultModel.fromJson(response).toEntity();
			
		} catch (e, stck) {
		throw DomainError.unexpected;
		}
	}
	
	@override
	Future<void> validate(String surveyId) async {
		try {
			final data = await cacheStorage.fetch("survey_result/$surveyId");
			return LocalSurveyResultModel.fromJson(data).toEntity();
		} catch (e, stck) {
			log("validate::\n\n"+e.toString(), stackTrace: stck);
			await cacheStorage.delete("survey_result/$surveyId");
		}
	}
}
