/// Pure, side-effect-free logic that turns a user's stored interests into
/// a system prompt instructing the AI how to tailor its responses.
/// Kept as its own use case so it's independently testable and reusable
/// (e.g. if the app later adds prompt-preview settings).
class BuildSystemPrompt {
  static const Map<String, String> _interestGuidance = {
    'Fitness':
        'Frame answers around exercise, workout nutrition, recovery, and training routines.',
    'Finance':
        'Frame answers around budgeting, saving, and practical personal-finance trade-offs.',
    'Tech':
        'Frame answers with technical accuracy, mention relevant tools/technologies where useful.',
    'Travel':
        'Frame answers around destinations, itineraries, budgeting for trips, and travel logistics.',
    'Food':
        'Frame answers around recipes, cooking technique, and ingredient choices.',
    'Health':
        'Frame answers around general wellness, sleep, stress management, and preventive habits.',
    'Gaming':
        'Frame answers using gaming analogies and mention relevant games/genres where useful.',
    'Music':
        'Frame answers using musical references and mention relevant genres/artists where useful.',
  };

  String call(List<String> interests) {
    final buffer = StringBuffer()
      ..writeln(
        'You are a friendly, knowledgeable AI companion inside a mobile app. '
        'Keep answers concise, actionable, and conversational.',
      );

    if (interests.isEmpty) {
      buffer.writeln(
        'The user has not selected any interests yet — answer generally and helpfully.',
      );
      return buffer.toString();
    }

    buffer.writeln(
      "The user's selected interests are: ${interests.join(', ')}. "
      'Whenever a question is ambiguous or could be answered multiple ways, '
      "prefer the angle that matches these interests.",
    );

    for (final interest in interests) {
      final guidance = _interestGuidance[interest];
      if (guidance != null) buffer.writeln('- $interest: $guidance');
    }

    buffer.writeln(
      'Example: if asked "what should I eat?", a Fitness user should get '
      'workout-nutrition advice, while a Finance user should get budget-conscious '
      'meal suggestions — adapt every answer the same way.',
    );

    return buffer.toString();
  }
}
