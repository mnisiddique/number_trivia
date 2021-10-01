import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart.';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/data/data_sources/number_trivia_remote_data_sources.dart';
import 'package:number_trivia/data/models/number_trivia_model.dart';

import '../../fixtures/fixture_reader.dart';

final _testee = "Remote Data Source";

class MockHttpClient extends Mock implements http.Client {}

MockHttpClient _mockHttpClient;
NumberTriviaRemoteDataSourceImpl _remoteDataSource;

void _generalSetup() {
  _mockHttpClient = MockHttpClient();
  _remoteDataSource = NumberTriviaRemoteDataSourceImpl(_mockHttpClient);
}

void _setupMockHttpClientSuccess() {
  when(_mockHttpClient.get(any, headers: anyNamed("headers"))).thenAnswer(
    (_) async => http.Response(
      fixture("trivia.json"),
      200,
    ),
  );
}

void _setupMockHttpClientFailure() {
  when(_mockHttpClient.get(any, headers: anyNamed("headers"))).thenAnswer(
    (_) async => http.Response(
      fixture("trivia.json"),
      404,
    ),
  );
}

void main() {
  group("Concrete Number Trivia ($_testee Impl): ", _testConcreteNumberTrivia);
  group("Random Number Trivia ($_testee Impl): ", _testRandomNumberTrivia);
}

void _testConcreteNumberTrivia() {
  final tNumber = 1;
  NumberTriviaModel tNumberTriviaModel;
  setUp(() {
    _generalSetup();
    tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));
  });

//Expectations:
//1. getConcreteNumberTrivia will perform get request on a certain url
//   by using the integer number supplied as url path and
//   with appropriate header.
//2. getConcreteNumberTrivia will return number trivia if succeeded
//3. getConcreteNumberTrivia will throw server exception if it fails

  test(
      "$_testee should preform a GET request on a URL with number being the endpoint and with application/json header",
      () async {
    //arrange
    _setupMockHttpClientSuccess();

    //act
    _remoteDataSource.getConcreteNumberTrivia(tNumber);

    //assert
    verify(_mockHttpClient.get(
      Uri.http("numbersapi.com", "$tNumber"),
      headers: {'Content-Type': 'application/json'},
    ));
  });

  test(
    "$_testee should return number trivia when the response code is 200 (success)",
    () async {
      //arrange
      _setupMockHttpClientSuccess();

      //act
      final result = await _remoteDataSource.getConcreteNumberTrivia(tNumber);

      //assert
      expect(result, equals(tNumberTriviaModel));
    },
  );
  test(
    "$_testee should throw server exception when the response code is not 200 (failure)",
    () async {
      //arrange
      _setupMockHttpClientFailure();

      //act
      final call = _remoteDataSource.getConcreteNumberTrivia;

      //assert
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    },
  );
}

void _testRandomNumberTrivia() {
  final tNumber = 1;
  NumberTriviaModel tNumberTriviaModel;
  setUp(() {
    _generalSetup();
    tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));
  });

  test(
    "$_testee should preform a GET request on a URL with the word 'random' being the endpoint and with application/json header",
    () async {
      //arrange
      _setupMockHttpClientSuccess();

      //act
      _remoteDataSource.getRandomNumberTrivia();

      //assert
      verify(
        _mockHttpClient.get(
          Uri.http("numbersapi.com", "random"),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    },
  );
  test(
    "$_testee should return random number trivia when the response code is 200 (success)",
    () async {
      //arrange
      _setupMockHttpClientSuccess();

      //act
      final result = await _remoteDataSource.getRandomNumberTrivia();

      //assert
      expect(result, equals(tNumberTriviaModel));
    },
  );

  test(
    "$_testee should throw server exception when the response code is not 200 (failure)",
    () async {
      //arrange
      _setupMockHttpClientFailure();

      //act
      final call = _remoteDataSource.getRandomNumberTrivia;

      //assert
      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    },
  );
}
