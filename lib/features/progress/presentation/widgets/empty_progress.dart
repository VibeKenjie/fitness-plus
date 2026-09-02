import 'package:flutter/material.dart';

class EmptyProgress extends StatelessWidget {
  const EmptyProgress({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
        border: Border(bottom: BorderSide(color: Colors.grey.shade400))
      ),
      child: const Column(
        children: [
          Icon(Icons.show_chart, size: 40, color: Colors.blue),
          SizedBox(height: 12),
          Text(
            'No completed workouts yet.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          )
        ],
      )
    );
  }
}