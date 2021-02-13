import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../http/http.dart';
import '../../domain/entities/entities.dart';
import 'local_survey_answer_model.dart';
import 'remote_survey_model.dart';
import 'remote_survey_result_model.dart';

class LocalSurveyResultModel extends Equatable {
  final String surveyId;
  final String question;
  final List<LocalSurveyAnswerModel> answers;

  LocalSurveyResultModel(
      {@required this.surveyId,
      @required this.question,
      @required this.answers});

  factory LocalSurveyResultModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([kSurveyId, kQuestion, kAnswers]))
      throw HttpError.invalidData;
    return LocalSurveyResultModel(
      surveyId: json[kSurveyId],
      answers: json[kAnswers]
          .map<LocalSurveyAnswerModel>(
              (json) => LocalSurveyAnswerModel.fromJson(json))
          .toList(),
      question: json[kQuestion],
    );
  }

  SurveyResultEntity toEntity() => SurveyResultEntity(
      surveyId: this.surveyId,
      answers:
          this.answers.map<SurveyAnswerEntity>((e) => e.toEntity()).toList(),
      question: this.question);

  @override
  List<Object> get props => [surveyId, question];

  factory LocalSurveyResultModel.fromEntity(SurveyResultEntity survey) => LocalSurveyResultModel(
      surveyId: survey.surveyId, question: survey.question,
      answers: survey.answers.map((e) => LocalSurveyAnswerModel.fromEntity(e)).toList());

  Map toJson() =>
      {
        kSurveyId:surveyId,
        kQuestion:question,
        kAnswers:answers.map((e) => e.toJson()).toList()
  };
}
