import 'package:injectable/injectable.dart';

import './i_supplier_service.dart';

@LazySingleton(as: ISupplierService)
class SupplierService implements ISupplierService {}
