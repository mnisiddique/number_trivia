import 'package:number_trivia/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/domain/repositories/number_trivia_repo.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepo _repo;

  GetRandomNumberTrivia(this._repo);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await _repo.getRandomNumberTrivia();
  }
}
