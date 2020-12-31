import 'package:flutter/material.dart';
import 'package:survey/ui/pages/pages.dart';
import '../../components/components.dart';

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
                showDialog(
                  context: contexto,
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
                          Text(
                            "Aguarde",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    ],
                  ),
                );
              } else {
                if (Navigator.canPop(contexto)) {
                  Navigator.pop(contexto);
                }
              }
            },
          );

          widget.presenter.mainErrorStream.listen(
            (error) {
              if (error != null && error.isNotEmpty) {
                Scaffold.of(contexto).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red[900],
                    content: Text(error, textAlign: TextAlign.center,),
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
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    child: Column(
                      children: [
                        StreamBuilder<String>(
                          stream: widget.presenter.emailErrorStream,
                          builder: (ctx, snap) => TextFormField(
                            onChanged: widget.presenter.validateEmail,
                            decoration: InputDecoration(
                              errorText:
                                  snap.data?.isEmpty == true ? null : snap.data,
                              labelText: "Email",
                              icon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColorLight,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        StreamBuilder<String>(
                          stream: widget.presenter.passwordErrorStream,
                          builder: (ctx, snap) => Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 32),
                            child: TextFormField(
                              onChanged: widget.presenter.validatePassword,
                              decoration: InputDecoration(
                                labelText: "Senha",
                                errorText: snap.data?.isEmpty == true
                                    ? null
                                    : snap.data,
                                icon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                            ),
                          ),
                        ),
                        StreamBuilder<bool>(
                            stream: widget.presenter.isFormValidStream,
                            builder: (context, snapshot) {
                              return RaisedButton(
                                child: Text("Entrar".toUpperCase()),
                                onPressed: snapshot.data == true
                                    ? widget.presenter.auth
                                    : null,
                              );
                            }),
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
          );
        },
      ),
    );
  }
}
