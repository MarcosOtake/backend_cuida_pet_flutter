import 'package:cuidapet_api/dtos/supplier_nearby_me_dto.dart';
import 'package:cuidapet_api/entities/supplier.dart';

abstract class ISupplierService {
  Future<List<SupplierNearbyMeDTO>> findNearByMe(double lat, double lng);
  Future<Supplier?> findById(int id);
}