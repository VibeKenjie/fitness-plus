import '../entities/workout.dart';
import '../repositories/workout_repository.dart';

class CreateWorkout {
  final WorkoutRepository repository;

  CreateWorkout(this.repository);

  Future<WorkoutEntity> call ({
    required String userId,
    required String name,
    required int repetition,
    required int sets
  }) {
    return repository.createWorkout(
      userId: userId, 
      name: name, 
      repetition: repetition, 
      sets: sets
    );
  }
}