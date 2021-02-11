import 'package:flutter/material.dart';
import 'package:survey/ui/components/reload_screen.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class SurveyResultPage extends StatelessWidget {
  final SurveyResultPresenter presenter;

  const SurveyResultPage({Key key, @required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    presenter.loadData();
  
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(R.strings.surveys),
      ),
      body: Builder(
        builder:(_){
          presenter.isLoadingStream.listen(
                (isLoading) {
              if (isLoading == true) {
                showSimpleLoading(context);
              } else {
                hideLoading(context);
              }
            },
          );
          
          return StreamBuilder<SurveyResultViewModel>(
            stream: presenter.surveyResultStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error, reload: presenter.loadData,);
              }
              if (snapshot.hasData) {
                return SurveyResult(viewModel: snapshot.data,);
              }
              return SizedBox(width: 0,);
            }
            
          );
        },
      ),
    );
  }
}
