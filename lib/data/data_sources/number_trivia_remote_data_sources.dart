import 'dart:convert';

import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/domain/entities/number_trivia.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTrivia> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTrivia> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl(this.client);

  Uri _httpUri(String path) => Uri.http("numbersapi.com", "$path");
  Map<String, String> _requestHeaders() => {'Content-Type': 'application/json'};

  @override
  Future<NumberTrivia> getConcreteNumberTrivia(int number) async {
    final response = await client.get(
      _httpUri("$number"),
      headers: _requestHeaders(),
    );
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }
    throw ServerException();
  }

  @override
  Future<NumberTrivia> getRandomNumberTrivia() async {
    final response = await client.get(
      _httpUri("random"),
      headers: _requestHeaders(),
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }
    throw ServerException();
  }
}
