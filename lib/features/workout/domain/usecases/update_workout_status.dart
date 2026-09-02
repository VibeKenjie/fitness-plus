import '../repositories/workout_repository.dart';

class UpdateWorkoutStatus {
  final WorkoutRepository repository;

  UpdateWorkoutStatus(this.repository);

  Future<void> call({
    required String workoutId,
    required bool isFinished,
  }) {
    return repository.updateWorkoutStatus(
      workoutId: workoutId, 
      isFinished: isFinished
    );
  }
}