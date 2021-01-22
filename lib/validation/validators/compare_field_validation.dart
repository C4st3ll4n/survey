import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../protocols/protocols.dart';
import '../../presentation/protocols/protocols.dart';

class CompareFieldValidation extends Equatable implements FieldValidation {
  final String field;
  final String valueToCompare;

  CompareFieldValidation({@required this.field, @required this.valueToCompare});

  @override
  ValidationError validate(String value) {
    return value != null && value == valueToCompare?null:ValidationError.invalidField;
  }

  @override
  List<Object> get props => [field];
}
