import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'supplier_controller.g.dart';

@Injectable()
class SupplierController {

   @Route.get('/')
   Future<Response> find(Request request) async { 
      return Response.ok(jsonEncode(''));
   }

   Router get router => _$SupplierControllerRouter(this);
}