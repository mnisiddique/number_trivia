import 'package:number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel(int number, String text) : super(number, text);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      (json["number"] as num).toInt(),
      json["text"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"text": text, "number": number};
  }
}
