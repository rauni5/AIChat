import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/build_system_prompt.dart';
import '../datasources/ai_remote_data_source.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final AiRemoteDataSource aiDataSource;
  final BuildSystemPrompt buildSystemPrompt;

  ChatRepositoryImpl({
    required this.aiDataSource,
    BuildSystemPrompt? buildSystemPrompt,
  }) : buildSystemPrompt = buildSystemPrompt ?? BuildSystemPrompt();

  @override
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String userId,
    required String message,
    required List<String> interests,
    required List<ChatMessageEntity> history,
  }) async {
    try {
      final systemPrompt = buildSystemPrompt(interests);
      final replyText = await aiDataSource.generateReply(
        systemPrompt: systemPrompt,
        userMessage: message,
        history: history,
      );

      return Right(ChatMessageModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: replyText,
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
      ));
    } on ApiException catch (e) {
      return Left(AiServiceFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
