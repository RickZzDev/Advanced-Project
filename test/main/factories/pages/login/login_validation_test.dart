import 'package:advancedProject/main/factories/factories.dart';
import 'package:advancedProject/validation/validators/email_validation.dart';
import 'package:advancedProject/validation/validators/required_field_validation.dart';
import 'package:test/test.dart';

void main() {
  test('Should return the correct validations', () {
    final validatations = makeLoginValidations();

    expect(validatations, [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
    ]);
  });
}
