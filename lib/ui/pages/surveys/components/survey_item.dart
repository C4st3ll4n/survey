import 'package:flutter/material.dart';
import 'package:survey/domain/entities/entities.dart';

class SurveyItem extends StatelessWidget {
  final SurveyEntity survey;

  const SurveyItem({Key key, this.survey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = const TextStyle(color: Colors.white);
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
      child: Column(
        children: [
          Text(
            "${survey.dateTime}",
            style:
                _textStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "${survey.question}",
            style: _textStyle.copyWith(fontSize: 24),
          )
        ],
      ),
    );
  }
}
