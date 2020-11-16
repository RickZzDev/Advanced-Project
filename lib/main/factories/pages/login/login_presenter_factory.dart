import 'package:advancedProject/main/factories/pages/login/login_validation_factory.dart';
import 'package:advancedProject/main/factories/usecases/authentication_factory.dart';
import 'package:advancedProject/presentation/presenters/stream_login_presenter.dart';
import 'package:advancedProject/ui/pages/login/login_presenter.dart';

LoginPresenter makeLoginPresenter() {
  return StreamLoginPresenter(
      authentication: makeRemoteAuthentication(),
      validation: makeLoginValidation());
}
