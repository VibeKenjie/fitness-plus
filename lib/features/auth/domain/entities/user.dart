class UserEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime birthdate;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.birthdate
  });

  String get fullName => '$firstName $lastName';

  String get initials {
    if (firstName.isEmpty){
      return 'U';
    }
    return firstName[0].toUpperCase();
  }
}