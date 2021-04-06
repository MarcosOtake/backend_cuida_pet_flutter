import 'package:injectable/injectable.dart';

import './i_categories_repository.dart';
	
@LazySingleton(as: ICategoriesRepository)
class CategoriesRepository implements  ICategoriesRepository {

}