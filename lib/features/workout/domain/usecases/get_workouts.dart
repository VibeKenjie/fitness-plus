import '../entities/workout.dart';
import '../repositories/workout_repository.dart';

class GetWorkouts {
  final WorkoutRepository repository;

  GetWorkouts(this.repository);

  Future<List<WorkoutEntity>> call(String userId){
    return repository.getWorkouts(userId);
  }
}