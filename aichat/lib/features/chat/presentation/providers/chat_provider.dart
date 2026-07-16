import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/send_message.dart';
import '../../../gamification/presentation/providers/gamification_provider.dart';

class ChatState {
  final List<ChatMessageEntity> messages;
  final bool isSending;
  final String? errorMessage;

  const ChatState({
    this.messages = const [],
    this.isSending = false,
    this.errorMessage,
  });

  ChatState copyWith({
    List<ChatMessageEntity>? messages,
    bool? isSending,
    String? errorMessage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      errorMessage: errorMessage,
    );
  }
}

/// Family provider keyed by (userId, interests) so each signed-in user gets
/// isolated chat state. Messages live only in memory for this session —
/// there's no backend to persist them to (see ChatRepository docs).
class ChatNotifier extends StateNotifier<ChatState> {
  final String userId;
  final List<String> interests;
  final Ref ref;

  ChatNotifier(this.ref, this.userId, this.interests) : super(const ChatState());

  Future<void> sendMessage(String text) async {
    final userMessage = ChatMessageEntity(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isSending: true,
      errorMessage: null,
    );

    final result = await sl.sendMessage(SendMessageParams(
      userId: userId,
      message: text,
      interests: interests,
      history: state.messages,
    ));

    result.fold(
      (failure) => state = state.copyWith(isSending: false, errorMessage: failure.message),
      (aiMessage) {
        state = state.copyWith(
          messages: [...state.messages, aiMessage],
          isSending: false,
        );
        // Gamification hook: award points / update streak / check badges
        // for every meaningful (successfully answered) interaction.
        ref.read(gamificationProvider.notifier).recordInteraction(userId);
      },
    );
  }
}

final chatProvider = StateNotifierProvider.family<ChatNotifier, ChatState, ChatArgs>(
  (ref, args) => ChatNotifier(ref, args.userId, args.interests),
);

class ChatArgs {
  final String userId;
  final List<String> interests;
  const ChatArgs(this.userId, this.interests);

  @override
  bool operator ==(Object other) =>
      other is ChatArgs && other.userId == userId && _listEq(other.interests, interests);

  @override
  int get hashCode => Object.hash(userId, Object.hashAll(interests));

  static bool _listEq(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
