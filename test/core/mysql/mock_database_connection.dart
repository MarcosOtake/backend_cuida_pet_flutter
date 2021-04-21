import 'package:cuidapet_api/application/database/i_database_connection.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_mysql_connection.dart';
import 'mock_results.dart';

class MockDatabaseConnection extends Mock implements IDatabaseConnection {
  final mysqlConnection = MockMysqlConnection();

  MockDatabaseConnection() {
    when(() => openConnection()).thenAnswer((_) async => mysqlConnection);
  }

  void mockQuery(MockResults mockResults, [List<Object>? params]) {
    when(() => mysqlConnection.query(any(), params ?? any()))
        .thenAnswer((_) async => mockResults);
  }
  
  void verifyConnectionClose() {
    verify(() => mysqlConnection.close()).called(1);
  }
}
