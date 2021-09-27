import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/domain/repositories/number_trivia_repo.dart';
import 'package:dartz/dartz.dart';

class GetConcreteNumberTrivia extends UseCase<NumberTrivia, NumberParam> {
  final NumberTriviaRepo _numberTriviaRepo;

  GetConcreteNumberTrivia(this._numberTriviaRepo);

  @override
  Future<Either<Failure, NumberTrivia>> call(NumberParam params) async {
    return await _numberTriviaRepo.getConcreteNumberTrivia(params.number);
  }
}

class NumberParam extends Equatable {
  final int number;

  NumberParam(this.number);

  @override
  List<Object> get props => [number];
}
