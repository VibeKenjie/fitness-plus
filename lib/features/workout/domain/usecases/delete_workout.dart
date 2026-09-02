import '../repositories/workout_repository.dart';

class DeleteWorkout {
  final WorkoutRepository repository;

  DeleteWorkout(this.repository);

  Future<void> call (String workoutId){
    return repository.deleteWorkout(workoutId);
  }
}