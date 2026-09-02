import 'package:fitness_pulse/app/dependencies.dart';
import 'package:fitness_pulse/features/workout/presentation/widgets/workout_card.dart';
import 'package:flutter/material.dart';
import '../../../workout/domain/entities/workout.dart';
import '../widgets/progress_stats.dart';
import '../widgets/weekly_activity_card.dart';
import '../widgets/empty_progress.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final authController = AppDependencies.authController;
    final workoutController = AppDependencies.workoutController;
    final user = authController.user;
    if (user == null) return;

    await workoutController.loadWorkouts(user.id);
  }

  @override
  Widget build(BuildContext context){
    final workoutController = AppDependencies.workoutController;
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: workoutController, 
          builder: (context, child){
            if(workoutController.workouts.isEmpty && workoutController.isLoading){
              return const Center(
                child: CircularProgressIndicator()
              );
            }

            int getWeeklyWorkoutCount(List<WorkoutEntity> workouts){
              final now = DateTime.now();
              return workouts.where((workout){
                final diff = now.difference(workout.createdAt).inDays;
                return diff >= 0 && diff < 7;
              }).length;
            }

            final completedWorkouts = workoutController.workouts.where((workout) => workout.isFinished).toList();

            return RefreshIndicator(
              onRefresh: _loadWorkouts, 
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    'Your Progress:',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 14),

                  ProgressStats(
                    totalWorkouts: completedWorkouts.length,
                    weeklyWorkouts: getWeeklyWorkoutCount(completedWorkouts)
                  ),
                  const SizedBox(height: 16),
                  WeeklyActivityCard(
                    workouts: completedWorkouts
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Completed Workouts:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  if(completedWorkouts.isEmpty) 
                    EmptyProgress(),
                  ...completedWorkouts.map((workout) => WorkoutCard(
                    workout: workout,
                  ))
                ],
              )
            );
          }
        )
      )
    );
  }
}