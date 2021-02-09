import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:survey/ui/components/reload_screen.dart';
import 'surveys_presenter.dart';
import 'components/components.dart';
import '../pages.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';

class SurveysPage extends StatelessWidget {
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
          presenter.isLoadingStream.listen(
            (isLoading) {
              if (isLoading == true) {
                showSimpleLoading(context);
              } else {
                hideLoading(context);
              }
            },
          );

          /*
  
          presenter.navigateToStream.listen(
                  (page) {
                if (page != null && page.trim().isNotEmpty) {
                  Get.offAllNamed(page);
                }
              }
          );*/

          return StreamBuilder<List<SurveyViewModel>>(
              stream: presenter.surveysStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ReloadScreen(error: snapshot.error, reload: presenter.loadData,);
                }
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: CarouselSlider(
                      items: snapshot.data
                          .map((e) => SurveyItem(
                                survey: e,
                              ))
                          .toList(),
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        aspectRatio: 1,
                        enableInfiniteScroll: true
                      ),
                    ),
                  );
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
