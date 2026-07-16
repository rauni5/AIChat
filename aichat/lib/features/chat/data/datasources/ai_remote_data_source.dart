import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/chat_message_entity.dart';

/// Talks to the Gemini API. Kept behind this interface so the repository
/// never needs to know transport details.
abstract class AiRemoteDataSource {
  Future<String> generateReply({
    required String systemPrompt,
    required String userMessage,
    required List<ChatMessageEntity> history,
  });
}

class AiRemoteDataSourceImpl implements AiRemoteDataSource {
  final DioClient _client;
  final String apiKey;

  AiRemoteDataSourceImpl({required this.apiKey, DioClient? client})
      : _client = client ?? DioClient();

  @override
  Future<String> generateReply({
    required String systemPrompt,
    required String userMessage,
    required List<ChatMessageEntity> history,
  }) async {
    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key=$apiKey';

    final contents = [
      ...history.map((m) => {
            'role': m.sender == MessageSender.ai ? 'model' : 'user',
            'parts': [
              {'text': m.text}
            ],
          }),
      {
        'role': 'user',
        'parts': [
          {'text': userMessage}
        ],
      },
    ];

    final response = await _client.safeRequest(() => _client.dio.post(
          url,
          data: {
            'system_instruction': {
              'parts': [
                {'text': systemPrompt}
              ],
            },
            'contents': contents,
          },
        ));

    try {
      final candidates = response.data['candidates'] as List;
      final text = candidates.first['content']['parts'][0]['text'] as String;
      return text.trim();
    } catch (_) {
      throw MalformedDataException('Unexpected Gemini response shape');
    }
  }
}
