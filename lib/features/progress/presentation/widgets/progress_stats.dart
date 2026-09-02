import 'package:flutter/material.dart';

class ProgressStats extends StatelessWidget {
  final int totalWorkouts;
  final int weeklyWorkouts;

  const ProgressStats({
    super.key,
    required this.totalWorkouts,
    required this.weeklyWorkouts
  });

  @override
  Widget build(BuildContext context){
    return Row (
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.fitness_center,
            value: totalWorkouts.toString(),
            label: 'Total Workouts',
          )
        ),
        const SizedBox(width: 11),
        Expanded(
          child: _StatCard(
            icon: Icons.calendar_today,
            value: weeklyWorkouts.toString(),
            label: 'This Week',
          )
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label
  });

  @override
  Widget build(BuildContext context){
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          bottom: BorderSide( color: Colors.grey.shade400 )
        )
      ),
      child: Column (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primary),
          const SizedBox(height: 12),
          Text (
            value,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 2),
          Text (
            label,
            style: const TextStyle( color: Colors.grey )
          ),
        ],
      )
    );
  }
}