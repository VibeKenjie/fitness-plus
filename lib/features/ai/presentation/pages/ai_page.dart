import 'package:flutter/material.dart';

import '../../../../app/dependencies.dart';
import '../../domain/entities/generated_workout.dart';

class AIPage extends StatelessWidget {
  final VoidCallback onWorkoutsAdded;

  const AIPage({
    super.key,
    required this.onWorkoutsAdded,
  });

  @override
  Widget build(BuildContext context) {
    final aiController = AppDependencies.aiController;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Workout'),
      ),
      body: AnimatedBuilder(
        animation: aiController,
        builder: (context, child) {
          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Create Your Workout',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 8),

                const Text(
                  'Select your workout level and we will create a workout plan for you.',
                ),

                const SizedBox(height: 24),

                const Text(
                  'Workout Level',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                _LevelButton(
                  title: 'Beginner',
                  description: 'For people who are new to working out.',
                  selected: aiController.selectedLevel == 'Beginner',
                  onTap: () {
                    aiController.selectLevel('Beginner');
                  },
                ),

                const SizedBox(height: 12),

                _LevelButton(
                  title: 'Intermediate',
                  description: 'For people with some workout experience.',
                  selected: aiController.selectedLevel == 'Intermediate',
                  onTap: () {
                    aiController.selectLevel('Intermediate');
                  },
                ),

                const SizedBox(height: 12),

                _LevelButton(
                  title: 'Advanced',
                  description: 'For experienced people looking for a challenge.',
                  selected: aiController.selectedLevel == 'Advanced',
                  onTap: () {
                    aiController.selectLevel('Advanced');
                  },
                ),

                const SizedBox(height: 24),

                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: aiController.selectedLevel == null ||
                            aiController.isLoading
                        ? null
                        : () async {
                            await aiController.generateWorkout();
                          },
                    child: aiController.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Generate Workout'),
                  ),
                ),

                const SizedBox(height: 24),

                if (aiController.generatedWorkouts.isNotEmpty) ...[
                  Text(
                    '${aiController.selectedLevel} Workout',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 12),

                  ...aiController.generatedWorkouts.map(
                    (workout) => _GeneratedWorkoutCard(
                      workout: workout,
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: aiController.isLoading
                          ? null
                          : () async {
                              await _addWorkoutsToDashboard(
                                context,
                                aiController.generatedWorkouts,
                              );
                            },
                      child: const Text('Add to Dashboard'),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _addWorkoutsToDashboard(
    BuildContext context,
    List<GeneratedWorkoutEntity> workouts,
  ) async {
    final authController = AppDependencies.authController;
    final workoutController = AppDependencies.workoutController;

    final user = authController.user;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in.'),
        ),
      );
      return;
    }

    for (final workout in workouts) {
      final success = await workoutController.create(
        userId: user.id,
        name: workout.name,
        repetition: workout.repetition,
        sets: workout.sets,
      );

      if (!success) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              workoutController.errorMessage ??
                  'Failed to add workout.',
            ),
          ),
        );

        return;
      }
    }

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Workout added to your dashboard!'),
      ),
    );

    onWorkoutsAdded();
  }
}

class _LevelButton extends StatelessWidget {
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const _LevelButton({
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected
              ? Colors.blue.withValues(alpha: 0.1)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? Colors.blue
                : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selected ? Colors.blue : Colors.grey,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GeneratedWorkoutCard extends StatelessWidget {
  final GeneratedWorkoutEntity workout;

  const _GeneratedWorkoutCard({
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.fitness_center,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              workout.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            '${workout.repetition} reps × ${workout.sets} sets',
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}