import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../gamification/presentation/providers/gamification_provider.dart';
import '../../../onboarding/domain/usecases/get_preferences.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  void initState() {
    super.initState();
    // Interests + gamification stats live in local storage, not a stream,
    // so hydrate them once when the chat screen first mounts.
    Future.microtask(() async {
      final uid = ref.read(authProvider).user?.uid;
      if (uid == null) return;
      final result = await sl.getPreferences(GetPreferencesParams(uid));
      result.fold(
        (_) {},
        (prefs) => ref.read(gamificationProvider.notifier).setInterests(prefs.interests),
      );
      ref.read(gamificationProvider.notifier).loadStats(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    if (user == null) return const SizedBox.shrink();

    final interests = ref.watch(gamificationProvider).interests;
    final args = ChatArgs(user.uid, interests);
    final chatState = ref.watch(chatProvider(args));

    ref.listen(chatProvider(args), (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Companion'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.of(context).pushNamed('/profile'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatState.messages.isEmpty
                ? const Center(child: Text('Say hi to get started! 👋'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: chatState.messages.length,
                    itemBuilder: (context, index) =>
                        MessageBubble(message: chatState.messages[index]),
                  ),
          ),
          ChatInputField(
            isSending: chatState.isSending,
            onSend: (text) => ref.read(chatProvider(args).notifier).sendMessage(text),
          ),
        ],
      ),
    );
  }
}
