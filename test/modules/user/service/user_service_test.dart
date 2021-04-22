import 'package:cuidapet_api/application/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/i_user_repository.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
import 'package:cuidapet_api/modules/user/service/user_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../core/log/mock_logger.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late IUserRepository userRepository;
  late ILogger log;
  late IUserService userService;

  setUp(() {
    userRepository = MockUserRepository();
    log = MockLogger();
    userService = UserService(userRepository: userRepository, log: log);
    registerFallbackValue<User>(User());
  });

  group('Group test loginWithEmailPassword', () {
    test('Should login with email and password', () async {
      //Arrange
      final id = 1;
      final email = 'rodrigorahman@gmail.com';
      final password = '123123';
      final supplierUser = false;
      final userMock = User(id: id, email: email);
      when(() => userRepository.loginWithEmailPassword(
          email, password, supplierUser)).thenAnswer((_) async => userMock);

      //Act
      final user = await userService.loginWithEmailPassword(
          email, password, supplierUser);

      //Assert
      expect(user, userMock);
      verify(() => userRepository.loginWithEmailPassword(
          email, password, supplierUser)).called(1);
    });

    test(
        'Should login with email and password and return UserNotfoundException',
        () async {
      //Arrange
      final email = 'rodrigorahman@gmail.com';
      final password = '123123';
      final supplierUser = false;
      when(() => userRepository.loginWithEmailPassword(
              email, password, supplierUser))
          .thenThrow(UserNotfoundException(message: 'Usuário não encontrado'));

      //Act
      final call = userService.loginWithEmailPassword;

      //Assert
      expect(() => call(email, password, supplierUser),
          throwsA(isA<UserNotfoundException>()));
      verify(() => userRepository.loginWithEmailPassword(
          email, password, supplierUser)).called(1);
    });
  });

  group('Group test loginWithSocial', () {
    test('Should login social with success', () async {
      //Arrange
      final email = 'rodrigorahman@academiadoflutter.com.br';
      final socialKey = '123';
      final socialType = 'Facebook';

      final userReturnLogin = User(
          id: 1, email: email, socialKey: socialKey, registerType: socialType);
      when(() => userRepository.loginByEmailSocialKey(
              email, socialKey, socialType))
          .thenAnswer((_) async => userReturnLogin);
      //Act
      final user =
          await userService.loginWithSocial(email, '', socialType, socialKey);

      //Assert
      expect(user, userReturnLogin);
      verify(() => userRepository.loginByEmailSocialKey(
          email, socialKey, socialType)).called(1);
    });

    test('Should login social with user not found and create a new user',
        () async {
      //Arrange
      final email = 'rodrigorahman@academiadoflutter.com.br';
      final socialKey = '123';
      final socialType = 'Facebook';

      final userCreated = User(
        id: 1,
        email: email,
        socialKey: socialKey,
        registerType: socialType,
      );

      when(() => userRepository.loginByEmailSocialKey(
              email, socialKey, socialType))
          .thenThrow(UserNotfoundException(message: 'Usuário não encontrado'));

      when(() => userRepository.createUser(any<User>()))
          .thenAnswer((_) async => userCreated);
      //Act
      final user =
          await userService.loginWithSocial(email, '', socialType, socialKey);

      //Assert
      expect(user, userCreated);
      verify(() => userRepository.loginByEmailSocialKey(
          email, socialKey, socialType)).called(1);
      verify(() => userRepository.createUser(any<User>())).called(1);
    });
  });
}
