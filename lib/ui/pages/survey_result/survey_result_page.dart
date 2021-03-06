import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/reload_screen.dart';
import '../../mixins/mixins.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class SurveyResultPage extends StatelessWidget with LoadingManager, SessionManager {
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
          
          handleLoading(stream: presenter.isLoadingStream, contexto: _);

          handleSession(stream: presenter.isSessionExpiredStream);

          return StreamBuilder<SurveyResultViewModel>(
            stream: presenter.surveyResultStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error, reload: presenter.loadData,);
              }
              if (snapshot.hasData) {
                return SurveyResult(viewModel: snapshot.data,onSave: presenter.save,);
              }
              return SizedBox(width: 0,);
            }
            
          );
        },
      ),
    );
  }
}
