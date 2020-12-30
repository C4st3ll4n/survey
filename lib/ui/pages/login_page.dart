import 'package:flutter/material.dart';

const klogo = "lib/ui/assets/logo.png";

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Image.asset("$klogo"),
            ),
            Text("LOGIN"),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      icon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Senha",
                      icon: Icon(Icons.lock),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                  ),
                  RaisedButton(
                    child: Text("Entrar".toUpperCase()),
                    onPressed: () {},
                  ),
                  FlatButton.icon(onPressed: (){}, icon: Icon(Icons.person_add), label: Text("Criar conta")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
