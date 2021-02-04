import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:survey/data/models/models.dart';
import '../http/http.dart';
import '../../domain/entities/entities.dart';

class LocalSurveyModel {
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
    if (!json.keys.toSet().containsAll([kId, kQuestion, kDateTime, kDidAnswer])) throw Exception("One or more keys are missing");
    return LocalSurveyModel(
      id: json[kId],
      didAnswer: json[kDidAnswer].toString().parseBool(),
      dateTime: DateTime.parse(json[kDateTime]),
      question: json[kQuestion],
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
      didAnswer: didAnswer, question: question, id: id, dateTime: dateTime);
}

extension BoolParsing on String {
  bool parseBool() => this.trim().toLowerCase() == 'true';
}
