import '../../domain/entities/generated_workout.dart';
import '../../domain/entities/workout_level.dart';

abstract class AIRepository {
  Future<List<GeneratedWorkoutEntity>> generateWorkout({
    required WorkoutLevel level
  });
}