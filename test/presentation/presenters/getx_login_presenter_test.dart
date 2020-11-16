import 'package:advancedProject/domain/entities/account_entity.dart';
import 'package:advancedProject/domain/helpers/domain_error.dart';
import 'package:advancedProject/domain/usecases/authentication.dart';
import 'package:advancedProject/domain/usecases/save_current_account.dart';
import 'package:advancedProject/presentation/presenters/presenters.dart';
import 'package:advancedProject/presentation/protocols/protocols.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  GetXLoginPresenter sut;
  ValidationSpy validation;
  AuthenticationSpy authenticationSpy;
  SaveCurrentAccountSpy saveCurrentAccountSpy;
  String token;
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
    mockAuthCall().thenAnswer((_) async => AccountEntity(token));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthCall().thenThrow(error);
  }

  PostExpectation mockSaveCurrentAccountCall() => when(
        saveCurrentAccountSpy.save(any),
      );

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpectedError);
  }

  String email;
  String password;

  setUp(() {
    authenticationSpy = AuthenticationSpy();
    validation = ValidationSpy();
    token = faker.guid.guid();
    saveCurrentAccountSpy = SaveCurrentAccountSpy();
    sut = GetXLoginPresenter(
      validation: validation,
      saveCurrentAccount: saveCurrentAccountSpy,
      authentication: authenticationSpy,
    );
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

    expectLater(sut.isFormValidStream, emits(true));

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

  test('Should call SaveCurrentAccount with correct value ', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(saveCurrentAccountSpy.save(AccountEntity(token))).called(1);
  });

  test('Should emit correct events on Authentication success ', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(true));
    await sut.auth();
  });

  test('Should change page on sucess', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    sut.navigateToStream.listen((page) {
      expect(page, '/surveys');
    });
    await sut.auth();
  });

  test('Should emit correct events on InvalidCredentials ', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInAnyOrder([true, false]));

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

  test('Should emit  unexpected error if saveCurrentAccount fails ', () async {
    mockSaveCurrentAccountError();
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.mainErrorStream.listen(expectAsync1((error) =>
        expect(error, 'Algo errado aconteceu. Tente novamente em breve')));

    await sut.auth();
  });
}
