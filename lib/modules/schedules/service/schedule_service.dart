import 'package:injectable/injectable.dart';

import './i_schedule_service.dart';

@LazySingleton(as: IScheduleService)
class ScheduleService implements IScheduleService {}
