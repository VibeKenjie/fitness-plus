import 'package:flutter/foundation.dart';

import '../../domain/entities/generated_workout.dart';
import '../../domain/usecases/generate_workout.dart';

class AIController extends ChangeNotifier {
  final GenerateWorkout generateWorkoutUseCase;

  AIController({
    required this.generateWorkoutUseCase,
  });

  String? _selectedLevel;
  List<GeneratedWorkoutEntity> _generatedWorkouts = [];
  bool _isLoading = false;

  String? get selectedLevel => _selectedLevel;
  List<GeneratedWorkoutEntity> get generatedWorkouts => _generatedWorkouts;
  bool get isLoading => _isLoading;

  void selectLevel(String level) {
    _selectedLevel = level;
    _generatedWorkouts = [];

    notifyListeners();
  }

  Future<bool> generateWorkout() async {
    if (_selectedLevel == null) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _generatedWorkouts = generateWorkoutUseCase(_selectedLevel!);

    _isLoading = false;
    notifyListeners();

    return _generatedWorkouts.isNotEmpty;
  }

  void clear() {
    _selectedLevel = null;
    _generatedWorkouts = [];

    notifyListeners();
  }
}
