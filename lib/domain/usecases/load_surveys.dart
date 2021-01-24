import 'package:survey/domain/entities/entities.dart';

abstract class LoadSurveys{
	Future<List<SurveyEntity>> load();
}