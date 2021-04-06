import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'categories_controller.g.dart';

@Injectable()
class CategoriesController {

   @Route.get('/')
   Future<Response> find(Request request) async { 
      return Response.ok(jsonEncode({'message': 'Hello Categories'}));
   }

   Router get router => _$CategoriesControllerRouter(this);
}