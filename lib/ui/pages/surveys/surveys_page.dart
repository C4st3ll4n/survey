import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'surveys_presenter.dart';
import 'components/components.dart';
import '../pages.dart';
import '../../components/reload_screen.dart';
import '../../mixins/mixins.dart';
import '../../helpers/helpers.dart';

class SurveysPage extends StatelessWidget with LoadingManager{
  final SurveysPresenter presenter;

  const SurveysPage({Key key, @required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    presenter.loadData();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(R.strings.surveys),
      ),
      body: Builder(
        builder: (_) {
          handleLoading(stream: presenter.isLoadingStream, contexto: _);
  
          presenter.navigateToStream.listen(
                  (page) {
                if (page?.isNotEmpty == true) {
                  Get.toNamed(page);
                }
              }
          );
          
          presenter.isSessionExpiredStream.listen(
                  (isExpired) {
                if (isExpired==true) {
                  Get.offAllNamed("/login");
                }
              }
          );

          return StreamBuilder<List<SurveyViewModel>>(
              stream: presenter.surveysStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ReloadScreen(error: snapshot.error, reload: presenter.loadData,);
                }
                if (snapshot.hasData) {
                  return Provider(create: (BuildContext context) => presenter,
                  child: SurveyItens(data: snapshot.data,));
                } else {
                  return Container(
                    width: 0,
                    height: 0,
                  );
                }
              });
        },
      ),
    );
  }
}
