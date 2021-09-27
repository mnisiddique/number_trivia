import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/domain/repositories/number_trivia_repo.dart';
import 'package:number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class NumberTriviaRepoMockImpl extends Mock implements NumberTriviaRepo {}

void main() {
  GetConcreteNumberTrivia concreteNumberTriviaUsecase;
  NumberTriviaRepoMockImpl mockRepo;

  setUp(() {
    mockRepo = NumberTriviaRepoMockImpl();
    concreteNumberTriviaUsecase = GetConcreteNumberTrivia(mockRepo);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(tNumber, "test");

  test("should get trivia for the number from the repository", () async {
    // "On the fly" implementation of the Repository using the Mockito package.
    // When getConcreteNumberTrivia is called with any argument, always answer with
    // the Right "side" of Either containing a test NumberTrivia object.
    when(mockRepo.getConcreteNumberTrivia(any))
        .thenAnswer((_) async => Right(tNumberTrivia));
    // The "act" phase of the test. Call the not-yet-existent method.
    final result = await concreteNumberTriviaUsecase(NumberParam(1));
    // UseCase should simply return whatever was returned from the Repository
    expect(result, Right(tNumberTrivia));
    // Verify that the method has been called on the Repository
    verify(mockRepo.getConcreteNumberTrivia(tNumber));
    // Only the above method should be called and nothing more.
    verifyNoMoreInteractions(mockRepo);
  });
}
