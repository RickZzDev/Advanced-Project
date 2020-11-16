import 'package:advancedProject/domain/helpers/domain_error.dart';
import 'package:advancedProject/ui/pages/login/login_presenter.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import 'package:advancedProject/domain/usecases/authentication.dart';
import 'package:advancedProject/presentation/protocols/protocols.dart';

class GetXLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  String _email;
  String _password;

  var _emailError = RxString();
  var _passwordError = RxString();
  var _mainError = RxString();
  var _isFormValid = false.obs;
  var _isLoading = false.obs;

  Stream<String> get passwordErrorStream => _emailError.stream;

  Stream<String> get emailErrorStream => _passwordError.stream;

  Stream<bool> get isFormValidStream => _isFormValid.stream;

  Stream<String> get mainErrorStream => _mainError.stream;

  Stream<bool> get isLoadingStream => _isLoading.stream;

  GetXLoginPresenter(
      {@required this.validation, @required this.authentication});

  void validateEmail(String email) {
    _email = email;
    _emailError.value = validation.validate(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value =
        validation.validate(field: 'password', value: password);
    _validateForm();
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
  }

  Future<void> auth() async {
    _isLoading.value = true;

    try {
      await authentication
          .auth(AuthenticationParams(email: _email, secret: _password));
    } on DomainError catch (e) {
      _mainError.value = e.description;
    }

    _isLoading.value = false;
  }

  void dispose() {}
}
