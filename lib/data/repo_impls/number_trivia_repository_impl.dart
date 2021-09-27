import 'package:flutter/foundation.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/data/data_sources/number_trivia_remote_data_sources.dart';
import 'package:number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:number_trivia/domain/repositories/number_trivia_repo.dart';

class NumberTriviaRepositoryImpl extends NumberTriviaRepo {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia =
            await remoteDataSource.getConcreteNumberTrivia(number);
        localDataSource.cacheTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await localDataSource.getLastTrivia());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    if (await networkInfo.isConnected) {
      try {
        final randomTrivia = await remoteDataSource.getRandomNumberTrivia();
        localDataSource.cacheTrivia(randomTrivia);
        return Right(randomTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await localDataSource.getLastTrivia());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
