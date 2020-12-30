import 'package:flutter/material.dart';
import 'package:survey/ui/pages/pages.dart';
import '../../components/components.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  const LoginPage({Key key, @required this.presenter}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginHeader(),
            Headline1(text: "Login",),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                child: Column(
                  children: [
                    StreamBuilder<String>(
                      stream: presenter.emailErrorStream,
                      builder:(ctx, snap)=> TextFormField(
                        onChanged: presenter.validateEmail,
                        decoration: InputDecoration(
                          errorText: snap.data?.isEmpty==true? null : snap.data,
                          labelText: "Email",
                          icon: Icon(
                            Icons.email,
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 32),
                      child: TextFormField(
                        onChanged: presenter.validatePassword,
                        decoration: InputDecoration(
                          labelText: "Senha",
                          icon: Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                      ),
                    ),
                    RaisedButton(
                      child: Text("Entrar".toUpperCase()),
                      onPressed: null,
                    ),
                    FlatButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.person_add),
                        label: Text("Criar conta")),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
