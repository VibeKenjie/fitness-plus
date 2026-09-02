class WorkoutEntity {
  final String id;
  final String userId;
  final String name;
  final int repetition;
  final int sets;
  final bool isFinished;
  final DateTime createdAt;

  const WorkoutEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.repetition,
    required this.sets,
    required this.isFinished,
    required this.createdAt
  });
}