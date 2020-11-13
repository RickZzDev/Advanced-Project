import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;
  LoginPage(this.presenter);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          presenter.isLoadingStream.listen(
            (isLoading) {
              if (isLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  child: SimpleDialog(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Aguarde...", textAlign: TextAlign.center),
                        ],
                      )
                    ],
                  ),
                );
              } else {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              }
            },
          );

          presenter.mainErrorStream.listen(
            (error) {
              if (error != null) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red[900],
                    content: Text(
                      error,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            },
          );

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginHeader(),
                Headline1(
                  text: "Login",
                ),
                Padding(
                  padding: EdgeInsets.all(32),
                  child: Form(
                    child: Column(
                      children: [
                        StreamBuilder<String>(
                            stream: presenter.emailErrorStream,
                            builder: (context, snapshot) {
                              return TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  errorText: snapshot.data?.isEmpty == true
                                      ? null
                                      : snapshot.data,
                                  icon: Icon(
                                    Icons.email,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                ),
                                onChanged: presenter.validateEmail,
                                keyboardType: TextInputType.emailAddress,
                              );
                            }),
                        StreamBuilder<String>(
                            stream: presenter.passwordErrorStream,
                            builder: (context, snapshot) {
                              return Padding(
                                padding: EdgeInsets.only(top: 8, bottom: 32),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: "Senha",
                                    errorText: snapshot.data?.isEmpty == true
                                        ? null
                                        : snapshot.data,
                                    icon: Icon(
                                      Icons.lock,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                  ),
                                  onChanged: presenter.validatePassword,
                                  obscureText: true,
                                ),
                              );
                            }),
                        StreamBuilder<bool>(
                            stream: presenter.isFormValidStream,
                            builder: (context, snapshot) {
                              return RaisedButton(
                                onPressed: snapshot.data == true
                                    ? presenter.auth
                                    : null,
                                child: Text("Entrar".toUpperCase()),
                              );
                            }),
                        FlatButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.person),
                          label: Text("criar conta"),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
