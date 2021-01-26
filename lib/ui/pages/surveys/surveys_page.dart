import 'package:faker/faker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:survey/ui/helpers/helpers.dart';
import 'package:survey/ui/pages/surveys/surveys_presenter.dart';
import '../../../data/models/models.dart';
import 'components/components.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;

  const SurveysPage({Key key,@required this.presenter}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    presenter.loadData();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(R.strings.surveys),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical:20.0),
        child: CarouselSlider(
          items: [
            SurveyItem(survey: RemoteSurveyModel.fromJson({
              "id": faker.guid.guid(),
              "question": faker.randomGenerator.string(50),
              "didAnswer": faker.randomGenerator.boolean(),
              "dateTime": faker.date.dateTime().toIso8601String()
            }).toEntity(),)
          ],
          options: CarouselOptions(
            enlargeCenterPage: true,aspectRatio: 1
          ),
        ),
      ),
    );
  }
}
