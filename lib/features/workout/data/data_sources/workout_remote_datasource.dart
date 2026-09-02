import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutRemoteDatasource {
  final FirebaseFirestore _firestore;

  WorkoutRemoteDatasource({
    FirebaseFirestore? firestore
  }): _firestore = firestore ?? FirebaseFirestore.instance;

  Future<DocumentReference<Map<String, dynamic>>> createWorkout({
    required String userId,
    required String name,
    required int repetition,
    required int sets,
  }){
    return _firestore.collection('workouts').add({
      'user_id': userId,
      'name': name,
      'repetition': repetition,
      'sets': sets,
      'is_finished': false,
      'created_at': FieldValue.serverTimestamp()
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getWorkouts(String userId){
    return _firestore.collection('workouts').where('user_id', isEqualTo: userId).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getWorkout(String workoutId){
    return _firestore.collection('workouts').doc(workoutId).get();
  }

  Future<void> updateWorkout({
    required String workoutId,
    required String name,
    required int repetition,
    required int sets,
  }) {
    return _firestore.collection('workouts').doc(workoutId).update({
      'name': name,
      'repetition': repetition,
      'sets': sets
    });
  }

  Future<void> updateWorkoutStatus({
    required String workoutId,
    required bool isFinished
  }){
    return _firestore.collection('workouts').doc(workoutId).update({ 'is_finished': isFinished });
  }

  Future<void> deleteWorkout(String workoutId){
    return _firestore.collection('workouts').doc(workoutId).delete();
  }
}