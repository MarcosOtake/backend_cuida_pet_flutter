import 'package:cuidapet_api/dtos/supplier_nearby_me_dto.dart';

abstract class ISupplierService {
  Future<List<SupplierNearbyMeDTO>> findNearByMe(double lat, double lng);
}