abstract class LoginPresenter {
  Stream<String> get emailErrorStream;
  Stream<String> get passwordErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<String> get navigateToStream;
  Stream<bool> get isLoadingStream;
  Stream<String> get mainErrorStream;

  void validateEmail(String email);

  void validatePassword(String pasword);

  Future<void> auth();

  void dispose();
}
