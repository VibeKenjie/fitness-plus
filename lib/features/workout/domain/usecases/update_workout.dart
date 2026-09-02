import '../repositories/workout_repository.dart';

class UpdateWokout {
  final WorkoutRepository repository;

  UpdateWokout(this.repository);

  Future<void> call ({
    required String workoutId,
    required String name,
    required int repetition,
    required int sets
  }) {
    return repository.updateWorkout(
      workoutId: workoutId, 
      name: name, 
      repetition: repetition, 
      sets: sets
    );
  }
}