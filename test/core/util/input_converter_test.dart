import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/util/input_converter.dart';

final _testee = "Input Converter";

void main() {
  InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });

  group(
    "String To Signed Integer: ",
    () {
      test(
        "$_testee should return integer when string represents unsigned integer",
        () async {
          //arrange
          final String numberString = "988";

          //act
          final result = inputConverter.stringToUnsignedInteger(numberString);

          //assert
          expect(result, equals(Right(988)));
        },
      );
      test(
        "$_testee should return a Failure when string represents letter",
        () async {
          //arrange
          final String numberString = "abc";

          //act
          final result = inputConverter.stringToUnsignedInteger(numberString);

          //assert
          expect(result, Left(InputConvertionFailure()));
        },
      );
      test(
        "$_testee should return a failure when string represents negative integer",
        () async {
          //arrange
          final String numberString = "-988";

          //act
          final result = inputConverter.stringToUnsignedInteger(numberString);

          //assert
          expect(result, equals(Left(InputConvertionFailure())));
        },
      );
      test(
        "$_testee should return a failure when string represents fraction",
        () async {
          //arrange
          final String numberString = "98.8";

          //act
          final result = inputConverter.stringToUnsignedInteger(numberString);

          //assert
          expect(result, equals(Left(InputConvertionFailure())));
        },
      );
    },
  );
}
