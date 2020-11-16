import 'package:advancedProject/presentation/protocols/protocols.dart';
import 'package:advancedProject/validation/protocols/field_validation.dart';
import 'package:meta/meta.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);
  String validate({@required String field, @required String value}) {
    String error;

    for (final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(value);
      if (error?.isNotEmpty == true) {
        return error;
      }
    }

    return error;
  }
}
