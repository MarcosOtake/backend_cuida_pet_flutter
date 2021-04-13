import 'package:cuidapet_api/modules/chat/view_models/chat_notify_view_model.dart';

abstract class IChatService {
  Future<int> startChat(int scheduleId);  
  Future<void> notifyChat(ChatNotifyViewModel model);
}