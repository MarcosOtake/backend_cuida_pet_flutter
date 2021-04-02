import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/i_user_repository.dart';
import 'package:cuidapet_api/modules/user/view_models/user_save_input_model.dart';
import 'package:injectable/injectable.dart';

import './i_user_service.dart';

@LazySingleton(as: IUserService)
class UserService implements IUserService {

  IUserRepository userRepository;
  UserService({
    required this.userRepository,
  });

  @override
  Future<User> createUser(UserSaveInputModel user) {
    
    final userEntity = User(
      email: user.email,
      password: user.password,
      registerType: 'App',
      supplierId: user.supplierId
    );

    return userRepository.createUser(userEntity);
  }
}
