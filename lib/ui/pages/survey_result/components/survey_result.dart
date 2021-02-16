import 'package:flutter/material.dart';
import 'package:survey/ui/pages/pages.dart';
import 'package:survey/ui/pages/survey_result/components/survey_header.dart';

import 'icons.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;
  final void Function({@required String answer}) onSave;

  const SurveyResult({
    Key key,
    this.viewModel,
    this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: (viewModel.answers.length + 1),
      itemBuilder: (contexto, indice) {
        if (indice == 0) {
          return SurveyHeader(
            question: viewModel.question,
          );
        } else {
          return GestureDetector(
              onTap:()=>onSave(answer:viewModel.answers[indice - 1].answer),
              child: SurveyAnswer(
                viewModel: viewModel.answers[indice - 1],
              ));
        }
      },
    );
  }
}
