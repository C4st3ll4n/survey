import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SurveyViewModel extends Equatable{
  final String id;
  final String question;
  final String formatedDate;
  final bool didAnswer;

  SurveyViewModel(
      {@required this.id,
      @required this.question,
      @required this.formatedDate,
      @required this.didAnswer});

  @override
  List<Object> get props => [id, question, formatedDate, didAnswer];

  @override
  bool get stringify => true;
  
  
}
