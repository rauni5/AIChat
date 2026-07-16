import 'package:flutter/material.dart';

class StreakIndicator extends StatelessWidget {
  final int currentStreak;
  const StreakIndicator({super.key, required this.currentStreak});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.local_fire_department, color: Colors.orange),
        const SizedBox(width: 4),
        Text('$currentStreak day streak', style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
