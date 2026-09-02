import '../entities/workout.dart';

abstract class WorkoutRepository {
  Future<WorkoutEntity> createWorkout({
    required String userId,
    required String name,
    required int repetition,
    required int sets
  });

  Future<List<WorkoutEntity>> getWorkouts(String userId);
  
  Future<WorkoutEntity?> getWorkout(String workoutId);

  Future<void> updateWorkout({
    required String workoutId,
    required String name,
    required int repetition,
    required int sets
  });

  Future<void> updateWorkoutStatus({ 
    required String workoutId,
    required bool isFinished
  });

  Future<void> deleteWorkout(String workoutId);
}