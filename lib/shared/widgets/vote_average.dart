import 'package:flutter/material.dart';

class VoteAverage extends StatelessWidget {
  final double average;

  const VoteAverage(this.average, {super.key});

  @override
  Widget build(BuildContext context) {
    var textStyles = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(Icons.star, size: 20, color: _getColor(average)),
        const SizedBox(width: 2),
        Text(
          average.toStringAsFixed(1),
          style: textStyles.bodyMedium
              ?.copyWith(color: _getColor(average), fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Color _getColor(double value) {
    if (value <= 3) return Colors.red;
    if (value <= 6) return Colors.orange[800]!;
    return Colors.amber;
  }
}
