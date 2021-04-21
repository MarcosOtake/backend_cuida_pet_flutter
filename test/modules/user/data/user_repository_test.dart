import 'dart:convert';

import 'package:cuidapet_api/application/exceptions/database_exception.dart';
import 'package:cuidapet_api/application/exceptions/user_exists_exception.dart';
import 'package:cuidapet_api/application/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api/application/helpers/cripty_helper.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/user_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mysql1/mysql1.dart';
import 'package:test/test.dart';

import '../../../core/fixture/fixture_reader.dart';
import '../../../core/log/mock_logger.dart';
import '../../../core/mysql/mock_database_connection.dart';
import '../../../core/mysql/mock_mysql_exception.dart';
import '../../../core/mysql/mock_results.dart';

void main() {
  late MockDatabaseConnection database;
  late ILogger log;
  late UserRepository userRepository;

  setUp(() {
    database = MockDatabaseConnection();
    log = MockLogger();
    userRepository = UserRepository(connection: database, log: log);
  });

  group('Group test findById', () {
    test('Should return user by id', () async {
      //Arrange
      final userId = 1;
      final userFixtureDB = FixtureReader.getJsonData(
          'modules/user/data/fixture/find_by_id_sucess_fixture.json');
      final mockResults = MockResults(userFixtureDB, [
        'ios_token',
        'android_token',
        'refresh_token',
        'img_avatar',
      ]);

      database.mockQuery(mockResults);

      final userMap = jsonDecode(userFixtureDB);
      final userExpected = User(
          id: userMap['id'],
          email: userMap['email'],
          registerType: userMap['tipo_cadastro'],
          iosToken: userMap['ios_token'],
          androidToken: userMap['android_token'],
          refreshToken: userMap['refresh_token'],
          imageAvatar: userMap['img_avatar'],
          supplierId: userMap['fornecedor_id']);

      //Act
      final user = await userRepository.findById(userId);

      //Assert
      expect(user, isA<User>());
      expect(user, userExpected);
      database.verifyConnectionClose();
    });

    test('Should return exception UserNotFoundException option 1', () async {
      //Arrange
      final id = 1;
      final mockResults = MockResults();
      database.mockQuery(mockResults, [id]);
      //Act
      var call = userRepository.findById;

      //Assert
      expect(() => call(id), throwsA(isA<UserNotfoundException>()));
      await Future.delayed(Duration(seconds: 1));
      database.verifyConnectionClose();
    });

    test('Should return exception UserNotFoundException option 2', () async {
      //Arrange
      final id = 1;
      final mockResults = MockResults();
      database.mockQuery(mockResults, [id]);
      //Act
      try {
        await userRepository.findById(id);
      } catch (e) {
        if (e is UserNotfoundException) {
        } else {
          fail('Exception errada deveria retornar um UserNotFoundException');
        }
      }

      database.verifyConnectionClose();
    });
  });

  group('Group test create user', () {
    test('Should create user with success', () async {
      //Arrange
      final userId = 1;
      final mockResults = MockResults();
      when(() => mockResults.insertId).thenReturn(userId);
      database.mockQuery(mockResults);
      final userInsert = User(
        email: 'rodrigorahman@academiadoflutter.com.br',
        registerType: 'APP',
        imageAvatar: '',
        password: '123123',
      );

      final userExpected = User(
        id: userId,
        email: 'rodrigorahman@academiadoflutter.com.br',
        registerType: 'APP',
        imageAvatar: '',
        password: ''
      );

      //Act
      final user = await userRepository.createUser(userInsert);
      //Assert
      expect(user, userExpected);
    });
  
    test('Should throw DatabaseException', () async {
      //Arrange
      database.mockQueryException();
      //Act
      var call = userRepository.createUser;
      //Assert
      expect(() => call(User()), throwsA(isA<DatabaseException>()));
      
    });

    test('Should throw UserExistsException', () async {
      //Arrange
      final exception = MockMysqlException();
      when(() => exception.message).thenReturn('usuario.email_UNIQUE');
      database.mockQueryException(exception);
      //Act
      var call = userRepository.createUser;
      //Assert
      expect(() => call(User()), throwsA(isA<UserExistsException>()));
      
    });
  });
}
