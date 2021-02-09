import 'package:flutter/material.dart';

class SurveyResult extends StatelessWidget {
	const SurveyResult({
		Key key,
	}) : super(key: key);
	
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
						children: [
							Image.network(
								"https://miro.medium.com/max/1000/1*ilC2Aqp5sZd1wi0CopD1Hw.png",
								width: 50,),
							Expanded(child: Padding(
								padding: const EdgeInsets.symmetric(
										horizontal: 10),
								child: Text("Vue JS ?",
									style: TextStyle(fontSize: 16),),
							)),
							Text("100 %", style: TextStyle(fontSize: 16,
									fontWeight: FontWeight.bold,
									color: Theme
											.of(context)
											.primaryColorDark),),
							Padding(
								padding: const EdgeInsets.only(left: 10),
								child: Icon(Icons.check_circle, color: Theme
										.of(context)
										.highlightColor,),
							),
						],
					),
				),
				Divider(height: 1,),
			],
		);
	}
}
