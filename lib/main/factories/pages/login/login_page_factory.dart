import 'package:advancedProject/main/factories/factories.dart';
import 'package:advancedProject/ui/pages/login/login_page.dart';
import 'package:flutter/cupertino.dart';

Widget makeLoginPage() {
  return LoginPage(makeGetXLoginPresenter());
}
