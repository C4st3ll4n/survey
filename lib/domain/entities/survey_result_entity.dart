import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:survey/domain/entities/entities.dart';

class SurveyResultEntity extends Equatable {
  final String surveyId;
  final String question;
  final bool didAnswer;
  final List<SurveyAnswerEntity> answers;

  SurveyResultEntity({
    @required this.surveyId,
    @required this.question,
    @required this.didAnswer,
    @required this.answers,
  });

  @override
  List<Object> get props => [
        surveyId,
        question,
      ];

  @override
  bool get stringify => true;
}
