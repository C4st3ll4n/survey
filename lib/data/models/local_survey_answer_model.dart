import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../http/http.dart';
import '../../domain/entities/entities.dart';
import 'remote_survey_answer_model.dart';

class LocalSurveyAnswerModel extends Equatable {
  final String image;
  final String answer;
  final bool isCurrentAnswer;
  final int percent;

  LocalSurveyAnswerModel(
      {this.image,
      @required this.answer,
      @required this.isCurrentAnswer,
      @required this.percent});

  factory LocalSurveyAnswerModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([kAnswer, kIsCurrentAnswer, kPercent]))
      throw HttpError.invalidData;
    return LocalSurveyAnswerModel(
        answer: json[kAnswer],
        isCurrentAnswer: bool.hasEnvironment(json[kIsCurrentAnswer]),
        percent: int.parse(json[kPercent]),
        image: json[kImage] ?? null);
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
      isCurrentAnswer: this.isCurrentAnswer,
      answer: this.answer,
      percent: this.percent,
      image: this.image ?? null);

  @override
  List<Object> get props => [answer, isCurrentAnswer, percent];

  factory LocalSurveyAnswerModel.fromEntity(SurveyAnswerEntity e) =>
      LocalSurveyAnswerModel(
          image: e.image,
          answer: e.answer,
          isCurrentAnswer: e.isCurrentAnswer,
          percent: e.percent);

  Map toJson() => {
        kAnswer: answer,
        kIsCurrentAnswer: isCurrentAnswer.toString(),
        kPercent: percent.toString(),
        kImage: image
      };
}
