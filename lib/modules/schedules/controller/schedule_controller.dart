
import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'schedule_controller.g.dart';

@Injectable()
class ScheduleController {

   @Route.get('/')
   Future<Response> find(Request request) async { 
      return Response.ok(jsonEncode(''));
   }

   Router get router => _$ScheduleControllerRouter(this);
}