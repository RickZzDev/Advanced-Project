import 'package:advancedProject/domain/helpers/domain_error.dart';
import 'package:advancedProject/presentation/presenters/stream_login_presenter%20copy.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:advancedProject/presentation/protocols/protocols.dart';
import 'package:advancedProject/presentation/presenters/presenters.dart';
import 'package:advancedProject/domain/usecases/authentication.dart';
import 'package:advancedProject/domain/entities/account_entity.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

void main() {
  StreamLoginPresenter sut;
  ValidationSpy validation;
  AuthenticationSpy authenticationSpy;
  PostExpectation mockValidationCall(String field) => when(
        validation.validate(
          field: field == null ? anyNamed('field') : field,
          value: anyNamed('value'),
        ),
      );

  void mockValidation({String field, String value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAuthCall() => when(
        authenticationSpy.auth(any),
      );

  void mockAuthentication() {
    mockAuthCall().thenAnswer((_) async => AccountEntity(faker.guid.guid()));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthCall().thenThrow(error);
  }

  String email;
  String password;

  setUp(() {
    authenticationSpy = AuthenticationSpy();
    validation = ValidationSpy();
    sut = StreamLoginPresenter(
        validation: validation, authentication: authenticationSpy);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
    mockAuthentication();
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);
    //ASSERT
    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null error if validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct password', () {
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(value: 'error');

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit password error if validation fails', () {
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(field: 'email', value: 'error');

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should emit password error if validation fails', () async {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('Should call Authentication with correct values ', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(authenticationSpy
            .auth(AuthenticationParams(email: email, secret: password)))
        .called(1);
  });

  test('Should emit correct events on Authentication success ', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    await sut.auth();
  });

  test('Should emit correct events on InvalidCredentials ', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));

    sut.mainErrorStream.listen(
        expectAsync1((error) => expect(error, 'Credenciais invalidas')));

    await sut.auth();
  });

  test('Should emit correct events on unexpected error ', () async {
    mockAuthenticationError(DomainError.unexpectedError);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));

    sut.mainErrorStream.listen(expectAsync1((error) =>
        expect(error, 'Algo errado aconteceu. Tente novamente em breve')));

    await sut.auth();
  });

  test('Should not emit after dispose', () async {
    expectLater(sut.emailErrorStream, neverEmits(null));

    sut.dispose();

    await sut.auth();
  });
}
