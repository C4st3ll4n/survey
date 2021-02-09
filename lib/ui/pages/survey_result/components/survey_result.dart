import 'package:flutter/material.dart';
import 'package:survey/ui/pages/pages.dart';

import 'icons.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;

  const SurveyResult({
    Key key,
    this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.answers.length + 1,
      itemBuilder: (contexto, indice) {
        if (indice == 0) {
          return Container(
            padding: EdgeInsets.only(top: 40, bottom: 20, right: 20, left: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withAlpha(90),
            ),
            child: Text(
              "${viewModel.question}",
            ),
          );
        } else {
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
                    viewModel.answers[indice - 1].image!=null ? Image.network(
                      "${viewModel.answers[indice - 1].image}",
                      width: 50,
                    ) : SizedBox(width: 0,),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "${viewModel.answers[indice - 1].answer}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Text(
                      "${viewModel.answers[indice - 1].percent}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark),
                    ),
                    viewModel.answers[indice - 1].isCurrentAnswer
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
      },
    );
  }
}

