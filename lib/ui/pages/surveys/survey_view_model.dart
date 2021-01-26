import 'package:meta/meta.dart';

class SurveyViewModel {
  final String id;
  final String question;
  final String formatedDate;
  final bool didAnswer;

  SurveyViewModel(
      {@required this.id,
      @required this.question,
      @required this.formatedDate,
      @required this.didAnswer});
}
