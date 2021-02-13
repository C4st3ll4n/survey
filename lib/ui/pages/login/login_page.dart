import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:survey/ui/mixins/mixins.dart';
import 'components/components.dart';
import '../pages.dart';
import '../../helpers/i18n/i18n.dart';
import '../../components/components.dart';
import '../../helpers/errors/errors.dart';

class LoginPage extends StatelessWidget with KeyboardManager, LoadingManager{
  
  final LoginPresenter presenter;

  const LoginPage({Key key, this.presenter}) : super(key: key);
  
  
  @override
  Widget build(BuildContext context) {
  
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
          
          handleLoading(stream: presenter.isLoadingStream, contexto: contexto);

          presenter.mainErrorStream.listen(
            (UIError error) {
              if (error != null) {
                showErrorMessage(contexto, error.description);
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
            onTap:()=> hideKeyboard(context),
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
                                onPressed: presenter.goToSignup,
                                icon: Icon(Icons.person_add),
                                label: Text(R.strings.addAccount)),
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



