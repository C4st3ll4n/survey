import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:survey/domain/entities/entities.dart';
import 'package:survey/domain/entities/survey_result_entity.dart';

class SurveyAnswerViewModel extends Equatable {
  final String image;
  final String answer;
  final bool isCurrentAnswer;
  final String percent;

  SurveyAnswerViewModel({
    this.image, this.answer, this.isCurrentAnswer, this.percent,
  });

  @override
  List<Object> get props => [answer, isCurrentAnswer, percent];

  @override
  bool get stringify => true;

  factory SurveyAnswerViewModel.fromEntity(SurveyAnswerEntity entity) => SurveyAnswerViewModel(
      image: entity.image,
      percent: "${entity.percent}%",
    isCurrentAnswer: entity.isCurrentAnswer,
    answer: entity.answer
    );
}
