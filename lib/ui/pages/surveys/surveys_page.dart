import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'surveys_presenter.dart';
import 'components/components.dart';
import '../pages.dart';
import '../../components/reload_screen.dart';
import '../../mixins/mixins.dart';
import '../../helpers/helpers.dart';

class SurveysPage extends StatefulWidget {
  final SurveysPresenter presenter;

  const SurveysPage({Key key, @required this.presenter}) : super(key: key);

  @override
  _SurveysPageState createState() {
    presenter.loadData();
    return _SurveysPageState();
  }
}

class _SurveysPageState extends State<SurveysPage>
    with LoadingManager, SessionManager, NavigationManager, RouteAware {
  
  
  
  @override
  Widget build(BuildContext context) {
    final routeObs = Get.find<RouteObserver>();
    routeObs.subscribe(this, ModalRoute.of(context));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(R.strings.surveys),
      ),
      body: Builder(
        builder: (_) {
          handleLoading(stream: widget.presenter.isLoadingStream, contexto: _);

          handleNavigation(stream: widget.presenter.navigateToStream);

          handleSession(
            stream: widget.presenter.isSessionExpiredStream,
          );

          return StreamBuilder<List<SurveyViewModel>>(
              stream: widget.presenter.surveysStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ReloadScreen(
                    error: snapshot.error,
                    reload: widget.presenter.loadData,
                  );
                }
                if (snapshot.hasData) {
                  return Provider(
                      create: (BuildContext context) => widget.presenter,
                      child: SurveyItens(
                        data: snapshot.data,
                      ));
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
  
  @override
  void didPopNext() => widget.presenter.loadData();

  @override
  void dispose() {
    Get.find<RouteObserver>().unsubscribe(this);
    super.dispose();
  }
}
