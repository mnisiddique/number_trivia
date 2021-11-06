import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'No Cached Trivia';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia concreteNumberTrivia;
  final GetRandomNumberTrivia randomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required InputConverter converter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(converter != null),
        concreteNumberTrivia = concrete,
        randomNumberTrivia = random,
        inputConverter = converter,
        super(Empty()) {
    on<NumberTriviaEvent>(_numberTriviaEventHandler);
  }

  FutureOr<void> _numberTriviaEventHandler(
    NumberTriviaEvent event,
    Emitter<NumberTriviaState> stateEmitter,
  ) async {
    switch (event.runtimeType) {
      case ConcreteNumberTriviaEvent:
        await _onConcreteTriviaEvent(
          (event as ConcreteNumberTriviaEvent).numberString,
          stateEmitter,
        );
        break;

      case RandomNumberTriviaEvent:
        await _onRandomTriviaEvent(stateEmitter);
        break;

      default:
        throw UnimplementedError();
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return "Unknown Error";
    }
  }

  NumberTriviaState _failureOrTriviaState(
      Either<Failure, NumberTrivia> either) {
    return either.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (numberTrivia) => Loaded(numberTivia: numberTrivia),
    );
  }

  FutureOr<void> _onConcreteTriviaEvent(
      String numberString, Emitter<NumberTriviaState> stateEmitter) async {
    final inputEither = inputConverter.stringToUnsignedInteger(numberString);
    stateEmitter(Empty());
    await inputEither.fold(
      (failure) async =>
          stateEmitter(Error(message: INVALID_INPUT_FAILURE_MESSAGE)),
      (integer) async {
        stateEmitter(Loading());
        final triviaOrFailure =
            await concreteNumberTrivia(NumberParam(integer));
        stateEmitter(_failureOrTriviaState(triviaOrFailure));
      },
    );
  }

  FutureOr<void> _onRandomTriviaEvent(
      Emitter<NumberTriviaState> stateEmitter) async {
    stateEmitter(Loading());
    final failureOrRandomTrivia = await randomNumberTrivia(NoParams());
    stateEmitter(_failureOrTriviaState(failureOrRandomTrivia));
  }
}
