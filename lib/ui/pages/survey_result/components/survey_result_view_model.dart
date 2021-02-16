import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:survey/domain/entities/entities.dart';

import 'survey_answer_view_model.dart';

class SurveyResultViewModel extends Equatable {
  final String surveyId;
  final String question;
  final List<SurveyAnswerViewModel> answers;

  SurveyResultViewModel({
    @required this.surveyId,
    @required this.question,
    @required this.answers,
  });

  @override
  List<Object> get props => [surveyId, question, answers];

  @override
  bool get stringify => true;

  factory SurveyResultViewModel.fromEntity(SurveyResultEntity entity) =>
      SurveyResultViewModel(
          question: entity.question,
          surveyId: entity.surveyId,
          answers: entity.answers
              .map((e) => SurveyAnswerViewModel.fromEntity(e))
              .toList());
}
