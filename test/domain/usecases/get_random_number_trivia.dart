import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/domain/repositories/number_trivia_repo.dart';
import 'package:number_trivia/domain/usecases/get_random_number_trivia.dart';

class NumberTriviaRepoImplMock extends Mock implements NumberTriviaRepo {}

void main() {
  NumberTriviaRepoImplMock mockRepo;
  GetRandomNumberTrivia randomTriviaUseCase;

// TODO: Investigate Why setup is not running as expected
//As setup is not running before everything mockRepo and usecase object remains
// null inside test case and shows runtime error
// but if we define mockRepo and use case inside test then test gets passed.

  setUp(() {
    print("Inside setup");
    mockRepo = NumberTriviaRepoImplMock();
    randomTriviaUseCase = GetRandomNumberTrivia(mockRepo);
  });

  final tNumber = 1;
  final tTrivia = NumberTrivia(tNumber, "Test for random number trivia");

  test('Should get trivia from repo', () async {
    print("Here the test runs");
    when(mockRepo.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tTrivia));

    final randomTrivia = await randomTriviaUseCase(NoParams());
    expect(randomTrivia, Right(tTrivia));
    verify(mockRepo.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockRepo);
  });
}
