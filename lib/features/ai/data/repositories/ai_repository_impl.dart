import '../../domain/entities/generated_workout.dart';
import '../../domain/entities/workout_level.dart';
import '../../domain/repositories/ai_repository.dart';
import '../data_sources/ai_remote_datasource.dart';
import '../model/generated_workout_model.dart';

class AIRepositoryImpl implements AIRepository {
  final AIRemoteDatasource remoteDatasource;
  AIRepositoryImpl({ required this.remoteDatasource });

  @override
  Future<List<GeneratedWorkoutEntity>> generateWorkout({
    required WorkoutLevel level
  }) async {
    final levelString = level.name;

    final data = await remoteDatasource.generateWorkout(level: levelString);

    return data.map((json) => GeneratedWorkoutModel.fromJson(json)).toList();
  }
}
