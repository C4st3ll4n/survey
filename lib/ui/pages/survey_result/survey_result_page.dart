import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../pages.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';

class SurveyResultPage extends StatelessWidget {
  final SurveysPresenter presenter;

  const SurveyResultPage({Key key, @required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    presenter.loadData();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(R.strings.surveys),
      ),
      body: Text("EOQ"),
    );
  }
}
