import 'package:flutter/material.dart';
import 'package:survey/ui/pages/survey_result/components/components.dart';

import 'icons.dart';

class SurveyAnswer extends StatelessWidget {
	final SurveyAnswerViewModel viewModel;
	
	const SurveyAnswer({Key key, @required this.viewModel}) : super(key: key);
	
	@override
	Widget build(BuildContext context) {
		return Column(
			children: [
				Container(
					padding: const EdgeInsets.all(15),
					decoration: BoxDecoration(
						color: Theme
								.of(context)
								.backgroundColor,
					),
					child: Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: _buildItens(context),
					),
				),
				Divider(
					height: 1,
				),
			],
		);
	}
	
	List<Widget> _buildItens(BuildContext context) {
		List<Widget> children = [
			
			Expanded(
				child: Padding(
					padding: const EdgeInsets.symmetric(horizontal: 10),
					child: Text(
						"${viewModel.answer}",
						style: TextStyle(fontSize: 16),
					),
				),
			),
			Text(
				"${viewModel.percent}",
				style: TextStyle(
						fontSize: 16,
						fontWeight: FontWeight.bold,
						color: Theme
								.of(context)
								.primaryColorDark),
			),
			viewModel.isCurrentAnswer
					? ActiveIcon()
					: DisableIcon(),
		];
		
		if (viewModel.image != null) {
			children.insert(0, Image.network(
				"${viewModel.image}",
				width: 50,
				height: 60,
			));
		}
		
		return children;
	}
}
