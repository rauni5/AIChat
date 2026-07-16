import 'package:flutter/material.dart';
import '../../domain/entities/badge_entity.dart';

class BadgeTile extends StatelessWidget {
  final BadgeEntity badge;
  const BadgeTile({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.emoji_events, color: Colors.amber),
        title: Text(badge.title),
        subtitle: Text(badge.description),
      ),
    );
  }
}
