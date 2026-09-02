import '../../domain/entities/generated_workout.dart';

class GeneratedWorkoutModel extends GeneratedWorkoutEntity {
  const GeneratedWorkoutModel({
    required super.name,
    required super.repetition,
    required super.sets,
  });

  factory GeneratedWorkoutModel.fromJson(Map<String, dynamic> json){
    return GeneratedWorkoutModel(
      name: json['name'] as String, 
      repetition: json['repetition'] as int, 
      sets: json['sets'] as int
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'name': name,
      'repetition': repetition,
      'sets': sets
    };
  }
}