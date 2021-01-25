import 'package:faker/faker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../data/models/models.dart';
import 'components/components.dart';

class SurveysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Surveys"),
      ),
      body: CarouselSlider(
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
    );
  }
}
