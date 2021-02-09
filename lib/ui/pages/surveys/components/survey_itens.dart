import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../survey_view_model.dart';
import 'components.dart';

class SurveyItens extends StatelessWidget {
	final List<SurveyViewModel> data;
	const SurveyItens({
		Key key, @required this.data,
	}) : super(key: key);
	
	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: const EdgeInsets.symmetric(vertical: 20.0),
			child: CarouselSlider(
				items: data
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
	}
}
