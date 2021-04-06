import 'package:injectable/injectable.dart';

import './i_categories_service.dart';

@LazySingleton(as: ICategoriesService)
class CategoriesService implements ICategoriesService {}
