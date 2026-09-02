import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Signup {
  final AuthRepository repository;

  Signup(this.repository);

  Future<UserEntity> call({
    required String firstName,
    required String lastName,
    required DateTime birthdate,
    required String email,
    required String password,
  }) {
    return repository.signup(
      firstName: firstName, 
      lastName: lastName, 
      birthdate: birthdate, 
      email: email, 
      password: password
    );
  }
}
