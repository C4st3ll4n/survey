import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:survey/ui/pages/pages.dart';
import '../../components/components.dart';
import 'components/components.dart';

class LoginPage extends StatelessWidget {
  
  final LoginPresenter presenter;

  const LoginPage({Key key, this.presenter}) : super(key: key);
  
  
  @override
  Widget build(BuildContext context) {
  
    void _hideKeyboard() {
      final _currentFocus = FocusScope.of(context);
      if(_currentFocus.hasPrimaryFocus){
        _currentFocus.unfocus();
      }
    }
    
    return Scaffold(
      body: Builder(
        builder: (contexto) {
          presenter.isLoadingStream.listen(
            (isLoading) {
              if (isLoading) {
                showSimpleLoading(contexto);
              } else {
                hideLoading(contexto);
              }
            },
          );

          presenter.mainErrorStream.listen(
            (error) {
              if (error != null && error.trim().isNotEmpty) {
                showErrorMessage(contexto, error);
            }
            }
          );

          presenter.navigateToStream.listen(
                  (page) {
                if (page != null && page.trim().isNotEmpty) {
                  Get.offAllNamed(page);
                }
              }
          );
          
          return GestureDetector(
            onTap: _hideKeyboard,
            child: SingleChildScrollView(
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
                      create: (BuildContext context) => presenter,
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
            ),
          );
        },
      ),
    );
  }

  
}



