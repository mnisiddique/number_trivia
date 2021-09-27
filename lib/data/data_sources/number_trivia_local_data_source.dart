import 'package:number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.

  Future<NumberTriviaModel> getLastTrivia();
  Future<void> cacheTrivia(NumberTriviaModel triviaModelToCache);
}