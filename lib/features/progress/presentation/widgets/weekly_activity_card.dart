import 'package:fitness_pulse/features/workout/domain/entities/workout.dart';
import 'package:flutter/material.dart';
import 'weekly_bar_chart.dart';

class WeeklyActivityCard extends StatelessWidget{
  final List<WorkoutEntity> workouts;
  
  const WeeklyActivityCard({
    super.key,
    required this.workouts
  });

  List<int> _getWeeklyCount(){
    final now = DateTime.now();

    final counts = List<int>.filled(7, 0);

    for (final workout in workouts){
      final diff = now.difference(workout.createdAt).inDays;

      if (diff >= 0 && diff <= 7){
        final index = 6 - diff;
        counts[index]++;
      }
    }
    return counts;
  }

  List<String> _getLabels(){
    final now = DateTime.now();
    return List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      const weekdays = [ 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun' ];
      return weekdays[date.weekday - 1];
    });
  }

  @override
  Widget build(BuildContext context){
    final counts = _getWeeklyCount();
    final labels = _getLabels();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
        border: Border(bottom: BorderSide(color: Colors.grey.shade400))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Weekly Activity', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: WeeklyBarChart(values: counts, labels: labels)
          )
        ],
      ),
    );
  }
}