import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

MockGetConcreteNumberTrivia _concreteNumberTrivia;
MockGetRandomNumberTrivia _randomNumberTrivia;
MockInputConverter _inputConverter;
NumberTriviaBloc _triviaBloc;

final _testee = "Number Trivia BLoC";

void main() {
  setUp(() {
    _concreteNumberTrivia = MockGetConcreteNumberTrivia();
    _randomNumberTrivia = MockGetRandomNumberTrivia();
    _inputConverter = MockInputConverter();
    _triviaBloc = NumberTriviaBloc(
      concrete: _concreteNumberTrivia,
      random: _randomNumberTrivia,
      converter: _inputConverter,
    );
  });

  test("$_testee should have empty state initially", () {
    final initialSate = _triviaBloc.state;
    expect(
      initialSate,
      equals(Empty()),
    );
  });

  group("Concrete Trivia: ", () {
    final String tNumberString = "1";
    final int tNumberInteger = 1;

    test(
      "$_testee should call input converter validate and convert string to unsigned integer",
      () async {
        when(_inputConverter.stringToUnsignedInteger(tNumberString))
            .thenReturn(Right(tNumberInteger));

        _triviaBloc.add(ConcreteNumberTriviaEvent(tNumberString));
        /**
         * We await untilCalled() because the logic inside a Bloc is triggered through a 
         * Stream<Event> which is, of course, asynchronous itself. Had we not awaited 
         * until the stringToUnsignedInteger has been called, the verification would 
         * always fail​, since we'd verify before the code had a chance to execute.
         */
        await untilCalled(_inputConverter.stringToUnsignedInteger(any));

        verify(_inputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      "$_testee should emit [Error] when the input is invalid",
      () async {
        when(_inputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InputConvertionFailure()));

        final expected = [
          Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];

        expectLater(_triviaBloc.state, emitsInOrder(expected));

        _triviaBloc.add(ConcreteNumberTriviaEvent(tNumberString));
      },
    );
  });
}
