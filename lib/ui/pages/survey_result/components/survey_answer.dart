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
            color: Theme.of(context).backgroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              viewModel.image!=null ? Image.network(
                "${viewModel.image}",
                width: 50,
              ) : SizedBox(width: 0,),
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
                    color: Theme.of(context).primaryColorDark),
              ),
              viewModel.isCurrentAnswer
                  ? ActiveIcon()
                  : DisableIcon(),
            ],
          ),
        ),
        Divider(
          height: 1,
        ),
      ],
    );
  }
}
