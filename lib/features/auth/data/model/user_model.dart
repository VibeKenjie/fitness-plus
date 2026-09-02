import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.birthdate,
  });

  factory UserModel.fromFirestore( String id, Map<String, dynamic> data ){
    return UserModel(
      id: id, 
      firstName: data['first_name'], 
      lastName: data['last_name'], 
      email: data['email'], 
      birthdate: (data['birthdate'] as Timestamp).toDate()
    );
  }

  Map<String, dynamic> toFirestore(){
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'birthdate': Timestamp.fromDate(birthdate)
    };
  }
}