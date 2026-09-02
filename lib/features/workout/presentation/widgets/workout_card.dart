import 'package:flutter/material.dart';
import '../../domain/entities/workout.dart';

class WorkoutCard extends StatelessWidget {
  final WorkoutEntity workout;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onStatusChanged;

  const WorkoutCard({
    super.key,
    required this.workout,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChanged
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
        border: Border(bottom: BorderSide(color: Colors.grey.shade400))
      ),
      child: Column (
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: Icon(Icons.fitness_center, color: Colors.grey)
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  workout.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ),
              Checkbox(
                value: workout.isFinished, 
                onChanged: (value){
                  if (value != null){
                    onStatusChanged(value);
                  }
                }
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _WorkoutInfo(label: 'Reps', value: workout.repetition.toString())
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _WorkoutInfo(label: 'Sets', value: workout.sets.toString())
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: onEdit, 
                icon: const Icon(Icons.edit),
                tooltip: 'Edit',
              ),
              IconButton(
                onPressed: onDelete, 
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Delete',
              )
            ],
          )
        ],
      )
    );
  }
}

class _WorkoutInfo extends StatelessWidget {
  final String label;
  final String value;

  const _WorkoutInfo ({
    required this.label,
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column (
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      )
    );
  }
}