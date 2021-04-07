import 'package:cuidapet_api/application/exceptions/database_exception.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/category.dart';
import 'package:cuidapet_api/entities/supplier.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import 'package:cuidapet_api/application/database/i_database_connection.dart';
import 'package:cuidapet_api/dtos/supplier_nearby_me_dto.dart';

import './i_supplier_repository.dart';

@LazySingleton(as: ISupplierRepository)
class SupplierRepository implements ISupplierRepository {
  IDatabaseConnection connection;
  ILogger log;

  SupplierRepository({
    required this.connection,
    required this.log,
  });

  @override
  Future<List<SupplierNearbyMeDTO>> findNearByPosition(
      double lat, double lng, int distance) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final query = ''' 
        SELECT f.id, f.nome, f.logo, f.categorias_fornecedor_id,
          (6371 *
            acos(
                            cos(radians($lat)) *
                            cos(radians(ST_X(f.latlng))) *
                            cos(radians($lng) - radians(ST_Y(f.latlng))) +
                            sin(radians($lat)) *
                            sin(radians(ST_X(f.latlng)))
                )) AS distancia
            FROM fornecedor f
            HAVING distancia <= $distance;
      ''';

      final result = await conn.query(query);
      return result
          .map(
            (f) => SupplierNearbyMeDTO(
                id: f['id'],
                name: f['nome'],
                logo: (f['logo'] as Blob?)?.toString(),
                distance: f['distancia'],
                categoryId: f['categorias_fornecedor_id']),
          )
          .toList();
    } on MySqlException catch (e, s) {
      log.error('Erro ao buscar fornecedores perto de mim', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<Supplier?> findById(int id) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final query = '''
        select 
          f.id, f.nome, f.logo, f.endereco, f.telefone, ST_X(f.latlng) as lat, ST_Y(f.latlng) as lng,
          f.categorias_fornecedor_id, c.nome_categoria, c.tipo_categoria
        from fornecedor as f
          inner join categorias_fornecedor as c on (f.categorias_fornecedor_id = c.id)
        where 
          f.id = ?
      ''';
      final result = await conn.query(query, [id]);

      if (result.isNotEmpty) {
        final dataMysql = result.first;
        return Supplier(
          id: dataMysql['id'],
          name: dataMysql['nome'],
          logo: (dataMysql['logo'] as Blob?).toString(),
          address: dataMysql['endereco'],
          phone: dataMysql['telefone'],
          lat: dataMysql['lat'],
          lng: dataMysql['lng'],
          category: Category(
              id: dataMysql['categorias_fornecedor_id'],
              name: dataMysql['nome_categoria'],
              type: dataMysql['tipo_categoria']),
        );
      }
    } on MySqlException catch (e, s) {
      log.error('Erro ao buscar fornecedor', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}
