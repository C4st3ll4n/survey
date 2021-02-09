import 'package:flutter/material.dart';
import 'package:survey/ui/components/reload_screen.dart';
import 'package:survey/ui/pages/survey_result/components/components.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class SurveyResultPage extends StatelessWidget {
  final SurveyResultPresenter presenter;

  const SurveyResultPage({Key key, @required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(R.strings.surveys),
      ),
      body: Builder(
        builder:(contexto){
  
          presenter.isLoadingStream.listen(
                (isLoading) {
              if (isLoading == true) {
                showSimpleLoading(context);
              } else {
                hideLoading(context);
              }
            },
          );
          
          presenter.loadData();
          
          
          return StreamBuilder<Object>(
            stream: presenter.surveyResultStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error, reload: presenter.loadData,);
              }
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: (4 + 1),
                  itemBuilder: (contexto, indice) {
                    if (indice == 0) {
                      return Container(
                          padding: EdgeInsets.only(
                              top: 40, bottom: 20, right: 20, left: 20),
                          decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .disabledColor
                                .withAlpha(90),
                          ),
                          child: Text("Qual seu frame fav ?"));
                    } else {
                      return SurveyResult();
                    }
                  },
                );
              }
              return SizedBox(width: 0,);
            }
            
          );
        },
      ),
    );
  }
}
