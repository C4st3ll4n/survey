import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey/ui/pages/pages.dart';
import '../../components/components.dart';
import 'components/components.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  const LoginPage({Key key, @required this.presenter}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  @override
  void dispose() {
    widget.presenter.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (contexto) {
          widget.presenter.isLoadingStream.listen(
            (isLoading) {
              if (isLoading) {
                showSimpleLoading(contexto);
              } else {
                hideLoading(contexto);
              }
            },
          );

          widget.presenter.mainErrorStream.listen(
            (error) {
              if (error != null && error.trim().isNotEmpty) {
                showErrorMessage(contexto, error);
            }
            }
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
                  padding: const EdgeInsets.all(32),
                  child: Provider(
                    create: (BuildContext context) => widget.presenter,
                    child: Form(
                      child: Column(
                        children: [
                          EmailInput(),
                          Padding(
                            padding: const EdgeInsets.only(top:8.0, bottom: 32),
                            child: PasswordInput(),
                          ),
                          LoginButton(),
                          FlatButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.person_add),
                              label: Text("Criar conta")),
                        ],
                      ),
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



