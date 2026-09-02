import 'package:fitness_pulse/features/workout/presentation/controllers/workout_controller.dart';

import '../features/auth/data/data_sources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/usecases/login.dart';
import '../features/auth/domain/usecases/logout.dart';
import '../features/auth/domain/usecases/signup.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';

import '../features/workout/data/data_sources/workout_remote_datasource.dart';
import '../features/workout/data/repositories/workout_repository_impl.dart';
import '../features/workout/domain/usecases/create_workout.dart';
import '../features/workout/domain/usecases/get_workouts.dart';
import '../features/workout/domain/usecases/get_workout.dart';
import '../features/workout/domain/usecases/update_workout.dart';
import '../features/workout/domain/usecases/update_workout_status.dart';
import '../features/workout/domain/usecases/delete_workout.dart';

class AppDependencies {
  static final authRemoteDataSource = AuthRemoteDataSource();
  static final authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);

  static final login = Login(authRepository);
  static final logout = Logout(authRepository);
  static final signup = Signup(authRepository);

  static final authController = AuthController(
    loginUseCase: login,
    logoutUseCase: logout,
    signupUseCase: signup
  );

  static final workoutRemoteDatasource = WorkoutRemoteDatasource();
  static final workoutRepository = WorkoutRepositoryImpl(remoteDatasource: workoutRemoteDatasource);

  static final createWorkout = CreateWorkout(workoutRepository);
  static final getWorkouts = GetWorkouts(workoutRepository);
  static final getWorkout = GetWorkout(workoutRepository);
  static final updateWorkout = UpdateWokout(workoutRepository);
  static final updateWorkoutStatus = UpdateWorkoutStatus(workoutRepository);
  static final deleteWorkout = DeleteWorkout(workoutRepository);
  
  static final workoutController = WorkoutController(
    createWorkoutUseCase: createWorkout, 
    getWorkoutsUseCase: getWorkouts, 
    getWorkoutUseCase: getWorkout, 
    updateWokoutUseCase: updateWorkout, 
    updateWorkoutStatusUseCase: updateWorkoutStatus, 
    deleteWorkoutUseCase: deleteWorkout
  );
}