import 'package:flutter/material.dart';
import '../../factories.dart';
import '../../../../ui/pages/pages.dart';

Widget makeSurveyResultPage(String surveyId)
=> SurveyResultPage(presenter: makeGetXSurveyResultPresenter(surveyId),);
