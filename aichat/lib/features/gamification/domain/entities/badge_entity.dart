import 'package:equatable/equatable.dart';

class BadgeEntity extends Equatable {
  final String id;
  final String title;
  final String description;

  const BadgeEntity({
    required this.id,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [id, title, description];
}

/// Static badge catalog. Kept in Domain because unlocking rules are
/// business logic, not a UI concern.
class BadgeCatalog {
  static const List<BadgeEntity> all = [
    BadgeEntity(id: 'first_question', title: 'First Steps', description: 'Ask your first question'),
    BadgeEntity(id: 'five_questions', title: '5 Questions Asked', description: 'Ask 5 questions'),
    BadgeEntity(id: 'twenty_five_questions', title: 'Curious Mind', description: 'Ask 25 questions'),
    BadgeEntity(id: 'three_day_streak', title: '3-Day Streak', description: 'Chat 3 days in a row'),
    BadgeEntity(id: 'seven_day_streak', title: '7-Day Streak', description: 'Chat 7 days in a row'),
  ];
}
