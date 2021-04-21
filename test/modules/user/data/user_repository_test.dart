import 'package:cuidapet_api/application/database/i_database_connection.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/user_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mysql1/mysql1.dart';
import 'package:test/test.dart';

import '../../../core/log/mock_logger.dart';
import '../../../core/mysql/mock_database_connection.dart';
import '../../../core/mysql/mock_mysql_connection.dart';
import '../../../core/mysql/mock_result_row.dart';
import '../../../core/mysql/mock_results.dart';

void main() {

  late IDatabaseConnection database;
  late ILogger log;
  late MySqlConnection mySqlConnection;
  late Results mysqlResults;
  late ResultRow mysqlResultRows;

  setUp((){
    database = MockDatabaseConnection();
    log = MockLogger();
    mySqlConnection = MockMysqlConnection();
    mysqlResults = MockResults();
    mysqlResultRows = MockResultRow();
  });

  group('Group test findById', () {
    test('Should return user by id', () async {
      //Arrange
      final userId = 1;
      final userRepository = UserRepository(connection: database, log: log);
      when(() => mySqlConnection.close()).thenAnswer((_) async => _);
      when(() => mysqlResults.first).thenReturn(mysqlResultRows);
      when(() => mysqlResultRows['id']).thenAnswer((invocation) => 1);
      when(() => mySqlConnection.query(any(), any())).thenAnswer((_) async => mysqlResults);
      when(() => mysqlResults.isEmpty).thenReturn(false);
      when(() => database.openConnection()).thenAnswer((_) async => mySqlConnection);
      
      //Act
      final user = await userRepository.findById(userId);
      
      //Assert
      expect(user, isA<User>());
      expect(user.id, 1);
    });
  });

}