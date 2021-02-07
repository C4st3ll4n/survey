import 'package:meta/meta.dart';
import '../http/http.dart';
import '../../domain/entities/entities.dart';
import 'remote_survey_answer_model.dart';
import 'remote_survey_model.dart';

const String kSurveyId = "surveyId";
const String kAnswers = "answers";

class RemoteSurveyResultModel {
  final String surveyId;
  final String question;
  final List<RemoteSurveyAnswerModel> answers;

  RemoteSurveyResultModel(
      {@required this.surveyId,
      @required this.question,
      @required this.answers});

  factory RemoteSurveyResultModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([kSurveyId, kQuestion, kAnswers]))
      throw HttpError.invalidData;
    return RemoteSurveyResultModel(
      surveyId: json[kSurveyId],
      answers: json[kAnswers].map<RemoteSurveyAnswerModel>((json)=> RemoteSurveyAnswerModel.fromJson(json)).toList(),
      question: json[kQuestion],
    );
  }

  SurveyResultEntity toEntity() => SurveyResultEntity(
      surveyId: this.surveyId,
      answers: this.answers.map<SurveyAnswerEntity>((e) => e.toEntity()).toList(),
      question: this.question);
}
