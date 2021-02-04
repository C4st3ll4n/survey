import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'models.dart';
import '../../domain/entities/entities.dart';

class LocalSurveyModel extends Equatable{
  final String id;
  final String question;
  final DateTime dateTime;
  final bool didAnswer;

  LocalSurveyModel(
      {@required this.id,
      @required this.question,
      @required this.dateTime,
      @required this.didAnswer});

  factory LocalSurveyModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([kId, kQuestion, kDateTime, kDidAnswer]))
      throw Exception("One or more keys are missing");
    return LocalSurveyModel(
      id: json[kId],
      didAnswer: json[kDidAnswer].toString().parseBool(),
      dateTime: DateTime.parse(json[kDateTime]),
      question: json[kQuestion],
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
      didAnswer: didAnswer, question: question, id: id, dateTime: dateTime);

  factory LocalSurveyModel.fromEntity(SurveyEntity e) => LocalSurveyModel(
      id: e.id,
      question: e.question,
      dateTime: e.dateTime,
      didAnswer: e.didAnswer);

  Map<String,String>toJson() => {
        kId: this.id,
        kQuestion: this.question,
        kDateTime: this.dateTime.toIso8601String(),
        kDidAnswer: this.didAnswer.toString()
      };

  @override
  List<Object> get props => [id, question, didAnswer, dateTime];
}

extension BoolParsing on String {
  bool parseBool() => this.trim().toLowerCase() == 'true';
}
