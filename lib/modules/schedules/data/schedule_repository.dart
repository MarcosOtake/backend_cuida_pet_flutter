import 'package:injectable/injectable.dart';

import './i_schedule_repository.dart';

@LazySingleton(as: IScheduleRepository)	
class ScheduleRepository implements  IScheduleRepository {

}