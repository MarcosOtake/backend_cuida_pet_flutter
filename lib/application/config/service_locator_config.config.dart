// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../modules/categories/controller/categories_controller.dart' as _i3;
import '../../modules/categories/data/categories_repository.dart' as _i5;
import '../../modules/categories/data/i_categories_repository.dart' as _i4;
import '../../modules/categories/service/categories_service.dart' as _i7;
import '../../modules/categories/service/i_categories_service.dart' as _i6;
import '../../modules/user/controller/auth_controller.dart' as _i17;
import '../../modules/user/controller/user_controller.dart' as _i16;
import '../../modules/user/data/i_user_repository.dart' as _i11;
import '../../modules/user/data/user_repository.dart' as _i12;
import '../../modules/user/service/i_user_service.dart' as _i14;
import '../../modules/user/service/user_service.dart' as _i15;
import '../database/database_connection.dart' as _i9;
import '../database/i_database_connection.dart' as _i8;
import '../logger/i_logger.dart' as _i13;
import 'database_connection_configuration.dart'
    as _i10; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.CategoriesController>(() => _i3.CategoriesController());
  gh.lazySingleton<_i4.ICategoriesRepository>(() => _i5.CategoriesRepository());
  gh.lazySingleton<_i6.ICategoriesService>(() => _i7.CategoriesService());
  gh.lazySingleton<_i8.IDatabaseConnection>(() =>
      _i9.DatabaseConnection(get<_i10.DatabaseConnectionConfiguration>()));
  gh.lazySingleton<_i11.IUserRepository>(() => _i12.UserRepository(
      connection: get<_i8.IDatabaseConnection>(), log: get<_i13.ILogger>()));
  gh.lazySingleton<_i14.IUserService>(() => _i15.UserService(
      userRepository: get<_i11.IUserRepository>(), log: get<_i13.ILogger>()));
  gh.factory<_i16.UserController>(() => _i16.UserController(
      userService: get<_i14.IUserService>(), log: get<_i13.ILogger>()));
  gh.factory<_i17.AuthController>(() => _i17.AuthController(
      userService: get<_i14.IUserService>(), log: get<_i13.ILogger>()));
  return get;
}
