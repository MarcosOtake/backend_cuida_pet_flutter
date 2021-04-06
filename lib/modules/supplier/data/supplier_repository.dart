import 'package:injectable/injectable.dart';

import './i_supplier_repository.dart';
	
@LazySingleton(as: ISupplierRepository)
class SupplierRepository implements  ISupplierRepository {

}