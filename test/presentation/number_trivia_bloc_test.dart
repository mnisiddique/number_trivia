import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/domain/entities/number_trivia.dart';
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
NumberTrivia _tNumberTrivia;
final int _tNumberInteger = 1;

final _testee = "Number Trivia BLoC";

void main() {
  setUp(() {
    _tNumberTrivia = NumberTrivia(_tNumberInteger, "Test Trivia");
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

    void setUpMockInputConverterSuccess() =>
        when(_inputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(_tNumberInteger));

    void setUpMockConcreteNumberTriviaSuccess() =>
        when(_concreteNumberTrivia(any))
            .thenAnswer((_) async => Right(_tNumberTrivia));

    test(
      "$_testee should call input converter validate and convert string to unsigned integer",
      () async {
        setUpMockInputConverterSuccess();
        setUpMockConcreteNumberTriviaSuccess();

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

        expectLater(_triviaBloc.stream, emitsInOrder(expected));

        _triviaBloc.add(ConcreteNumberTriviaEvent(tNumberString));
      },
    );

    test(
      "$_testee should get data from concrete use case",
      () async {
        setUpMockInputConverterSuccess();
        setUpMockConcreteNumberTriviaSuccess();

        _triviaBloc.add(ConcreteNumberTriviaEvent(tNumberString));
        await untilCalled(_concreteNumberTrivia(any));
        verify(_concreteNumberTrivia(NumberParam(_tNumberInteger)));
      },
    );

    test(
      "$_testee should emit [Loading, Loaded] when data is gotten successfully",
      () async {
        setUpMockInputConverterSuccess();

        setUpMockConcreteNumberTriviaSuccess();

        final expected = [
          Empty(),
          Loading(),
          Loaded(numberTivia: _tNumberTrivia),
        ];

        expectLater(_triviaBloc.stream, emitsInOrder(expected));
        _triviaBloc.add(ConcreteNumberTriviaEvent(tNumberString));
      },
    );

    test(
      "$_testee should emit [Loading, error] when getting data fails",
      () async {
        setUpMockInputConverterSuccess();

        when(_concreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        final expectations = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];

        expectLater(_triviaBloc.stream, emitsInOrder(expectations));
        _triviaBloc.add(ConcreteNumberTriviaEvent(tNumberString));
      },
    );
    test(
      "$_testee should emit [Loading, error] with a proper message when getting data fails",
      () async {
        setUpMockInputConverterSuccess();

        when(_concreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        final expectations = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];

        expectLater(_triviaBloc.stream, emitsInOrder(expectations));
        _triviaBloc.add(ConcreteNumberTriviaEvent(tNumberString));
      },
    );
  });

  group("Random trivia: ", () {
    void setUpMockRandomNumberTriviaSuccess() => when(_randomNumberTrivia(any))
        .thenAnswer((_) async => Right(_tNumberTrivia));
    test(
      "$_testee should get random number trivia",
      () async {
        setUpMockRandomNumberTriviaSuccess();
        _triviaBloc.add(RandomNumberTriviaEvent());
        await untilCalled(_randomNumberTrivia(any));
        verify(_randomNumberTrivia(NoParams()));
      },
    );

    test(
      "$_testee should emit [Loading, Error] state when data loading fails",
      () {
        when(_randomNumberTrivia(NoParams()))
            .thenAnswer((_) async => Left(ServerFailure()));

        final expectations = [
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];

        expectLater(_triviaBloc.stream, emitsInOrder(expectations));

        _triviaBloc.add(RandomNumberTriviaEvent());
      },
    );
    test(
      "$_testee should emit [Loading, Error] state with proper message when data loading fails",
      () {
        when(_randomNumberTrivia(NoParams()))
            .thenAnswer((_) async => Left(CacheFailure()));

        final expectations = [
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];

        expectLater(_triviaBloc.stream, emitsInOrder(expectations));

        _triviaBloc.add(RandomNumberTriviaEvent());
      },
    );
    test(
      "$_testee should emit [Loading, Loaded] state when data loading successfull",
      () {
        setUpMockRandomNumberTriviaSuccess();

        final expectations = [
          Loading(),
          Loaded(numberTivia: _tNumberTrivia),
        ];

        expectLater(_triviaBloc.stream, emitsInOrder(expectations));

        _triviaBloc.add(RandomNumberTriviaEvent());
      },
    );
  });
}
