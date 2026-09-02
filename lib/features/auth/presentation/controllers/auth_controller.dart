import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/signup.dart';

class AuthController extends ChangeNotifier {
  final Login loginUseCase;
  final Logout logoutUseCase;
  final Signup signupUseCase;

  AuthController({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.signupUseCase
  });

  UserEntity? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserEntity? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;

  Future<bool> signup({
    required String firstName,
    required String lastName,
    required DateTime? birthdate,
    required String email,
    required String password,
    required String confirmPassword
  }) async {
    _clearError();

    if(firstName.trim().isEmpty || lastName.trim().isEmpty || birthdate == null || email.trim().isEmpty || password.isEmpty || confirmPassword.isEmpty){
      _errorMessage = 'Please fill in all fields.';
      notifyListeners();
      return false;
    }

    if(password != confirmPassword){
      _errorMessage = 'Password doesn\'t match.';
      notifyListeners();
      return false;
    }

    if (password.length < 8) {
      _errorMessage = 'Password must contain at least 8 characters';
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      _user = await signupUseCase(
        firstName: firstName.trim(), 
        lastName: lastName.trim(), 
        birthdate: birthdate, 
        email: email.trim(), 
        password: password 
      );

      return true;
    } catch (err){
      _errorMessage = _formatError(err);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login({
    required String email,
    required String password
  }) async {
    _clearError();

    if(email.trim().isEmpty || password.trim().isEmpty){
      _errorMessage = 'Please enter your email and password.';
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      _user = await loginUseCase(
        email: email.trim(),
        password: password
      );

      return true;
    } catch (err){
      _errorMessage = _formatError(err);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);

    try {
      await logoutUseCase();
      _user = null;
    } catch (err) {
      _errorMessage = _formatError(err);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  void _clearError(){
    _errorMessage = null;
    notifyListeners();
  }

  String _formatError(Object error){
    return error.toString().replaceFirst('Exception: ', '');
  }
}