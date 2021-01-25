import 'package:flutter/material.dart';
import 'package:survey/domain/entities/entities.dart';

class SurveyItem extends StatelessWidget {
  final SurveyEntity survey;

  const SurveyItem({Key key, this.survey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = const TextStyle(color: Colors.white);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0,1),
              spreadRadius: 0,
              blurRadius: 2,
              color: Colors.black
            )
          ]
        ),
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
      ),
    );
  }
}
