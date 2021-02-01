import 'dart:developer';

import 'package:meta/meta.dart';
import '../http/http.dart';
import '../../domain/entities/entities.dart';

const String kId = "id";
const String kQuestion = "question";
const String kDateTime = "date";
const String kDidAnswer = "didAnswer";

class RemoteSurveyModel {
  final String id;
  final String question;
  final String dateTime;
  final bool didAnswer;

  RemoteSurveyModel(
      {@required this.id,
      @required this.question,
      @required this.dateTime,
      @required this.didAnswer});

  factory RemoteSurveyModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([kId, kQuestion, kDateTime, kDidAnswer])) throw HttpError.invalidData;
    return RemoteSurveyModel(
      id: json[kId],
      didAnswer: json[kDidAnswer],
      dateTime: json[kDateTime],
      question: json[kQuestion],
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
      didAnswer: didAnswer, question: question, id: id, dateTime: DateTime.parse(dateTime));
}
