import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../protocols/protocols.dart';
import '../../presentation/protocols/protocols.dart';

class CompareFieldValidation extends Equatable implements FieldValidation {
  final String field;
  final String fieldToCompare;

  CompareFieldValidation({@required this.field, @required this.fieldToCompare});

  @override
  ValidationError validate(Map input) => input['field'] != null && input[fieldToCompare] != null && input['field'] != input[fieldToCompare] ?ValidationError.invalidField:null;

  @override
  List<Object> get props => [field];
}
