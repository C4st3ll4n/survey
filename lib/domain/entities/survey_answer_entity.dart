import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class SurveyAnswerEntity extends Equatable {
  final String image;
  final String answer;
  final bool isCurrentAnswer;
  final int percent;
  

  SurveyAnswerEntity({
    this.image,
    @required this.answer,
    @required this.percent,
    @required this.isCurrentAnswer,
  });

  @override
  List<Object> get props => [
    answer, isCurrentAnswer, percent
      ];

  @override
  bool get stringify => true;
}
