import 'package:flutter/foundation.dart';
import '../../domain/entities/workout.dart';
import '../../data/model/workout_model.dart';
import '../../domain/usecases/create_workout.dart';
import '../../domain/usecases/get_workouts.dart';
import '../../domain/usecases/get_workout.dart';
import '../../domain/usecases/update_workout.dart';
import '../../domain/usecases/update_workout_status.dart';
import '../../domain/usecases/delete_workout.dart';

class WorkoutController extends ChangeNotifier {
  final CreateWorkout createWorkoutUseCase;
  final GetWorkout getWorkoutUseCase;
  final GetWorkouts getWorkoutsUseCase;
  final UpdateWokout updateWokoutUseCase;
  final UpdateWorkoutStatus updateWorkoutStatusUseCase;
  final DeleteWorkout deleteWorkoutUseCase;

  WorkoutController({
    required this.createWorkoutUseCase,
    required this.getWorkoutsUseCase,
    required this.getWorkoutUseCase,
    required this.updateWokoutUseCase,
    required this.updateWorkoutStatusUseCase,
    required this.deleteWorkoutUseCase
  });

  List<WorkoutEntity> _workouts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<WorkoutEntity> get workouts => _workouts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> loadWorkouts(String userId) async {
    _clearError();
    _setLoading(true);
    try {
      _workouts = await getWorkoutsUseCase(userId);
      return true;
    } catch (err) {
      _errorMessage = 'Failed to load workouts';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> create({
    required String userId,
    required String name,
    required int repetition,
    required int sets
  }) async {
    _clearError();
    _setLoading(true);

    try {
      final workout = await createWorkoutUseCase(
        userId: userId,
        name: name,
        repetition: repetition,
        sets: sets
      );

      _workouts.add(workout);
      return true;
    } catch (err) {
      _errorMessage = 'Failed to create workout.';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> update({
    required String workoutId,
    required String name,
    required int repetition,
    required int sets
  }) async {
    _clearError();
    _setLoading(true);

    try {
      await updateWokoutUseCase(
        workoutId: workoutId,
        name: name,
        repetition: repetition,
        sets: sets
      );

      final index = _workouts.indexWhere((workout) => workout.id == workoutId);

      if(index != -1) {
        final oldWorkout = _workouts[index];
        _workouts[index] = WorkoutModel(
          id: oldWorkout.id, 
          userId: oldWorkout.userId,
          name: name, 
          repetition: repetition, 
          sets: sets, 
          isFinished: oldWorkout.isFinished,
          createdAt: oldWorkout.createdAt
        );
      }

      return true;
    } catch (err) {
      debugPrint('Error: $err');
      _errorMessage = 'Failed to update workout.';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateStatus({
    required String workoutId,
    required bool isFinished
  }) async {
    _clearError();
    _setLoading(true);

    try {
      await updateWorkoutStatusUseCase(workoutId: workoutId, isFinished: isFinished);

      final index = _workouts.indexWhere((workout) => workout.id == workoutId);

      if(index != -1) {
        final oldWorkout = _workouts[index];
        _workouts[index] = WorkoutModel(
          id: oldWorkout.id, 
          userId: oldWorkout.userId, 
          name: oldWorkout.name, 
          repetition: oldWorkout.repetition, 
          sets: oldWorkout.sets, 
          isFinished: isFinished,
          createdAt: oldWorkout.createdAt
        );
        
      }

      return true;
    } catch (err) {
      debugPrint('Error: $err');
      _errorMessage = 'Failed to update workout status.';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> delete(String workoutId) async {
    _clearError();
    _setLoading(true);

    try {
      await deleteWorkoutUseCase(workoutId);
      _workouts.removeWhere((workout) => workout.id == workoutId);
      return true;
    } catch (err) {
      _errorMessage = 'Failed to delete the workout.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}