import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/domain/entities/number_trivia.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(1, "Test Text");

  group("fromJson", () {
    test("Should be a subclass of number trivia entity", () async {
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    });

    test("should return a valid model when the JSON number is an integer",
        () async {
      final jsonMap = json.decode(fixture("trivia.json"));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });

    test("should return a valid model when the JSON number is a double",
        () async {
      final jsonMap = json.decode(fixture("trivia_double.json"));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });

    test("should return a valid JSON map containing proper data", () async {
      final result = tNumberTriviaModel.toJson();
      final expectedJson = {"text": "Test Text", "number": 1};
      expect(result, expectedJson);
    });
  });
}
