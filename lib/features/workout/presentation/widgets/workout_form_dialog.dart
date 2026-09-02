import 'package:flutter/material.dart';
import '../../../../app/dependencies.dart';
import '../../domain/entities/workout.dart';

class WorkoutFormDialog extends StatefulWidget{
  final WorkoutEntity? workout;
  const WorkoutFormDialog({super.key, this.workout});

  bool get isEditing => workout != null;

  @override
  State<WorkoutFormDialog> createState() => _WorkoutFormDialogState();
}

class _WorkoutFormDialogState extends State<WorkoutFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _repetitionController;
  late final TextEditingController _setsController;
  String? _selectedWorkout;

  final List<String> _workoutOptions = [
    'Bench Press',
    'Squats',
    'Deadlift',
    'Pushup',
    'Pullup',
    'ShoulderPress',
    'Bicept Curls',
    'Tricept Extensions',
    'Lunges',
    'Leg Press',
    'Lat Pulldownl',
    'Plank'
  ];

  @override
  void initState() {
    super.initState();
    _repetitionController = TextEditingController( text: widget.workout?.repetition.toString() ?? '' );
    _setsController = TextEditingController( text: widget.workout?.sets.toString() ?? '');
    _selectedWorkout = widget.workout?.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _repetitionController.dispose();
    _setsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _selectedWorkout;
    final repetition = int.tryParse(_repetitionController.text.trim());
    final sets = int.tryParse(_setsController.text.trim());

    if(name == null || repetition == null || sets == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter valid workout information')));
      return;
    }

    final controller = AppDependencies.workoutController;

    bool success;

    if (widget.isEditing) {
      success = await controller.update(
        workoutId: widget.workout!.id,
        name: name, 
        repetition: repetition, 
        sets: sets 
      );
    } else {
      final user = AppDependencies.authController.user;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You must be logged in.')));
        return;
      }

      success = await controller.create(
        userId: user.id,
        name: name,
        repetition: repetition,
        sets: sets
      );
    }

    if(!context.mounted) return;

    if(success){
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(controller.errorMessage ?? 'Something went wrong.')));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppDependencies.workoutController;
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child){
        return AlertDialog(
          title: Text(widget.isEditing ? 'Edit workout' : 'Create Workout'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedWorkout,
                  decoration: const InputDecoration(
                    labelText: 'Workout Name',
                    border: OutlineInputBorder(),
                  ),
                  items: _workoutOptions.map((workout) {
                    return DropdownMenuItem<String>(
                      value: workout,
                      child: Text(workout)
                    );
                  }).toList(),
                  onChanged: controller.isLoading ? null : (value) { setState(() {
                    _selectedWorkout = value;
                  });},
                ),
                const SizedBox(height: 16),
                Row (
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _repetitionController,
                        enabled: !controller.isLoading,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Reps',
                          hintText: 'How many repetition.',
                          border: OutlineInputBorder()
                        ),
                      )
                    ),
                    const SizedBox(width: 16),
                    Expanded (
                      child: TextField(
                        controller: _setsController,
                        enabled: !controller.isLoading,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Sets',
                          hintText: 'How many sets.',
                          border: OutlineInputBorder()
                        ),
                      ), 
                    )
                 ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: controller.isLoading ? null : () { Navigator.pop(context); }, 
              child: const Text('Cancel')
            ),
            ElevatedButton(
              onPressed: controller.isLoading ? null : _submit, 
              child: controller.isLoading 
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2)
                )
                : Text (widget.isEditing ? 'Save' : 'Create')
            )
          ],
        );
      },
    );
  }
}