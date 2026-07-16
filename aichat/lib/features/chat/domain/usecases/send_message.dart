import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessageParams {
  final String userId;
  final String message;
  final List<String> interests;
  final List<ChatMessageEntity> history;

  const SendMessageParams({
    required this.userId,
    required this.message,
    required this.interests,
    required this.history,
  });
}

class SendMessage implements UseCase<ChatMessageEntity, SendMessageParams> {
  final ChatRepository repository;
  SendMessage(this.repository);

  @override
  Future<Either<Failure, ChatMessageEntity>> call(SendMessageParams params) {
    if (params.message.trim().isEmpty) {
      return Future.value(const Left(ValidationFailure('Message cannot be empty.')));
    }
    return repository.sendMessage(
      userId: params.userId,
      message: params.message.trim(),
      interests: params.interests,
      history: params.history,
    );
  }
}
