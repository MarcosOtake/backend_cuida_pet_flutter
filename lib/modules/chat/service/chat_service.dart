import 'package:injectable/injectable.dart';

import 'package:cuidapet_api/modules/chat/data/i_chat_repository.dart';

import './i_chat_service.dart';

@LazySingleton(as: IChatService)
class ChatService implements IChatService {
  final IChatRepository repository;

  ChatService({
    required this.repository,
  });

  @override
  Future<int> startChat(int scheduleId) => repository.startChat(scheduleId);
}
