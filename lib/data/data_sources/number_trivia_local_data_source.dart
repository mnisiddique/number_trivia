import 'dart:convert';

import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.

  Future<NumberTriviaModel> getLastTrivia();
  Future<void> cacheTrivia(NumberTriviaModel triviaModelToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  static const cachedNumberTriviaPreferenceKey = "CACHED_NUMBER_TRIVIA";
  final SharedPreferences _sharedPreferences;

  NumberTriviaLocalDataSourceImpl(this._sharedPreferences);

  @override
  Future<void> cacheTrivia(NumberTriviaModel triviaModelToCache) {
    return _sharedPreferences.setString(
      cachedNumberTriviaPreferenceKey,
      json.encode(triviaModelToCache.toJson()),
    );
  }

  @override
  Future<NumberTriviaModel> getLastTrivia() async {
    final lastTriviaJson =
        _sharedPreferences.getString(cachedNumberTriviaPreferenceKey);
    if (lastTriviaJson != null) {
      return Future.value(
        NumberTriviaModel.fromJson(
          json.decode(lastTriviaJson),
        ),
      );
    } else {
      throw CacheException();
    }
  }
}
