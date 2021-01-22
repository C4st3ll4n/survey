import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import '../../helpers/helpers.dart';

import '../../helpers/errors/errors.dart';
import '../../components/components.dart';
import '../pages.dart';
import 'components/components.dart';

class SignUpPage extends StatelessWidget {
  final SignUpPresenter presenter;

  const SignUpPage({Key key, this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _hideKeyboard() {
      final _currentFocus = FocusScope.of(context);
      if (_currentFocus.hasPrimaryFocus) {
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

          presenter.mainErrorStream.listen((UIError error) {
            if (error != null) {
              showErrorMessage(contexto, error.description);
            }
          });

          presenter.navigateToStream.listen((page) {
            if (page != null && page.trim().isNotEmpty) {
              Get.offAllNamed(page);
            }
          });

          return GestureDetector(
            onTap: _hideKeyboard,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginHeader(),
                  Headline1(
                    text: R.strings.addAccount,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Provider(
                      create: (BuildContext context) => presenter,
                      child: Form(
                        child: Column(
                          children: [
                            NameInput(),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: EmailInput(),
                            ),
                            PasswordInput(),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: PasswordConfirmationInput(),
                            ),
                            SignUpButton(),
                            FlatButton.icon(
                                onPressed: presenter.goToLogin,
                                icon: Icon(Icons.exit_to_app),
                                label: Text(R.strings.login)),
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
