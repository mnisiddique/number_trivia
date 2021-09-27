import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/data/data_sources/number_trivia_remote_data_sources.dart';
import 'package:number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/data/repo_impls/number_trivia_repository_impl.dart';
import 'package:number_trivia/domain/entities/number_trivia.dart';

final String testee = "Number trivia repo";

class MockNumberTriviaLocalDatasource extends Mock
    implements NumberTriviaLocalDataSource {}

class MockNumberTriviaRemoteDatasource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

NumberTriviaRepositoryImpl numberTriviaRepositoryImpl;

MockNumberTriviaRemoteDatasource mockNumberTriviaRemoteDatasource;
MockNumberTriviaLocalDatasource mockNumberTriviaLocalDatasource;
MockNetworkInfo mockNetworkInfo;

void generalSetup() {
  mockNumberTriviaRemoteDatasource = MockNumberTriviaRemoteDatasource();
  mockNumberTriviaLocalDatasource = MockNumberTriviaLocalDatasource();
  mockNetworkInfo = MockNetworkInfo();
  numberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
    localDataSource: mockNumberTriviaLocalDatasource,
    remoteDataSource: mockNumberTriviaRemoteDatasource,
    networkInfo: mockNetworkInfo,
  );
}

void main() {
  group("Is Device Online: ", testWhetherDeviceIsOnline);

  group(
    "When Device Is Online: ",
    testWhenDeviceIsOnline,
  );

  group(
    "When Device Is Offline: ",
    testWhenDeviceIsOffline,
  );
  group(
    "When Device Is Online (Random trivia): ",
    testWhenDeviceIsOnlineRandomTrivia,
  );

  group(
    "When Device Is Offline (Random trivia): ",
    testWhenDeviceIsOfflineRandomTrivia,
  );
}

void testWhenDeviceIsOnlineRandomTrivia() {
  final tRandomNumber = 9;
  final tRandomNumberTriviaModel =
      NumberTriviaModel(tRandomNumber, "Test Random Number Trivia");

  setUp(() {
    generalSetup();
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
  });

  test(
      "$testee should return remote random data when call to remote datasource is successfull",
      () async {
    //arrange
    when(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia())
        .thenAnswer((realInvocation) async => tRandomNumberTriviaModel);

    //act
    final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();

    //assert
    verify(mockNetworkInfo.isConnected);
    expect(result, equals(Right(tRandomNumberTriviaModel)));
  });

  test(
      "$testee should cache remote random data locally when call to remote datasource is successfull",
      () async {
    //arrange
    when(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia())
        .thenAnswer((realInvocation) async => tRandomNumberTriviaModel);

    //act
    await numberTriviaRepositoryImpl.getRandomNumberTrivia();

    //assert
    verify(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia());
    verify(
        mockNumberTriviaLocalDatasource.cacheTrivia(tRandomNumberTriviaModel));
  });

  test(
      "$testee should return server failure when call to remote datasource is unsuccessfull",
      () async {
    //arrange
    when(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia())
        .thenThrow(ServerException());

    //act
    final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();

    //assert
    verify(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia());
    verifyZeroInteractions(mockNumberTriviaLocalDatasource);
    expect(result, equals(Left(ServerFailure())));
  });
}

void testWhenDeviceIsOfflineRandomTrivia() {
  final tRandomNumber = 9;
  final tRandomNumberTriviaModel =
      NumberTriviaModel(tRandomNumber, "Test Random Number Trivia");
  setUp(() {
    generalSetup();
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
  });

  test("$testee should return last locally cached data when data is present",
      () async {
    //arrange
    when(mockNumberTriviaLocalDatasource.getLastTrivia())
        .thenAnswer((realInvocation) async => tRandomNumberTriviaModel);
    //act
    final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();

    //assert
    verifyZeroInteractions(mockNumberTriviaRemoteDatasource);
    verify(mockNumberTriviaLocalDatasource.getLastTrivia());
    expect(result, equals(Right(tRandomNumberTriviaModel)));
  });
  test("$testee should return cache failure when data is not present",
      () async {
    //arrange
    when(mockNumberTriviaLocalDatasource.getLastTrivia())
        .thenThrow(CacheException());

    //act
    final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();

    //assert
    verifyZeroInteractions(mockNumberTriviaRemoteDatasource);
    verify(mockNumberTriviaLocalDatasource.getLastTrivia());
    expect(result, equals(Left(CacheFailure())));
  });
}

void testWhetherDeviceIsOnline() {
  final tNumber = 1;

  setUp(generalSetup);
  test("$testee should check whether device is online", () async {
    //arrange
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

    //act
    numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);

    //assert
    verify(mockNetworkInfo.isConnected);
  });
}

void testWhenDeviceIsOnline() {
  final tNumber = 1;
  final tNumberTriviaModel = NumberTriviaModel(tNumber, "Test trivia");
  final numberTrivia = tNumberTriviaModel;
  setUp(() {
    generalSetup();
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
  });

  test(
      "$testee should return remote data when call to remote data source is successfull",
      () async {
    //arrange
    when(mockNumberTriviaRemoteDatasource.getConcreteNumberTrivia(tNumber))
        .thenAnswer((_) async => tNumberTriviaModel);
    //act
    final result =
        await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);

    //assert
    expect(result, Right(tNumberTriviaModel));
  });

  test(
      "$testee should cache data locally when call to remote data source is successful",
      () async {
    //mockNumberTriviaLocalDatasource.cacheTrivia(triviaModelToCache)

    //arrange
    when(mockNumberTriviaRemoteDatasource.getConcreteNumberTrivia(tNumber))
        .thenAnswer((realInvocation) async => tNumberTriviaModel);

    //act
    await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);

    //assert
    verify(mockNumberTriviaRemoteDatasource.getConcreteNumberTrivia(tNumber));
    verify(mockNumberTriviaLocalDatasource.cacheTrivia(numberTrivia));
  });

  test(
      "$testee should return server failure when call to remote datasource is unsuccessful",
      () async {
    //arrange
    when(mockNumberTriviaRemoteDatasource.getConcreteNumberTrivia(tNumber))
        .thenThrow(ServerException());

    //act
    final result =
        await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);

    //assert
    verify(mockNumberTriviaRemoteDatasource.getConcreteNumberTrivia(tNumber));
    verifyZeroInteractions(mockNumberTriviaLocalDatasource);

    expect(result, equals(Left(ServerFailure())));
  });
}

void testWhenDeviceIsOffline() {
  final tNumber = 1;
  final tNumberTriviaModel =
      NumberTriviaModel(tNumber, "Test triviawhich was cached last");
  setUp(() {
    generalSetup();
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
  });

  test("$testee should return last locally cached data when data is present",
      () async {
    //arrange
    when(mockNumberTriviaLocalDatasource.getLastTrivia())
        .thenAnswer((_) async => tNumberTriviaModel);

    //act
    final result =
        await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);

    //assert
    verifyZeroInteractions(mockNumberTriviaRemoteDatasource);
    verify(mockNumberTriviaLocalDatasource.getLastTrivia());
    expect(result, equals(Right(tNumberTriviaModel)));
  });
  test("$testee should return server failure when data not present", () async {
    //arrange
    when(mockNumberTriviaLocalDatasource.getLastTrivia())
        .thenThrow(CacheException());

    //act
    final result =
        await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);

    //assert
    verifyZeroInteractions(mockNumberTriviaRemoteDatasource);
    verify(mockNumberTriviaLocalDatasource.getLastTrivia());
    expect(result, equals(Left(CacheFailure())));
  });
}
