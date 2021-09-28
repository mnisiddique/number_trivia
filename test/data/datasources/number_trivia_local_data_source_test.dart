import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart.';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

final _testee = "Local data source";

void main() {
  NumberTriviaLocalDataSourceImpl localDataSource;
  MockSharedPreferences mockSharedPreference;

  setUp(() {
    mockSharedPreference = MockSharedPreferences();
    localDataSource = NumberTriviaLocalDataSourceImpl(mockSharedPreference);
  });

  group("Getting Last Trivia: ", () {
    final tNumberTrivia =
        NumberTriviaModel.fromJson(json.decode(fixture("trivia_cached.json")));
    test("Should return trivia from shared preference when there is one",
        () async {
      //arrange
      when(mockSharedPreference.getString(any))
          .thenAnswer((_) => fixture("trivia_cached.json"));
      //act
      final result = await localDataSource.getLastTrivia();

      //assert
      verify(mockSharedPreference.getString("CACHED_NUMBER_TRIVIA"));
      expect(result, equals(tNumberTrivia));
    });
    test("Should throw cache exception when there is no cached number trivia",
        () async {
      //arrange
      when(mockSharedPreference.getString(any)).thenReturn(null);
      //act
      final call = localDataSource.getLastTrivia;

      //assert
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group(
    "Cache Trivia: ",
    () {
      final tTriviaModelToCache = NumberTriviaModel(1, "Test Trivia Text");
      test("$_testee should call shared preference to cache the trivia",
          () async {
        //act
        localDataSource.cacheTrivia(tTriviaModelToCache);

        //assert
        verify(
          mockSharedPreference.setString(
              NumberTriviaLocalDataSourceImpl.cachedNumberTriviaPreferenceKey,
              json.encode(tTriviaModelToCache.toJson())),
        );
      });
    },
  );
}
