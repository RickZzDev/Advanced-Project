import 'package:advancedProject/main/factories/pages/login/login_validation_factory.dart';
import 'package:advancedProject/main/factories/usecases/authentication_factory.dart';
import 'package:advancedProject/presentation/presenters/getx_login_presenter.dart';
import 'package:advancedProject/presentation/presenters/presenters.dart';
import 'package:advancedProject/ui/pages/login/login_presenter.dart';

LoginPresenter makeStreamLoginPresenter() {
  return StreamLoginPresenter(
      authentication: makeRemoteAuthentication(),
      validation: makeLoginValidation());
}

LoginPresenter makeGetXLoginPresenter() {
  return GetXLoginPresenter(
      authentication: makeRemoteAuthentication(),
      validation: makeLoginValidation());
}
