import 'package:advancedProject/main/factories/pages/login/login_page_factory.dart';
import 'package:advancedProject/ui/components/components.dart';
import 'package:advancedProject/ui/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: "/login",
          page: makeLoginPage,
        ),
        GetPage(
          name: "/surveys",
          page: () => Scaffold(
            body: Text("Enquetes"),
          ),
        )
      ],
      title: "Advanced",
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
    );
  }
}
