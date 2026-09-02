import '../entities/workout.dart';
import '../repositories/workout_repository.dart';

class GetWorkout {
  final WorkoutRepository repository;

  GetWorkout(this.repository);

  Future<WorkoutEntity?> call(String workoutId){
    return repository.getWorkout(workoutId);
  }
}