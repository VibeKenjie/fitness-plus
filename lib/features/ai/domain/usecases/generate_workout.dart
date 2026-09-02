import '../entities/generated_workout.dart';

class GenerateWorkout {
  List<GeneratedWorkoutEntity> call(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return const [
          GeneratedWorkoutEntity(
            name: 'Pushup',
            repetition: 10,
            sets: 3,
          ),
          GeneratedWorkoutEntity(
            name: 'Squats',
            repetition: 12,
            sets: 3,
          ),
          GeneratedWorkoutEntity(
            name: 'Lunges',
            repetition: 10,
            sets: 2,
          ),
        ];

      case 'intermediate':
        return const [
          GeneratedWorkoutEntity(
            name: 'Bench Press',
            repetition: 10,
            sets: 4,
          ),
          GeneratedWorkoutEntity(
            name: 'Squats',
            repetition: 10,
            sets: 4,
          ),
          GeneratedWorkoutEntity(
            name: 'Pullup',
            repetition: 8,
            sets: 3,
          ),
          GeneratedWorkoutEntity(
            name: 'ShoulderPress',
            repetition: 10,
            sets: 3,
          ),
        ];

      case 'advanced':
        return const [
          GeneratedWorkoutEntity(
            name: 'Deadlift',
            repetition: 8,
            sets: 5,
          ),
          GeneratedWorkoutEntity(
            name: 'Bench Press',
            repetition: 8,
            sets: 5,
          ),
          GeneratedWorkoutEntity(
            name: 'Pullup',
            repetition: 10,
            sets: 4,
          ),
          GeneratedWorkoutEntity(
            name: 'Squats',
            repetition: 8,
            sets: 5,
          ),
        ];

      default:
        return const [];
    }
  }
}
