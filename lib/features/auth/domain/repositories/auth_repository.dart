import '../../domain/entities/user.dart';

abstract class AuthRepository {
  Future<UserEntity> signup ({
    required String firstName,
    required String lastName,
    required DateTime birthdate,
    required String email,
    required String password
  });

  Future<UserEntity> login({
    required String email,
    required String password
  });

  Future<UserEntity?> getCurrentUser();

  Future<void> logout();

  Stream<UserEntity?> authStateChanges();
}