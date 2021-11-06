import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      if (str == null || str.isEmpty) {
        throw FormatException();
      }

      final convertedInteger = int.parse(str);
      if (convertedInteger < 0) {
        throw FormatException();
      }
      return Right(convertedInteger);
    } on FormatException {
      return Left(InputConvertionFailure());
    }
  }
}

class InputConvertionFailure extends Failure {
  @override
  List<Object> get props => [];
}
