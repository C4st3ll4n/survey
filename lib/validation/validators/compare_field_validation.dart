import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../protocols/protocols.dart';
import '../../presentation/protocols/protocols.dart';

class CompareFieldValidation extends Equatable implements FieldValidation {
  final String field;
  final String fieldToCompare;

  CompareFieldValidation({@required this.field, @required this.fieldToCompare});

  @override
  ValidationError validate(Map input) {
    return input['field'] != null && input['field'] == input[fieldToCompare]?null:ValidationError.invalidField;
  }

  @override
  List<Object> get props => [field];
}
