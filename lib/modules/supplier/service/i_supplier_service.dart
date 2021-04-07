import 'package:cuidapet_api/dtos/supplier_nearby_me_dto.dart';
import 'package:cuidapet_api/entities/supplier.dart';
import 'package:cuidapet_api/entities/supplier_service.dart';
import 'package:cuidapet_api/modules/supplier/view_models/create_supplier_user_view_model.dart';

abstract class ISupplierService {
  Future<List<SupplierNearbyMeDTO>> findNearByMe(double lat, double lng);
  Future<Supplier?> findById(int id);
  Future<List<SupplierService>> findServicesBySupplier(int supplierId);
  Future<bool> checkUserEmailsExists(String email);
  Future<void> createUserSupplier(CreateSupplierUserViewModel model);
}