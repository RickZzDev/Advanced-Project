import 'package:advancedProject/main/builders/builders.dart';
import 'package:advancedProject/presentation/protocols/protocols.dart';
import 'package:advancedProject/validation/protocols/field_validation.dart';
import 'package:advancedProject/validation/validators/required_field_validation.dart';
import 'package:advancedProject/validation/validators/validators.dart';
import 'package:advancedProject/validation/validators/validators_composite.dart';

Validation makeLoginValidation() {
  return ValidationComposite([
    RequiredFieldValidation('email'),
    EmailValidation('email'),
    RequiredFieldValidation('password')
  ]);
}

List<FieldValidation> makeLoginValidations() {
  return [
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().build()
  ];
}
