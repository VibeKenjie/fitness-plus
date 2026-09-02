import 'package:fitness_pulse/app/dependencies.dart';
import 'package:fitness_pulse/features/workout/presentation/widgets/workout_form_dialog.dart';
import 'package:fitness_pulse/features/workout/presentation/widgets/workout_card.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String capitalize(String text){
    if(text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  void _showWorkoutDialog() {
    showDialog(
      context: context, 
      builder: (context) {
        return const WorkoutFormDialog();
      }
    );
  }

  Future<void> _loadWorkouts() async {
    final authController = AppDependencies.authController;
    final workoutController = AppDependencies.workoutController;
    final user = authController.user;

    if (user == null) return;
    await workoutController.loadWorkouts(user.id);
  }

  Future<void> _updateWorkoutStatus(String workoutId, bool isFinished) async {
    final controller = AppDependencies.workoutController;
    final success = await controller.updateStatus(workoutId: workoutId, isFinished: isFinished);

    if(!mounted) return;
    if(!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update workout status.')));
    }
  }

  Future<void> _deleteWorkout(String workoutId) async {
    final controller = AppDependencies.workoutController;
    final success = await controller.delete(workoutId);

    if(!mounted) return;
    if(!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update workout status.')));
    }
  }

  @override
  Widget build(BuildContext context){
    final authController = AppDependencies.authController;
    final workoutController = AppDependencies.workoutController;
    final user = authController.user;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column (
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                        border: Border(
                          bottom: BorderSide( color: Colors.grey.shade400 )
                        )
                      ),
                      child: Row (
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.redAccent,
                            child: Text ( user?.initials ?? 'U', style: TextStyle(fontSize: 18, color: Colors.black) ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Hello, ${capitalize(user?.firstName ?? 'unknown')} ${capitalize(user?.lastName ?? 'user')}",
                                  style: TextStyle(fontSize: 20, color: Colors.black),
                                )
                              ],
                            )
                          )
                        ],
                      )
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Workout:',
                      style: TextStyle(fontSize: 14, color: Colors.grey )
                    ),
                    const SizedBox(height: 16),
                    AnimatedBuilder(
                      animation: workoutController, 
                      builder: (context, child) {

                        if(workoutController.isLoading && workoutController.workouts.isEmpty){
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(30),
                              child: CircularProgressIndicator()
                            )
                          );
                        }

                        if(workoutController.workouts.isEmpty){
                          return Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(16),
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade400
                                )
                              )
                            ),
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.fitness_center,
                                  size: 40,
                                  color: Colors.blue
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'No workout yet.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Tap the '+' button to create your first workout",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            )
                          );
                        }

                        return Column(
                          children: workoutController.workouts.where((workout) => !workout.isFinished).map((workout) {
                            return WorkoutCard(
                              workout: workout,
                              onEdit: () {
                                showDialog(
                                  context: context, 
                                  builder: (context) {
                                    return WorkoutFormDialog(workout: workout);
                                  }
                                );
                              }, onDelete: () {
                                _deleteWorkout(workout.id);
                              },
                              onStatusChanged: (value){
                                _updateWorkoutStatus(workout.id, value);
                              }
                            );
                          }).toList(),
                        );
                      }
                    )
                  ],
                )
              )
            )
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showWorkoutDialog,
        child: const Icon(Icons.add)
      ),
    );
  }
}