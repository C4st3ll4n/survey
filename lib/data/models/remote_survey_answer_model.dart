import 'package:meta/meta.dart';
import '../http/http.dart';
import '../../domain/entities/entities.dart';

const String kImage = "image";
const String kIsCurrentAnswer = "isCurrentAccountAnswer";
const String kAnswer = "answer";
const String kPercent = "percent";
const String kCount = "count";

class RemoteSurveyAnswerModel {
	final String image;
	final String answer;
	final bool isCurrentAnswer;
	final int percent;
	
	RemoteSurveyAnswerModel({ this.image,
		@required this.answer,
		@required this.isCurrentAnswer,
		@required this.percent});
	
	factory RemoteSurveyAnswerModel.fromJson(Map json) {
		if (! json.keys.toSet().containsAll(
				[kAnswer, kIsCurrentAnswer, kPercent]))
			throw HttpError.invalidData;
		return RemoteSurveyAnswerModel(
			answer: json[kAnswer],
			isCurrentAnswer: json[kIsCurrentAnswer],
			percent: json[kPercent],
			image: json[kImage]??null
		);
	}
	
	SurveyAnswerEntity toEntity() =>
			SurveyAnswerEntity(
					isCurrentAnswer: this.isCurrentAnswer,
					answer: this.answer,
					percent: this.percent,
					image: this.image??null
			);
}
