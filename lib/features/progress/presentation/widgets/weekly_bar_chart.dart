import 'package:flutter/material.dart';

class WeeklyBarChart extends StatelessWidget {
  final List<int> values;
  final List<String> labels;

  const WeeklyBarChart({
    super.key, 
    required this.values, 
    required this.labels
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final maxChartValue = maxValue == 0 ? 1 : maxValue;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(values.length, (index) {
        final value = values[index];
        final height = value == 0 ? 4.0 : 120 * (value/maxChartValue);
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  value.toString(),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(6)
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  labels[index],
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                )
              ],
            )
          )
        );
      })
    );
  }
}