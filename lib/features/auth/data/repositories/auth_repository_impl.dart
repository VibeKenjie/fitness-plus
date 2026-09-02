import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_datasource.dart';
import '../model/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({ required this.remoteDataSource });

  @override
  Future<UserEntity> signup({
    required String firstName,
    required String lastName,
    required DateTime birthdate,
    required String email,
    required String password,
  }) async {
    final credential = await remoteDataSource.signup(email: email, password: password);
    final firebaseUser = credential.user;

    if(firebaseUser == null) {
      throw Exception('Could not create user');
    }

    await remoteDataSource.createUserProfile(
      uid: firebaseUser.uid, 
      firstName: firstName, 
      lastName: lastName, 
      email: email, 
      birthdate: birthdate
    );

    return UserModel(
      id: firebaseUser.uid, 
      firstName: firstName, 
      lastName: lastName, 
      email: email, 
      birthdate: birthdate
    );
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password
  }) async {
    final credential = await remoteDataSource.login(email: email, password: password);
    final firebaseUser = credential.user;

    if (firebaseUser == null){
      throw Exception('Login Failed.');
    }

    final document = await remoteDataSource.getUserProfile(firebaseUser.uid);

    if (!document.exists || document.data() == null){
      throw Exception('User profile not found.');
    }

    return UserModel.fromFirestore(firebaseUser.uid, document.data()!);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final firebaseUser = remoteDataSource.currentFirebaseUser;

    if (firebaseUser == null) return null;

    final document = await remoteDataSource.getUserProfile(firebaseUser.uid);

    if(!document.exists || document.data() == null) return null;

    return UserModel.fromFirestore(firebaseUser.uid, document.data()!);
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  Stream<UserEntity?> authStateChanges() async* {
    await for (final firebaseUser in remoteDataSource.authStateChanges){
      if (firebaseUser == null) {
        yield null;
        continue;
      }

      final document = await remoteDataSource.getUserProfile(firebaseUser.uid);
      
      if(!document.exists || document.data() == null) {
        yield null;
        continue;
      }

      yield UserModel.fromFirestore(firebaseUser.uid, document.data()!);
    }
  }
}