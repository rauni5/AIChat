import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat_message_entity.dart';

abstract class ChatRepository {
  /// [interests] are injected into the system prompt so the AI's reply is
  /// tailored to the user's onboarding preferences. Returns only the AI's
  /// reply — chat history is kept in memory by the presentation layer for
  /// this session (no backend, so nothing to persist across devices/app
  /// restarts here; see README for how to add local persistence if needed).
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String userId,
    required String message,
    required List<String> interests,
    required List<ChatMessageEntity> history,
  });
}
