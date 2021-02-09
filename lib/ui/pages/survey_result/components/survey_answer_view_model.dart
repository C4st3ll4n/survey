import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
}
