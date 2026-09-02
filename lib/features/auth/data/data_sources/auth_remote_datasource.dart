import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSource({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance, _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signup({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createUserProfile({
    required String uid,
    required String firstName,
    required String lastName,
    required String email,
    required DateTime birthdate,
  }) {
    return _firestore.collection('users').doc(uid).set({
      'first_name': firstName,
      'last_name': lastName,
      'birthdate': Timestamp.fromDate(birthdate),
      'email': email,
      'created_at': FieldValue.serverTimestamp()
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile(String uid){
    return _firestore.collection('users').doc(uid).get();
  }

  Future<void> logout(){
    return _firebaseAuth.signOut();
  }

  User? get currentFirebaseUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges();
  }
}