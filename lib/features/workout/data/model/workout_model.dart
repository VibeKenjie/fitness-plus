import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/workout.dart';

class WorkoutModel extends WorkoutEntity {
  const WorkoutModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.repetition,
    required super.sets,
    required super.isFinished,
    required super.createdAt
  });

  factory WorkoutModel.fromFirestore(String id, String userId, Map<String, dynamic> data){
    return WorkoutModel(
      id: id,
      userId: userId, 
      name: data['name'], 
      repetition: data['repetition'], 
      sets: data['sets'], 
      isFinished: data['is_finished'],
      createdAt: (data['created_at'] as Timestamp).toDate()
    );
  }

  Map<String, dynamic> toFirestore(){
    return {
      'user_id': userId,
      'name': name,
      'repetition': repetition,
      'sets': sets,
      'is_finished': isFinished,
      'created_at': Timestamp.fromDate(createdAt)
    };
  }
}