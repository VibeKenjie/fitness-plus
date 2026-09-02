import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/workout.dart';
import '../../domain/repositories/workout_repository.dart';
import '../data_sources/workout_remote_datasource.dart';
import '../model/workout_model.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutRemoteDatasource remoteDatasource;
  WorkoutRepositoryImpl({
    required this.remoteDatasource
  });

  @override
  Future<WorkoutEntity> createWorkout({
    required String userId,
    required String name,
    required int repetition,
    required int sets,
  }) async {
    final document = await remoteDatasource.createWorkout(
      userId: userId, 
      name: name, 
      repetition: repetition,
      sets: sets
    );

    final snapshot = await document.get();

    if(!snapshot.exists || snapshot.data() == null) {
      throw Exception('Failed to retrieve created workout.');
    }

    final data = snapshot.data()!;

    return WorkoutModel(
      id: document.id,
      userId: userId,
      name: name,
      repetition: repetition,
      sets: sets,
      isFinished: false,
      createdAt: (data['created_at'] as Timestamp).toDate()
    );
  }

  @override
  Future<List<WorkoutEntity>> getWorkouts(String userId) async {
    final snapshot = await remoteDatasource.getWorkouts(userId);

    return snapshot.docs.map((document) {
      final data = document.data();

      return WorkoutModel.fromFirestore(document.id, data['user_id'] as String, data);
    }).toList();
  }

  @override
  Future<WorkoutEntity?> getWorkout(String workoutId) async {
    final document = await remoteDatasource.getWorkout(workoutId);

    if(!document.exists || document.data() == null) return null;

    final data = document.data()!;

    return WorkoutModel.fromFirestore(document.id, data['user_id'], data);
  }

  @override
  Future<void> updateWorkout({
    required String workoutId,
    required String name,
    required int repetition,
    required int sets
  }) {
    return remoteDatasource.updateWorkout(
      workoutId: workoutId, 
      name: name, 
      repetition: repetition, 
      sets: sets
    );
  }

  @override
  Future<void> updateWorkoutStatus({
    required String workoutId,
    required bool isFinished
  }) {
    return remoteDatasource.updateWorkoutStatus(
      workoutId: workoutId, 
      isFinished: isFinished
    );
  }

  @override
  Future<void> deleteWorkout(String workoutId){
    return remoteDatasource.deleteWorkout(workoutId);
  }
}